import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

void main() {
  late Serverpod pod;
  late int port;

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  setUp(() async {
    // Setup a bare-bone serverpod
    pod = Serverpod(
      [],
      Protocol(),
      Endpoints(),
      config: ServerpodConfig(
        apiServer: portZeroConfig, // not used in these tests
        webServer: portZeroConfig,
      ),
      authenticationHandler: (session, token) => Future.value(
          token == 'Bearer good' ? AuthenticationInfo('mario', {}) : null),
    );

    pod.webServer.addMiddleware(_AuthMiddleware().call, '/api');
    pod.webServer.addRoute(TestRoute(), '/api/foo');
    pod.webServer.addRoute(TestRoute(), '/bar');

    await pod.start();

    port = pod.webServer.port!;
    print(port);
  });

  tearDown(() async {
    await pod.shutdown(exitProcess: false);
  });

  group(
      'Given a route that requires authentication is added to an authenticated path',
      () {
    test(
        'when client requests the path without authorization, '
        'then a 401 Unauthorized is returned', () async {
      var response = await http.get(Uri.http('localhost:$port', '/api/foo'));

      expect(response.statusCode, 401);
    });

    test(
        'when client requests the path with invalid authorization, '
        'then a 401 Unauthorized is returned', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/api/foo'),
        headers: {
          'Authorization': 'Bearer bad',
        },
      );

      expect(response.statusCode, 401);
    });

    test(
        'when client requests the path with valid authorization, '
        'then a 200 OK is returned', () async {
      var response = await http.get(
        Uri.http('localhost:$port', '/api/foo'),
        headers: {
          'Authorization': 'Bearer good',
        },
      );

      expect(response.statusCode, 200);
      expect(response.body, 'mario');
    });
  });

  test(
      'Given a route that requires authentication is added to an unauthenticated path, '
      'when a client request the path without authorization, '
      'then a 500 Internal Error is returned', () async {
    var response =
        await http.get(Uri.http('localhost:$port', '/bar'), headers: {});

    expect(response.statusCode, 500);
  });
}

/// Test route that requires authentication (uses ctx.authInfo)
class TestRoute extends Route {
  @override
  FutureOr<HandledContext> handleCall(Session session, NewContext context) {
    return context.respond(
        Response.ok(body: Body.fromString(context.authInfo.userIdentifier)));
  }
}

final _authInfoProperty = ContextProperty<AuthenticationInfo>('authInfo');

extension on RequestContext {
  AuthenticationInfo get authInfo => _authInfoProperty[this];
}

class _AuthMiddleware {
  Handler call(Handler next) {
    return (ctx) async {
      final info = await ctx.session.authenticated;
      if (info == null) return ctx.respond(Response.unauthorized());
      _authInfoProperty[ctx] = info;
      return next(ctx);
    };
  }
}
