import '../../../../core/error/failures.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<({Failure? failure, AuthSession? session})> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}

class GetSessionUseCase {
  final AuthRepository _repository;
  const GetSessionUseCase(this._repository);

  Future<({Failure? failure, AuthSession? session})> call() {
    return _repository.getSession();
  }
}

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<({Failure? failure, bool success})> call() {
    return _repository.logout();
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<({Failure? failure, AuthSession? session})> call({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role = 'employee',
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      profileImageUrl: profileImageUrl,
      role: role,
    );
  }
}

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  const ForgotPasswordUseCase(this._repository);

  Future<({Failure? failure, bool success})> call({
    required String email,
  }) {
    return _repository.forgotPassword(email: email);
  }
}

