import 'dart:convert';
import 'dart:io';

import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';

/// Convenience methods for handling authentication with Firebase.
class FirebaseAuth {
  static FirebaseAuthManager? _authManager;

  /// Returns the Firebase app.
  static Future<FirebaseAuthManager> get authManager async {
    if (_authManager != null) {
      return _authManager!;
    }

    var firebaseServiceAccountJson = jsonDecode(
      await File(AuthConfig.current.firebaseServiceAccountKeyJson)
          .readAsString(),
    );

    var authManager = FirebaseAuthManager();
    await authManager.init(firebaseServiceAccountJson);

    _authManager = authManager;
    return _authManager!;
  }
}
