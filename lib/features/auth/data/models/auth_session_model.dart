import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.user,
    required super.token,
    required super.expiresAt,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final userMap = SafeParser.toMap(json['user']);
    final user = UserModel.fromJson(userMap);
    final token = SafeParser.toStr(json['token'], fallback: 'mock_jwt_token');
    final expiresAt = SafeParser.toDateTime(json['expires_at'] ?? json['expiresAt']) ??
        DateTime.now().add(const Duration(days: 30));

    return AuthSessionModel(
      user: user,
      token: token,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user is UserModel) ? (user as UserModel).toJson() : UserModel.fromEntity(user).toJson(),
      'token': token,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  factory AuthSessionModel.fromEntity(AuthSession entity) {
    return AuthSessionModel(
      user: entity.user,
      token: entity.token,
      expiresAt: entity.expiresAt,
    );
  }
}
