// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBuHuLHGSoFiAns_SkifJvE4-OvRYw9snk',
    appId: '1:493471932326:web:f57a539c642bd40adbf967',
    messagingSenderId: '493471932326',
    projectId: 'mis3-da4d2',
    authDomain: 'mis3-da4d2.firebaseapp.com',
    storageBucket: 'mis3-da4d2.appspot.com',
    measurementId: 'G-NPLNHJLMCT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAF6y_UD13lpsR9YMbsDcf-HAi1tHHZNIY',
    appId: '1:493471932326:android:3e28623d6b203350dbf967',
    messagingSenderId: '493471932326',
    projectId: 'mis3-da4d2',
    storageBucket: 'mis3-da4d2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_HCo6B8SzIob64Iv_MQl-TEXqGxUPrqc',
    appId: '1:493471932326:ios:23b50a1ec6cc49ebdbf967',
    messagingSenderId: '493471932326',
    projectId: 'mis3-da4d2',
    storageBucket: 'mis3-da4d2.appspot.com',
    iosBundleId: 'com.example.mis3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_HCo6B8SzIob64Iv_MQl-TEXqGxUPrqc',
    appId: '1:493471932326:ios:4e060045e0d73a2fdbf967',
    messagingSenderId: '493471932326',
    projectId: 'mis3-da4d2',
    storageBucket: 'mis3-da4d2.appspot.com',
    iosBundleId: 'com.example.mis3.RunnerTests',
  );
}
