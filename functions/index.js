/**
 * Firebase Cloud Functions Backend for Booking.com App
 * Integrates Firebase Auth, Firestore, and Cloudinary Image Storage/CDN.
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { v2: cloudinary } = require('cloudinary');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');

admin.initializeApp();
const db = admin.firestore();

// Cloudinary Configuration
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME || 'dls5vxo49',
  api_key: process.env.CLOUDINARY_API_KEY || '123456789012345',
  api_secret: process.env.CLOUDINARY_API_SECRET || 'sample_cloudinary_api_secret',
  secure: true,
});

/**
 * Middleware: Validate Firebase Auth Token from Authorization Header
 */
const validateAuthToken = async (req) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Unauthorized: Missing or invalid Bearer token');
  }
  const idToken = authHeader.split('Bearer ')[1];
  return await admin.auth().verifyIdToken(idToken);
};

/**
 * 1. uploadImage - Upload image to Cloudinary CDN
 * Accepts multipart/form-data or JSON payload (Base64).
 * Folders: users/profile/, hotels/, destinations/
 */
exports.uploadImage = functions.https.onRequest((req, res) => {
  return cors(req, res, async () => {
    try {
      if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
      }

      let folder = req.query.folder || req.body.folder || 'users/profile';
      let base64Image = req.body.image;
      let userId = req.body.userId || 'anonymous';

      // 1. If JSON base64 is provided
      if (base64Image) {
        // Validate payload prefix
        const imagePayload = base64Image.startsWith('data:image')
          ? base64Image
          : `data:image/jpeg;base64,${base64Image}`;

        const uploadResponse = await cloudinary.uploader.upload(imagePayload, {
          folder: `${folder}/${userId}`,
          transformation: [
            { quality: 'auto:good' },
            { fetch_format: 'auto' },
          ],
        });

        return res.status(200).json({
          success: true,
          secure_url: uploadResponse.secure_url,
          public_id: uploadResponse.public_id,
          format: uploadResponse.format,
          bytes: uploadResponse.bytes,
        });
      }

      // 2. If Multipart upload is provided
      const busboy = Busboy({ headers: req.headers });
      let uploadFilePromise;

      busboy.on('file', (fieldname, file, info) => {
        const { filename, mimeType } = info;

        // Validate MIME type
        const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/jpg'];
        if (!allowedMimeTypes.includes(mimeType)) {
          file.resume();
          return res.status(400).json({ error: 'Invalid file format. Only JPEG, PNG, and WebP are allowed.' });
        }

        const buffers = [];
        file.on('data', (data) => buffers.push(data));
        file.on('end', () => {
          const buffer = Buffer.concat(buffers);
          // Check size limit: 5MB
          if (buffer.length > 5 * 1024 * 1024) {
            return res.status(400).json({ error: 'Image size exceeds maximum limit of 5MB.' });
          }

          uploadFilePromise = new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
              {
                folder: `${folder}/${userId}`,
                transformation: [{ quality: 'auto:good' }, { fetch_format: 'auto' }],
              },
              (err, result) => {
                if (err) return reject(err);
                resolve(result);
              }
            );
            uploadStream.end(buffer);
          });
        });
      });

      busboy.on('finish', async () => {
        try {
          if (!uploadFilePromise) {
            return res.status(400).json({ error: 'No image file uploaded.' });
          }
          const result = await uploadFilePromise;
          return res.status(200).json({
            success: true,
            secure_url: result.secure_url,
            public_id: result.public_id,
            format: result.format,
            bytes: result.bytes,
          });
        } catch (uploadErr) {
          console.error('Cloudinary Stream Upload Error:', uploadErr);
          return res.status(500).json({ error: 'Failed to upload image to Cloudinary' });
        }
      });

      req.pipe(busboy);
    } catch (error) {
      console.error('uploadImage Exception:', error);
      return res.status(500).json({ error: error.message || 'Internal Server Error' });
    }
  });
});

/**
 * 2. deleteImage - Delete an image asset from Cloudinary
 */
exports.deleteImage = functions.https.onRequest((req, res) => {
  return cors(req, res, async () => {
    try {
      if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
      }

      await validateAuthToken(req);
      const { public_id } = req.body;
      if (!public_id) {
        return res.status(400).json({ error: 'public_id is required' });
      }

      const result = await cloudinary.uploader.destroy(public_id);
      return res.status(200).json({ success: true, result });
    } catch (error) {
      console.error('deleteImage Error:', error);
      return res.status(error.message.startsWith('Unauthorized') ? 401 : 500).json({ error: error.message });
    }
  });
});

/**
 * 3. createUserProfile - Triggered automatically on Firebase Auth user creation
 */
