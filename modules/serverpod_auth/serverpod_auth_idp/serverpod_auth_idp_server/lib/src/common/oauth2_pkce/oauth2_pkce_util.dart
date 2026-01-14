import 'dart:convert';

import 'package:http/http.dart' as http;

import 'oauth2_exception.dart';
import 'oauth2_pkce_config.dart';

/// Generic utility class for OAuth2 PKCE (Proof Key for Code Exchange) token
/// exchange.
///
/// This class provides the core logic for exchanging an authorization code
/// for an access token using the PKCE flow. It follows the same pattern
/// keeping the core logic generic and reusable.
///
/// {@template oauth2_pkce_util}
/// The OAuth2 PKCE flow involves:
/// 1. Client generates a code verifier and code challenge
/// 2. Client initiates authorization with the code challenge
/// 3. User authorizes the application
/// 4. Client receives an authorization code
/// 5. Client exchanges the code and code verifier for an access token
///
/// This utility handles step 5 (token exchange) on the server side.
/// {@endtemplate}
///
/// ## Usage
///
/// Create a provider-specific configuration that implements [OAuth2PkceConfig]
/// and pass it to the constructor:
///
/// ```dart
/// final oauth2Util = OAuth2PkceUtil(config: myProviderConfig);
///
/// final accessToken = await oauth2Util.exchangeCodeForToken(
///   code: authorizationCode,
///   codeVerifier: pkceCodeVerifier,
///   redirectUri: 'https://example.com/callback',
/// );
/// ```
class OAuth2PkceUtil {
  /// The provider-specific configuration for OAuth2 PKCE.
  final OAuth2PkceConfig config;

  /// Creates a new [OAuth2PkceUtil] with the given configuration.
  OAuth2PkceUtil({required this.config});

  /// Exchanges an authorization code for an access token using PKCE.
  ///
  /// Implements the OAuth2 token exchange flow per
  /// [RFC 6749](https://tools.ietf.org/html/rfc6749#section-4.1.3) with
  /// PKCE extension from [RFC 7636](https://tools.ietf.org/html/rfc7636).
  ///
  /// Parameters:
  /// - [code]: Authorization code received after user authorizes the application
  /// - [codeVerifier]: PKCE code verifier used to generate the code challenge.
  ///   Proves the client making this request initiated the authorization flow
  /// - [redirectUri]: Must exactly match the redirect URI from the authorization
  ///   request (required by OAuth2 specification for security)
  /// - [httpClient]: Optional HTTP client for testing with mocks. If not provided,
  ///   a new [http.Client] is created
  ///
  /// Returns the access token string on success.
  ///
  /// Throws an exception created by [OAuth2PkceConfig.createException] if:
  /// - The HTTP request fails (non-200 status code)
  /// - The response body cannot be parsed as JSON
  /// - The provider returns an error response
  /// - The access token field is missing from the response
  Future<String> exchangeCodeForToken({
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
    http.Client? httpClient,
  }) async {
    // Track if the client was provided to avoid closing it.
    final clientProvidedByUser = httpClient != null;
    httpClient ??= http.Client();

    try {
      // Build request body with standard OAuth2 parameters
      final Map<String, dynamic> bodyParams = {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'code_verifier': codeVerifier,
        ...config.tokenRequestParams, // Add provider-specific params
      };

      // Build headers
      final headers = Map<String, String>.from(config.tokenRequestHeaders);

      // Handle credentials based on configuration
      switch (config.credentialsLocation) {
        case OAuth2CredentialsLocation.header:
          // Send credentials in Authorization header (preferred method)
          final credentials = base64Encode(
            utf8.encode('${config.clientId}:${config.clientSecret}'),
          );
          headers['Authorization'] = 'Basic $credentials';
          break;

        case OAuth2CredentialsLocation.body:
          // Send credentials in request body
          bodyParams[config.clientIdKey] = config.clientId;
          bodyParams[config.clientSecretKey] = config.clientSecret;
          break;
      }

      // Convert body params to URL-encoded format
      final body = bodyParams.entries
          .map(
            (final e) =>
                '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}',
          )
          .join('&');

      final response = await httpClient.post(
        config.tokenEndpointUrl,
        headers: headers,
        body: body,
      );

      if (response.statusCode != 200) {
        throw OAuth2Exception(
          'http_error',
          errorDescription:
              'Failed to exchange authorization code for access token: '
              'HTTP ${response.statusCode}',
        );
      }

      Map<String, dynamic> responseBody;
      try {
        responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw OAuth2Exception(
          'invalid_response',
          errorDescription: 'Failed to parse token response: $e',
        );
      }

      return config.parseAccessToken(responseBody);
    } finally {
      // Close the client only if we created it internally
      if (!clientProvidedByUser) {
        httpClient.close();
      }
    }
  }
}
