import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Public Firebase web config for the push example.
///
/// Android uses a local `google-services.json` (not committed). Web reads
/// values from `--dart-define`s. The service worker at
/// `web/firebase-messaging-sw.js` must use the same project values.
class FirebaseBootstrap {
  /// Initializes Firebase when the current platform has config.
  static Future<void> init() async {
    if (kIsWeb) {
      if (!isWebConfigured) return;
      await Firebase.initializeApp(options: webOptions);
      return;
    }
    await Firebase.initializeApp();
  }

  /// True when the web `--dart-define`s needed to initialize Firebase are set.
  static bool get isWebConfigured {
    return const String.fromEnvironment('FIREBASE_API_KEY').isNotEmpty &&
        const String.fromEnvironment('FIREBASE_APP_ID').isNotEmpty &&
        const String.fromEnvironment('FIREBASE_PROJECT_ID').isNotEmpty;
  }

  /// Web-only options. All values come from `--dart-define`s.
  static FirebaseOptions get webOptions {
    return const FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      databaseURL: String.fromEnvironment('FIREBASE_DATABASE_URL'),
      measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
    );
  }

  /// VAPID key for `FirebaseMessaging.getToken` on web.
  static String? get vapidKey {
    const key = String.fromEnvironment('FCM_VAPID_KEY');
    return key.isEmpty ? null : key;
  }
}
