import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';

const _passwordKey = 'serverpod_auth_firebaseServiceAccountKey';

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
      final password = Serverpod.instance.getPassword(_passwordKey);
      if (password != null) {
        firebaseServiceAccountJson = jsonDecode(password);
      } else {
        firebaseServiceAccountJson = jsonDecode(
          await File(AuthConfig.current.firebaseServiceAccountKeyJson)
              .readAsString(),
        );
      }
    } catch (e) {
      throw FirebaseInitException(
        'Failed to load "firebase_service_account_key.json" file or password '
        '$_passwordKey: $e',
      );
    }

    authManager = FirebaseAuthManager(
      firebaseServiceAccountJson,
    );

    _authManager = authManager;
    return authManager;
  }
}
