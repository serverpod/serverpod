import 'package:serverpod_auth_server/src/firebase/auth/credential.dart';

import 'firebase_admin.dart';
import 'app/firebase_internals.dart';
import 'service.dart';

/// Represents initialized Firebase application and provides access to the
/// app's services.
class App {
  final String _name;

  final AppOptions _options;

  final Map<Type, FirebaseService> _services = {};

  final FirebaseAppInternals _internals;

  FirebaseAppInternals get internals => _internals;

  /// Do not call this constructor directly. Instead, use
  /// [FirebaseAdmin.initializeApp] to create an app.
  App(String name, AppOptions options)
      : _name = name,
        _internals = FirebaseAppInternals(options.credential),
        _options = options;

  /// The name of this application.
  ///
  /// `[DEFAULT]` is the name of the default App.
  String get name {
    _checkDestroyed();
    return _name;
  }

  /// The (read-only) configuration options for this app.
  ///
  /// These are the original parameters given in [FirebaseAdmin.initializeApp].
  AppOptions get options {
    _checkDestroyed();
    return _options;
  }

  /// Gets the [Auth] service for this application.
  Auth auth() => _getService(() => Auth(this));

  T _getService<T extends FirebaseService>(T Function() factory) {
    _checkDestroyed();
    return (_services[T] ??= factory()) as T;
  }

  /// Throws an Error if the FirebaseApp instance has already been deleted.
  void _checkDestroyed() {
    if (internals.isDeleted) {
      throw FirebaseAppError.appDeleted(
        'Firebase app named "$_name" has already been deleted.',
      );
    }
  }
}

/// Available options to pass to initializeApp().
class AppOptions {
  /// A [Credential] object used to authenticate the Admin SDK.
  ///
  /// You can obtain a credential via one of the following methods:
  ///
  /// - [applicationDefaultCredential]
  /// - [cert]
  /// - [refreshToken]
  final Credential credential;

  /// The URL of the Realtime Database from which to read and write data.
  final String? databaseUrl;

  /// The ID of the Google Cloud project associated with the App.
  final String? projectId;

  /// The name of the default Cloud Storage bucket associated with the App.
  final String? storageBucket;

  /// The client email address of the service account.
  final String? serviceAccountId;

  /// Creates new [AppOptions] object
  AppOptions({
    required this.credential,
    this.databaseUrl,
    this.projectId,
    this.storageBucket,
    this.serviceAccountId,
  });
}
