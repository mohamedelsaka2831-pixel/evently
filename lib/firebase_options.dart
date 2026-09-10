
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
    apiKey: 'AIzaSyApItP3RJaTziXmdL7oIDThX7X26ytOTP8',
    appId: '1:76804139522:web:f8dee1544229cf5c1d151b',
    messagingSenderId: '76804139522',
    projectId: 'evently-elsaka',
    authDomain: 'evently-elsaka.firebaseapp.com',
    storageBucket: 'evently-elsaka.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBl21GTcB6LaJMqCwcUxezNFhH5J28W7aQ',
    appId: '1:76804139522:android:c66fd426f93535d31d151b',
    messagingSenderId: '76804139522',
    projectId: 'evently-elsaka',
    storageBucket: 'evently-elsaka.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnSFvkzJodFcCk3o_dUdwjcXEJmCt3CYM',
    appId: '1:76804139522:ios:baf509c44fcba6881d151b',
    messagingSenderId: '76804139522',
    projectId: 'evently-elsaka',
    storageBucket: 'evently-elsaka.firebasestorage.app',
    iosBundleId: 'com.example.evently',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAnSFvkzJodFcCk3o_dUdwjcXEJmCt3CYM',
    appId: '1:76804139522:ios:baf509c44fcba6881d151b',
    messagingSenderId: '76804139522',
    projectId: 'evently-elsaka',
    storageBucket: 'evently-elsaka.firebasestorage.app',
    iosBundleId: 'com.example.evently',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyApItP3RJaTziXmdL7oIDThX7X26ytOTP8',
    appId: '1:76804139522:web:27ab020216ea29751d151b',
    messagingSenderId: '76804139522',
    projectId: 'evently-elsaka',
    authDomain: 'evently-elsaka.firebaseapp.com',
    storageBucket: 'evently-elsaka.firebasestorage.app',
  );
}
