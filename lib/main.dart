import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/config/app_environment.dart';
import 'core/config/firebase_options.dart';
import 'core/di/injection.dart';
import 'core/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter Framework Error: ${details.exceptionAsString()}',
      tag: 'FLUTTER_ERROR ⚠️',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    AppLogger.error(
      'Uncaught Async Error: $error',
      tag: 'ASYNC_ERROR 💥',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  bool firebaseReady = false;
  try {
    AppLogger.info('Initializing Firebase...', tag: 'STARTUP 🚀');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    firebaseReady = true;
    AppLogger.firebase('Firebase initialized successfully (Online / Cloud Firestore ready)', isSuccess: true);
  } catch (e, stack) {
    AppLogger.firebase('Firebase initialization error', error: e, stackTrace: stack);
  }

  AppEnvironment.dataSourceMode = firebaseReady ? AppDataSourceMode.firebase : AppDataSourceMode.mock;
  AppLogger.info('Active Data Mode: ${AppEnvironment.dataSourceMode.name.toUpperCase()}', tag: 'STARTUP 🚀');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setApplicationSwitcherDescription(
    const ApplicationSwitcherDescription(
      label: 'Booking.com by Dilshan',
      primaryColor: 0xFF0D9488,
    ),
  );

  await initDependencies();

  runApp(const BookingApp());
}
