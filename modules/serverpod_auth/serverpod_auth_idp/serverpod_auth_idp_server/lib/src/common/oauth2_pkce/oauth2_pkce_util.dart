import 'dart:convert';

import 'package:http/http.dart' as http;

import 'oauth2_exception.dart';
import 'oauth2_pkce_server_config.dart';

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
  /// - [httpClient]: Optional HTTP client for testing with mocks. If not provided,
  ///   a new [http.Client] is created
  ///
  /// Returns the access token string on success.
  ///
  /// Throws an [OAuth2Exception] in case of errors, with reason:
  /// - [OAuth2ExceptionReason.invalidResponse] if the response cannot be parsed
  /// - [OAuth2ExceptionReason.missingAccessToken] if the access token is missing
  /// - [OAuth2ExceptionReason.networkError] if a network error occurs
  /// - [OAuth2ExceptionReason.unknown] for other unexpected errors
  Future<String> exchangeCodeForToken({
    required final String code,
    final String? codeVerifier,
    required final String redirectUri,
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
          reason: OAuth2ExceptionReason.networkError,
          message:
              'Failed to exchange authorization code for access token: '
              'HTTP ${response.statusCode}',
        );
      }

      Map<String, dynamic> responseBody;
      try {
        responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw OAuth2Exception(
          reason: OAuth2ExceptionReason.invalidResponse,
          message: 'Failed to parse token response as JSON: ${e.toString()}',
        );
      }

      try {
        return config.parseAccessToken(responseBody);
      } on OAuth2Exception {
        rethrow;
      } catch (e) {
        throw OAuth2Exception(
          reason: OAuth2ExceptionReason.missingAccessToken,
          message:
              'Access token missing or invalid in response: ${e.toString()}',
        );
      }
    } on OAuth2Exception {
      rethrow;
    } catch (e) {
      throw OAuth2Exception(
        reason: OAuth2ExceptionReason.networkError,
        message: 'Network error during token exchange: ${e.toString()}',
      );
    } finally {
      // Close the client only if we created it internally
      if (!clientProvidedByUser) {
        httpClient.close();
      }
    }
  }
}
