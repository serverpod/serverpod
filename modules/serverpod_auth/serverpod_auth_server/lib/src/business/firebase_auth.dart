import 'dart:convert';
import 'dart:io';

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

    Map<String, dynamic> json = jsonDecode(
      await File(AuthConfig.current.firebaseServiceAccountKeyJson)
          .readAsString(),
    );

    var auth = Auth();

    await auth.init(json);

    _auth = auth;
    return _auth!;
  }
}
