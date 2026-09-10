import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/price_calculator.dart';

void main() {
  group('PriceCalculator', () {
    test('calculates correct breakdown for assessment example (2000 x 3 nights x 2 rooms)', () {
      final result = PriceCalculator.calculate(
        baseRoomPrice: 2000.0,
        nights: 3,
        rooms: 2,
        taxRate: 0.12,
        serviceChargeRate: 0.05,
      );

      expect(result.subtotal, 12000.0);
      expect(result.taxAmount, 1440.0); // 12% of 12000
      expect(result.serviceChargeAmount, 600.0); // 5% of 12000
      expect(result.grandTotal, 14040.0);
    });

    test('handles 1 night and 1 room accurately', () {
      final result = PriceCalculator.calculate(
        baseRoomPrice: 5000.0,
        nights: 1,
        rooms: 1,
      );

      expect(result.subtotal, 5000.0);
      expect(result.taxAmount, 600.0); // 12% of 5000
      expect(result.serviceChargeAmount, 250.0); // 5% of 5000
      expect(result.grandTotal, 5850.0);
    });

    test('handles zero nights gracefully (yields 0 subtotal)', () {
      final result = PriceCalculator.calculate(
        baseRoomPrice: 4000.0,
        nights: 0,
        rooms: 2,
      );

      expect(result.subtotal, 0.0);
      expect(result.taxAmount, 0.0);
      expect(result.serviceChargeAmount, 0.0);
      expect(result.grandTotal, 0.0);
    });

    test('handles negative nights or rooms gracefully', () {
      final result = PriceCalculator.calculate(
        baseRoomPrice: 3000.0,
        nights: -2,
        rooms: -1,
      );

      expect(result.subtotal, 0.0);
      expect(result.grandTotal, 0.0);
    });

    test('handles large luxury values correctly without precision errors', () {
      final result = PriceCalculator.calculate(
        baseRoomPrice: 150000.0,
        nights: 10,
        rooms: 4,
        taxRate: 0.18,
        serviceChargeRate: 0.10,
      );

      // Subtotal = 150,000 * 10 * 4 = 6,000,000
      expect(result.subtotal, 6000000.0);
      expect(result.taxAmount, 1080000.0);
      expect(result.serviceChargeAmount, 600000.0);
      expect(result.grandTotal, 7680000.0);
    });
  });
}
