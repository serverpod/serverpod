import 'dart:convert';
import 'dart:io';


import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:serverpod_auth_server/src/firebase/src/utils/env.dart';

import 'auth/credential.dart';

/// Provides access to Firebase Admin APIs.
///
/// To start using Firebase services initialize a Firebase application with
/// [initializeApp] method.
class FirebaseAdmin {
  final Map<String, App> _apps = {};

  static final FirebaseAdmin instance = FirebaseAdmin._();

  static const String defaultAppName = '[DEFAULT]';
  static const String firebaseConfigVar = 'FIREBASE_CONFIG';

  FirebaseAdmin._();

  /// Creates and initializes a Firebase [App] instance with the given
  /// [options] and [name].
  ///
  /// The options is initialized with provided `credential` and `databaseURL`.
  /// A valid credential can be obtained with [cert] or
  /// [certFromPath].
  ///
  /// The [name] argument allows using multiple Firebase applications at the same
  /// time. If omitted then default app name is used.
  ///
  /// Example:
  ///
  ///     var certificate = FirebaseAdmin.instance.cert(
  ///       projectId: 'your-project-id',
  ///       clientEmail: 'your-client-email',
  ///       privateKey: 'your-private-key',
  ///     );
  ///     var app = FirebaseAdmin.instance.initializeApp(
  ///       AppOptions(
  ///         credential: certificate,
  ///         databaseURL: 'https://your-database.firebase.io')
  ///     );
  ///
  /// See also:
  ///   * [App]
  ///   * [cert]
  ///   * [certFromPath]
  App initializeApp([AppOptions? options, String name = defaultAppName]) {
    options ??= _loadOptionsFromEnvVar(Credentials.applicationDefault());
    if (name.isEmpty) {
      throw FirebaseAppError.invalidAppName(
        'Invalid Firebase app name "$name" provided. App name must be a non-empty string.',
      );
    } else if (_apps.containsKey(name)) {
      if (name == defaultAppName) {
        throw FirebaseAppError.duplicateApp(
          'The default Firebase app already exists. This means you called initializeApp() '
          'more than once without providing an app name as the second argument. In most cases '
          'you only need to call initializeApp() once. But if you do want to initialize '
          'multiple apps, pass a second argument to initializeApp() to give each app a unique '
          'name.',
        );
      } else {
        throw FirebaseAppError.duplicateApp(
          'Firebase app named "$name" already exists. This means you called initializeApp() '
          'more than once with the same app name as the second argument. Make sure you provide a '
          'unique name every time you call initializeApp().',
        );
      }
    }

    return _apps[name] = App(name, options);
  }

  /// Returns the FirebaseApp instance with the provided name (or the default
  /// FirebaseApp instance if no name is provided).
  App? app([String appName = defaultAppName]) {
    if (appName.isEmpty) {
      throw FirebaseAppError.invalidAppName(
        'Invalid Firebase app name "$appName" provided. App name must be a non-empty string.',
      );
    } else if (_apps[appName] == null) {
      var errorMessage = appName == defaultAppName
          ? 'The default Firebase app does not exist. '
          : 'Firebase app named "$appName" does not exist. ';
      errorMessage +=
          'Make sure you call initializeApp() before using any of the Firebase services.';

      throw FirebaseAppError.noApp(errorMessage);
    }

    return _apps[appName];
  }

  /// Returns an array of all the non-deleted FirebaseApp instances.
  List<App> get apps => _apps.values.toList();

  /// Creates [App] certificate.
  Credential cert({
    required String projectId,
    required String clientEmail,
    required String privateKey,
  }) {
    throw UnimplementedError();
  }

  /// Creates app certificate from service account file at specified [path].
  Credential certFromPath(String path) {
    return ServiceAccountCredential(path);
  }

  /// Parse the file pointed to by the FIREBASE_CONFIG_VAR, if it exists.
  /// Or if the FIREBASE_CONFIG_ENV contains a valid JSON object, parse it
  /// directly.
  /// If the environment variable contains a string that starts with '{' it will
  /// be parsed as JSON, otherwise it will be assumed to be pointing to a file.
  AppOptions _loadOptionsFromEnvVar(Credential? credential) {
    var config = env[firebaseConfigVar];
    if (config == null || config.isEmpty) {
      return AppOptions(credential: credential!);
    }
    try {
      var contents =
          config.startsWith('{') ? config : File(config).readAsStringSync();
      var v = json.decode(contents) as Map;
      return AppOptions(
        credential: credential!,
        projectId: v['projectId'],
        databaseUrl: v['databaseURL'],
        storageBucket: v['storageBucket'],
      );
    } catch (error) {
      // Throw a nicely formed error message if the file contents cannot be parsed
      throw FirebaseAppError.invalidAppOptions(
        'Failed to parse app options file: $error',
      );
    }
  }
}

extension FirebaseAdminExtension on FirebaseAdmin {
  void removeApp(String name) {
    _apps.remove(name);
  }
}
