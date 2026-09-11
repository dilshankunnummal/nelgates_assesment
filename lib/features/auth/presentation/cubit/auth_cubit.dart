import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetSessionUseCase getSessionUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
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

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profileImageUrl,
    String role = 'employee',
  }) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
      phone: phone,
      profileImageUrl: profileImageUrl,
      role: role,
    );
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
    } else if (result.session != null) {
      emit(Authenticated(result.session!));
    } else {
      emit(const AuthError('Registration failed. Please try again.'));
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    final result = await forgotPasswordUseCase(email: email);
    if (result.failure != null) {
      emit(AuthError(result.failure!.message));
      return false;
    }
    return result.success;
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await logoutUseCase();
    emit(const Unauthenticated());
  }
}
