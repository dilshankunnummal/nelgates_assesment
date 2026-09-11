import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/firebase_auth_data_source.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final AuthLocalDataSource localDataSource;

  FirebaseAuthRepositoryImpl({
    required this.firebaseAuthDataSource,
    required this.localDataSource,
  });

  @override
  Future<({Failure? failure, AuthSession? session})> login({
    required String email,
    required String password,
  }) async {
    try {
      final sessionModel = await firebaseAuthDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveSession(sessionModel);
      return (failure: null, session: sessionModel);
    } on AuthenticationException catch (e) {
      return (failure: AuthenticationFailure(e.message), session: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), session: null);
    }
  }

  @override
  Future<({Failure? failure, AuthSession? session})> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role = 'employee',
  }) async {
    try {
      final sessionModel = await firebaseAuthDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        profileImageUrl: profileImageUrl,
        role: role,
      );
      await localDataSource.saveSession(sessionModel);
      return (failure: null, session: sessionModel);
    } on AuthenticationException catch (e) {
      return (failure: AuthenticationFailure(e.message), session: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), session: null);
    }
  }

  @override
  Future<({Failure? failure, bool success})> forgotPassword({
    required String email,
  }) async {
    try {
      await firebaseAuthDataSource.forgotPassword(email: email);
      return (failure: null, success: true);
    } on AuthenticationException catch (e) {
      return (failure: AuthenticationFailure(e.message), success: false);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), success: false);
    }
  }

  @override
  Future<({Failure? failure, AuthSession? session})> getSession() async {
    try {
      // 1. Check local Hive session first
      final localSession = await localDataSource.getSession();
      if (localSession != null && !localSession.isExpired) {
        return (failure: null, session: localSession);
      }

      // 2. Check current Firebase session
      final firebaseSession = await firebaseAuthDataSource.getCurrentSession();
      if (firebaseSession != null) {
        await localDataSource.saveSession(firebaseSession);
        return (failure: null, session: firebaseSession);
      }

      return (failure: null, session: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), session: null);
    }
  }

  @override
  Future<({Failure? failure, bool success})> logout() async {
    try {
      await firebaseAuthDataSource.logout();
      await localDataSource.clearSession();
      return (failure: null, success: true);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), success: false);
    }
  }
}
