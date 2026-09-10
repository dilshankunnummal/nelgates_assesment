import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _dayMonthYearFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM');
  static final DateFormat _fullDayMonthYearFormat = DateFormat('EEE, dd MMM yyyy');

  /// Strips time components to ensure date-only comparison.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Calculates number of nights between check-in and check-out.
  /// Returns at least 1 night if checkOut > checkIn, or 0 if invalid.
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final start = dateOnly(checkIn);
    final end = dateOnly(checkOut);
    final difference = end.difference(start).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Validates whether check-out date is strictly after check-in date.
  static bool isValidDateRange(DateTime checkIn, DateTime checkOut) {
    final start = dateOnly(checkIn);
    final end = dateOnly(checkOut);
    return end.isAfter(start);
  }

  /// Formats date: e.g. "10 Sep 2026"
  static String format(DateTime date) {
    return _dayMonthYearFormat.format(date);
  }

  /// Alias for format
  static String formatDate(DateTime date) {
    return format(date);
  }

  /// Formats short date: e.g. "10 Sep"
  static String formatShort(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Formats date with weekday: e.g. "Thu, 10 Sep 2026"
  static String formatFull(DateTime date) {
    return _fullDayMonthYearFormat.format(date);
  }

  /// Formats stay range: e.g. "10 Sep - 13 Sep (3 nights)"
  static String formatRange(DateTime checkIn, DateTime checkOut) {
    final nights = calculateNights(checkIn, checkOut);
    final nightText = nights == 1 ? '1 night' : '$nights nights';
    return '${formatShort(checkIn)} - ${formatShort(checkOut)} ($nightText)';
  }
}
