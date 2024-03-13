import 'package:firebase_admin/firebase_admin.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Convenience methods for handling authentication with Firebase.
class FirebaseAuth {
  static App? _app;

  /// Returns the Firebase app.
  static App get app {
    if (_app != null) {
      return _app!;
    }

    var cert = FirebaseAdmin.instance.certFromPath(
      AuthConfig.current.firebaseServiceAccountKeyJson,
    );

    var app = FirebaseAdmin.instance.initializeApp(
      AppOptions(credential: cert),
    );

    _app = app;
    return app;
  }
}
