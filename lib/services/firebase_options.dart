import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyClxrtmVkKRi-Zr2iDk_HevmW0yMLAXzIs',
    authDomain: 'elderly-companion-app.firebaseapp.com',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
    messagingSenderId: '383134210909',
    appId: '1:383134210909:web:fee47d18d997264a07e6b4',
    measurementId: 'G-DG7Y1JFF9E',
  );

  // TODO: Replace these with native Firebase options from your Firebase project.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: '383134210909',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '383134210909',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
    iosBundleId: 'com.example.elderlycompanion',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: '383134210909',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
    iosBundleId: 'com.example.elderlycompanion',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: '383134210909',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: '383134210909',
    projectId: 'elderly-companion-app',
    storageBucket: 'elderly-companion-app.firebasestorage.app',
  );
}
