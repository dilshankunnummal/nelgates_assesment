import 'dart:math';

class BookingIdGenerator {
  static final Random _random = Random();
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Generates a realistic unique booking ID like "HTL-2026-K9M2P4".
  static String generate([int? year]) {
    final y = year ?? DateTime.now().year;
    final suffix = List.generate(6, (_) => _chars[_random.nextInt(_chars.length)]).join();
    return 'HTL-$y-$suffix';
  }
}
