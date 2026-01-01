import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;

import '../../../common/id_token_verifier/id_token_verifier_config.dart';
import '../../../common/id_token_verifier/id_token_verifier_exception.dart';

/// Google-specific configuration for ID token verification.
///
/// This configuration handles Google OAuth 2.0 tokens, which use
/// JWKS-formatted certificates.
class GoogleIdTokenConfig implements IdTokenVerifierConfig {
  /// Valid Google issuers for OAuth 2.0 tokens.
  static const List<String> _googleIssuers = [
    'accounts.google.com',
    'https://accounts.google.com',
  ];

  /// Creates a new Google ID token configuration.
  const GoogleIdTokenConfig();

  @override
  String get certsUrl => 'https://www.googleapis.com/oauth2/v3/certs';

  @override
  Iterable<dart_jsonwebtoken.JWTKey> parseKeys(final String responseBody) {
    final jwksJson = jsonDecode(responseBody) as Map<String, dynamic>;
    final jwksList = (jwksJson['keys'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final keys = <dart_jsonwebtoken.JWTKey>[];
    for (final jwk in jwksList) {
      try {
        final key = dart_jsonwebtoken.JWTKey.fromJWK(jwk);
        keys.add(key);
      } catch (e) {
        continue;
      }
    }

    return keys;
  }

  @override
  void validateIssuer(final Map<String, dynamic> claims) {
    final issuer = claims['iss'] as String?;
    if (issuer == null || !_googleIssuers.contains(issuer)) {
      throw GoogleIdTokenValidationServerException('Invalid issuer');
    }
  }

  @override
  void validateAudience(
    final Map<String, dynamic> claims,
    final String? audience,
  ) {
    if (audience != null) {
      final aud = claims['aud'];
      final audienceMatches = aud is String
          ? aud == audience
          : aud is List && aud.contains(audience);
      if (!audienceMatches) {
        throw GoogleIdTokenValidationServerException('Audience does not match');
      }
    }
  }

  @override
  void validateExtraClaims(
    final Map<String, dynamic> claims,
    final DateTime now,
  ) {
    // Google has no extra claims to validate
  }

  @override
  Exception createException(final String message) {
    return GoogleIdTokenValidationServerException(message);
  }
}

/// Exception thrown when the Google ID token validation fails.
class GoogleIdTokenValidationServerException
    extends IdTokenValidationException {
  /// Creates a new instance.
  GoogleIdTokenValidationServerException(super.message);
}
