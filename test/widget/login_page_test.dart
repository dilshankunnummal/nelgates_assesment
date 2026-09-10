import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nelegate_assessment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nelegate_assessment/features/auth/presentation/cubit/auth_state.dart';
import 'package:nelegate_assessment/features/auth/presentation/pages/login_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('LoginPage renders email, password fields and demo buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Employee Login'), findsOneWidget);
    expect(find.text('HR Login'), findsOneWidget);
  });
}
