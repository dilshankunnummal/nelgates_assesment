import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/theme/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    test('initial theme is light when no persisted mode', () {
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeMode.light);
      expect(cubit.isDarkMode, isFalse);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'toggles from light to dark, then back to light',
      build: () => ThemeCubit(),
      act: (cubit) {
        cubit.toggleTheme();
        cubit.toggleTheme();
      },
      expect: () => [
        ThemeMode.dark,
        ThemeMode.light,
      ],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'setTheme explicitly sets ThemeMode',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setTheme(ThemeMode.dark),
      expect: () => [
        ThemeMode.dark,
      ],
    );
  });
}
