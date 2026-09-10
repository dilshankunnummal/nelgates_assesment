class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{10,14}$',
  );

  /// Validates email address.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 5) {
      return 'Password must be at least 5 characters';
    }
    return null;
  }

  /// Validates phone number.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (!_phoneRegExp.hasMatch(clean)) {
      return 'Please enter a valid phone number (10-14 digits)';
    }
    return null;
  }

  /// Validates guest full name.
  static String? validateName(String? value, [String fieldName = 'Full name']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  /// Validates date range.
  static String? validateDates(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null) return 'Check-in date is required';
    if (checkOut == null) return 'Check-out date is required';
    if (!checkOut.isAfter(checkIn)) {
      return 'Check-out date must be after check-in date';
    }
    return null;
  }

  /// Validates adult count.
  static String? validateAdults(int adults) {
    if (adults < 1) {
      return 'At least 1 adult is required';
    }
    return null;
  }

  /// Validates room count.
  static String? validateRooms(int rooms) {
    if (rooms < 1) {
      return 'At least 1 room is required';
    }
    return null;
  }
}
