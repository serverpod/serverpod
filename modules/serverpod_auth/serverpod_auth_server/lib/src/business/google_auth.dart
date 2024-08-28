import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
// ignore: implementation_imports
import 'package:googleapis_auth/src/auth_http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

const _configFilePath = 'config/google_client_secret.json';

/// Convenience methods for handling authentication with Google and accessing
/// Google's APIs.
class GoogleAuth {
  /// The client secret loaded from `config/google_client_secret.json`, null
  /// if the client secrets failed to load.
  static final clientSecret = _loadClientSecret();

  static GoogleClientSecret? _loadClientSecret() {
    try {
      var file = File(_configFilePath);
      var jsonData = file.readAsStringSync();
      var data = jsonDecode(jsonData);

      if (data['web'] == null) {
        throw const FormatException(
          'Missing "web" section in $_configFilePath',
        );
      }

      Map web = data['web'];

      var clientId = web['client_id'];

      if (clientId == null) {
        throw const FormatException(
          'Missing "client_id" in $_configFilePath',
        );
      }

      var clientSecret = web['client_secret'];
      if (clientSecret == null) {
        throw const FormatException(
          'Missing "client_secret" in $_configFilePath',
        );
      }

      var redirectUris = web['redirect_uris'];
      if (redirectUris == null) {
        throw const FormatException(
          'Missing "redirect_uris" in $_configFilePath',
        );
      }

      return GoogleClientSecret._(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUris: (redirectUris as List).cast<String>(),
      );
    } catch (e) {
      stdout.writeln(
        'serverpod_auth_server: Failed to load $_configFilePath. Sign in with Google will be disabled. Error: $e',
      );
      return null;
    }
  }

  /// Returns an authenticated client for a specific, authenticated user. The
  /// client can be used to access Google's APIs. To be able to get a client
  /// the user must have been authenticated with Google, otherwise null is
  /// returned.
  static Future<AutoRefreshingAuthClient?> authClientForUser(
    Session session,
    int userId,
  ) async {
    if (clientSecret == null) {
      throw StateError(
        'Google client secret from $_configFilePath is not loaded',
      );
    }

    var refreshTokenData = await GoogleRefreshToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (refreshTokenData == null) {
      return null;
    }

    var credentials = AccessCredentials.fromJson(
      jsonDecode(refreshTokenData.refreshToken),
    );

    var client = http.Client();

    var clientId = ClientId(clientSecret!.clientId, clientSecret!.clientSecret);

    return AutoRefreshingClient(
      client,
      const GoogleAuthEndpoints(),
      clientId,
      credentials,
      closeUnderlyingClient: true,
    );
  }
}

/// Contains information about the credentials for the server to access Google's
/// APIs. The secrets are typically loaded from
/// `config/google_client_secret.json`. The file can be downloaded from Google's
/// cloud console.
class GoogleClientSecret {
  /// The client identifier.
  late final String clientId;

  /// The client secret.
  late final String clientSecret;

  /// List of redirect uris.
  late List<String> redirectUris;

  /// Private constructor to initialize the object.
  GoogleClientSecret._({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUris,
  });
}
