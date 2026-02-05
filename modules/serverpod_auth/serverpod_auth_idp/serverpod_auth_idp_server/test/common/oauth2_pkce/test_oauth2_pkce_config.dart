import 'package:serverpod_auth_idp_server/core.dart';

/// Test implementation of OAuth2PkceServerConfig for testing purposes.
///
/// This configuration allows customization of all OAuth2 parameters
/// to test different provider scenarios.
class TestOAuth2PkceServerConfig {
  /// The underlying OAuth2 PKCE server configuration.
  late final OAuth2PkceServerConfig oauth2Config;

  /// Whether parseTokenResponse should throw on error field.
  final bool testShouldThrowOnError;

  /// Creates a test configuration with sensible defaults.
  TestOAuth2PkceServerConfig({
    final String testClientId = 'test_client_id',
    final String testClientSecret = 'test_client_secret',
    final Uri? testTokenEndpointUrl,
    final OAuth2CredentialsLocation testCredentialsLocation =
        OAuth2CredentialsLocation.header,
    final String testClientIdKey = 'client_id',
    final String testClientSecretKey = 'client_secret',
    final Map<String, String> testTokenRequestHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    final Map<String, dynamic> testTokenRequestParams = const {},
    this.testShouldThrowOnError = false,
  }) {
    oauth2Config = OAuth2PkceServerConfig(
      tokenEndpointUrl:
          testTokenEndpointUrl ??
          Uri.parse('https://test.example.com/oauth/token'),
      clientId: testClientId,
      clientSecret: testClientSecret,
      credentialsLocation: testCredentialsLocation,
      clientIdKey: testClientIdKey,
      clientSecretKey: testClientSecretKey,
      tokenRequestHeaders: testTokenRequestHeaders,
      tokenRequestParams: testTokenRequestParams,
      parseTokenResponse: _parseTokenResponse,
    );
  }

  /// Custom token response parser for testing.
  OAuth2PkceTokenResponse _parseTokenResponse(
    final Map<String, dynamic> responseBody,
  ) {
    if (testShouldThrowOnError) {
      final error = responseBody['error'] as String?;
      if (error != null) {
        final errorDescription = responseBody['error_description'] as String?;
        throw OAuth2InvalidResponseException(
          'Invalid response from test provider:'
          ' $error${errorDescription != null ? " - $errorDescription" : ""}',
        );
      }
    }

    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw const OAuth2MissingAccessTokenException(
        'No access token in test response',
      );
    }

    return OAuth2PkceTokenResponse(
      accessToken: accessToken,
      refreshToken: responseBody['refresh_token'] as String?,
      expiresIn: responseBody['expires_in'] as int?,
      raw: responseBody,
    );
  }
}
