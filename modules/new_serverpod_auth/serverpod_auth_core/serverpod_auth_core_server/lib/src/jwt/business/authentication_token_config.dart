/// Configuration options for the JWT authentication module.
class AuthenticationTokenConfig {
  /// The lifetime of access tokens.
  ///
  /// This will be encoded in each access token, and for
  /// incoming requests only the token's value will be used.
  ///
  /// Defaults to 10 minutes.
  final Duration accessTokenLifetime;

  /// The lifetime of a refresh token.
  ///
  /// Once this is expired, no new refresh/access token pair can be created from
  /// the previous refresh token.
  ///
  /// This is checked whenever a rotation takes place and is not encoded in the
  /// refresh token.
  ///
  /// Defaults to 14 days.
  /// Meaning the refresh tokens needs to be used / rotated at least every 14 days
  /// to keep the client with working credentials.
  final Duration refreshTokenLifetime;

  /// The issuer set on the JWT access tokens.
  ///
  /// Set as `iss` claim.
  /// https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1
  ///
  /// If set, incoming tokens will be validated to contain the same issuer.
  ///
  /// Defaults to `null`.
  final String? issuer;

  /// The amount of random bytes used for the fixed secret part of each individual refresh token.
  ///
  /// Default to 16.
  final int refreshTokenFixedSecretLength;

  /// The amount of random bytes used for the rotating secret of the refresh token.
  ///
  /// Defaults to 64.
  final int refreshTokenRotatingSecretLength;

  /// The amount of random bytes used to hash the rotation secret of the refresh token with.
  ///
  /// Defaults to 16.
  final int refreshTokenRotatingSecretSaltLength;

  /// Create a new user profile configuration.
  AuthenticationTokenConfig({
    this.accessTokenLifetime = const Duration(minutes: 10),
    this.refreshTokenLifetime = const Duration(days: 14),
    this.issuer,
    this.refreshTokenFixedSecretLength = 16,
    this.refreshTokenRotatingSecretLength = 64,
    this.refreshTokenRotatingSecretSaltLength = 16,
  });
}
