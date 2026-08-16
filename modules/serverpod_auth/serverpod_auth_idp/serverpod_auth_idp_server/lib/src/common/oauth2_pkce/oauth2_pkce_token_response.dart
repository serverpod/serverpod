/// OAuth2 token response containing access token and optional metadata.
class OAuth2PkceTokenResponse {
  /// The access token issued by the authorization server.
  final String accessToken;

  /// The refresh token used to obtain new access tokens.
  final String? refreshToken;

  /// The lifetime in seconds of the access token.
  final int? expiresIn;

  /// Raw parsed response for accessing provider-specific fields.
  final Map<String, dynamic> raw;

  /// Creates a new [OAuth2PkceTokenResponse].
  const OAuth2PkceTokenResponse({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.raw = const {},
  });
}
