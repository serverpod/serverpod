import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import 'web_auth_test_utils.dart';

void main() {
  late http.Client client;

  setUpAll(() {
    client = http.Client();
  });

  tearDownAll(() => client.close());

  group('Given HTML web auth with Google and GitHub', () {
    late Serverpod pod;
    late Uri base;
    late String pepper;

    setUp(() async {
      pod = createWebAuthPod();
      initSasAuth(
        pod,
        identityProviderBuilders: [
          GoogleIdpConfig(clientSecret: googleSecret()),
          GitHubIdpConfig(
            clientId: 'test-github-client-id',
            clientSecret: 'test-github-secret',
          ),
        ],
      );
      pod.authenticationHandler = (final session, final token) async {
        if (token == 'good') {
          return AuthenticationInfo('mario', {}, authId: 'good');
        }
        return null;
      };
      pod.configureWebAuthRoutes(
        googleLoginOverride:
            (
              final session, {
              required final code,
              required final codeVerifier,
              required final redirectUri,
            }) async {
              session.writeWebAuthCookie('issued');
            },
      );
      pod.webServer.addRoute(WhoAmIRoute(), '/whoami');
      pod.webServer.addRoute(
        FlutterWebAuth2CallbackRoute(),
        '/auth/callback',
      );
      await pod.start();
      base = Uri.parse('http://localhost:${pod.webServer.port}');
      pepper = pod.getPassword(webAuthOAuthStatePepperPasswordKey)!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    Future<http.Response> req(
      final String method,
      final String path, {
      final String? cookie,
      final String? origin,
    }) {
      return send(
        client,
        base,
        method,
        path,
        cookie: cookie,
        origin: origin,
      );
    }

    test(
      'when OAuth starts then the response is 302 with client_id, '
      'code_challenge, S256, no-store, and an HMAC state cookie.',
      () async {
        final response = await req('GET', '/auth/google');
        expect(response.statusCode, 302);
        expect(response.headers['cache-control'], contains('no-store'));
        final location = Uri.parse(response.headers['location']!);
        expect(location.host, 'accounts.google.com');
        expect(location.queryParameters['client_id'], 'test-google-client-id');
        expect(location.queryParameters['code_challenge'], isNotEmpty);
        expect(location.queryParameters['code_challenge_method'], 'S256');
        expect(
          location.queryParameters['redirect_uri'],
          'http://localhost:8082/auth/google/callback',
        );
        final oauthCookie = setCookieValue(
          response,
          oauthStateCookieName(pod.config.authCookie!),
        );
        expect(oauthCookie, isNotEmpty);
        final payload = decodeHmacPayload(oauthCookie!, pepper);
        expect(payload, isNotNull);
        expect(payload!['provider'], 'google');
        expect(payload['state'], location.queryParameters['state']);
      },
    );

    test(
      'when return_to is an open redirect then the HMAC cookie stores '
      'loginSuccessPath.',
      () async {
        final streamed = await client.send(
          http.Request(
            'GET',
            base.replace(
              path: '/auth/google',
              queryParameters: {'return_to': 'https://evil'},
            ),
          )..followRedirects = false,
        );
        final res = await http.Response.fromStream(streamed);
        final oauthCookie = setCookieValue(
          res,
          oauthStateCookieName(pod.config.authCookie!),
        );
        final payload = decodeHmacPayload(oauthCookie!, pepper);
        expect(payload!['return_to'], '/');
      },
    );

    test(
      'when return_to is /foo/..//evil.com then the HMAC cookie stores '
      'loginSuccessPath.',
      () async {
        final streamed = await client.send(
          http.Request(
            'GET',
            base.replace(
              path: '/auth/google',
              queryParameters: {'return_to': '/foo/..//evil.com'},
            ),
          )..followRedirects = false,
        );
        final res = await http.Response.fromStream(streamed);
        final oauthCookie = setCookieValue(
          res,
          oauthStateCookieName(pod.config.authCookie!),
        );
        final payload = decodeHmacPayload(oauthCookie!, pepper);
        expect(payload!['return_to'], '/');
      },
    );

    test(
      'when the OAuth state cookie is tampered then the callback is 403 '
      'and the user is not signed out.',
      () async {
        final start = await req('GET', '/auth/google');
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final tampered =
            '${oauthCookie.substring(0, 4)}xxxx${oauthCookie.substring(8)}';
        final response = await req(
          'GET',
          '/auth/google/callback',
          cookie: '$authCookieName=good; $name=$tampered',
        );
        expect(response.statusCode, 403);
        expect(setCookieValue(response, authCookieName), isNull);
        expect(setCookieCleared(response, name), isTrue);

        final who = await req(
          'GET',
          '/whoami',
          cookie: '$authCookieName=good',
        );
        expect(who.body, 'mario');
      },
    );

    test(
      'when the OAuth state query does not match then the callback is 403, '
      'the OAuth cookie is cleared, and the user is not signed out.',
      () async {
        final start = await req('GET', '/auth/google');
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final response = await req(
          'GET',
          '/auth/google/callback',
          cookie: '$authCookieName=good; $name=$oauthCookie',
        );
        expect(response.statusCode, 403);
        expect(setCookieValue(response, authCookieName), isNull);
        expect(setCookieCleared(response, name), isTrue);
        final who = await req(
          'GET',
          '/whoami',
          cookie: '$authCookieName=good',
        );
        expect(who.body, 'mario');
      },
    );

    test(
      'when a GitHub OAuth cookie is sent to the Google callback then 403 '
      'and the user is not signed out.',
      () async {
        final start = await req('GET', '/auth/github');
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final location = Uri.parse(start.headers['location']!);
        final state = location.queryParameters['state'];
        final streamed = await client.send(
          http.Request(
              'GET',
              base.replace(
                path: '/auth/google/callback',
                queryParameters: {'state': state, 'code': 'x'},
              ),
            )
            ..followRedirects = false
            ..headers['cookie'] = '$authCookieName=good; $name=$oauthCookie',
        );
        final response = await http.Response.fromStream(streamed);
        expect(response.statusCode, 403);
        final who = await req(
          'GET',
          '/whoami',
          cookie: '$authCookieName=good',
        );
        expect(who.body, 'mario');
      },
    );

    test(
      'when the provider returns error=access_denied then the OAuth cookie '
      'is cleared, the response is 303 to login, and no auth cookie is set.',
      () async {
        final start = await req('GET', '/auth/google');
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final streamed = await client.send(
          http.Request(
              'GET',
              base.replace(
                path: '/auth/google/callback',
                queryParameters: {'error': 'access_denied'},
              ),
            )
            ..followRedirects = false
            ..headers['cookie'] = '$name=$oauthCookie',
        );
        final response = await http.Response.fromStream(streamed);
        expect(response.statusCode, 303);
        expect(response.headers['location'], '/auth/login');
        expect(setCookieCleared(response, name), isTrue);
        expect(setCookieValue(response, authCookieName), isNull);
      },
    );

    test(
      'when loginWithCode is mocked then the callback sets the auth cookie '
      'and 303s to the safe return_to.',
      () async {
        final streamedStart = await client.send(
          http.Request(
            'GET',
            base.replace(
              path: '/auth/google',
              queryParameters: {'return_to': '/account'},
            ),
          )..followRedirects = false,
        );
        final start = await http.Response.fromStream(streamedStart);
        final name = oauthStateCookieName(pod.config.authCookie!);
        final oauthCookie = setCookieValue(start, name)!;
        final state = Uri.parse(
          start.headers['location']!,
        ).queryParameters['state']!;
        final streamed = await client.send(
          http.Request(
              'GET',
              base.replace(
                path: '/auth/google/callback',
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
      },
    );

    test(
      'when GET /auth/callback is requested then FlutterWebAuth2CallbackRoute '
      'still serves the callback page.',
      () async {
        final response = await req('GET', '/auth/callback');
        expect(response.statusCode, 200);
        expect(response.body, contains('postAuthenticationMessage'));
      },
    );

    test(
      'when Email IDP is not configured then GET /auth/login has no form '
      'and POST is 404.',
      () async {
        final getResponse = await req('GET', '/auth/login');
        expect(getResponse.statusCode, 200);
        expect(getResponse.body, isNot(contains('name="email"')));
        expect(getResponse.headers['cache-control'], contains('no-store'));
        expect(getResponse.body, contains('Continue with Google'));
        expect(getResponse.body, contains('Continue with GitHub'));

        final post = await send(
          client,
          base,
          'POST',
          '/auth/login',
          origin: allowedOrigin,
          body: formBody({'csrf': 'x', 'email': 'a', 'password': 'b'}),
        );
        expect(post.statusCode, 404);
      },
    );
  });

  group('Given HTML web auth with https public port 443', () {
    late Serverpod pod;
    late Uri base;

    setUp(() async {
      pod = createWebAuthPod(
        webServer: ServerConfig(
          port: 0,
          publicScheme: 'https',
          publicHost: 'example.com',
          publicPort: 443,
        ),
      );
      initSasAuth(
        pod,
        identityProviderBuilders: [
          GoogleIdpConfig(
            clientSecret: googleSecret(
              redirectUris: const ['https://example.com/auth/google/callback'],
            ),
          ),
        ],
      );
      pod.configureWebAuthRoutes();
      await pod.start();
      base = Uri.parse('http://localhost:${pod.webServer.port}');
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when OAuth starts then redirect_uri omits :443.',
      () async {
        final streamed = await client.send(
          http.Request('GET', base.replace(path: '/auth/google'))
            ..followRedirects = false,
        );
        final response = await http.Response.fromStream(streamed);
        expect(response.statusCode, 302);
        final location = Uri.parse(response.headers['location']!);
        expect(
          location.queryParameters['redirect_uri'],
          'https://example.com/auth/google/callback',
        );
      },
    );
  });

  group('Given HTML web auth with SAS only', () {
    late Serverpod pod;
    late Uri base;

    setUp(() async {
      pod = createWebAuthPod();
      initSasAuth(pod);
      pod.configureWebAuthRoutes();
      await pod.start();
      base = Uri.parse('http://localhost:${pod.webServer.port}');
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when Google is not configured then /auth/google is 404.', () async {
      final streamed = await client.send(
        http.Request('GET', base.replace(path: '/auth/google'))
          ..followRedirects = false,
      );
      final response = await http.Response.fromStream(streamed);
      expect(response.statusCode, 404);
    });
  });
}
