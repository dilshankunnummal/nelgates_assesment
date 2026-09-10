import 'package:equatable/equatable.dart';
import '../constants/app_constants.dart';

class PriceBreakdown extends Equatable {
  final double baseRoomPrice;
  final int nights;
  final int rooms;
  final double subtotal;
  final double taxAmount;
  final double taxRate;
  final double serviceChargeAmount;
  final double serviceChargeRate;
  final double grandTotal;

  const PriceBreakdown({
    required this.baseRoomPrice,
    required this.nights,
    required this.rooms,
    required this.subtotal,
    required this.taxAmount,
    required this.taxRate,
    required this.serviceChargeAmount,
    required this.serviceChargeRate,
    required this.grandTotal,
  });

  /// Alias for grandTotal
  double get totalAmount => grandTotal;

  @override
  List<Object?> get props => [
        baseRoomPrice,
        nights,
        rooms,
        subtotal,
        taxAmount,
        taxRate,
        serviceChargeAmount,
        serviceChargeRate,
        grandTotal,
      ];
}

class PriceCalculator {
  /// Calculates comprehensive price breakdown:
  /// Subtotal = baseRoomPrice * nights * rooms
  /// Tax = subtotal * taxRate
  /// Service Charge = subtotal * serviceChargeRate
  /// Grand Total = Subtotal + Tax + Service Charge
  static PriceBreakdown calculate({
    required double baseRoomPrice,
    required int nights,
    required int rooms,
    double taxRate = AppConstants.taxRate,
    double serviceChargeRate = AppConstants.serviceChargeRate,
  }) {
    final validNights = nights > 0 ? nights : 0;
    final validRooms = rooms > 0 ? rooms : 0;
    final validBasePrice = baseRoomPrice > 0 ? baseRoomPrice : 0.0;

    final subtotal = validBasePrice * validNights * validRooms;
    final taxAmount = (subtotal * taxRate * 100).roundToDouble() / 100;
    final serviceChargeAmount = (subtotal * serviceChargeRate * 100).roundToDouble() / 100;
    final grandTotal = (subtotal + taxAmount + serviceChargeAmount);

    return PriceBreakdown(
      baseRoomPrice: validBasePrice,
      nights: validNights,
      rooms: validRooms,
      subtotal: subtotal,
      taxAmount: taxAmount,
      taxRate: taxRate,
      serviceChargeAmount: serviceChargeAmount,
      serviceChargeRate: serviceChargeRate,
      grandTotal: grandTotal,
    );
  }
}
