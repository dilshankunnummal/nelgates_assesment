import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateEmail validates correctly', () {
      expect(Validators.validateEmail('user@hotel.com'), isNull);
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail(null), 'Email is required');
      expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email address');
    });

    test('validatePassword validates minimum length', () {
      expect(Validators.validatePassword('HR@123'), isNull);
      expect(Validators.validatePassword(''), 'Password is required');
      expect(Validators.validatePassword(null), 'Password is required');
      expect(Validators.validatePassword('123'), 'Password must be at least 5 characters');
    });

    test('validatePhone validates phone numbers', () {
      expect(Validators.validatePhone('+919876543210'), isNull);
      expect(Validators.validatePhone('9876543210'), isNull);
      expect(Validators.validatePhone(''), 'Phone number is required');
      expect(Validators.validatePhone('123'), 'Please enter a valid phone number (10-14 digits)');
    });

    test('validateName validates full name', () {
      expect(Validators.validateName('Alex Mercer'), isNull);
      expect(Validators.validateName(''), 'Full name is required');
      expect(Validators.validateName('A'), 'Full name must be at least 2 characters');
    });

    test('validateAdults requires at least 1 adult', () {
      expect(Validators.validateAdults(1), isNull);
      expect(Validators.validateAdults(2), isNull);
      expect(Validators.validateAdults(0), 'At least 1 adult is required');
    });

    test('validateRooms requires at least 1 room', () {
      expect(Validators.validateRooms(1), isNull);
      expect(Validators.validateRooms(0), 'At least 1 room is required');
    });
  });
}
