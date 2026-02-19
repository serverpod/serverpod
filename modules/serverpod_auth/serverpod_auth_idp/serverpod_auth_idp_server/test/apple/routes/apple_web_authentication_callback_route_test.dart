import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/src/providers/apple/business/routes/apple_server_notification_route.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

void main() {
  final tokenManager = ServerSideSessionsTokenManager(
    config: ServerSideSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
  );

  const testAndroidPackageIdentifier = 'com.example.testapp';
  const testWebRedirectUri = 'https://example.com/auth/complete';
  const androidUserAgent =
      'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36';
  const webUserAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36';

  AppleWebAuthenticationCallbackRoute createRoute({
    final String? androidPackageIdentifier,
    final String? webRedirectUri,
  }) {
    final signInWithApple = _SignInWithAppleFake();
    final utils = AppleIdpUtils(
      tokenManager: tokenManager,
      signInWithApple: signInWithApple,
      authUsers: const AuthUsers(),
    );
    return AppleWebAuthenticationCallbackRoute(
      utils: utils,
      androidPackageIdentifier: androidPackageIdentifier,
      webRedirectUri: webRedirectUri,
    );
  }

  Future<Response> callRoute(
    final AppleWebAuthenticationCallbackRoute route, {
    required final String? userAgent,
    required final String body,
  }) async {
    final request = _RequestFake(userAgent: userAgent, body: body);
    final result = await route.handleCall(_SessionFake(), request);
    expect(result, isA<Response>());
    return result as Response;
  }

  group(
    'Given AppleWebAuthenticationCallbackRoute with redirection parameters configured',
    () {
      late AppleWebAuthenticationCallbackRoute route;

      setUp(() {
        route = createRoute(
          androidPackageIdentifier: testAndroidPackageIdentifier,
          webRedirectUri: testWebRedirectUri,
        );
      });

      test(
        'when calling endpoint with Android User-Agent and POST with form body '
        'then it returns 307 with correct intent URI.',
        () async {
          final response = await callRoute(
            route,
            userAgent: androidUserAgent,
            body: 'code=test_auth_code&state=test_state',
          );

          expect(response.statusCode, 307);
          expect(
            response.headers['Location']?.first,
            equals(
              'intent://callback?code=test_auth_code&state=test_state#Intent;'
              'package=$testAndroidPackageIdentifier;scheme=signinwithapple;end',
            ),
          );
        },
      );

      test(
        'when calling endpoint with Android User-Agent and params have special '
        'characters then it URL encodes correctly.',
        () async {
          final response = await callRoute(
            route,
            userAgent: androidUserAgent,
            body: 'code=abc%2B123&user=%7B%22name%22%3A%22test%22%7D',
          );

          expect(response.statusCode, 307);
          expect(
            response.headers['Location']?.first,
            equals(
              'intent://callback?code=abc%2B123&'
              'user=%7B%22name%22%3A%22test%22%7D#Intent;'
              'package=$testAndroidPackageIdentifier;scheme=signinwithapple;end',
            ),
          );
        },
      );

      test(
        'when calling endpoint with Android User-Agent and empty body '
        'then it returns 307 with empty params.',
        () async {
          final response = await callRoute(
            route,
            userAgent: androidUserAgent,
            body: '',
          );

          expect(response.statusCode, 307);
          expect(
            response.headers['Location']?.first,
            equals(
              'intent://callback#Intent;'
              'package=$testAndroidPackageIdentifier;scheme=signinwithapple;end',
            ),
          );
        },
      );

      test(
        'when calling endpoint with Web User-Agent then it returns 303 with'
        ' web redirection URI.',
        () async {
          final response = await callRoute(
            route,
            userAgent: webUserAgent,
            body: 'code=test_auth_code',
          );

          expect(response.statusCode, 303);
          expect(
            response.headers['Location']?.first,
            equals('$testWebRedirectUri?code=test_auth_code'),
          );
        },
      );

      test(
        'when calling endpoint with Web User-Agent and empty body '
        'then it returns 303 redirect to webRedirectUri without query params.',
        () async {
          final response = await callRoute(
            route,
            userAgent: webUserAgent,
            body: '',
          );

          expect(response.statusCode, 303);
          expect(
            response.headers['Location']?.first,
            equals(testWebRedirectUri),
          );
        },
      );

      test(
        'when calling endpoint with Web User-Agent and params have special '
        'characters then it URL encodes correctly.',
        () async {
          final response = await callRoute(
            route,
            userAgent: webUserAgent,
            body: 'code=abc%2B123&user=%7B%22name%22%3A%22test%22%7D',
          );

          expect(response.statusCode, 303);
          expect(
            response.headers['Location']?.first,
            equals(
              '$testWebRedirectUri?code=abc%2B123&'
              'user=%7B%22name%22%3A%22test%22%7D',
            ),
          );
        },
      );

      test(
        'when calling endpoint with no User-Agent then it redirects as Web.',
        () async {
          final response = await callRoute(
            route,
            userAgent: null,
            body: 'code=test_auth_code',
          );

          expect(response.statusCode, 303);
          expect(
            response.headers['Location']?.first,
            equals('$testWebRedirectUri?code=test_auth_code'),
          );
        },
      );
    },
  );

  group(
    'Given AppleWebAuthenticationCallbackRoute without androidPackageIdentifier configured',
    () {
      late AppleWebAuthenticationCallbackRoute route;

      setUp(() {
        route = createRoute(
          androidPackageIdentifier: null,
          webRedirectUri: testWebRedirectUri,
        );
      });

      test(
        'when calling endpoint with Android User-Agent then it returns 500.',
        () async {
          final response = await callRoute(
            route,
            userAgent: androidUserAgent,
            body: 'code=test_auth_code',
          );

          expect(response.statusCode, 500);
          expect(
            await response.readAsString(),
            'Parameter androidPackageIdentifier must be set for '
            'Apple Sign In to work on Android.',
          );
        },
      );
    },
  );

  group(
    'Given AppleWebAuthenticationCallbackRoute without webRedirectUri configured',
    () {
      late AppleWebAuthenticationCallbackRoute route;

      setUp(() {
        route = createRoute(
          androidPackageIdentifier: testAndroidPackageIdentifier,
          webRedirectUri: null,
        );
      });

      test(
        'when calling endpoint with Web User-Agent then it returns 500.',
        () async {
          final response = await callRoute(
            route,
            userAgent: webUserAgent,
            body: 'code=test_auth_code',
          );

          expect(response.statusCode, 500);
          expect(
            await response.readAsString(),
            'Parameter webRedirectUri must be set for Apple Sign In to work on '
            'Web when using the server callback route.',
          );
        },
      );
    },
  );
}

class _SignInWithAppleFake extends Fake implements SignInWithApple {}

class _SessionFake extends Fake implements Session {}

class _RequestFake extends Fake implements Request {
  final String? _userAgent;
  final String _body;

  _RequestFake({
    required final String? userAgent,
    required final String body,
  }) : _userAgent = userAgent,
       _body = body;

  @override
  Headers get headers => Headers.build((final h) {
    if (_userAgent != null) {
      h['User-Agent'] = [_userAgent];
    }
  });

  @override
  Future<String> readAsString({
    final Encoding? encoding,
    final int? maxLength,
  }) async => _body;
}
