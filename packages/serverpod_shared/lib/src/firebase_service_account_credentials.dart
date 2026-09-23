import 'dart:convert';
import 'dart:io';

/// Firebase service-account credentials, as downloaded from the Firebase
/// console under Project Settings > Service Accounts > Generate new private
/// key.
///
/// Token verification only needs [projectId]. Signing (FCM OAuth, admin APIs)
/// also needs [clientEmail] and [privateKey].
final class FirebaseServiceAccountCredentials {
  /// The Firebase project identifier.
  final String projectId;

  /// The service account client email.
  final String? clientEmail;

  /// PEM-encoded RSA private key used to mint OAuth access tokens.
  final String? privateKey;

  /// Optional key id from the service-account JSON (`private_key_id`).
  final String? privateKeyId;

  /// Token endpoint used when exchanging a signed JWT for an access token.
  ///
  /// Defaults to Google's OAuth token URI when omitted from the JSON.
  final String tokenUri;

  /// Default Google OAuth token endpoint.
  static const defaultTokenUri = 'https://oauth2.googleapis.com/token';

  /// Creates a new instance.
  ///
  /// Only [projectId] is required for ID-token verification. FCM sending
  /// requires [clientEmail] and [privateKey] as well.
  const FirebaseServiceAccountCredentials({
    required this.projectId,
    this.clientEmail,
    this.privateKey,
    this.privateKeyId,
    this.tokenUri = defaultTokenUri,
  });

  /// Creates a new instance from a JSON map matching the Firebase console
  /// service-account file.
  factory FirebaseServiceAccountCredentials.fromJson(
    final Map<String, dynamic> json,
  ) {
    final projectId = json['project_id'] as String?;
    if (projectId == null || projectId.isEmpty) {
      throw const FormatException('Missing or empty "project_id"');
    }

    final tokenUri = json['token_uri'] as String?;

    return FirebaseServiceAccountCredentials(
      projectId: projectId,
      clientEmail: json['client_email'] as String?,
      privateKey: json['private_key'] as String?,
      privateKeyId: json['private_key_id'] as String?,
      tokenUri: (tokenUri == null || tokenUri.isEmpty)
          ? defaultTokenUri
          : tokenUri,
    );
  }

  /// Creates a new instance from a JSON string.
  factory FirebaseServiceAccountCredentials.fromJsonString(
    final String jsonString,
  ) {
    final data = jsonDecode(jsonString);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Not a JSON (map) object');
    }

    return FirebaseServiceAccountCredentials.fromJson(data);
  }

  /// Creates a new instance from a JSON file on disk.
  factory FirebaseServiceAccountCredentials.fromJsonFile(final File file) {
    return FirebaseServiceAccountCredentials.fromJsonString(
      file.readAsStringSync(),
    );
  }

  /// Whether this credential set can mint Google OAuth access tokens.
  bool get canSign =>
      clientEmail != null &&
      clientEmail!.isNotEmpty &&
      privateKey != null &&
      privateKey!.isNotEmpty;
}
