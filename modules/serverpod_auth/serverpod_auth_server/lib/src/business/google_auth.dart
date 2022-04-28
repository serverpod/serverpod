import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
// ignore: implementation_imports
import 'package:googleapis_auth/src/auth_http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../module.dart';

const String _configFilePath = 'config/google_client_secret.json';

/// Convenience methods for handling authentication with Google and accessing
/// Google's APIs.
class GoogleAuth {
  /// The client secret loaded from `config/google_client_secret.json`, null
  /// if the client secrets failed to load.
  static final GoogleClientSecret? clientSecret = _loadClientSecret();

  static GoogleClientSecret? _loadClientSecret() {
    try {
      return GoogleClientSecret._(_configFilePath);
    } catch (e) {
      stdout.writeln(
        'serverpod_auth_server: Failed to load $_configFilePath. Sign in with  Google will be disabled.',
      );
    }
    return null;
  }

  /// Returns an authenticated client for a specific, authenticated user. The
  /// client can be used to access Google's APIs. To be able to get a client
  /// the user must have been authenticated with Google, otherwise null is
  /// returned.
  static Future<AutoRefreshingAuthClient?> authClientForUser(
    Session session,
    int userId,
  ) async {
    assert(
      clientSecret != null,
      'Google client secret from $_configFilePath is not loaded',
    );

    GoogleRefreshToken? refreshTokenData =
        await GoogleRefreshToken.findSingleRow(
      session,
      where: (GoogleRefreshTokenTable t) => t.userId.equals(userId),
    );
    if (refreshTokenData == null) {
      return null;
    }

    AccessCredentials credentials = AccessCredentials.fromJson(
      jsonDecode(refreshTokenData.refreshToken),
    );

    http.Client client = http.Client();

    ClientId clientId =
        ClientId(clientSecret!.clientId, clientSecret!.clientSecret);

    return AutoRefreshingClient(
      client,
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
  final String _path;

  /// The client identifier.
  late final String clientId;

  /// The client secret.
  late final String clientSecret;

  /// List of redirect uris.
  late List<String> redirectUris;

  /// Loads the google client secrets from the provided path.
  GoogleClientSecret._(this._path) {
    File file = File(_path);
    String jsonData = file.readAsStringSync();
    Map<String, dynamic> data = jsonDecode(jsonData);

    Map<String, dynamic> web = data['web'];
    clientId = web['client_id'];
    clientSecret = web['client_secret'];
    redirectUris = (web['redirect_uris'] as List<String>).cast<String>();
  }
}
