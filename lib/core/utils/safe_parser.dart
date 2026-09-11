class SafeParser {

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

  static String toStr(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) return value;
    return value.toString();
  }

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

  static String toImageUrl(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isNotEmpty ? trimmed : fallback;
    }
    if (value is Map) {

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

  static Map<String, dynamic> toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return {};
  }

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

    try {
      final dyn = value as dynamic;
      if (dyn.toDate != null) {
        return dyn.toDate() as DateTime;
      }
    } catch (_) {}
    return null;
  }
}
