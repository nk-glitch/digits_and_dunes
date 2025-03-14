// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDrFI0tE_Cc4r2nth44WItI8-RXbBEyVuM',
    appId: '1:337460878186:web:1d157b624c671afcbb2313',
    messagingSenderId: '337460878186',
    projectId: 'digits-and-dunes',
    authDomain: 'digits-and-dunes.firebaseapp.com',
    storageBucket: 'digits-and-dunes.firebasestorage.app',
    measurementId: 'G-7ELM3ND8DQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA41hnDEAPqaEFZ01wg6FcQ2218V6Z9Sto',
    appId: '1:337460878186:android:3a75bacaf779a292bb2313',
    messagingSenderId: '337460878186',
    projectId: 'digits-and-dunes',
    storageBucket: 'digits-and-dunes.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8TB1qh-0Cj02Uf8vklHwGR8ELqsh03Ak',
    appId: '1:337460878186:ios:baf106a19e8af8c2bb2313',
    messagingSenderId: '337460878186',
    projectId: 'digits-and-dunes',
    storageBucket: 'digits-and-dunes.firebasestorage.app',
    iosBundleId: 'com.example.digitsAndDunes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDrFI0tE_Cc4r2nth44WItI8-RXbBEyVuM',
    appId: '1:337460878186:web:1774935ce78f7537bb2313',
    messagingSenderId: '337460878186',
    projectId: 'digits-and-dunes',
    authDomain: 'digits-and-dunes.firebaseapp.com',
    storageBucket: 'digits-and-dunes.firebasestorage.app',
    measurementId: 'G-CTFGEQ3GXM',
  );
}
