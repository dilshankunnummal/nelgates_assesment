import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/core/error/failures.dart';
import 'package:nelegate_assessment/features/auth/domain/entities/auth_session.dart';
import 'package:nelegate_assessment/features/auth/domain/entities/user.dart';
import 'package:nelegate_assessment/features/auth/domain/usecases/auth_usecases.dart';
import 'package:nelegate_assessment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nelegate_assessment/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}
class MockGetSessionUseCase extends Mock implements GetSessionUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockGetSessionUseCase mockGetSessionUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthCubit authCubit;

  const tUser = User(
    id: 'USR-001',
    email: 'employee@hotel.com',
    name: 'Alex Mercer',
    role: 'employee',
  );

  final tSession = AuthSession(
    user: tUser,
    token: 'test_token',
    expiresAt: DateTime.now().add(const Duration(days: 10)),
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockGetSessionUseCase = MockGetSessionUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authCubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      forgotPasswordUseCase: mockForgotPasswordUseCase,
      getSessionUseCase: mockGetSessionUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });


  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, const AuthInitial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase(
              email: 'employee@hotel.com',
              password: 'Employee@123',
            )).thenAnswer((_) async => (failure: null, session: tSession));
        return authCubit;
      },
      act: (cubit) => cubit.login(
        email: 'employee@hotel.com',
        password: 'Employee@123',
      ),
      expect: () => [
        const AuthLoading(),
        Authenticated(tSession),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when login fails with invalid credentials',
      build: () {
        when(() => mockLoginUseCase(
              email: 'wrong@hotel.com',
              password: 'wrong',
            )).thenAnswer((_) async => (
              failure: const AuthenticationFailure('Invalid credentials'),
              session: null,
            ));
        return authCubit;
      },
      act: (cubit) => cubit.login(
        email: 'wrong@hotel.com',
        password: 'wrong',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] on logout',
      build: () {
        when(() => mockLogoutUseCase()).thenAnswer((_) async => (failure: null, success: true));
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });
}
