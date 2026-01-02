import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;

import '../../../common/id_token_verifier/id_token_verifier_config.dart';
import '../../../common/id_token_verifier/id_token_verifier_exception.dart';

/// Firebase-specific configuration for ID token verification.
///
/// This configuration handles Firebase Authentication tokens, which use
/// PEM-encoded certificates and have specific validation requirements.
class FirebaseIdTokenConfig implements IdTokenVerifierConfig {
  /// The Firebase project ID used for issuer and audience validation.
  final String projectId;

  /// Creates a new Firebase ID token configuration.
  const FirebaseIdTokenConfig({required this.projectId});

  @override
  String get certsUrl =>
      'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com';

  @override
  Iterable<dart_jsonwebtoken.JWTKey> parseKeys(final String responseBody) {
    final certsJson = jsonDecode(responseBody) as Map<String, dynamic>;
    final keys = <dart_jsonwebtoken.JWTKey>[];

    for (final entry in certsJson.entries) {
      try {
        final pem = entry.value as String;
        final key = dart_jsonwebtoken.RSAPublicKey.cert(pem);
        keys.add(key);
      } catch (e) {
        continue;
      }
    }

    return keys;
  }

  @override
  void validateIssuer(final Map<String, dynamic> claims) {
    final expectedIssuer = 'https://securetoken.google.com/$projectId';
    final issuer = claims['iss'] as String?;
    if (issuer == null || issuer != expectedIssuer) {
      throw FirebaseIdTokenValidationServerException(
        'Invalid issuer: expected $expectedIssuer',
      );
    }
  }

  @override
  void validateAudience(
    final Map<String, dynamic> claims,
    final String? audience,
  ) {
    final aud = claims['aud'];
    final audienceMatches = aud is String
        ? aud == projectId
        : aud is List && aud.contains(projectId);
    if (!audienceMatches) {
      throw FirebaseIdTokenValidationServerException('Audience does not match');
    }
  }

  @override
  void validateExtraClaims(
    final Map<String, dynamic> claims,
    final DateTime now,
  ) {
    final sub = claims['sub'] as String?;
    if (sub != null && sub.length > 128) {
      throw FirebaseIdTokenValidationServerException('Invalid subject length');
    }

    final authTime = claims['auth_time'] as int?;
    if (authTime == null) {
      throw FirebaseIdTokenValidationServerException(
        'Missing auth_time claim',
      );
    }
    final authDateTime = DateTime.fromMillisecondsSinceEpoch(
      authTime * 1000,
      isUtc: true,
    );
    if (authDateTime.isAfter(now)) {
      throw FirebaseIdTokenValidationServerException('Invalid auth_time');
    }
  }

  @override
  Exception createException(final String message) {
    return FirebaseIdTokenValidationServerException(message);
  }
}

/// Exception thrown when the Firebase ID token validation fails.
class FirebaseIdTokenValidationServerException
    extends IdTokenValidationException {
  /// Creates a new instance.
  FirebaseIdTokenValidationServerException(super.message);
}
