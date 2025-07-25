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
    apiKey: 'AIzaSyDVSPS3uk4_jUgy5l8AaWtJJSHW18jPtZQ',
    appId: '1:123727316886:web:743b6e27c29b8baf81ffb7',
    messagingSenderId: '123727316886',
    projectId: 'instaxbloc-5251f',
    authDomain: 'instaxbloc-5251f.firebaseapp.com',
    storageBucket: 'instaxbloc-5251f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjS2YlHPeIVh8jZ78HeYoR8h7dah4anl4',
    appId: '1:123727316886:android:71a9935a55636a3581ffb7',
    messagingSenderId: '123727316886',
    projectId: 'instaxbloc-5251f',
    storageBucket: 'instaxbloc-5251f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCB6vfzztTC8NYRAt6hUmzQIgXGl12egwI',
    appId: '1:123727316886:ios:b9c24e8710da1f9c81ffb7',
    messagingSenderId: '123727316886',
    projectId: 'instaxbloc-5251f',
    storageBucket: 'instaxbloc-5251f.firebasestorage.app',
    iosBundleId: 'com.example.instaXBloc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCB6vfzztTC8NYRAt6hUmzQIgXGl12egwI',
    appId: '1:123727316886:ios:b9c24e8710da1f9c81ffb7',
    messagingSenderId: '123727316886',
    projectId: 'instaxbloc-5251f',
    storageBucket: 'instaxbloc-5251f.firebasestorage.app',
    iosBundleId: 'com.example.instaXBloc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVSPS3uk4_jUgy5l8AaWtJJSHW18jPtZQ',
    appId: '1:123727316886:web:1264849fdc18b29281ffb7',
    messagingSenderId: '123727316886',
    projectId: 'instaxbloc-5251f',
    authDomain: 'instaxbloc-5251f.firebaseapp.com',
    storageBucket: 'instaxbloc-5251f.firebasestorage.app',
  );
}
