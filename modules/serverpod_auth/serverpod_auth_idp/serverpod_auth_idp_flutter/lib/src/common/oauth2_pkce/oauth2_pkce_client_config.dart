/// Configuration for an OAuth2 provider (client-side).
class OAuth2PkceProviderClientConfig {
  /// Authorization endpoint URL.
  final Uri authorizationEndpoint;

  /// OAuth2 client ID.
  final String clientId;

  /// Redirect URI for OAuth2 callback.
  final String redirectUri;

  /// Callback URL scheme (protocol part of redirect URI).
  final String callbackUrlScheme;

  /// Default permission scopes.
  final List<String> defaultScopes;

  /// Extra query parameters for authorization request.
  final Map<String, String> additionalAuthParams;

  /// Separator for joining scopes.
  final String scopeSeparator;

  /// Enable state parameter for CSRF protection.
  final bool enableState;

  /// Enable PKCE for OAuth2 flow.
  final bool enablePKCE;

  /// Create a new config.
  const OAuth2PkceProviderClientConfig({
    required this.authorizationEndpoint,
    required this.clientId,
    required this.redirectUri,
    required this.callbackUrlScheme,
    this.defaultScopes = const [],
    this.additionalAuthParams = const {},
    this.scopeSeparator = ' ',
    this.enableState = true,
    this.enablePKCE = true,
  });
}
