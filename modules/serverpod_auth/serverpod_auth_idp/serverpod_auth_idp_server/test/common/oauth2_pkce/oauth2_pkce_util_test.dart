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
  group('Given OAuth2PkceUtil with test configuration', () {
    late TestOAuth2PkceConfig config;
    late OAuth2PkceUtil oauth2Util;

    setUp(() {
      config = TestOAuth2PkceConfig();
      oauth2Util = OAuth2PkceUtil(config: config);
    });

    group('when exchanging authorization code for token', () {
      test(
        'Given valid authorization code when exchanged then returns access token.',
        () async {
          const accessToken = 'test_access_token_12345';
          const responseBody = {
            'access_token': accessToken,
            'token_type': 'Bearer',
            'expires_in': 3600,
          };

          final mockClient = MockHttpClient(
            statusCode: 200,
            responseBody: jsonEncode(responseBody),
          );

          final result = await oauth2Util.exchangeCodeForToken(
            code: 'auth_code_123',
            codeVerifier: 'code_verifier_xyz',
            redirectUri: 'https://example.com/callback',
            httpClient: mockClient,
          );

          expect(result, equals(accessToken));
        },
      );

      test(
        'Given credentials in header mode when token is exchanged then Authorization header is sent.',
        () async {
          config.testCredentialsLocation = OAuth2CredentialsLocation.header;

          final mockClient = MockHttpClient(
            statusCode: 200,
            responseBody: jsonEncode({
              'access_token': 'token',
              'token_type': 'Bearer',
            }),
          );

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

      test(
        'Given credentials in body mode when token is exchanged then credentials are in body.',
        () async {
          config.testCredentialsLocation = OAuth2CredentialsLocation.body;

          final mockClient = MockHttpClient(
            statusCode: 200,
            responseBody: jsonEncode({
              'access_token': 'token',
              'token_type': 'Bearer',
            }),
          );

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

      test(
        'Given 400 Bad Request when token is exchanged then throws OAuth2Exception.',
        () async {
          final mockClient = MockHttpClient(
            statusCode: 400,
            responseBody: jsonEncode({
              'error': 'invalid_request',
              'error_description': 'The request is malformed',
            }),
          );

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

      test(
        'Given 401 Unauthorized when token is exchanged then throws OAuth2Exception.',
        () async {
          final mockClient = MockHttpClient(
            statusCode: 401,
            responseBody: jsonEncode({
              'error': 'invalid_client',
              'error_description': 'Client authentication failed',
            }),
          );

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

      test(
        'Given 500 Internal Server Error when token is exchanged then throws OAuth2Exception.',
        () async {
          final mockClient = MockHttpClient(
            statusCode: 500,
            responseBody: 'Internal Server Error',
          );

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

      test(
        'Given response with invalid JSON when token is exchanged then throws OAuth2Exception.',
        () async {
          final mockClient = MockHttpClient(
            statusCode: 200,
            responseBody: 'not a valid json',
          );

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

      test(
        'Given response without access token field when token is exchanged then throws OAuth2Exception.',
        () async {
          final mockClient = MockHttpClient(
            statusCode: 200,
            responseBody: jsonEncode({
              'token_type': 'Bearer',
              'expires_in': 3600,
              // Missing access_token field
            }),
          );

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
  });
}
