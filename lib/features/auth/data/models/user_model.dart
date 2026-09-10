import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.avatar,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: SafeParser.toStr(json['id'], fallback: 'USR-001'),
      email: SafeParser.toStr(json['email'], fallback: 'user@hotel.com'),
      name: SafeParser.toStr(json['name'], fallback: 'Guest User'),
      role: SafeParser.toStr(json['role'], fallback: 'employee'),
      avatar: SafeParser.toImageUrl(json['avatar'] ?? json['image']),
      phone: json['phone'] != null ? SafeParser.toStr(json['phone']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'avatar': avatar,
      'phone': phone,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      avatar: user.avatar,
      phone: user.phone,
    );
  }
}
