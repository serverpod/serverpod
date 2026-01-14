/// Location where OAuth2 credentials should be sent in token requests.
///
/// Per [RFC 6749 Section 2.3](https://tools.ietf.org/html/rfc6749#section-2.3),
/// credentials can be sent either in the Authorization header (preferred) or
/// in the request body.
enum OAuth2CredentialsLocation {
  /// Send credentials in the Authorization header using Basic authentication.
  ///
  /// This is the preferred method per RFC 6749. The client ID and secret are
  /// base64-encoded as "clientId:clientSecret" and sent as:
  /// `Authorization: Basic <base64-encoded-credentials>`
  header,

  /// Send credentials as parameters in the request body.
  ///
  /// The client ID and secret are sent as form parameters in the token request.
  body,
}

/// Configuration for OAuth2 PKCE token exchange.
///
/// Defines provider-specific settings for OAuth2 authentication flows using
/// PKCE (Proof Key for Code Exchange). Implementations specify the token
/// endpoint URL, client credentials, request format, and response parsing logic.
///
/// The OAuth2 PKCE flow is handled by [OAuth2PkceUtil], which uses this
/// configuration to make provider-specific token requests.
abstract class OAuth2PkceConfig {
  /// The OAuth2 token endpoint URL for exchanging authorization codes.
  ///
  /// This URL is used to exchange an authorization code for an access token,
  /// as defined in [RFC 6749 Section 3.2](https://tools.ietf.org/html/rfc6749#section-3.2).
  ///
  /// Consult your OAuth2 provider's documentation for the correct endpoint URL.
  /// Common patterns:
  /// - `https://provider.com/oauth2/token`
  /// - `https://provider.com/login/oauth/access_token`
  Uri get tokenEndpointUrl;

  /// The OAuth2 client ID obtained from your provider's application settings.
  ///
  /// Public identifier for your application, assigned when you register
  /// your OAuth2 client with the provider.
  String get clientId;

  /// The OAuth2 client secret obtained from your provider's application settings.
  ///
  /// Confidential secret used to authenticate your application during the
  /// token exchange. Keep this value secure and never expose it to clients.
  String get clientSecret;

  /// The request body parameter name for the client ID.
  ///
  /// Defaults to `client_id` per RFC 6749. Override only if your provider
  /// requires a different parameter name.
  String get clientIdKey => 'client_id';

  /// The request body parameter name for the client secret.
  ///
  /// Defaults to `client_secret` per RFC 6749. Override only if your provider
  /// requires a different parameter name.
  String get clientSecretKey => 'client_secret';

  /// Specifies where to send client credentials in token requests.
  ///
  /// Per [RFC 6749 Section 2.3](https://tools.ietf.org/html/rfc6749#section-2.3),
  /// credentials can be sent via:
  /// - [OAuth2CredentialsLocation.header]: Authorization header with Basic auth (preferred)
  /// - [OAuth2CredentialsLocation.body]: Request body parameters
  ///
  /// Defaults to [OAuth2CredentialsLocation.header]. Override if your provider
  /// requires body parameters.
  OAuth2CredentialsLocation get credentialsLocation =>
      OAuth2CredentialsLocation.header;

  /// HTTP headers to include in token exchange requests.
  ///
  /// Defaults to standard OAuth2 headers:
  /// - `Accept: application/json` - Request JSON response
  /// - `Content-Type: application/x-www-form-urlencoded` - Standard form encoding
  ///
  /// Override if your provider requires additional or different headers.
  Map<String, String> get tokenRequestHeaders => const {
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  /// Additional parameters to include in token exchange requests.
  ///
  /// Standard OAuth2 parameters (grant_type, code, redirect_uri, code_verifier,
  /// client_id, client_secret) are included automatically.
  ///
  /// Override to add provider-specific parameters. For example:
  /// ```dart
  /// @override
  /// Map<String, dynamic> get tokenRequestParams => {'resource': 'https://api.provider.com'};
  /// ```
  Map<String, dynamic> get tokenRequestParams => const {};

  /// Parses the provider's token response and extracts the access token.
  ///
  /// The [responseBody] contains the decoded JSON response from the token endpoint.
  /// Different providers may structure their responses differently.
  ///
  /// This method should:
  /// - Check for error fields and throw [OAuth2Exception] if present
  /// - Extract and return the access token string
  /// - Throw [OAuth2Exception] if the access token is missing or invalid
  ///
  /// Example success response:
  /// ```json
  /// {
  ///   "access_token": "ya29.a0AfH6SMBx...",
  ///   "token_type": "Bearer",
  ///   "expires_in": 3600
  /// }
  /// ```
  ///
  /// Example error response:
  /// ```json
  /// {
  ///   "error": "invalid_grant",
  ///   "error_description": "The authorization code is invalid."
  /// }
  /// ```
  String parseAccessToken(final Map<String, dynamic> responseBody);
}
