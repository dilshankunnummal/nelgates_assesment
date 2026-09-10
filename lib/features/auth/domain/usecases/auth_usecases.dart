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
