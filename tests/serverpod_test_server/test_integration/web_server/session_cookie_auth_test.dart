import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

const _allowedOrigin = 'http://localhost:9999';
const _authCookieName = WebAuthCookieConfig.defaultName;
const _refreshCookieName = '${WebAuthCookieConfig.defaultName}_refresh';
const _goodToken = 'good';

final _portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

void main() {
  late http.Client client;

  setUpAll(() {
    client = http.Client();
  });

  tearDownAll(() {
    client.close();
  });

  group('Given a web server with authCookie and an authenticationHandler', () {
    late Serverpod pod;
    late int port;
    late Uri base;

    setUp(() async {
      pod = _createPod(
        authCookie: const WebAuthCookieConfig(secure: false),
        allowedOrigins: const [_allowedOrigin],
      );

      pod.webServer.addRoute(_WhoAmIRoute(), '/whoami');
      pod.webServer.addRoute(_SetCookieRoute(), '/set-cookie');
      pod.webServer.addRoute(_WriteAuthCookieRoute(), '/write-auth-cookie');
      pod.webServer.addRoute(_ThrowCookieRoute(), '/throw-cookie');
      pod.webServer.addRoute(_ThrowAuthCookieRoute(), '/throw-auth-cookie');
      pod.webServer.addRoute(_HtmlCookieRoute(), '/html-cookie');
      pod.webServer.fallbackRoute = _FallbackCookieRoute();

      pod.webServer.addMiddleware(
        requireLogin(redirectTo: '/login'),
        '/private',
      );
      pod.webServer.addRoute(_WhoAmIRoute(), '/private');

      pod.webServer.addMiddleware(requireLogin(), '/locked');
      pod.webServer.addRoute(_WhoAmIRoute(), '/locked');

      pod.webServer.addMiddleware(
        requireLogin(redirectTo: '/login?from=nav'),
        '/with-query',
      );
      pod.webServer.addRoute(_WhoAmIRoute(), '/with-query');

      await pod.start();
      port = pod.webServer.port!;
      base = Uri.parse('http://localhost:$port');
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    Future<http.Response> send(
      String method,
      String path, {
      Map<String, String>? headers,
    }) async {
      final request = http.Request(method, base.replace(path: path))
        ..followRedirects = false;
      if (headers != null) request.headers.addAll(headers);
      final streamed = await client.send(request);
      return http.Response.fromStream(streamed);
    }

    test(
      'when a Bearer token is sent '
      'then the request is authenticated from the header.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {'authorization': 'Bearer $_goodToken'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );

    test(
      'when the auth cookie is sent without an Authorization header '
      'then the request is authenticated from the cookie.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );

    test(
      'when neither header nor cookie is sent '
      'then the request is anonymous.',
      () async {
        final response = await send('GET', '/whoami');
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when both a Bearer token and an auth cookie are sent '
      'then the header wins.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {
            'authorization': 'Bearer $_goodToken',
            'cookie': '$_authCookieName=other',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );

    test(
      'when an invalid Bearer token and a valid auth cookie are sent '
      'then the request is anonymous (cookie is not a fallback).',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {
            'authorization': 'Bearer bad',
            'cookie': '$_authCookieName=$_goodToken',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when cookie-transport is set with an auth cookie '
      'then the request is anonymous.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {
            webAuthModeHeaderName: webAuthModeCookieTransport,
            'cookie': '$_authCookieName=$_goodToken',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when only the refresh cookie is sent '
      'then the request is anonymous.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {'cookie': '$_refreshCookieName=$_goodToken'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when the auth cookie name is duplicated '
      'then the request is anonymous.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {
            'cookie': '$_authCookieName=$_goodToken; $_authCookieName=other',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when the auth cookie is garbage '
      'then the request is anonymous and not 500.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {'cookie': '$_authCookieName=not-a-token'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when setResponseCookie is called '
      'then Set-Cookie is present on success.',
      () async {
        final response = await send('GET', '/set-cookie');
        expect(response.statusCode, 200);
        expect(response.headers['set-cookie'], contains('queued=1'));
      },
    );

    test(
      'when setResponseCookie is called and the handler throws '
      'then Set-Cookie is present on the 500.',
      () async {
        final response = await send('GET', '/throw-cookie');
        expect(response.statusCode, 500);
        expect(response.headers['set-cookie'], contains('queued=1'));
      },
    );

    test(
      'when writeWebAuthCookie is called from a Relic route '
      'then the auth cookie is delivered (WebCallSession is cookie-mode).',
      () async {
        final response = await send('GET', '/write-auth-cookie');
        expect(response.statusCode, 200);
        expect(response.headers['set-cookie'], contains('$_authCookieName='));
      },
    );

    test(
      'when writeWebAuthCookie is called and the handler throws '
      'then the auth cookie is still delivered.',
      () async {
        final response = await send('GET', '/throw-auth-cookie');
        expect(response.statusCode, 500);
        expect(response.headers['set-cookie'], contains('$_authCookieName='));
      },
    );

    test(
      'when the fallback route queues a cookie '
      'then Set-Cookie is present.',
      () async {
        final response = await send('GET', '/no-such-route');
        expect(response.statusCode, 200);
        expect(response.body, 'fallback');
        expect(response.headers['set-cookie'], contains('fallback=1'));
      },
    );

    test(
      'when a cookie-authenticated POST is missing Origin '
      'then the response is 403.',
      () async {
        final response = await send(
          'POST',
          '/whoami',
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, 403);
      },
    );

    test(
      'when a cookie-authenticated POST has Origin null '
      'then the response is 403.',
      () async {
        final response = await send(
          'POST',
          '/whoami',
          headers: {
            'cookie': '$_authCookieName=$_goodToken',
            'origin': 'null',
          },
        );
        expect(response.statusCode, 403);
      },
    );

    test(
      'when a cookie-authenticated POST has a disallowed Origin '
      'then the response is 403.',
      () async {
        final response = await send(
          'POST',
          '/whoami',
          headers: {
            'cookie': '$_authCookieName=$_goodToken',
            'origin': 'https://evil.example',
          },
        );
        expect(response.statusCode, 403);
      },
    );

    test(
      'when a cookie-authenticated POST has an allow-listed Origin '
      'with different case and a trailing slash '
      'then the request is served.',
      () async {
        final response = await send(
          'POST',
          '/whoami',
          headers: {
            'cookie': '$_authCookieName=$_goodToken',
            'origin': 'HTTP://LOCALHOST:9999/',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );

    test(
      'when a cookie-less POST has a foreign Origin '
      'then it is not Origin-gated.',
      () async {
        final response = await send(
          'POST',
          '/whoami',
          headers: {'origin': 'https://evil.example'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when a cookie-authenticated GET has a disallowed Origin '
      'then the request is still served.',
      () async {
        final response = await send(
          'GET',
          '/whoami',
          headers: {
            'cookie': '$_authCookieName=$_goodToken',
            'origin': 'https://evil.example',
          },
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );

    test(
      'when a cookie-authenticated HEAD is missing Origin '
      'then it is not Origin-gated.',
      () async {
        final response = await send(
          'HEAD',
          '/whoami',
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, isNot(403));
      },
    );

    test(
      'when a cookie-authenticated OPTIONS is missing Origin '
      'then it is not Origin-gated.',
      () async {
        final response = await send(
          'OPTIONS',
          '/whoami',
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, isNot(403));
      },
    );

    for (final method in ['PUT', 'PATCH', 'DELETE']) {
      test(
        'when a cookie-authenticated $method is missing Origin '
        'then the response is 403.',
        () async {
          final response = await send(
            method,
            '/whoami',
            headers: {'cookie': '$_authCookieName=$_goodToken'},
          );
          expect(response.statusCode, 403);
        },
      );
    }

    test(
      'when an unauthenticated client hits a requireLogin path with redirectTo '
      'then the response is 303 with a safe return_to.',
      () async {
        final response = await send('GET', '/private');
        expect(response.statusCode, 303);
        expect(
          response.headers['location'],
          '/login?return_to=${Uri.encodeQueryComponent('/private')}',
        );
      },
    );

    test(
      'when an unauthenticated client hits a requireLogin path without redirectTo '
      'then the response is 401.',
      () async {
        final response = await send('GET', '/locked');
        expect(response.statusCode, 401);
      },
    );

    test(
      'when redirectTo already contains a query '
      'then return_to is appended with &.',
      () async {
        final response = await send('GET', '/with-query');
        expect(response.statusCode, 303);
        expect(
          response.headers['location'],
          '/login?from=nav&return_to=${Uri.encodeQueryComponent('/with-query')}',
        );
      },
    );

    test(
      'when an authenticated client hits a requireLogin path '
      'then the request is served.',
      () async {
        final response = await send(
          'GET',
          '/private',
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'mario');
      },
    );
  });

  group('Given a web server without authCookie', () {
    late Serverpod pod;
    late int port;

    setUp(() async {
      pod = _createPod();
      pod.webServer.addRoute(_WhoAmIRoute(), '/whoami');
      pod.webServer.addRoute(_WriteAuthCookieRoute(), '/write-auth-cookie');
      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when an auth cookie is sent '
      'then it is ignored and the request is anonymous.',
      () async {
        final response = await client.get(
          Uri.parse('http://localhost:$port/whoami'),
          headers: {'cookie': '$_authCookieName=$_goodToken'},
        );
        expect(response.statusCode, 200);
        expect(response.body, 'anonymous');
      },
    );

    test(
      'when writeWebAuthCookie is called '
      'then no Set-Cookie is issued.',
      () async {
        final response = await client.get(
          Uri.parse('http://localhost:$port/write-auth-cookie'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['set-cookie'], isNull);
      },
    );
  });

  group('Given a web server in dev mode', () {
    late Serverpod pod;
    late int port;

    setUp(() async {
      pod = _createPod(
        authCookie: const WebAuthCookieConfig(secure: false),
        allowedOrigins: const [_allowedOrigin],
      );
      pod.webServer.addRoute(_HtmlCookieRoute(), '/html-cookie');
      pod.webServer.setDevModeForTesting(true);
      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when an HTML route queues a cookie '
      'then Set-Cookie is preserved after script injection.',
      () async {
        final response = await client.get(
          Uri.parse('http://localhost:$port/html-cookie'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('/__dev/version'));
        expect(response.headers['set-cookie'], contains('html=1'));
      },
    );
  });
}

Serverpod _createPod({
  WebAuthCookieConfig? authCookie,
  List<String>? allowedOrigins,
}) {
  return Serverpod(
    [],
    Protocol(),
    Endpoints(),
    config: ServerpodConfig(
      apiServer: _portZeroConfig,
      webServer: _portZeroConfig,
      authCookie: authCookie,
      allowedOrigins: allowedOrigins,
    ),
    authenticationHandler: (session, token) async {
      if (token == _goodToken) {
        return AuthenticationInfo('mario', {}, authId: 'good');
      }
      return null;
    },
  );
}

const _allMethods = {
  Method.get,
  Method.head,
  Method.post,
  Method.put,
  Method.patch,
  Method.delete,
  Method.options,
};

class _WhoAmIRoute extends Route {
  _WhoAmIRoute() : super(methods: _allMethods);

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    final auth = session.authenticated;
    return Response.ok(
      body: Body.fromString(auth == null ? 'anonymous' : auth.userIdentifier),
    );
  }
}

class _SetCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    session.setResponseCookie(SetCookie(name: 'queued', value: '1'));
    return Response.ok();
  }
}

class _WriteAuthCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    final wrote = session.writeWebAuthCookie('issued-token');
    return Response.ok(body: Body.fromString('$wrote'));
  }
}

class _ThrowCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    session.setResponseCookie(SetCookie(name: 'queued', value: '1'));
    throw Exception('handler boom');
  }
}

class _ThrowAuthCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    session.writeWebAuthCookie('issued-token');
    throw Exception('handler boom');
  }
}

class _HtmlCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    session.setResponseCookie(SetCookie(name: 'html', value: '1'));
    return Response.ok(
      body: Body.fromString(
        '<html><body></body></html>',
        mimeType: MimeType.html,
      ),
    );
  }
}

class _FallbackCookieRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    session.setResponseCookie(SetCookie(name: 'fallback', value: '1'));
    return Response.ok(body: Body.fromString('fallback'));
  }
}