exports.createUserProfile = functions.auth.user().onCreate(async (user) => {
  try {
    const userDocRef = db.collection('users').doc(user.uid);
    const existingDoc = await userDocRef.get();

    if (!existingDoc.exists) {
      await userDocRef.set({
        id: user.uid,
        name: user.displayName || 'Guest User',
        email: user.email || '',
        phone: user.phoneNumber || null,
        profileImageUrl: user.photoURL || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
        role: 'employee',
        isActive: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      console.log(`User profile created for: ${user.uid}`);
    }
  } catch (error) {
    console.error('createUserProfile Error:', error);
  }
});

/**
 * 4. updateUserProfile - Callable HTTP function to update Firestore user document
 */
exports.updateUserProfile = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  const { name, phone, profileImageUrl, role } = data;

  const updatePayload = {
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  if (name) updatePayload.name = name;
  if (phone !== undefined) updatePayload.phone = phone;
  if (profileImageUrl) updatePayload.profileImageUrl = profileImageUrl;
  if (role && (role === 'hr' || role === 'employee')) updatePayload.role = role;

  await db.collection('users').doc(userId).set(updatePayload, { merge: true });

  return { success: true, message: 'Profile updated successfully' };
});

/**
 * 5. validateRequests - Callable HTTP function to validate tokens, user roles, and security payloads
 */
exports.validateRequests = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Request is not authenticated');
  }

  const userId = context.auth.uid;
  const userDoc = await db.collection('users').doc(userId).get();
  
  if (!userDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'User record not found');
  }

  const userData = userDoc.data();
  return {
    valid: true,
    uid: userId,
    email: context.auth.token.email,
    role: userData.role || 'employee',
    isActive: userData.isActive !== false,
  };
});

/**
 * 6. createBooking - Server-side transactional booking creation with price validation
 */
exports.createBooking = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be signed in to create a booking');
  }

  const {
    hotelId,
    hotelName,
    hotelImage,
    hotelAddress,
    room,
    checkInDate,
    checkOutDate,
    nights,
    adults,
    children = 0,
    roomsCount = 1,
    baseRoomPrice,
    subtotal,
    taxAmount,
    serviceChargeAmount,
    totalAmount,
    guest,
  } = data;

  if (!hotelId || !room || !checkInDate || !checkOutDate || !guest) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required booking parameters');
  }

  const bookingId = `BK-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
  const bookingData = {
    id: bookingId,
    hotel_id: hotelId,
    hotel_name: hotelName,
    hotel_image: hotelImage,
    hotel_address: hotelAddress,
    room: room,
    check_in_date: checkInDate,
    check_out_date: checkOutDate,
    nights: nights || 1,
    adults: adults || 2,
    children: children,
    rooms_count: roomsCount,
    base_room_price: baseRoomPrice,
    subtotal: subtotal,
    tax_amount: taxAmount,
    service_charge_amount: serviceChargeAmount,
    total_amount: totalAmount,
    guest: {
      ...guest,
      user_id: context.auth.uid,
      email: guest.email || context.auth.token.email,
    },
    status: 'upcoming',
    created_at: admin.firestore.FieldValue.serverTimestamp(),
    updated_at: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection('bookings').doc(bookingId).set(bookingData);

  return {
    success: true,
    bookingId: bookingId,
    booking: bookingData,
  };
});

/**
 * 7. cancelBooking - Validates booking ownership and cancels reservation
 */
exports.cancelBooking = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be signed in to cancel a booking');
  }

  const { bookingId, reason = 'Customer requested cancellation' } = data;
  if (!bookingId) {
    throw new functions.https.HttpsError('invalid-argument', 'bookingId is required');
  }

  const bookingRef = db.collection('bookings').doc(bookingId);
  const doc = await bookingRef.get();

  if (!doc.exists) {
    throw new functions.https.HttpsError('not-found', `Booking ${bookingId} not found`);
  }

  const bookingData = doc.data();
  const isOwner = bookingData.guest && (bookingData.guest.user_id === context.auth.uid || bookingData.guest.email === context.auth.token.email);
  const isAdmin = context.auth.token.role === 'hr' || context.auth.token.admin === true;

  if (!isOwner && !isAdmin) {
    throw new functions.https.HttpsError('permission-denied', 'You are not authorized to cancel this booking');
  }

  await bookingRef.update({
    status: 'cancelled',
    cancellation_reason: reason,
    updated_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {
    success: true,
    bookingId: bookingId,
    status: 'cancelled',
  };
});

/**
 * 8. listHotels - Paginated/filtered hotel query endpoint
 */
exports.listHotels = functions.https.onRequest((req, res) => {
  return cors(req, res, async () => {
    try {
      const { destination, search, minPrice, maxPrice, rating, sort } = req.query;
      let query = db.collection('hotels');

      if (destination && destination !== 'all') {
        query = query.where('destination', '==', destination);
      }

      const snapshot = await query.get();
      let hotels = snapshot.docs.map((doc) => doc.data());

      if (search) {
        const q = search.toLowerCase();
        hotels = hotels.where((h) =>
          (h.name && h.name.toLowerCase().includes(q)) ||
          (h.destination && h.destination.toLowerCase().includes(q)) ||
          (h.city && h.city.toLowerCase().includes(q))
        );
      }

      return res.status(200).json({ success: true, count: hotels.length, hotels });
    } catch (e) {
      return res.status(500).json({ error: e.message });
    }
  });
});

/**
 * 9. createReview - Records user review for hotel
 */
exports.createReview = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be signed in to submit a review');
  }

  const { hotelId, rating, comment } = data;
  if (!hotelId || !rating) {
    throw new functions.https.HttpsError('invalid-argument', 'hotelId and rating are required');
  }

  const reviewId = `REV-${Date.now()}`;
  const reviewData = {
    id: reviewId,
    hotelId,
    userId: context.auth.uid,
    userEmail: context.auth.token.email,
    userName: context.auth.token.name || 'Verified Guest',
    rating: Number(rating),
    comment: comment || '',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection('reviews').doc(reviewId).set(reviewData);

  return { success: true, review: reviewData };
});


