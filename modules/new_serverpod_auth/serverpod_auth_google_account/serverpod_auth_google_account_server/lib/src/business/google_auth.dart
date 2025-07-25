import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

const _configFilePath = 'config/google_client_secret.json';
const _passwordKey = 'serverpod_auth_google_account_clientSecret';

/// Convenience methods for handling authentication with Google and accessing
/// Google's APIs.
@internal
class GoogleAuth {
  /// The client secret loaded from `config/google_client_secret.json` or
  /// password `serverpod_auth_googleClientSecret`, null if the client secrets
  /// failed to load.
  static final clientSecret = _loadClientSecret();

  static GoogleClientSecret? _loadClientSecret() {
    try {
      late final String jsonData;
      final password = Serverpod.instance.getPassword(_passwordKey);
      if (password != null) {
        jsonData = password;
      } else {
        final file = File(_configFilePath);
        jsonData = file.readAsStringSync();
      }

      final data = jsonDecode(jsonData);
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Not a JSON (map) object');
      }

      if (data['web'] == null) {
        throw const FormatException('Missing "web" section');
      }

      final web = data['web'] as Map;

      final webClientId = web['client_id'] as String?;
      if (webClientId == null) {
        throw const FormatException('Missing "client_id"');
      }

      final webClientSecret = web['client_secret'] as String?;
      if (webClientSecret == null) {
        throw const FormatException('Missing "client_secret"');
      }

      final webRedirectUris = web['redirect_uris'] as List?;
      if (webRedirectUris == null) {
        throw const FormatException('Missing "redirect_uris"');
      }

      return GoogleClientSecret._(
        clientId: webClientId,
        clientSecret: webClientSecret,
        redirectUris: webRedirectUris.cast<String>(),
      );
    } catch (e) {
      stderr.writeln(
        'serverpod_auth_server: Failed to load $_configFilePath or password $_passwordKey. Sign in with Google will be disabled. Error: $e',
      );
      return null;
    }
  }
}

/// Contains information about the credentials for the server to access Google's
/// APIs. The secrets are typically loaded from
/// `config/google_client_secret.json`. The file can be downloaded from Google's
/// cloud console.
@internal
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
