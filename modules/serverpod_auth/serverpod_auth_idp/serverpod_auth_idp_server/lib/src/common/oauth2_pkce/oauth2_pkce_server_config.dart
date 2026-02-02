import 'oauth2_pkce_token_response.dart';

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

/// Signature for parsing the OAuth2 token response from the provider.
///
/// Implementations should:
/// 1. Validate the response and check for error fields
/// 2. Extract required fields (`access_token` at minimum)
/// 3. Extract optional fields (`refresh_token`, `expires_in`, etc.)
/// 4. Throw [OAuth2InvalidResponseException] or [OAuth2MissingAccessTokenException]
///    on validation failures
///
/// Example implementation:
/// ```dart
/// static OAuth2PkceTokenResponse parseTokenResponse(
///   Map<String, dynamic> responseBody,
/// ) {
///   // Check for errors
///   final error = responseBody['error'] as String?;
///   if (error != null) {
///     throw OAuth2InvalidResponseException('Error: $error');
///   }
///
///   // Extract access token (required)
///   final accessToken = responseBody['access_token'] as String?;
///   if (accessToken == null) {
///     throw OAuth2MissingAccessTokenException('Missing access_token');
///   }
///
///   // Extract optional fields
///   return OAuth2PkceTokenResponse(
///     accessToken: accessToken,
///     refreshToken: responseBody['refresh_token'] as String?,
///     expiresIn: responseBody['expires_in'] as int?,
///     raw: responseBody,
///   );
/// }
/// ```
typedef ParseTokenResponse =
    OAuth2PkceTokenResponse Function(Map<String, dynamic> responseBody);

/// Configuration for OAuth2 token exchange (server-side).
class OAuth2PkceServerConfig {
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

  /// Callback to parse the token response from the provider.
  ///
  /// This callback is responsible for:
  /// - Validating the response structure
  /// - Extracting the access token (required)
  /// - Extracting optional fields (refresh token, expiration, provider-specific data)
  /// - Throwing appropriate exceptions on errors
  ///
  /// See [ParseTokenResponse] for implementation guidelines.
  final ParseTokenResponse parseTokenResponse;

  /// Create a new server config for OAuth2 PKCE.
  const OAuth2PkceServerConfig({
    required this.tokenEndpointUrl,
    required this.clientId,
    required this.clientSecret,
    required this.parseTokenResponse,
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
