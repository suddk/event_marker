// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBlcQUdTNG1VP4FXhBLl07KTzG1Y1H7ZY4",
    appId: "1:703420758038:android:bb42fa4d1102e5b15a6011",
    messagingSenderId: "703420758038",
    projectId: "eventmarker-b979e",
    storageBucket: "eventmarker-b979e.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAtcvZw9Qco44WJJT6Zc5jbpUb2UAIJDCI",
    appId: "1:703420758038:ios:c32a4ffaba38bd6b5a6011",
    messagingSenderId: "703420758038",
    projectId: "eventmarker-b979e",
    storageBucket: "eventmarker-b979e.appspot.com",
    iosClientId: "703420758038-cdqb3fq94b5hmklf89p1tg64vgfi22q3.apps.googleusercontent.com",
    iosBundleId: "com.example.eventmarker",
  );
}
