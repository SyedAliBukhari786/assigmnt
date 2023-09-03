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
    apiKey: 'AIzaSyDN6Morvl9LWz09oPB9NJiEzUm3oED_OEU',
    appId: '1:522641953528:web:141ca140a7d3d71c5ce10d',
    messagingSenderId: '522641953528',
    projectId: 'flutterclitesting',
    authDomain: 'flutterclitesting.firebaseapp.com',
    databaseURL: 'https://flutterclitesting-default-rtdb.firebaseio.com',
    storageBucket: 'flutterclitesting.appspot.com',
    measurementId: 'G-0D0PSKL43X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO9WQPDA1npLuTFmW_Yd93aIe3CrVFMgo',
    appId: '1:522641953528:android:eb4851910fbd1af25ce10d',
    messagingSenderId: '522641953528',
    projectId: 'flutterclitesting',
    databaseURL: 'https://flutterclitesting-default-rtdb.firebaseio.com',
    storageBucket: 'flutterclitesting.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8TTqa0SiUl_U0zbuslfZw9G9s_7TMzh4',
    appId: '1:522641953528:ios:c5ea07bfe3c3c8675ce10d',
    messagingSenderId: '522641953528',
    projectId: 'flutterclitesting',
    databaseURL: 'https://flutterclitesting-default-rtdb.firebaseio.com',
    storageBucket: 'flutterclitesting.appspot.com',
    iosClientId: '522641953528-91tb0fh5dvb320nrg0ka6vnv4cr6fcj0.apps.googleusercontent.com',
    iosBundleId: 'com.example.testproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8TTqa0SiUl_U0zbuslfZw9G9s_7TMzh4',
    appId: '1:522641953528:ios:a2b0e778efe607c75ce10d',
    messagingSenderId: '522641953528',
    projectId: 'flutterclitesting',
    databaseURL: 'https://flutterclitesting-default-rtdb.firebaseio.com',
    storageBucket: 'flutterclitesting.appspot.com',
    iosClientId: '522641953528-ejcqsa6qmu5vsgp3u8bki8ta93di0829.apps.googleusercontent.com',
    iosBundleId: 'com.example.testproject.RunnerTests',
  );
}