/// Configuration options for the JWT authentication module.
class AuthenticationTokenConfig {
  /// The default lifetime of access tokens.
  ///
  /// This will be encoded in each access token, and for
  /// incoming requests only the token's value will be used.
  ///
  /// Defaults to 10 minutes.
  final Duration defaultAccessTokenLifetime;

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

  /// Create a new user profile configuration.
  AuthenticationTokenConfig({
    this.defaultAccessTokenLifetime = const Duration(minutes: 10),
    this.refreshTokenLifetime = const Duration(days: 14),
  });

  /// The current JWT authentication module configuration.
  static AuthenticationTokenConfig current = AuthenticationTokenConfig();
}
