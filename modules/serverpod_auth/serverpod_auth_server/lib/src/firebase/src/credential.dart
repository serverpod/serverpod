import 'dart:convert';
import 'dart:io';

import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/src/utils/env.dart';

import 'auth/credential.dart';
import 'utils/error.dart';
import 'package:path/path.dart' as path;

void setApplicationDefaultCredential(Credential? credential) {
  Credentials._globalAppDefaultCred = credential;
}

class Credentials {
  static Credential? _globalAppDefaultCred;

  static Future<void> logout() async {
    var f = File(firebaseAdminCredentialPath!);
    await f.delete();
  }

  static Future<Credential> login(
      {String? clientId, String? clientSecret}) async {
    var issuer = await Issuer.discover(Issuer.google);

    var client = Client(
      issuer,
      clientId ?? String.fromEnvironment('FIREBASE_CLIENT_ID'),
      clientSecret:
          clientSecret ?? String.fromEnvironment('FIREBASE_CLIENT_SECRET'),
    );

    // create an authenticator
    var authenticator = Authenticator(client,
        scopes: [
          'email',
          'https://www.googleapis.com/auth/cloud-platform',
          'https://www.googleapis.com/auth/cloudplatformprojects.readonly',
          'https://www.googleapis.com/auth/firebase',
          'openid'
        ],
        port: 4000);

    // starts the authentication
    var c = await authenticator.authorize(); // this will open a browser

    var v = {
      'client_id': client.clientId,
      'client_secret': client.clientSecret,
      'refresh_token': c.response!['refresh_token']
    };

    var f = File(firebaseAdminCredentialPath!);
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(JsonEncoder.withIndent(' ').convert(v));

    var credential = RefreshTokenCredential(v);

    return credential;
  }

  /// Returns a [Credential] created from the Google Application Default
  /// Credentials (ADC) that grants admin access to Firebase services.
  ///
  /// This credential can be used in the call to [initializeApp].
  ///
  /// This will look for credentials in the following locations:
  ///
  ///   * the service-account.json file in the package main directory
  ///   * the service account file path specified in the env variable GOOGLE_APPLICATION_CREDENTIALS
  ///   * the configuration file stored at [firebaseAdminCredentialPath] containing
  ///   credentials obtained with [Credentials.login]
  ///   * gcloud's application default credentials
  ///   * credentials from the firebase tools
  static Credential? applicationDefault() =>
      _globalAppDefaultCred ??= _getApplicationDefault();

  /// Returns [Credential] created from the provided service account that grants
  /// admin access to Firebase services.
  ///
  /// This credential can be used in the call to [initializeApp].
  /// [credentials] must be a path to a service account key JSON file or an
  /// object representing a service account key.
  static Credential cert(credentials) {
    throw UnimplementedError();
  }

  /// Returns [Credential] created from the provided refresh token that grants
  /// admin access to Firebase services.
  ///
  /// This credential can be used in the call to [initializeApp].
  static Credential refreshToken(refreshTokenPathOrObject) {
    throw UnimplementedError();
  }

  static String? get _gcloudCredentialPath {
    var config = _configDir;
    if (config == null) return null;
    return path.join(config, 'gcloud/application_default_credentials.json');
  }

  /// The path where credentials obtained by doing [Credentials.login] are
  /// stored
  ///
  /// On windows, this is `$APP_DATA/firebase_admin/application_default_credentials.json`,
  /// on other platforms, this is `$HOME/.config/firebase_admin/application_default_credentials.json`.
  ///
  static String? get firebaseAdminCredentialPath {
    var config = _configDir;
    if (config == null) return null;
    return path.join(
        config, 'firebase_admin/application_default_credentials.json');
  }

  static String? get _configDir {
    // Windows has a dedicated low-rights location for apps at ~/Application Data
    if (Platform.isWindows) {
      return env['APPDATA'];
    }

    // On *nix the gcloud cli creates a . dir.
    if (env.isDefined('HOME')) {
      return path.join(env['HOME']!, '.config');
    }
    return null;
  }

  static Credential? _getApplicationDefault() {
    var f = File('service-account.json');
    if (f.existsSync()) {
      return _credentialFromFile(f.path);
    }
    if (env['GOOGLE_APPLICATION_CREDENTIALS'] != null) {
      return _credentialFromFile(env['GOOGLE_APPLICATION_CREDENTIALS']!);
    }

    if (firebaseAdminCredentialPath != null) {
      final refreshToken =
          _readCredentialFile(firebaseAdminCredentialPath!, true);
      if (refreshToken != null) {
        return RefreshTokenCredential(refreshToken);
      }
    }

    // It is OK to not have this file. If it is present, it must be valid.
    if (_gcloudCredentialPath != null) {
      final refreshToken = _readCredentialFile(_gcloudCredentialPath!, true);
      if (refreshToken != null) {
        return RefreshTokenCredential(refreshToken);
      }
    }

    // TODO Credential on compute engine
    return null;
  }

  static Credential _credentialFromFile(String filePath) {
    final credentialsFile = _readCredentialFile(filePath);
    if (credentialsFile == null) {
      throw FirebaseAppError.invalidCredential(
        'Failed to parse contents of the credentials file as an object',
      );
    }

    if (credentialsFile['type'] == 'service_account') {
      return ServiceAccountCredential(credentialsFile);
    }

    if (credentialsFile['type'] == 'authorized_user') {
      return RefreshTokenCredential(credentialsFile);
    }

    throw FirebaseAppError.invalidCredential(
      'Invalid contents in the credentials file',
    );
  }

  static Map<String, dynamic>? _readCredentialFile(String filePath,
      [bool ignoreMissing = false]) {
    String fileText;
    try {
      fileText = File(filePath).readAsStringSync();
    } catch (error) {
      if (ignoreMissing) {
        return null;
      }

      throw FirebaseAppError.invalidCredential(
          'Failed to read credentials from file $filePath: $error');
    }

    try {
      return json.decode(fileText);
    } catch (error) {
      throw FirebaseAppError.invalidCredential(
          'Failed to parse contents of the credentials file as an object: $error');
    }
  }
}

/// Interface which provides Google OAuth2 access tokens used to authenticate
/// with Firebase services.
abstract class Credential {
  /// Returns a Google OAuth2 [AccessToken] object used to authenticate with
  /// Firebase services.
  Future<AccessToken> getAccessToken();
}

/// Google OAuth2 access token object used to authenticate with Firebase
/// services.
abstract class AccessToken {
  /// The actual Google OAuth2 access token.
  String get accessToken;

  DateTime get expirationTime;
}
