/// Abstract configuration for an OAuth2 provider.
///
/// Implementations of this class define provider-specific settings for the
/// OAuth2 authorization flow with optional PKCE (Proof Key for Code Exchange).
/// This includes the authorization endpoint, client configuration, and any
/// provider-specific parameters.
///
/// This configuration pattern allows the [OAuth2PkceUtil] to handle the
/// generic OAuth2 flow while delegating provider-specific details to
/// the configuration.
abstract class OAuth2PkceProviderConfig {
  /// The OAuth2 authorization endpoint URL.
  ///
  /// This is the URL where users are redirected to authorize your application.
  /// Consult your OAuth2 provider's documentation for the correct endpoint.
  ///
  /// Common patterns:
  /// - `https://provider.com/oauth2/authorize`
  /// - `https://provider.com/login/oauth/authorize`
  Uri get authorizationEndpoint;

  /// The OAuth2 client ID obtained from your provider's application settings.
  ///
  /// Public identifier assigned when you register your application with
  /// the OAuth2 provider.
  String get clientId;

  /// The redirect URI for the OAuth2 callback.
  ///
  /// Must exactly match one of the redirect URIs registered with your OAuth2
  /// provider. After authorization, the provider redirects to this URI with
  /// the authorization code.
  ///
  /// Examples:
  /// - Web: `https://example.com/auth/callback`
  /// - Mobile (custom scheme): `com.example.app://oauth/callback`
  String get redirectUri;

  /// The callback URL scheme used to identify OAuth2 callback completion.
  ///
  /// Must be the scheme portion (protocol) of [redirectUri]. Used by
  /// [FlutterWebAuth2] to detect when the authorization flow completes.
  ///
  /// Example: For redirect URI `com.example.app://oauth/callback`,
  /// use `com.example.app` as the callback URL scheme.
  String get callbackUrlScheme;

  /// Default permission scopes to request during authorization.
  ///
  /// Scopes define what data and actions your application can access.
  /// If empty, the provider's default scopes are used. Consult your
  /// provider's documentation for available scopes.
  ///
  /// Can be overridden per authorization request via [OAuth2PkceUtil.authorize].
  List<String> get defaultScopes => const [];

  /// Additional query parameters to include in the authorization request.
  ///
  /// Standard OAuth2 parameters (client_id, redirect_uri, response_type, state,
  /// code_challenge, code_challenge_method, scope) are included automatically.
  ///
  /// Override to add provider-specific parameters.
  Map<String, String> get additionalAuthParams => const {};

  /// The separator used to join multiple scopes in the authorization request.
  ///
  /// Defaults to `' '` (space) as per OAuth2 specification. Some providers may
  /// require different separators (e.g., `','` for comma-separated scopes).
  String get scopeSeparator => ' ';

  /// Whether to include and validate the state parameter for CSRF protection.
  ///
  /// Defaults to `true`. When enabled, a random state value is generated and
  /// validated upon callback. Set to `false` only if the provider doesn't
  /// support the state parameter (non-standard).
  bool get enableState => true;

  /// Whether to use PKCE (Proof Key for Code Exchange) for this OAuth2 flow.
  ///
  /// Defaults to `true`. When enabled, a code verifier and code challenge are
  /// generated and used in the authorization flow. Set to `false` if the
  /// provider doesn't support PKCE.
  bool get enablePKCE => true;
}
