import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<({Failure? failure, AuthSession? session})> login({
    required String email,
    required String password,
  }) async {
    try {
      final sessionModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveSession(sessionModel);
      return (failure: null, session: sessionModel);
    } on AuthenticationException catch (e) {
      return (failure: AuthenticationFailure(e.message), session: null);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), session: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message, statusCode: e.statusCode), session: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), session: null);
    }
  }

  @override
  Future<({Failure? failure, AuthSession? session})> getSession() async {
    try {
      final sessionModel = await localDataSource.getSession();
      if (sessionModel == null) {
        return (failure: null, session: null);
      }
      if (sessionModel.isExpired) {
        await localDataSource.clearSession();
        return (failure: const AuthenticationFailure('Session expired'), session: null);
      }
      return (failure: null, session: sessionModel);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), session: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), session: null);
    }
  }

  @override
  Future<({Failure? failure, bool success})> logout() async {
    try {
      await localDataSource.clearSession();
      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), success: false);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), success: false);
    }
  }
}
