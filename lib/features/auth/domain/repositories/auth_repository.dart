import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<({Failure? failure, AuthSession? session})> login({
    required String email,
    required String password,
  });

  Future<({Failure? failure, AuthSession? session})> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role,
  });

  Future<({Failure? failure, bool success})> forgotPassword({
    required String email,
  });

  Future<({Failure? failure, AuthSession? session})> getSession();

  Future<({Failure? failure, bool success})> logout();
}

