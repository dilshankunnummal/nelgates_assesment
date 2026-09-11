import 'package:equatable/equatable.dart';
import '../../../../features/hotels/domain/entities/room.dart';
import 'guest.dart';

class Booking extends Equatable {
  final String id;
  final String? userId;
  final String hotelId;
  final String hotelName;
  final String hotelImage;
  final String hotelAddress;
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  final int adults;
  final int children;
  final int roomsCount;
  final double baseRoomPrice;
  final double subtotal;
  final double taxAmount;
  final double serviceChargeAmount;
  final double totalAmount;
  final Guest guest;
  final String status;
  final DateTime createdAt;
  final String? cancellationReason;

  const Booking({
    required this.id,
    this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImage,
    required this.hotelAddress,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.adults,
    required this.children,
    required this.roomsCount,
    required this.baseRoomPrice,
    required this.subtotal,
    required this.taxAmount,
    required this.serviceChargeAmount,
    required this.totalAmount,
    required this.guest,
    required this.status,
    required this.createdAt,
    this.cancellationReason,
  });

  bool get isUpcoming => status.toLowerCase() == 'upcoming';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  Booking copyWith({
    String? userId,
    String? status,
    String? cancellationReason,
  }) {
    return Booking(
      id: id,
      userId: userId ?? this.userId,
      hotelId: hotelId,
      hotelName: hotelName,
      hotelImage: hotelImage,
      hotelAddress: hotelAddress,
      room: room,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      nights: nights,
      adults: adults,
      children: children,
      roomsCount: roomsCount,
      baseRoomPrice: baseRoomPrice,
      subtotal: subtotal,
      taxAmount: taxAmount,
      serviceChargeAmount: serviceChargeAmount,
      totalAmount: totalAmount,
      guest: guest,
      status: status ?? this.status,
      createdAt: createdAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        hotelId,
        hotelName,
        hotelImage,
        hotelAddress,
        room,
        checkInDate,
        checkOutDate,
        nights,
        adults,
        children,
        roomsCount,
        baseRoomPrice,
        subtotal,
        taxAmount,
        serviceChargeAmount,
        totalAmount,
        guest,
        status,
        createdAt,
        cancellationReason,
      ];
}
