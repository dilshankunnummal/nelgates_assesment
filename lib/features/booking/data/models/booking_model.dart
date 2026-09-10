import '../../../../core/utils/safe_parser.dart';
import '../../../../features/hotels/data/models/room_model.dart';
import '../../domain/entities/booking.dart';
import 'guest_model.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.hotelId,
    required super.hotelName,
    required super.hotelImage,
    required super.hotelAddress,
    required super.room,
    required super.checkInDate,
    required super.checkOutDate,
    required super.nights,
    required super.adults,
    required super.children,
    required super.roomsCount,
    required super.baseRoomPrice,
    required super.subtotal,
    required super.taxAmount,
    required super.serviceChargeAmount,
    required super.totalAmount,
    required super.guest,
    required super.status,
    required super.createdAt,
    super.cancellationReason,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final roomMap = SafeParser.toMap(json['room']);
    final room = RoomModel.fromJson(roomMap);

    final guestMap = SafeParser.toMap(json['guest']);
    final guest = GuestModel.fromJson(guestMap);

    final checkIn = SafeParser.toDateTime(json['check_in_date'] ?? json['checkInDate']) ??
        DateTime.now().add(const Duration(days: 1));
    final checkOut = SafeParser.toDateTime(json['check_out_date'] ?? json['checkOutDate']) ??
        checkIn.add(const Duration(days: 2));

    final createdAt = SafeParser.toDateTime(json['created_at'] ?? json['createdAt']) ??
        DateTime.now();

    return BookingModel(
      id: SafeParser.toStr(json['id'], fallback: 'HTL-2026-MOCK01'),
      hotelId: SafeParser.toStr(json['hotel_id'] ?? json['hotelId'], fallback: 'HTL-001'),
      hotelName: SafeParser.toStr(json['hotel_name'] ?? json['hotelName'], fallback: 'Grand Palace'),
      hotelImage: SafeParser.toImageUrl(
        json['hotel_image'] ?? json['hotelImage'] ?? json['image'],
        fallback: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      ),
      hotelAddress: SafeParser.toStr(
        json['hotel_address'] ?? json['hotelAddress'] ?? json['address'],
        fallback: 'Main Coastal Road',
      ),
      room: room,
      checkInDate: checkIn,
      checkOutDate: checkOut,
      nights: SafeParser.toInt(json['nights'], fallback: 1),
      adults: SafeParser.toInt(json['adults'], fallback: 2),
      children: SafeParser.toInt(json['children'], fallback: 0),
      roomsCount: SafeParser.toInt(json['rooms_count'] ?? json['roomsCount'] ?? json['rooms'], fallback: 1),
      baseRoomPrice: SafeParser.toDouble(json['base_room_price'] ?? json['baseRoomPrice'] ?? json['price'], fallback: 2500.0),
      subtotal: SafeParser.toDouble(json['subtotal'], fallback: 2500.0),
      taxAmount: SafeParser.toDouble(json['tax_amount'] ?? json['taxAmount'] ?? json['tax'], fallback: 300.0),
      serviceChargeAmount: SafeParser.toDouble(
        json['service_charge_amount'] ?? json['serviceChargeAmount'] ?? json['serviceCharge'],
        fallback: 125.0,
      ),
      totalAmount: SafeParser.toDouble(json['total_amount'] ?? json['totalAmount'] ?? json['total'], fallback: 2925.0),
      guest: guest,
      status: SafeParser.toStr(json['status'], fallback: 'upcoming'),
      createdAt: createdAt,
      cancellationReason: json['cancellation_reason'] != null || json['cancellationReason'] != null
          ? SafeParser.toStr(json['cancellation_reason'] ?? json['cancellationReason'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final roomJson = room is RoomModel ? (room as RoomModel).toJson() : RoomModel.fromEntity(room).toJson();
    final guestJson = guest is GuestModel ? (guest as GuestModel).toJson() : GuestModel.fromEntity(guest).toJson();

    return {
      'id': id,
      'hotel_id': hotelId,
      'hotel_name': hotelName,
      'hotel_image': hotelImage,
      'hotel_address': hotelAddress,
      'room': roomJson,
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'nights': nights,
      'adults': adults,
      'children': children,
      'rooms_count': roomsCount,
      'base_room_price': baseRoomPrice,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'service_charge_amount': serviceChargeAmount,
      'total_amount': totalAmount,
      'guest': guestJson,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'cancellation_reason': cancellationReason,
    };
  }

  factory BookingModel.fromEntity(Booking entity) {
    return BookingModel(
      id: entity.id,
      hotelId: entity.hotelId,
      hotelName: entity.hotelName,
      hotelImage: entity.hotelImage,
      hotelAddress: entity.hotelAddress,
      room: entity.room,
      checkInDate: entity.checkInDate,
      checkOutDate: entity.checkOutDate,
      nights: entity.nights,
      adults: entity.adults,
      children: entity.children,
      roomsCount: entity.roomsCount,
      baseRoomPrice: entity.baseRoomPrice,
      subtotal: entity.subtotal,
      taxAmount: entity.taxAmount,
      serviceChargeAmount: entity.serviceChargeAmount,
      totalAmount: entity.totalAmount,
      guest: entity.guest,
      status: entity.status,
      createdAt: entity.createdAt,
      cancellationReason: entity.cancellationReason,
    );
  }
}
