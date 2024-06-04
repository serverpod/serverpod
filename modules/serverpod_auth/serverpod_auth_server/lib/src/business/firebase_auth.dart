import 'dart:convert';
import 'dart:io';

import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';

/// Convenience methods for handling authentication with Firebase.
class FirebaseAuth {
  static FirebaseAuthManager? _authManager;

  /// Returns the Firebase app.
  /// This method will throw [FirebaseException]
  /// if it fails to load or validate the firebase user credentials
  static Future<FirebaseAuthManager> get authManager async {
    var authManager = _authManager;
    if (authManager != null) {
      return authManager;
    }

    Map<String, dynamic> firebaseServiceAccountJson;
    try {
      firebaseServiceAccountJson = jsonDecode(
        await File(AuthConfig.current.firebaseServiceAccountKeyJson)
            .readAsString(),
      );
    } catch (e) {
      throw FirebaseInitException(
        'Failed to load "firebase_service_account_key.json" file: $e',
      );
    }

    authManager = FirebaseAuthManager(
      firebaseServiceAccountJson,
    );

    _authManager = authManager;
    return authManager;
  }
}
