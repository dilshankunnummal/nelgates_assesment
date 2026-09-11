import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrDecimalFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num amount, {bool showDecimals = false}) {
    if (showDecimals && (amount % 1 != 0)) {
      return _inrDecimalFormatter.format(amount);
    }
    return _inrFormatter.format(amount.round());
  }

  static String formatPerNight(num amount) {
    return '${format(amount)} / night';
  }
}
