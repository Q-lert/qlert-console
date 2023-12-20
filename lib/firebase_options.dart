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
    apiKey: 'AIzaSyDaMEjKWNugspOyl_bhPEUi5NH9-D1XXeE',
    appId: '1:504418280321:web:ee40c89128c1e9a1d03e80',
    messagingSenderId: '504418280321',
    projectId: 'qlert-58141',
    authDomain: 'qlert-58141.firebaseapp.com',
    storageBucket: 'qlert-58141.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfh4zP8qmBYpMXBqCCoURx3WOVeTeniSk',
    appId: '1:504418280321:android:90c5cb3d160ebd0ed03e80',
    messagingSenderId: '504418280321',
    projectId: 'qlert-58141',
    storageBucket: 'qlert-58141.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0vujxPXkJ3DB2Ew7YomgE0NRnQi4QwCA',
    appId: '1:504418280321:ios:f58565cb0602f798d03e80',
    messagingSenderId: '504418280321',
    projectId: 'qlert-58141',
    storageBucket: 'qlert-58141.appspot.com',
    iosBundleId: 'com.example.qlertConsole',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0vujxPXkJ3DB2Ew7YomgE0NRnQi4QwCA',
    appId: '1:504418280321:ios:7730d06656552d88d03e80',
    messagingSenderId: '504418280321',
    projectId: 'qlert-58141',
    storageBucket: 'qlert-58141.appspot.com',
    iosBundleId: 'com.example.qlertConsole.RunnerTests',
  );
}
