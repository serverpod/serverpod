import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/protocol.dart' show TableDefinition;
import 'package:test/test.dart';

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}

class _TestSerializationManager extends SerializationManagerServer {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
}

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a WebServer.addRoute', () {
    late Serverpod pod;

    setUp(() async {
      pod = Serverpod(
        [],
        _TestSerializationManager(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    group('when calling with a tail-path', () {
      test(
        'then it accepts route with root-path',
        () {
          expect(
            () => pod.webServer.addRoute(_TestRoute(path: '/'), '/**'),
            returnsNormally,
          );
        },
      );

      test(
        'then it rejects route that registers sub-routes',
        () {
          expect(
            () => pod.webServer.addRoute(
              _TestRoute(
                injector: (r) => r.get('/sub-route', (_) => Response.ok()),
              ),
              '/**',
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'then it rejects route with non-root path',
        () {
          expect(
            () => pod.webServer.addRoute(_TestRoute(path: '/a'), '/**'),
            throwsArgumentError,
          );
        },
      );

      test(
        'then it rejects route with tail in its own path',
        () {
          expect(
            () => pod.webServer.addRoute(_TestRoute(path: '/**'), '/**'),
            throwsArgumentError,
          );
        },
      );
    });

    group('when calling without tail path', () {
      test(
        'then it accepts route that registers sub-routes',
        () {
          expect(
            () => pod.webServer.addRoute(
              _TestRoute(
                injector: (r) => r.get('/sub-route', (_) => Response.ok()),
              ),
              '/api',
            ),
            returnsNormally,
          );
        },
      );

      test(
        'then it accepts route with non-root path',
        () {
          expect(
            () => pod.webServer.addRoute(_TestRoute(path: '/a'), '/api'),
            returnsNormally,
          );
        },
      );

      test(
        'then it accepts route with tail in its own path',
        () {
          expect(
            () => pod.webServer.addRoute(_TestRoute(path: 'b/**'), '/api'),
            returnsNormally,
          );
        },
      );
    });

    test(
      'when adding a route without host, then it matches any host',
      () {
        final route = _TestRoute(path: '/');
        expect(route.host, isNull);
        expect(
          () => pod.webServer.addRoute(route, '/api'),
          returnsNormally,
        );
      },
    );

    test(
      'when adding a route with host, then it is set correctly',
      () {
        final route = _TestRoute(host: 'api.example.com', path: '/');
        expect(route.host, equals('api.example.com'));
        expect(
          () => pod.webServer.addRoute(route, '/api'),
          returnsNormally,
        );
      },
    );

    test(
      'when adding routes with different hosts, then both are accepted',
      () {
        final apiRoute = _TestRoute(host: 'api.example.com', path: '/');
        final webRoute = _TestRoute(host: 'www.example.com', path: '/');
        final anyRoute = _TestRoute(path: '/health');

        expect(
          () {
            pod.webServer.addRoute(apiRoute, '/users');
            pod.webServer.addRoute(webRoute, '/users');
            pod.webServer.addRoute(anyRoute, '/');
          },
          returnsNormally,
        );
      },
    );
  });

  group('Given a WebServer with host-specific routes', () {
    late Serverpod pod;
    late int port;

    setUp(() async {
      pod = Serverpod(
        [],
        _TestSerializationManager(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      pod.webServer.addRoute(
        _TestRoute(host: 'api.example.com', path: '/', body: 'api-host'),
        '/data',
      );
      pod.webServer.addRoute(
        _TestRoute(host: 'web.example.com', path: '/', body: 'web-host'),
        '/data',
      );
      pod.webServer.addRoute(
        _TestRoute(path: '/', body: 'any-host'),
        '/health',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when request has matching host header, then host-specific route responds',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/data'),
          headers: {'Host': 'api.example.com'},
        );

        expect(response.statusCode, 200);
        expect(response.body, 'api-host');
      },
    );

    test(
      'when request has different matching host header, then corresponding route responds',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/data'),
          headers: {'Host': 'web.example.com'},
        );

        expect(response.statusCode, 200);
        expect(response.body, 'web-host');
      },
    );

    test(
      'when request has non-matching host header for host-specific route, then returns 404',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/data'),
          headers: {'Host': 'other.example.com'},
        );

        expect(response.statusCode, 404);
      },
    );

    test(
      'when route has no host restriction, then it responds to any host',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/health'),
          headers: {'Host': 'any.example.com'},
        );

        expect(response.statusCode, 200);
        expect(response.body, 'any-host');
      },
    );

    test(
      'when route has no host restriction, then it responds without host header',
      () async {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:$port/health'),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'any-host');
      },
    );
  });
}

class _TestRoute extends Route {
  void Function(RelicRouter)? injector;
  final String body;

  _TestRoute({this.injector, super.path, super.host, this.body = ''});

  @override
  void injectIn(RelicRouter router) => (injector ?? super.injectIn)(router);

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return Response.ok(body: Body.fromString(body));
  }
}
