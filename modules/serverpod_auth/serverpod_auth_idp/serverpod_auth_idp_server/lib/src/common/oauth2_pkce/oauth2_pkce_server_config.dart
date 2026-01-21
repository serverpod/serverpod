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

/// Signature for parsing the access token from the provider's token response.
typedef ParseAccessToken = String Function(Map<String, dynamic> responseBody);

/// Configuration for OAuth2 token exchange (server-side).
final class OAuth2PkceServerConfig {
  /// Token endpoint URL for exchanging authorization codes.
  final Uri tokenEndpointUrl;

  /// OAuth2 client ID.
  final String clientId;

  /// OAuth2 client secret (keep secure).
  final String clientSecret;

  /// Request body parameter name for client ID.
  final String clientIdKey;

  /// Request body parameter name for client secret.
  final String clientSecretKey;

  /// Where to send credentials in token requests.
  final OAuth2CredentialsLocation credentialsLocation;

  /// HTTP headers for token requests.
  final Map<String, String> tokenRequestHeaders;

  /// Extra parameters for token requests.
  final Map<String, dynamic> tokenRequestParams;

  /// Callback to parse access token from provider response.
  final ParseAccessToken parseAccessToken;

  /// Create a new server config for OAuth2 PKCE.
  const OAuth2PkceServerConfig({
    required this.tokenEndpointUrl,
    required this.clientId,
    required this.clientSecret,
    required this.parseAccessToken,
    this.clientIdKey = 'client_id',
    this.clientSecretKey = 'client_secret',
    this.credentialsLocation = OAuth2CredentialsLocation.header,
    this.tokenRequestHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    this.tokenRequestParams = const {},
  });
}
