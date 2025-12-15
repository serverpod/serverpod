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

  group('Given WebServer.addRoute', () {
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
  });
}

class _TestRoute extends Route {
  void Function(RelicRouter)? injector;
  _TestRoute({this.injector, super.path});

  @override
  void injectIn(RelicRouter router) => (injector ?? super.injectIn)(router);

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return Response.ok();
  }
}
