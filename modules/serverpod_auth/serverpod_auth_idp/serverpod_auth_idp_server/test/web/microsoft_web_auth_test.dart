import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:test/test.dart';

import 'web_auth_test_utils.dart';

void main() {
  late http.Client client;

  setUpAll(() {
    client = http.Client();
  });

  tearDownAll(() => client.close());

  group('Given HTML web auth with Microsoft', () {
    late Serverpod pod;
    late Uri base;
    late bool? capturedIsWebPlatform;

    setUp(() async {
      capturedIsWebPlatform = null;
      pod = createWebAuthPod();
      initSasAuth(
        pod,
        identityProviderBuilders: [
          MicrosoftIdpConfig(
            clientId: 'test-microsoft-client-id',
            clientSecret: 'test-microsoft-secret',
            tenant: 'common',
            authorityHost: 'login.microsoftonline.com',
          ),
        ],
      );
      pod.configureWebAuthRoutes(
        loginSuccessPath: '/account',
        microsoftLoginOverride:
            (
              final session, {
              required final code,
              required final codeVerifier,
              required final redirectUri,
              required final isWebPlatform,
            }) async {
              capturedIsWebPlatform = isWebPlatform;
              session.writeWebAuthCookie('issued');
            },
      );
      pod.webServer.addMiddleware(
        requireLogin(redirectTo: '/auth/login'),
        '/account',
      );
      pod.webServer.addRoute(WhoAmIRoute(), '/account');
      await pod.start();
      base = Uri.parse('http://localhost:${pod.webServer.port}');
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when OAuth starts then the response is 302 to the tenant authorize '
      'URL with Flutter-matching scopes.',
      () async {
        final response = await send(client, base, 'GET', '/auth/microsoft');
        expect(response.statusCode, 302);
        expect(response.headers['cache-control'], contains('no-store'));
        final location = Uri.parse(response.headers['location']!);
        expect(location.host, 'login.microsoftonline.com');
        expect(location.path, '/common/oauth2/v2.0/authorize');
        expect(
          location.queryParameters['client_id'],
          'test-microsoft-client-id',
        );
        expect(
          location.queryParameters['scope'],
          'openid profile email offline_access '
          'https://graph.microsoft.com/User.Read',
        );
        expect(
          location.queryParameters['redirect_uri'],
          'http://localhost:8082/auth/microsoft/callback',
        );
        expect(location.queryParameters['code_challenge_method'], 'S256');
      },
    );

    test(
      'when login is mocked then the callback calls login with '
      'isWebPlatform: true and sets the auth cookie.',
      () async {
        final start = await send(client, base, 'GET', '/auth/microsoft');
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final streamed = await client.send(
          http.Request(
              'GET',
              base.replace(
                path: '/auth/microsoft/callback',
                queryParameters: {'code': 'ok', 'state': state},
              ),
            )
            ..followRedirects = false
            ..headers['cookie'] = '$name=$oauthCookie',
        );
        final response = await http.Response.fromStream(streamed);
        expect(response.statusCode, 303);
        expect(response.headers['location'], '/account');
        expect(setCookieValue(response, authCookieName), 'issued');
        expect(capturedIsWebPlatform, isTrue);
      },
    );

    test(
      'when GET /auth/login is requested then the Microsoft button is shown.',
      () async {
        final response = await send(client, base, 'GET', '/auth/login');
        expect(response.body, contains('Continue with Microsoft'));
      },
    );

    test(
      'when requireLogin is mounted only on /account then /auth/login is '
      'public and /account redirects.',
      () async {
        final login = await send(client, base, 'GET', '/auth/login');
        expect(login.statusCode, 200);
        final account = await send(client, base, 'GET', '/account');
        expect(account.statusCode, 303);
        expect(account.headers['location'], contains('/auth/login'));
      },
    );
  });
}
