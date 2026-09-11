import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized, structured console logging utility for debug and production.
class AppLogger {
  // ANSI Color codes for clean console readability
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';

  static void info(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 19);
      debugPrint('$_blue[$timestamp] [ℹ️ $tag]$_reset $message');
    }
  }

  static void success(String message, {String tag = 'SUCCESS'}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 19);
      debugPrint('$_green[$timestamp] [✅ $tag]$_reset $message');
    }
  }

  static void warning(String message, {String tag = 'WARNING', Object? error}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 19);
      debugPrint('$_yellow[$timestamp] [⚠️ $tag]$_reset $message${error != null ? " | Error: $error" : ""}');
    }
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final errorDetail = error != null ? '\n  ➜ Details: $error' : '';
    debugPrint('$_red[$timestamp] [❌ $tag]$_reset $message$errorDetail');
    if (stackTrace != null && kDebugMode) {
      debugPrint('$_red  ➜ StackTrace:\n$stackTrace$_reset');
    }
    // Also send to developer log for DevTools inspection
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void firebase(String message, {Object? error, StackTrace? stackTrace, bool isSuccess = false}) {
    if (error != null) {
      AppLogger.error(message, tag: 'FIREBASE 🔥', error: error, stackTrace: stackTrace);
    } else if (isSuccess) {
      AppLogger.success(message, tag: 'FIREBASE 🔥');
    } else {
      AppLogger.info(message, tag: 'FIREBASE 🔥');
    }
  }

  static void cloudinary(String message, {Object? error, bool isSuccess = false}) {
    if (error != null) {
      AppLogger.error(message, tag: 'CLOUDINARY ☁️', error: error);
    } else if (isSuccess) {
      AppLogger.success(message, tag: 'CLOUDINARY ☁️');
    } else {
      AppLogger.info(message, tag: 'CLOUDINARY ☁️');
    }
  }

  static void seeder(String message, {Object? error, bool isSuccess = false}) {
    if (error != null) {
      AppLogger.error(message, tag: 'SEEDER 🌱', error: error);
    } else if (isSuccess) {
      AppLogger.success(message, tag: 'SEEDER 🌱');
    } else {
      AppLogger.info(message, tag: 'SEEDER 🌱');
    }
  }

  static void auth(String message, {Object? error, bool isSuccess = false}) {
    if (error != null) {
      AppLogger.error(message, tag: 'AUTH 🔐', error: error);
    } else if (isSuccess) {
      AppLogger.success(message, tag: 'AUTH 🔐');
    } else {
      AppLogger.info(message, tag: 'AUTH 🔐');
    }
  }
}
