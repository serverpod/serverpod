import 'package:serverpod_auth_idp_server/core.dart';

/// Test implementation of OAuth2PkceConfig for testing purposes.
///
/// This configuration allows customization of all OAuth2 parameters
/// to test different provider scenarios.
class TestOAuth2PkceConfig implements OAuth2PkceConfig {
  /// Creates a test configuration with sensible defaults.
  TestOAuth2PkceConfig({
    this.testClientId = 'test_client_id',
    this.testClientSecret = 'test_client_secret',
    this.testTokenEndpointUrl,
    this.testCredentialsLocation = OAuth2CredentialsLocation.header,
    this.testClientIdKey = 'client_id',
    this.testClientSecretKey = 'client_secret',
    this.testTokenRequestHeaders = const {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    this.testTokenRequestParams = const {},
    this.testShouldThrowOnError = false,
  });

  /// The test client ID.
  String testClientId;

  /// The test client secret.
  String testClientSecret;

  /// The test token endpoint URL.
  Uri? testTokenEndpointUrl;

  /// Where to send credentials (header or body).
  OAuth2CredentialsLocation testCredentialsLocation;

  /// Custom field name for client ID.
  String testClientIdKey;

  /// Custom field name for client secret.
  String testClientSecretKey;

  /// Custom headers to send.
  Map<String, String> testTokenRequestHeaders;

  /// Custom parameters to send.
  Map<String, dynamic> testTokenRequestParams;

  /// Whether parseAccessToken should throw on error field.
  bool testShouldThrowOnError;

  @override
  Uri get tokenEndpointUrl =>
      testTokenEndpointUrl ?? Uri.parse('https://test.example.com/oauth/token');

  @override
  String get clientId => testClientId;

  @override
  String get clientSecret => testClientSecret;

  @override
  OAuth2CredentialsLocation get credentialsLocation => testCredentialsLocation;

  @override
  String get clientIdKey => testClientIdKey;

  @override
  String get clientSecretKey => testClientSecretKey;

  @override
  Map<String, String> get tokenRequestHeaders => testTokenRequestHeaders;

  @override
  Map<String, dynamic> get tokenRequestParams => testTokenRequestParams;

  @override
  String parseAccessToken(final Map<String, dynamic> responseBody) {
    // Check for error in response (if configured to do so)
    if (testShouldThrowOnError) {
      final error = responseBody['error'] as String?;
      if (error != null) {
        throw createException('OAuth2 error: $error');
      }
    }

    // Extract access token
    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw createException('No access token in response');
    }

    return accessToken;
  }

  @override
  Exception createException(final String message) {
    return TestOAuth2Exception(message);
  }
}

/// Test exception for OAuth2 errors.
class TestOAuth2Exception implements Exception {
  /// Creates a test exception with the given message.
  const TestOAuth2Exception(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'TestOAuth2Exception: $message';
}
