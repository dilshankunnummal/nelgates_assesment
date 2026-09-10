import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../constants/storage_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box? _themeBox;

  ThemeCubit({Box? themeBox})
      : _themeBox = themeBox,
        super(_initialTheme(themeBox));

  static ThemeMode _initialTheme(Box? box) {
    if (box == null) return ThemeMode.light;
    final savedMode = box.get(StorageConstants.themeModeKey);
    if (savedMode == 'dark') return ThemeMode.dark;
    if (savedMode == 'light') return ThemeMode.light;
    return ThemeMode.light;
  }

  void toggleTheme() {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setTheme(nextMode);
  }

  void setTheme(ThemeMode mode) {
    _themeBox?.put(
      StorageConstants.themeModeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(mode);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
