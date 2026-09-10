import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthSession extends Equatable {
  final User user;
  final String token;
  final DateTime expiresAt;

  const AuthSession({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [user, token, expiresAt];
}
