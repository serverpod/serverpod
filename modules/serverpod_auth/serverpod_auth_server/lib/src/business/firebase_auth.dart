import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';

/// Convenience methods for handling authentication with Firebase.
class FirebaseAuth {
  static Auth? _auth;

  /// Returns the Firebase app.
  static Future<Auth> get auth async {
    if (_auth != null) {
      return _auth!;
    }

    await Auth.instance.init(
      AuthConfig.current.firebaseServiceAccountKeyJson,
    );

    _auth = Auth.instance;
    return _auth!;
  }
}
