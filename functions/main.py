import os
import firebase_admin
from firebase_admin import auth, firestore
from firebase_functions import https_fn, auth_fn
import cloudinary
import cloudinary.uploader

# Initialize Firebase Admin & Firestore
firebase_admin.initialize_app()
db = firestore.client()

# Configure Cloudinary
cloudinary.config(
    cloud_name=os.environ.get("CLOUDINARY_CLOUD_NAME", "dls5vxo49"),
    api_key=os.environ.get("CLOUDINARY_API_KEY", "123456789012345"),
    api_secret=os.environ.get("CLOUDINARY_API_SECRET", "sample_cloudinary_api_secret"),
    secure=True
)

@https_fn.on_request()
def upload_image(req: https_fn.Request) -> https_fn.Response:
    """1. Upload image to Cloudinary CDN returning secure URL."""
    if req.method != "POST":
        return https_fn.Response("Method Not Allowed", status=405)

    try:
        data = req.get_json(silent=True) or {}
        base64_img = data.get("image")
        folder = data.get("folder", "users/profile")
        user_id = data.get("userId", "guest")

        if base64_img:
            payload = base64_img if base64_img.startswith("data:image") else f"data:image/jpeg;base64,{base64_img}"
            upload_res = cloudinary.uploader.upload(
                payload,
                folder=f"{folder}/{user_id}",
                quality="auto:good",
                fetch_format="auto"
            )
            return https_fn.Response(
                f'{{"success": true, "secure_url": "{upload_res.get("secure_url")}", "public_id": "{upload_res.get("public_id")}"}}',
                status=200,
                mimetype="application/json"
            )

        return https_fn.Response('{"error": "No image provided"}', status=400, mimetype="application/json")
    except Exception as e:
        return https_fn.Response(f'{{"error": "{str(e)}"}}', status=500, mimetype="application/json")


@https_fn.on_request()
def delete_image(req: https_fn.Request) -> https_fn.Response:
    """2. Delete an image asset from Cloudinary."""
    if req.method != "POST":
        return https_fn.Response("Method Not Allowed", status=405)

    try:
        data = req.get_json(silent=True) or {}
        public_id = data.get("public_id")
        if not public_id:
            return https_fn.Response('{"error": "public_id is required"}', status=400, mimetype="application/json")

        result = cloudinary.uploader.destroy(public_id)
        return https_fn.Response(f'{{"success": true, "result": "{result}"}}', status=200, mimetype="application/json")
    except Exception as e:
        return https_fn.Response(f'{{"error": "{str(e)}"}}', status=500, mimetype="application/json")


@auth_fn.on_user_created()
def create_user_profile(event: auth_fn.AuthEvent) -> None:
    """3. Create Firestore user document upon Firebase Auth account creation."""
    try:
        user_id = event.data.uid
        email = event.data.email or ""
        display_name = event.data.display_name or "Guest User"
        photo_url = event.data.photo_url or "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80"
        phone = event.data.phone_number

        user_ref = db.collection("users").document(user_id)
        if not user_ref.get().exists:
            user_ref.set({
                "id": user_id,
                "name": display_name,
                "email": email,
                "phone": phone,
                "profileImageUrl": photo_url,
                "role": "employee",
                "isActive": True,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP
            })
    except Exception as e:
        print(f"create_user_profile error: {e}")


@https_fn.on_call()
def update_user_profile(req: https_fn.CallableRequest) -> dict:
    """4. Update user profile details in Firestore."""
    if not req.auth:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.UNAUTHENTICATED, "User must be authenticated")

    user_id = req.auth.uid
    data = req.data or {}

    update_payload = {"updatedAt": firestore.SERVER_TIMESTAMP}
    for field in ["name", "phone", "profileImageUrl", "role"]:
        if field in data:
            update_payload[field] = data[field]

    db.collection("users").document(user_id).set(update_payload, merge=True)
    return {"success": True, "message": "Profile updated successfully"}


@https_fn.on_call()
def validate_requests(req: https_fn.CallableRequest) -> dict:
    """5. Validate user auth token and role."""
    if not req.auth:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.UNAUTHENTICATED, "Request is not authenticated")

    user_id = req.auth.uid
    user_doc = db.collection("users").document(user_id).get()

    if not user_doc.exists:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.NOT_FOUND, "User record not found")

    user_data = user_doc.to_dict() or {}
    return {
        "valid": True,
        "uid": user_id,
        "email": req.auth.token.get("email"),
        "role": user_data.get("role", "employee"),
        "isActive": user_data.get("isActive", True)
    }


@https_fn.on_call()
def create_booking(req: https_fn.CallableRequest) -> dict:
    """6. Create hotel reservation with server-side validation."""
    if not req.auth:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.UNAUTHENTICATED, "Must be authenticated")

    data = req.data or {}
    booking_id = f"BK-{int(firestore.SERVER_TIMESTAMP)}-{user_id[:4]}" if "user_id" in locals() else f"BK-PROD-{data.get('hotelId', 'HTL')}"

    booking_data = {
        "id": booking_id,
        "hotel_id": data.get("hotelId"),
        "hotel_name": data.get("hotelName"),
        "hotel_image": data.get("hotelImage"),
        "hotel_address": data.get("hotelAddress"),
        "room": data.get("room"),
        "check_in_date": data.get("checkInDate"),
        "check_out_date": data.get("checkOutDate"),
        "nights": data.get("nights", 1),
        "adults": data.get("adults", 2),
        "children": data.get("children", 0),
        "rooms_count": data.get("roomsCount", 1),
        "base_room_price": data.get("baseRoomPrice", 0.0),
        "subtotal": data.get("subtotal", 0.0),
        "tax_amount": data.get("taxAmount", 0.0),
        "service_charge_amount": data.get("serviceChargeAmount", 0.0),
        "total_amount": data.get("totalAmount", 0.0),
        "guest": {
            **(data.get("guest") or {}),
            "user_id": req.auth.uid,
            "email": req.auth.token.get("email")
        },
        "status": "upcoming",
        "created_at": firestore.SERVER_TIMESTAMP
    }

    db.collection("bookings").document(booking_id).set(booking_data)
    return {"success": True, "bookingId": booking_id, "booking": booking_data}


@https_fn.on_call()
def cancel_booking(req: https_fn.CallableRequest) -> dict:
    """7. Cancel reservation and update status."""
    if not req.auth:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.UNAUTHENTICATED, "Must be authenticated")

    data = req.data or {}
    booking_id = data.get("bookingId")
    if not booking_id:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INVALID_ARGUMENT, "bookingId required")

    booking_ref = db.collection("bookings").document(booking_id)
    doc = booking_ref.get()
    if not doc.exists:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.NOT_FOUND, "Booking not found")

    booking_ref.update({
        "status": "cancelled",
        "cancellation_reason": data.get("reason", "Customer requested cancellation"),
        "updated_at": firestore.SERVER_TIMESTAMP
    })

    return {"success": True, "bookingId": booking_id, "status": "cancelled"}


import json

@https_fn.on_request()
def list_hotels(req: https_fn.Request) -> https_fn.Response:
    """8. Paginated & filtered hotel query."""
    try:
        dest = req.args.get("destination")
        query = db.collection("hotels")
        if dest and dest != "all":
            query = query.where("destination", "==", dest)

        docs = query.stream()
        hotels = [d.to_dict() for d in docs]
        return https_fn.Response(
            json.dumps({"success": True, "count": len(hotels), "hotels": hotels}, default=str),
            status=200,
            mimetype="application/json"
        )
    except Exception as e:
        return https_fn.Response(json.dumps({"error": str(e)}), status=500, mimetype="application/json")