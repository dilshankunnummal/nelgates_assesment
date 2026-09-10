import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('parses JSON with all fields', () {
      final json = {
        'id': 'USR-HR-001',
        'email': 'hr@hotel.com',
        'name': 'Sarah Jenkins (HR Manager)',
        'role': 'hr',
        'avatar': 'https://hotel.com/avatar.jpg',
        'phone': '+91 9811223344',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'USR-HR-001');
      expect(user.email, 'hr@hotel.com');
      expect(user.isHr, isTrue);
      expect(user.avatar, 'https://hotel.com/avatar.jpg');
    });

    test('handles missing optional fields with defaults', () {
      final json = {
        'id': 'USR-002',
        'email': 'employee@hotel.com',
        'name': 'Alex Mercer',
        'role': 'employee',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'USR-002');
      expect(user.isHr, isFalse);
      expect(user.avatar, isEmpty);
      expect(user.phone, isNull);
    });

    test('toJson serializes correctly', () {
      const user = UserModel(
        id: 'USR-001',
        email: 'test@hotel.com',
        name: 'Test User',
        role: 'employee',
      );

      final json = user.toJson();
      expect(json['id'], 'USR-001');
      expect(json['email'], 'test@hotel.com');
      expect(json['role'], 'employee');
    });
  });
}
