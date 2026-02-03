import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
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
        internal.Protocol(),
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
}

class _TestRoute extends Route {
  void Function(RelicRouter)? injector;
  _TestRoute({this.injector, super.path, super.host});

  @override
  void injectIn(RelicRouter router) => (injector ?? super.injectIn)(router);

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return Response.ok();
  }
}
