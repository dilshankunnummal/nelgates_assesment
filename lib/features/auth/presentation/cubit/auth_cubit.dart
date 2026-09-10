import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final GetSessionUseCase getSessionUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.getSessionUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial());

  Future<void> checkAuthSession() async {
    emit(const AuthLoading());
    final result = await getSessionUseCase();
    if (result.failure != null) {
      emit(const Unauthenticated());
    } else if (result.session != null) {
      emit(Authenticated(result.session!));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await loginUseCase(email: email, password: password);
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
    } else if (result.session != null) {
      emit(Authenticated(result.session!));
    } else {
      emit(const AuthError('Authentication failed. Please try again.'));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await logoutUseCase();
    emit(const Unauthenticated());
  }
}
