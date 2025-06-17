import 'dart:convert';
import 'dart:io';

import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';

// Since we do not have access to [session.passwords] in this class, we need to
// manually check for the password with the prefix "SERVERPOD_PASSWORD_" in the
// environment variables. This prefix would be stripped by the PasswordManager
// when the password is loaded.
const _passwordKey =
    'SERVERPOD_PASSWORD_serverpod_auth_firebaseServiceAccountKey';

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
      if (Platform.environment.containsKey(_passwordKey)) {
        firebaseServiceAccountJson = jsonDecode(
          Platform.environment[_passwordKey]!,
        );
      } else {
        firebaseServiceAccountJson = jsonDecode(
          await File(AuthConfig.current.firebaseServiceAccountKeyJson)
              .readAsString(),
        );
      }
    } catch (e) {
      throw FirebaseInitException(
        'Failed to load "firebase_service_account_key.json" file or password '
        '${_passwordKey.substring('SERVERPOD_PASSWORD_'.length)}: $e',
      );
    }

    authManager = FirebaseAuthManager(
      firebaseServiceAccountJson,
    );

    _authManager = authManager;
    return authManager;
  }
}
