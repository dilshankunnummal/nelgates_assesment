import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('calculates correct nights between dates', () {
      final checkIn = DateTime(2026, 9, 10, 15, 30);
      final checkOut = DateTime(2026, 9, 13, 11, 00);

      final nights = AppDateUtils.calculateNights(checkIn, checkOut);
      expect(nights, 3);
    });

    test('returns 0 nights if check-out equals check-in', () {
      final checkIn = DateTime(2026, 9, 10);
      final checkOut = DateTime(2026, 9, 10);

      expect(AppDateUtils.calculateNights(checkIn, checkOut), 0);
    });

    test('returns 0 nights if check-out is before check-in', () {
      final checkIn = DateTime(2026, 9, 10);
      final checkOut = DateTime(2026, 9, 8);

      expect(AppDateUtils.calculateNights(checkIn, checkOut), 0);
    });

    test('isValidDateRange validates check-out is strictly after check-in', () {
      final d1 = DateTime(2026, 9, 10);
      final d2 = DateTime(2026, 9, 12);

      expect(AppDateUtils.isValidDateRange(d1, d2), isTrue);
      expect(AppDateUtils.isValidDateRange(d2, d1), isFalse);
      expect(AppDateUtils.isValidDateRange(d1, d1), isFalse);
    });

    test('formatRange returns nicely formatted string', () {
      final d1 = DateTime(2026, 9, 10);
      final d2 = DateTime(2026, 9, 13);

      final formatted = AppDateUtils.formatRange(d1, d2);
      expect(formatted, contains('10 Sep'));
      expect(formatted, contains('13 Sep'));
      expect(formatted, contains('3 nights'));
    });
  });
}
