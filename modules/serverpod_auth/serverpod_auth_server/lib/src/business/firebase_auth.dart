import 'dart:convert';

import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/app.dart';
import 'package:serverpod_auth_server/src/firebase/auth.dart';

/// Convenience methods for handling authentication with Firebase.
class FirebaseAuth {
  static Auth? _auth;

  /// Returns the Firebase app.
  static Auth get auth {
    if (_auth != null) {
      return _auth!;
    }

    var auth = Auth(
      App(
        jsonDecode(
          AuthConfig.current.firebaseServiceAccountKeyJson,
        ),
      ),
    );
    _auth = auth;
    return _auth!;
  }
}
