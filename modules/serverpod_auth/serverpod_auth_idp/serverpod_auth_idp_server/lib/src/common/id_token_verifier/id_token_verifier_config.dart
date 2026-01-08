import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;

export 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart'
    show JWTKey, RSAPublicKey;

/// Abstract configuration for ID token verification.
///
/// Implementations of this class define provider-specific behavior for
/// fetching certificates, parsing keys, and validating claims.
abstract class IdTokenVerifierConfig {
  /// The URL that provides public certificates for verifying ID tokens.
  String get certsUrl;

  /// Parses the response body from the certificates URL and returns
  /// an iterable of JWT keys for verification.
  Iterable<dart_jsonwebtoken.JWTKey> parseKeys(final String responseBody);

  /// Validates the issuer claim.
  ///
  /// Throws an exception if the issuer is invalid.
  void validateIssuer(final Map<String, dynamic> claims);

  /// Validates the audience claim.
  ///
  /// The [audience] parameter is the expected audience value.
  /// Throws an exception if the audience is invalid.
  void validateAudience(
    final Map<String, dynamic> claims,
    final String? audience,
  );

  /// Performs provider-specific extra claim validations.
  ///
  /// Called after common claims (exp, iat, sub) have been validated.
  /// The [now] parameter is the current time for time-based validations.
  void validateExtraClaims(
    final Map<String, dynamic> claims,
    final DateTime now,
  );

  /// Creates a provider-specific exception with the given message.
  Exception createException(final String message);
}
