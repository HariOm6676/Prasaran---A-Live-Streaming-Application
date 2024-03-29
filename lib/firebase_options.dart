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
    apiKey: 'AIzaSyBXzaMtLWMfL19ZGjIoq_2izKVUCPsORcU',
    appId: '1:35356689493:web:568ae2513f3753702e00dc',
    messagingSenderId: '35356689493',
    projectId: 'prasaran',
    authDomain: 'prasaran.firebaseapp.com',
    storageBucket: 'prasaran.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWINGeiZfIUlx6pdS2u7MiOW2aZRlSk3c',
    appId: '1:35356689493:android:6d01b8b6adda39282e00dc',
    messagingSenderId: '35356689493',
    projectId: 'prasaran',
    storageBucket: 'prasaran.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH3rVyWdMsgaBNxOFL-aVGPXp-3dAabWU',
    appId: '1:35356689493:ios:838ac5a5508b959a2e00dc',
    messagingSenderId: '35356689493',
    projectId: 'prasaran',
    storageBucket: 'prasaran.appspot.com',
    iosBundleId: 'com.example.videoConferencing',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBH3rVyWdMsgaBNxOFL-aVGPXp-3dAabWU',
    appId: '1:35356689493:ios:cac484c2e8f789252e00dc',
    messagingSenderId: '35356689493',
    projectId: 'prasaran',
    storageBucket: 'prasaran.appspot.com',
    iosBundleId: 'com.example.videoConferencing.RunnerTests',
  );
}
