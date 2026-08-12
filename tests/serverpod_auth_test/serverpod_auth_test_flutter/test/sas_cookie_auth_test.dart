import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Raw-HTTP tests against the running test server for the cookie side of
/// server-side-session (SAS) auth. See `jwt_cookie_auth_test.dart` for why
/// these are raw HTTP.
const _apiUrl = 'http://localhost:8080';
const _authModeHeader = 'x-serverpod-auth-mode';
const _authCookieName = 'serverpod_auth';

void main() {
  group('Given an SAS sign-in request in cookie mode', () {
    late String userId;

    setUp(() async {
      userId = await _createTestUser();
    });

    test(
      'when creating a session '
      'then the token is moved from the body to an HttpOnly cookie.',
      () async {
        final response = await _call(
          'authTest',
          'createSasToken',
          args: {'authUserId': userId},
          headers: {_authModeHeader: 'cookie-transport'},
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isEmpty);

        final header = response.headers['set-cookie']!;
        expect(header, startsWith('$_authCookieName='));
        expect(header.toLowerCase(), contains('httponly'));
        expect(header.toLowerCase(), contains('path=/'));
      },
    );

    test(
      'when creating a session without the cookie marker '
      'then the token stays in the body and no cookie is set.',
      () async {
        final response = await _call(
          'authTest',
          'createSasToken',
          args: {'authUserId': userId},
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isNotEmpty);
        expect(response.headers['set-cookie'], isNull);
      },
    );
  });

  group('Given an authenticated SAS caller in cookie mode', () {
    late String callerId;
    late String callerAuthHeader;

    setUp(() async {
      callerId = await _createTestUser();
      final signIn = await _call(
        'authTest',
        'createSasToken',
        args: {'authUserId': callerId},
      );
      final token =
          (jsonDecode(signIn.body) as Map<String, dynamic>)['token'] as String;
      callerAuthHeader = 'Bearer $token';
    });

    test(
      'when creating a session for another user '
      'then the token stays in the body and no cookie is set.',
      () async {
        final otherUserId = await _createTestUser();

        final response = await _call(
          'authTest',
          'createSasToken',
          args: {'authUserId': otherUserId},
          headers: {
            _authModeHeader: 'cookie',
            'authorization': callerAuthHeader,
          },
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isNotEmpty);
        expect(response.headers['set-cookie'], isNull);
      },
    );

    test(
      'when creating a session for the caller themself '
      'then the token is issued as a cookie.',
      () async {
        final response = await _call(
          'authTest',
          'createSasToken',
          args: {'authUserId': callerId},
          headers: {
            _authModeHeader: 'cookie',
            'authorization': callerAuthHeader,
          },
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isEmpty);
        expect(response.headers['set-cookie'], startsWith('$_authCookieName='));
      },
    );
  });

  group('Given a session signed in with an SAS cookie', () {
    late String userId;
    late String cookieHeader;

    setUp(() async {
      userId = await _createTestUser();
      final signIn = await _call(
        'authTest',
        'createSasToken',
        args: {'authUserId': userId},
        headers: {_authModeHeader: 'cookie-transport'},
      );
      final setCookie = signIn.headers['set-cookie']!;
      cookieHeader = setCookie.substring(0, setCookie.indexOf(';'));
    });

    test(
      'when calling with the cookie-auth marker '
      'then the cookie authenticates the call.',
      () async {
        final response = await _call(
          'authTest',
          'checkSessionUnauthenticated',
          headers: {
            _authModeHeader: 'cookie',
            'cookie': cookieHeader,
          },
        );

        expect(response.statusCode, 200);
        expect(jsonDecode(response.body), isTrue);
      },
    );

    test(
      'when calling with the transport-only marker '
      'then the cookie does not authenticate the call.',
      () async {
        final response = await _call(
          'authTest',
          'checkSessionUnauthenticated',
          headers: {
            _authModeHeader: 'cookie-transport',
            'cookie': cookieHeader,
          },
        );

        expect(response.statusCode, 200);
        expect(jsonDecode(response.body), isFalse);
      },
    );

    test(
      'when signing out '
      'then both auth cookies are cleared.',
      () async {
        final response = await _call(
          'serverpod_auth_core.status',
          'signOutDevice',
          headers: {
            _authModeHeader: 'cookie',
            'cookie': cookieHeader,
          },
        );

        expect(response.statusCode, 200);
        final header = response.headers['set-cookie']!;
        expect(header, contains('$_authCookieName=;'));
        expect(header, contains('${_authCookieName}_refresh=;'));
        expect(header, contains('Max-Age=0'));
      },
    );
  });
}

Future<http.Response> _call(
  String endpoint,
  String method, {
  Map<String, dynamic> args = const {},
  Map<String, String> headers = const {},
}) {
  return http.post(
    Uri.parse('$_apiUrl/$endpoint/$method'),
    headers: headers,
    body: jsonEncode(args),
  );
}

Future<String> _createTestUser() async {
  final response = await _call('authTest', 'createTestUser');
  expect(response.statusCode, 200);
  return jsonDecode(response.body) as String;
}
