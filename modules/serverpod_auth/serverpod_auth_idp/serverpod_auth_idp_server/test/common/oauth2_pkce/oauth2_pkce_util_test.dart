import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_oauth2_pkce_config.dart';

/// Mock HTTP client for testing OAuth2 token exchange.
class MockHttpClient extends http.BaseClient {
  /// Creates a mock client with the given response.
  MockHttpClient({
    required this.statusCode,
    required this.responseBody,
  });

  /// The HTTP status code to return.
  final int statusCode;

  /// The response body to return.
  final String responseBody;

  /// Captured request for verification.
  http.BaseRequest? capturedRequest;

  /// Captured headers for verification.
  Map<String, String>? capturedHeaders;

  /// Captured body for verification.
  String? capturedBody;

  @override
  Future<http.StreamedResponse> send(final http.BaseRequest request) async {
    capturedRequest = request;
    capturedHeaders = Map.from(request.headers);

    if (request is http.Request) {
      capturedBody = request.body;
    }

    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      statusCode,
      request: request,
    );
  }
}

void main() {
  late TestOAuth2PkceServerConfig config;
  late OAuth2PkceUtil oauth2Util;

  setUp(() {
    config = TestOAuth2PkceServerConfig();
    oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);
  });

  group('Given OAuth2PkceUtil with valid authorization code', () {
    late MockHttpClient mockClient;

    setUp(() {
      const accessToken = 'test_access_token_12345';
      const responseBody = {
        'access_token': accessToken,
        'token_type': 'Bearer',
        'expires_in': 3600,
      };

      mockClient = MockHttpClient(
        statusCode: 200,
        responseBody: jsonEncode(responseBody),
      );
    });

    test(
      'when exchanging code for token then returns access token',
      () async {
        final result = await oauth2Util.exchangeCodeForToken(
          code: 'auth_code_123',
          codeVerifier: 'code_verifier_xyz',
          redirectUri: 'https://example.com/callback',
          httpClient: mockClient,
        );

        expect(result, equals('test_access_token_12345'));
      },
    );
  });

  group('Given OAuth2PkceUtil with header credentials mode', () {
    late MockHttpClient mockClient;

    setUp(() {
      config = TestOAuth2PkceServerConfig(
        testCredentialsLocation: OAuth2CredentialsLocation.header,
      );
      oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);

      mockClient = MockHttpClient(
        statusCode: 200,
        responseBody: jsonEncode({
          'access_token': 'token',
          'token_type': 'Bearer',
        }),
      );
    });

    test(
      'when exchanging code for token then sends Authorization header',
      () async {
        await oauth2Util.exchangeCodeForToken(
          code: 'auth_code',
          codeVerifier: 'verifier',
          redirectUri: 'https://example.com/callback',
          httpClient: mockClient,
        );

        expect(
          mockClient.capturedHeaders,
          containsPair('Authorization', startsWith('Basic ')),
        );

        // Verify client ID and secret are NOT in body when using header mode
        expect(mockClient.capturedBody, isNot(contains('client_id=')));
        expect(mockClient.capturedBody, isNot(contains('client_secret=')));
      },
    );
  });

  group('Given OAuth2PkceUtil with body credentials mode', () {
    late MockHttpClient mockClient;

    setUp(() {
      config = TestOAuth2PkceServerConfig(
        testCredentialsLocation: OAuth2CredentialsLocation.body,
      );
      oauth2Util = OAuth2PkceUtil(config: config.oauth2Config);

      mockClient = MockHttpClient(
        statusCode: 200,
        responseBody: jsonEncode({
          'access_token': 'token',
          'token_type': 'Bearer',
        }),
      );
    });

    test(
      'when exchanging code for token then sends credentials in body',
      () async {
        await oauth2Util.exchangeCodeForToken(
          code: 'auth_code',
          codeVerifier: 'verifier',
          redirectUri: 'https://example.com/callback',
          httpClient: mockClient,
        );

        // Verify credentials are in body
        expect(mockClient.capturedBody, contains('client_id='));
        expect(mockClient.capturedBody, contains('client_secret='));

        // Verify no Basic auth header
        expect(
          mockClient.capturedHeaders,
          isNot(containsPair('Authorization', startsWith('Basic '))),
        );
      },
    );
  });

  group('Given OAuth2PkceUtil with 400 Bad Request response', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient(
        statusCode: 400,
        responseBody: jsonEncode({
          'error': 'invalid_request',
          'error_description': 'The request is malformed',
        }),
      );
    });

    test(
      'when exchanging code for token then throws OAuth2Exception',
      () async {
        expect(
          () => oauth2Util.exchangeCodeForToken(
            code: 'invalid_code',
            codeVerifier: 'verifier',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          ),
          throwsA(isA<OAuth2Exception>()),
        );
      },
    );
  });

  group('Given OAuth2PkceUtil with 401 Unauthorized response', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient(
        statusCode: 401,
        responseBody: jsonEncode({
          'error': 'invalid_client',
          'error_description': 'Client authentication failed',
        }),
      );
    });

    test(
      'when exchanging code for token then throws OAuth2Exception',
      () async {
        expect(
          () => oauth2Util.exchangeCodeForToken(
            code: 'auth_code',
            codeVerifier: 'verifier',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          ),
          throwsA(isA<OAuth2Exception>()),
        );
      },
    );
  });

  group('Given OAuth2PkceUtil with 500 Internal Server Error response', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient(
        statusCode: 500,
        responseBody: 'Internal Server Error',
      );
    });

    test(
      'when exchanging code for token then throws OAuth2Exception',
      () async {
        expect(
          () => oauth2Util.exchangeCodeForToken(
            code: 'auth_code',
            codeVerifier: 'verifier',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          ),
          throwsA(isA<OAuth2Exception>()),
        );
      },
    );
  });

  group('Given OAuth2PkceUtil with invalid JSON response', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient(
        statusCode: 200,
        responseBody: 'not a valid json',
      );
    });

    test(
      'when exchanging code for token then throws OAuth2Exception',
      () async {
        expect(
          () => oauth2Util.exchangeCodeForToken(
            code: 'auth_code',
            codeVerifier: 'verifier',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          ),
          throwsA(isA<OAuth2Exception>()),
        );
      },
    );
  });

  group('Given OAuth2PkceUtil with response missing access token', () {
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient(
        statusCode: 200,
        responseBody: jsonEncode({
          'token_type': 'Bearer',
          'expires_in': 3600,
          // Missing access_token field
        }),
      );
    });

    test(
      'when exchanging code for token then throws OAuth2Exception',
      () async {
        expect(
          () => oauth2Util.exchangeCodeForToken(
            code: 'auth_code',
            codeVerifier: 'verifier',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          ),
          throwsA(isA<OAuth2Exception>()),
        );
      },
    );
  });
}
