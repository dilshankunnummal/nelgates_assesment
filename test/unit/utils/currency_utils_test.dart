import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/currency_utils.dart';

void main() {
  group('CurrencyUtils', () {
    test('formats numbers into INR currency format', () {
      expect(CurrencyUtils.format(2000), contains('2,000'));
      expect(CurrencyUtils.format(12500), contains('12,500'));
      expect(CurrencyUtils.format(125000), contains('1,25,000'));
      expect(CurrencyUtils.format(0), contains('0'));
    });

    test('formatPerNight appends / night suffix', () {
      final formatted = CurrencyUtils.formatPerNight(4500);
      expect(formatted, contains('4,500'));
      expect(formatted, contains('/ night'));
    });
  });
}
