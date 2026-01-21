import 'package:serverpod_auth_idp_server/core.dart';

/// Test implementation of OAuth2PkceServerConfig for testing purposes.
///
/// This configuration allows customization of all OAuth2 parameters
/// to test different provider scenarios.
class TestOAuth2PkceServerConfig {
  /// The underlying OAuth2 PKCE server configuration.
  late final OAuth2PkceServerConfig oauth2Config;

  /// Whether parseAccessToken should throw on error field.
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
      parseAccessToken: _parseAccessToken,
    );
  }

  /// Custom access token parser for testing.
  String _parseAccessToken(final Map<String, dynamic> responseBody) {
    // Check for error in response
    if (testShouldThrowOnError) {
      final error = responseBody['error'] as String?;
      if (error != null) {
        final errorDescription = responseBody['error_description'] as String?;
        throw OAuth2Exception(error, errorDescription: errorDescription);
      }
    }

    // Extract access token
    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw OAuth2Exception(
        'missing_token',
        errorDescription: 'No access token in response',
      );
    }

    return accessToken;
  }
}
