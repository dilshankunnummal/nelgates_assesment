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

  /// Formats amount in INR: e.g. ₹2,000, ₹12,500, ₹1,25,000.
  static String format(num amount, {bool showDecimals = false}) {
    if (showDecimals && (amount % 1 != 0)) {
      return _inrDecimalFormatter.format(amount);
    }
    return _inrFormatter.format(amount.round());
  }

  /// Formats amount with suffix e.g. "₹2,000 / night"
  static String formatPerNight(num amount) {
    return '${format(amount)} / night';
  }
}
