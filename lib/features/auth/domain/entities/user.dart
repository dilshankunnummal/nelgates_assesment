import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role; // 'hr' or 'employee'
  final String? avatar;
  final String? phone;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
    this.phone,
  });

  bool get isHr => role.toLowerCase() == 'hr';

  @override
  List<Object?> get props => [id, email, name, role, avatar, phone];
}
