import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:test/test.dart';

import 'web_auth_test_utils.dart';

void main() {
  late http.Client client;

  setUpAll(() {
    client = http.Client();
  });

  tearDownAll(() => client.close());

  group('Given HTML web auth with Apple', () {
    late Serverpod pod;
    late Uri base;
    late bool? capturedNative;
    late String pepper;

    setUp(() async {
      capturedNative = null;
      pod = createWebAuthPod();
      initSasAuth(
        pod,
        identityProviderBuilders: [appleTestConfig],
      );
      pod.configureWebAuthRoutes(
        loginSuccessPath: '/account',
        appleLoginOverride:
            (
              final session, {
              required final identityToken,
              required final authorizationCode,
              required final isNativeApplePlatformSignIn,
              final firstName,
              final lastName,
            }) async {
              capturedNative = isNativeApplePlatformSignIn;
              session.writeWebAuthCookie('issued');
            },
      );
      pod.configureAppleIdpRoutes(
        webAuthenticationCallbackRoutePath: '/auth/callback',
      );
      await pod.start();
      base = Uri.parse('http://localhost:${pod.webServer.port}');
      pepper = pod.getPassword(webAuthOAuthStatePepperPasswordKey)!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    Future<http.Response> appleCallback({
      required final String state,
      final String? code = 'ok',
      final String? idToken = 'id-token',
      final String? error,
      final String? cookie,
      final String? origin,
      final String? user,
    }) {
      final fields = <String, String>{'state': state};
      if (code != null) fields['code'] = code;
      if (idToken != null) fields['id_token'] = idToken;
      if (error != null) fields['error'] = error;
      if (user != null) fields['user'] = user;
      return send(
        client,
        base,
        'POST',
        '/auth/apple/web/callback',
        origin: origin,
        cookie: cookie,
        body: formBody(fields),
      );
    }

    test(
      'when Apple starts then the response is 302 with form_post, HMAC state, '
      'and no OAuth cookie.',
      () async {
        final response = await send(client, base, 'GET', '/auth/apple');
        expect(response.statusCode, 302);
        expect(response.headers['cache-control'], contains('no-store'));
        final location = Uri.parse(response.headers['location']!);
        expect(location.host, 'appleid.apple.com');
        expect(location.path, '/auth/authorize');
        expect(location.queryParameters['response_mode'], 'form_post');
        expect(location.queryParameters['response_type'], 'code id_token');
        expect(location.queryParameters['client_id'], 'test.apple.service');
        expect(
          location.queryParameters['redirect_uri'],
          'http://localhost:8082/auth/apple/web/callback',
        );
        expect(location.queryParameters['scope'], 'name email');
        final state = location.queryParameters['state']!;
        final payload = decodeHmacPayload(state, pepper);
        expect(payload, isNotNull);
        expect(payload!['provider'], 'apple');
        expect(payload['nonce'], location.queryParameters['nonce']);
        expect(
          setCookieValue(
            response,
            oauthStateCookieName(pod.config.authCookie!),
          ),
          isNull,
        );
      },
    );

    test(
      'when the callback POST has no auth cookie then HMAC state still '
      'completes login.',
      () async {
        final start = await send(client, base, 'GET', '/auth/apple');
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final response = await appleCallback(state: state);
        expect(response.statusCode, 303);
        expect(response.headers['location'], '/account');
        expect(setCookieValue(response, authCookieName), 'issued');
        expect(capturedNative, isFalse);
      },
    );

    test(
      'when the callback POST has Origin https://appleid.apple.com then it '
      'is not Origin-gated.',
      () async {
        final start = await send(client, base, 'GET', '/auth/apple');
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final response = await appleCallback(
          state: state,
          origin: 'https://appleid.apple.com',
        );
        expect(response.statusCode, 303);
        expect(setCookieValue(response, authCookieName), 'issued');
      },
    );

    test(
      'when a leftover SAS cookie is not sent then Origin from Apple does '
      'not 403.',
      () async {
        final start = await send(client, base, 'GET', '/auth/apple');
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final response = await appleCallback(
          state: state,
          origin: 'https://appleid.apple.com',
          cookie: null,
        );
        expect(response.statusCode, isNot(403));
        expect(response.statusCode, 303);
      },
    );

    test(
      'when Apple state is tampered then the callback is 403 and no auth '
      'cookie is set.',
      () async {
        final start = await send(client, base, 'GET', '/auth/apple');
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final tampered = '${state.substring(0, 4)}xxxx${state.substring(8)}';
        final response = await appleCallback(state: tampered);
        expect(response.statusCode, 403);
        expect(setCookieValue(response, authCookieName), isNull);
      },
    );

    test(
      'when Flutter /auth/callback is requested then '
      'AppleWebAuthenticationCallbackRoute is unchanged.',
      () async {
        final response = await send(
          client,
          base,
          'POST',
          '/auth/callback',
          body: formBody({'code': 'x'}),
        );
        expect(response.statusCode, 303);
        expect(
          response.headers['location'],
          contains('https://example.com/app'),
        );
      },
    );

    test(
      'when GET /auth/login is requested then the Apple button is shown.',
      () async {
        final response = await send(client, base, 'GET', '/auth/login');
        expect(response.body, contains('Continue with Apple'));
      },
    );
  });
}
