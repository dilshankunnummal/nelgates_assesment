import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _dayMonthYearFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM');
  static final DateFormat _fullDayMonthYearFormat = DateFormat('EEE, dd MMM yyyy');

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final start = dateOnly(checkIn);
    final end = dateOnly(checkOut);
    final difference = end.difference(start).inDays;
    return difference > 0 ? difference : 0;
  }

  static bool isValidDateRange(DateTime checkIn, DateTime checkOut) {
    final start = dateOnly(checkIn);
    final end = dateOnly(checkOut);
    return end.isAfter(start);
  }

  static String format(DateTime date) {
    return _dayMonthYearFormat.format(date);
  }

  static String formatDate(DateTime date) {
    return format(date);
  }

  static String formatShort(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatFull(DateTime date) {
    return _fullDayMonthYearFormat.format(date);
  }

  static String formatRange(DateTime checkIn, DateTime checkOut) {
    final nights = calculateNights(checkIn, checkOut);
    final nightText = nights == 1 ? '1 night' : '$nights nights';
    return '${formatShort(checkIn)} - ${formatShort(checkOut)} ($nightText)';
  }
}
