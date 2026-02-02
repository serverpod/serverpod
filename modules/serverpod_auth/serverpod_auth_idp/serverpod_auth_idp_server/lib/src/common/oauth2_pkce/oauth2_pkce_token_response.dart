/// OAuth2 token response containing access token and optional metadata.
///
/// The response typically includes:
/// - `access_token` (required): The access token for API requests
/// - `expires_in` (optional): Token lifetime in seconds
/// - `refresh_token` (optional): Token for obtaining new access tokens
/// - Provider-specific fields available in [raw]
class OAuth2PkceTokenResponse {
  /// The access token issued by the authorization server.
  ///
  /// This token is used to authenticate API requests to the provider.
  final String accessToken;

  /// The refresh token used to obtain new access tokens.
  ///
  /// Optional. Not all providers issue refresh tokens, especially for
  /// authorization code flows without offline access scope.
  final String? refreshToken;

  /// The lifetime in seconds of the access token.
  ///
  /// Optional. If omitted, the authorization server should provide the
  /// expiration time via other means or the token does not expire.
  final int? expiresIn;

  /// Raw parsed response containing all fields from the provider.
  ///
  /// Use this to access provider-specific fields not covered by the
  /// standard OAuth2 response. For example:
  /// - GitHub: `scope`, `token_type`
  /// - Google: `id_token`, `scope`
  /// - Facebook: `data_access_expiration_time`
  final Map<String, dynamic> raw;

  /// Creates a new [OAuth2PkceTokenResponse].
  const OAuth2PkceTokenResponse({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.raw = const {},
  });
}
