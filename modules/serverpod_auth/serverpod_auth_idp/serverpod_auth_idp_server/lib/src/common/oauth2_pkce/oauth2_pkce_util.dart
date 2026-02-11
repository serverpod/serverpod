import 'dart:convert';

import 'package:http/http.dart' as http;

import 'oauth2_exception.dart';
import 'oauth2_pkce_server_config.dart';
import 'oauth2_pkce_token_response.dart';

/// Generic utility class for OAuth2 token exchange with optional PKCE support.
///
/// This class provides the core logic for exchanging an authorization code
/// for an access token. It follows a generic pattern keeping the core logic
/// reusable across different OAuth2 providers.
///
/// {@template oauth2_pkce_util}
/// The OAuth2 flow involves:
/// 1. Client generates a code verifier and code challenge (if using PKCE)
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
/// Create a provider-specific configuration that implements [OAuth2PkceServerConfig]
/// and pass it to the constructor:
///
/// ```dart
/// final oauth2Util = OAuth2PkceUtil(config: myProviderConfig);
///
/// final accessToken = await oauth2Util.exchangeCodeForToken(
///   code: authorizationCode,
///   redirectUri: 'https://example.com/callback',
/// );
/// ```
class OAuth2PkceUtil {
  /// The provider-specific configuration for OAuth2 PKCE.
  final OAuth2PkceServerConfig config;

  /// Creates a new [OAuth2PkceUtil] with the given configuration.
  OAuth2PkceUtil({required this.config});

  /// Exchanges an authorization code for an access token.
  ///
  /// Implements the OAuth2 token exchange flow per
  /// [RFC 6749](https://tools.ietf.org/html/rfc6749#section-4.1.3) with
  /// optional PKCE extension from [RFC 7636](https://tools.ietf.org/html/rfc7636).
  ///
  /// Parameters:
  /// - [code]: Authorization code received after user authorizes the application
  /// - [codeVerifier]: Optional PKCE code verifier used to generate the code
  ///   challenge. Required only if the OAuth2 provider uses PKCE. When provided,
  ///   proves the client making this request initiated the authorization flow.
  /// - [redirectUri]: Must exactly match the redirect URI from the authorization
  ///   request (required by OAuth2 specification for security)
  /// - [includeClientSecret]: Whether to include the client secret in the
  ///   token request. Defaults to `true`, which sends credentials according to
  ///   [OAuth2PkceServerConfig.credentialsLocation]. Set to `false` when the
  ///   OAuth2 provider requires that the secret is omitted for certain client
  ///   types (e.g., Microsoft rejects secrets for non-web clients). When
  ///   `false`, only the client ID is sent in the request body per
  ///   [RFC 6749 §2.3.1](https://tools.ietf.org/html/rfc6749#section-2.3.1),
  ///   regardless of [OAuth2PkceServerConfig.credentialsLocation].
  /// - [httpClient]: Optional HTTP client for testing with mocks. If not provided,
  ///   a new [http.Client] is created
  ///
  /// Returns the [OAuth2PkceTokenResponse] on success, including access token,
  /// optional refresh token, expiration time, and provider-specific data.
  ///
  /// Throws one of the following [OAuth2Exception] subclasses in case of errors:
  /// - [OAuth2InvalidResponseException] if the response cannot be parsed
  /// - [OAuth2MissingAccessTokenException] if the access token is missing
  /// - [OAuth2NetworkErrorException] if a network error occurs
  /// - [OAuth2UnknownException] for other unexpected errors
  Future<OAuth2PkceTokenResponse> exchangeCodeForToken({
    required final String code,
    final String? codeVerifier,
    required final String redirectUri,
    final bool includeClientSecret = true,
    http.Client? httpClient,
  }) async {
    final clientProvidedByUser = httpClient != null;
    httpClient ??= http.Client();

    try {
      final Map<String, dynamic> bodyParams = {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        ...config.tokenRequestParams,
      };

      if (codeVerifier != null) {
        bodyParams['code_verifier'] = codeVerifier;
      }

      final headers = Map<String, String>.from(config.tokenRequestHeaders);

      if (includeClientSecret) {
        switch (config.credentialsLocation) {
          case OAuth2CredentialsLocation.header:
            final credentials = base64Encode(
              utf8.encode('${config.clientId}:${config.clientSecret}'),
            );
            headers['Authorization'] = 'Basic $credentials';
            break;

          case OAuth2CredentialsLocation.body:
            bodyParams[config.clientIdKey] = config.clientId;
            bodyParams[config.clientSecretKey] = config.clientSecret;
            break;
        }
      } else {
        // Without a secret, client_id is always sent in the body per
        // RFC 6749 §2.3.1 (Authorization header requires both id and secret).
        bodyParams[config.clientIdKey] = config.clientId;
      }

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
        throw OAuth2InvalidResponseException(
          'Failed to exchange authorization code for access token: '
          'HTTP ${response.statusCode}',
        );
      }

      Map<String, dynamic> responseBody;
      try {
        responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw OAuth2InvalidResponseException(
          'Failed to parse token response as JSON: ${e.toString()}',
        );
      }

      try {
        return config.parseTokenResponse(responseBody);
      } on OAuth2Exception {
        rethrow;
      } catch (e) {
        throw OAuth2MissingAccessTokenException(
          'Token response parsing failed: ${e.toString()}',
        );
      }
    } on OAuth2Exception {
      rethrow;
    } catch (e) {
      throw OAuth2NetworkErrorException(
        'Network error during token exchange: ${e.toString()}',
      );
    } finally {
      // Close the client only if we created it internally
      if (!clientProvidedByUser) {
        httpClient.close();
      }
    }
  }
}
