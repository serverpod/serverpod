import 'dart:convert';
import 'dart:io';

/// Configuration for the Google identity provider.
class GoogleIDPConfig {
  /// The client secret used for the Google sign-in.
  final GoogleClientSecret clientSecret;

  /// Creates a new instance of [GoogleIDPConfig].
  GoogleIDPConfig({
    required this.clientSecret,
  });
}

/// Contains information about the credentials for the server to access Google's
/// APIs. The secrets are typically loaded from
/// `config/google_client_secret.json`. The file can be downloaded from Google's
/// cloud console.
final class GoogleClientSecret {
  /// The client identifier.
  final String clientId;

  /// The client secret.
  final String clientSecret;

  /// List of redirect uris.
  final List<String> redirectUris;

  /// Private constructor to initialize the object.
  GoogleClientSecret._({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUris,
  });

  /// Creates a new instance of [GoogleClientSecret] from a JSON map.
  /// Expects the JSON to match the structure of the file downloaded from
  /// Google's cloud console.
  ///
  /// Example:
  /// {
  ///   "web": {
  ///     "client_id": "your-client-id.apps.googleusercontent.com",
  ///     "client_secret": "your-client-secret",
  ///     "redirect_uris": [
  ///       "http://localhost:8080/auth/google/callback",
  ///       "https://your-production-domain.com/auth/google/callback"
  ///     ]
  ///     ...
  /// }
  ///
  factory GoogleClientSecret.fromJson(final Map<String, dynamic> json) {
    if (json['web'] == null) {
      throw const FormatException('Missing "web" section');
    }

    final web = json['web'] as Map;

    final webClientId = web['client_id'] as String?;
    if (webClientId == null) {
      throw const FormatException('Missing "client_id"');
    }

    final webClientSecret = web['client_secret'] as String?;
    if (webClientSecret == null) {
      throw const FormatException('Missing "client_secret"');
    }

    final webRedirectUris = web['redirect_uris'] as List<String>?;
    if (webRedirectUris == null) {
      throw const FormatException('Missing "redirect_uris"');
    }

    return GoogleClientSecret._(
      clientId: webClientId,
      clientSecret: webClientSecret,
      redirectUris: webRedirectUris,
    );
  }

  /// Creates a new instance of [GoogleClientSecret] from a JSON string.
  /// The string is expected to follow the format described in
  /// [GoogleClientSecret.fromJson].
  factory GoogleClientSecret.fromJsonString(final String jsonString) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return GoogleClientSecret.fromJson(data);
  }

  /// Creates a new instance of [GoogleClientSecret] from a JSON file.
  /// The file is expected to follow the format described in
  /// [GoogleClientSecret.fromJson].
  factory GoogleClientSecret.fromJsonFile(final File file) {
    final jsonString = file.readAsStringSync();
    return GoogleClientSecret.fromJsonString(jsonString);
  }
}
