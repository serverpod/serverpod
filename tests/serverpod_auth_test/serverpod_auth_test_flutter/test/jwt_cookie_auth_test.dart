import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Raw-HTTP tests against the running test server for the cookie side of JWT
/// auth. `Set-Cookie` is invisible to in-browser clients, so the browser
/// integration tests cannot assert on it; these tests craft the cookie-mode
/// headers directly and inspect the raw responses.
///
/// The header names and values are spelled out literally to pin the wire
/// protocol independently of the client-side constants.
const _apiUrl = 'http://localhost:8080';
const _authModeHeader = 'x-serverpod-auth-mode';
const _basePathHeader = 'x-serverpod-base-path';
const _refreshCookieName = 'serverpod_auth_refresh';

void main() {
  group('Given a JWT sign-in request in cookie mode', () {
    late String userId;

    setUp(() async {
      userId = await _createTestUser();
    });

    test(
      'when creating a JWT token '
      'then the refresh token is moved from the body to a path-scoped '
      'HttpOnly cookie.',
      () async {
        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': userId},
          headers: {_authModeHeader: 'cookie-transport'},
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isNotEmpty);
        expect(body['refreshToken'], isNull);

        final cookie = _parseSetCookie(response);
        expect(cookie.name, _refreshCookieName);
        expect(cookie.value, isNotEmpty);
        expect(cookie.attributes['path'], '/jwtRefresh');
        expect(cookie.attributes, contains('httponly'));
        expect(int.parse(cookie.attributes['max-age']!), greaterThan(0));
      },
    );

    test(
      'when creating a JWT token with a declared base path '
      'then the refresh cookie path includes the prefix.',
      () async {
        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': userId},
          headers: {
            _authModeHeader: 'cookie-transport',
            _basePathHeader: '/api',
          },
        );

        expect(response.statusCode, 200);
        expect(_parseSetCookie(response).attributes['path'], '/api/jwtRefresh');
      },
    );

    test(
      'when creating a JWT token with a malformed declared base path '
      'then the refresh cookie path falls back to the configured path.',
      () async {
        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': userId},
          headers: {
            _authModeHeader: 'cookie-transport',
            _basePathHeader: 'api',
          },
        );

        expect(response.statusCode, 200);
        expect(_parseSetCookie(response).attributes['path'], '/jwtRefresh');
      },
    );

    test(
      'when creating a JWT token without the cookie marker '
      'then the tokens stay in the body and no cookie is set.',
      () async {
        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': userId},
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isNotEmpty);
        expect(body['refreshToken'], isNotEmpty);
        expect(response.headers['set-cookie'], isNull);
      },
    );
  });

  group('Given an authenticated caller in cookie mode', () {
    late String callerId;
    late String callerAccessToken;

    setUp(() async {
      callerId = await _createTestUser();
      final signIn = await _call(
        'authTest',
        'createJwtToken',
        args: {'authUserId': callerId},
      );
      callerAccessToken =
          (jsonDecode(signIn.body) as Map<String, dynamic>)['token'] as String;
    });

    test(
      'when creating a JWT token for another user '
      'then the call is rejected and no cookie is set.',
      () async {
        final otherUserId = await _createTestUser();

        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': otherUserId},
          headers: {
            _authModeHeader: 'cookie',
            'authorization': 'Bearer $callerAccessToken',
          },
        );

        expect(response.statusCode, isNot(200));
        expect(response.body, contains('SignInWhileAuthenticatedException'));
        expect(response.headers['set-cookie'], isNull);
      },
    );

    test(
      'when creating a JWT token for the caller themself '
      'then the refresh token is set as a cookie.',
      () async {
        final response = await _call(
          'authTest',
          'createJwtToken',
          args: {'authUserId': callerId},
          headers: {
            _authModeHeader: 'cookie',
            'authorization': 'Bearer $callerAccessToken',
          },
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['refreshToken'], isNull);
        expect(_parseSetCookie(response).name, _refreshCookieName);
      },
    );
  });

  group('Given a session signed in with a refresh cookie', () {
    late String refreshCookieValue;

    setUp(() async {
      final userId = await _createTestUser();
      final signIn = await _call(
        'authTest',
        'createJwtToken',
        args: {'authUserId': userId},
        headers: {_authModeHeader: 'cookie-transport'},
      );
      refreshCookieValue = _parseSetCookie(signIn).value;
    });

    test(
      'when refreshing from the cookie '
      'then the rotated refresh token is moved from the body to the cookie.',
      () async {
        final response = await _call(
          'jwtRefresh',
          'refreshAccessToken',
          args: {'refreshToken': null},
          headers: {
            _authModeHeader: 'cookie-transport',
            'cookie': '$_refreshCookieName=$refreshCookieValue',
          },
        );

        expect(response.statusCode, 200);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['token'], isNotEmpty);
        expect(body['refreshToken'], isNull);

        final cookie = _parseSetCookie(response);
        expect(cookie.name, _refreshCookieName);
        expect(cookie.value, isNot(refreshCookieValue));
        expect(cookie.attributes['path'], '/jwtRefresh');
      },
    );

    test(
      'when refreshing with duplicate refresh cookies '
      'then the call fails.',
      () async {
        final response = await _call(
          'jwtRefresh',
          'refreshAccessToken',
          args: {'refreshToken': null},
          headers: {
            _authModeHeader: 'cookie-transport',
            'cookie':
                '$_refreshCookieName=$refreshCookieValue; '
                '$_refreshCookieName=stray-duplicate',
          },
        );

        expect(response.statusCode, isNot(200));
        expect(response.body, contains('RefreshTokenNotFoundException'));
      },
    );

    test(
      'when refreshing without the cookie '
      'then the call fails and no cookie is set.',
      () async {
        final response = await _call(
          'jwtRefresh',
          'refreshAccessToken',
          args: {'refreshToken': null},
          headers: {_authModeHeader: 'cookie-transport'},
        );

        expect(response.statusCode, isNot(200));
        expect(response.body, contains('RefreshTokenNotFoundException'));
        expect(response.headers['set-cookie'], isNull);
      },
    );
  });

  test(
    'Given a session signed in without cookie mode '
    'when refreshing with the body token '
    'then the rotated refresh token is returned in the body.',
    () async {
      final userId = await _createTestUser();
      final signIn = await _call(
        'authTest',
        'createJwtToken',
        args: {'authUserId': userId},
      );
      final refreshToken =
          (jsonDecode(signIn.body) as Map<String, dynamic>)['refreshToken']
              as String;

      final response = await _call(
        'jwtRefresh',
        'refreshAccessToken',
        args: {'refreshToken': refreshToken},
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      expect(body['token'], isNotEmpty);
      expect(body['refreshToken'], isNotEmpty);
      expect(response.headers['set-cookie'], isNull);
    },
  );
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

class _SetCookie {
  _SetCookie(this.name, this.value, this.attributes);

  final String name;
  final String value;

  /// Attribute names lower-cased; value-less attributes map to an empty
  /// string.
  final Map<String, String> attributes;
}

_SetCookie _parseSetCookie(http.Response response) {
  final header = response.headers['set-cookie'];
  expect(header, isNotNull, reason: 'expected a Set-Cookie header');

  final segments = header!.split('; ');
  final nameAndValue = segments.first.split('=');
  final attributes = <String, String>{
    for (final segment in segments.skip(1))
      segment.split('=').first.toLowerCase(): segment.contains('=')
          ? segment.substring(segment.indexOf('=') + 1)
          : '',
  };
  return _SetCookie(
    nameAndValue.first,
    nameAndValue.sublist(1).join('='),
    attributes,
  );
}
