// File generated for Firebase initialization across platforms.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCv3Szq1YT35AMTNvip_mo9WABdh6aZWVg',
    appId: '1:274482428373:web:c833200e611e2a9e35255c',
    messagingSenderId: '274482428373',
    projectId: 'story-nest-8e84c',
    authDomain: 'story-nest-8e84c.firebaseapp.com',
    storageBucket: 'story-nest-8e84c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCv3Szq1YT35AMTNvip_mo9WABdh6aZWVg',
    appId: '1:274482428373:android:c833200e611e2a9e35255c',
    messagingSenderId: '274482428373',
    projectId: 'story-nest-8e84c',
    storageBucket: 'story-nest-8e84c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv3Szq1YT35AMTNvip_mo9WABdh6aZWVg',
    appId: '1:274482428373:ios:1234567890abcdef',
    messagingSenderId: '274482428373',
    projectId: 'story-nest-8e84c',
    storageBucket: 'story-nest-8e84c.firebasestorage.app',
    iosBundleId: 'com.example.nelegateAssessment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCv3Szq1YT35AMTNvip_mo9WABdh6aZWVg',
    appId: '1:274482428373:ios:1234567890abcdef',
    messagingSenderId: '274482428373',
    projectId: 'story-nest-8e84c',
    storageBucket: 'story-nest-8e84c.firebasestorage.app',
    iosBundleId: 'com.example.nelegateAssessment',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv3Szq1YT35AMTNvip_mo9WABdh6aZWVg',
    appId: '1:274482428373:web:c833200e611e2a9e35255c',
    messagingSenderId: '274482428373',
    projectId: 'story-nest-8e84c',
    authDomain: 'story-nest-8e84c.firebaseapp.com',
    storageBucket: 'story-nest-8e84c.firebasestorage.app',
  );
}
