class SafeParser {
  /// Safely parses an integer from any dynamic value (int, double, numeric String, etc.).
  static int toInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) {
      final clean = value.trim().replaceAll(',', '');
      final parsed = int.tryParse(clean);
      if (parsed != null) return parsed;
      final parsedDouble = double.tryParse(clean);
      if (parsedDouble != null) return parsedDouble.toInt();
    }
    return fallback;
  }

  /// Safely parses a double from any dynamic value (double, int, numeric String, etc.).
  static double toDouble(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      final clean = value.trim().replaceAll(',', '');
      final parsed = double.tryParse(clean);
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  /// Safely parses a String from any dynamic value.
  static String toStr(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely parses a boolean from any dynamic value.
  static bool toBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    return fallback;
  }

  /// Safely parses an image URL from multiple possible schemas:
  /// - String URL
  /// - Map with 'large', 'small', 'thumb', 'icon', 'image_url', 'url', 'image'
  /// - List of strings or maps (picks first valid)
  static String toImageUrl(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isNotEmpty ? trimmed : fallback;
    }
    if (value is Map) {
      // Check priority keys
      final candidateKeys = [
        'large',
        'image_url',
        'url',
        'image',
        'thumb',
        'thumbnail',
        'small',
        'icon',
        'src',
      ];
      for (final key in candidateKeys) {
        if (value.containsKey(key) && value[key] != null) {
          final res = toImageUrl(value[key]);
          if (res.isNotEmpty) return res;
        }
      }
    }
    if (value is List && value.isNotEmpty) {
      return toImageUrl(value.first, fallback: fallback);
    }
    return fallback;
  }

  /// Safely parses a List of images from a dynamic value (String, List of Strings, List of Maps, Map).
  static List<String> toImageList(dynamic value, {List<String> fallback = const []}) {
    if (value == null) return fallback;
    if (value is List) {
      final list = <String>[];
      for (final item in value) {
        final img = toImageUrl(item);
        if (img.isNotEmpty) list.add(img);
      }
      return list.isNotEmpty ? list : fallback;
    }
    final single = toImageUrl(value);
    return single.isNotEmpty ? [single] : fallback;
  }

  /// Safely parses a List of items using a mapper function.
  static List<T> toList<T>(dynamic value, T Function(dynamic item) mapper) {
    if (value == null || value is! List) return [];
    return value.map((e) {
      try {
        return mapper(e);
      } catch (_) {
        return null;
      }
    }).whereType<T>().toList();
  }

  /// Safely parses a `Map<String, dynamic>` from any dynamic value.
  static Map<String, dynamic> toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return {};
  }

  /// Safely parses a DateTime from dynamic (DateTime, int timestamp, String ISO).
  static DateTime? toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
