import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}

class _TestWidget extends WebWidget {
  @override
  String toString() => '<html><body>Test</body></html>';
}

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given WidgetRoute with custom HTTP methods', () {
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

    test(
      'when WidgetRoute is created with GET only (default) then methods contains only GET.',
      () {
        final route = _GetOnlyRoute();
        expect(route.methods, {Method.get});
      },
    );

    test(
      'when WidgetRoute is created with GET and POST then methods contains both.',
      () {
        final route = _GetPostRoute();
        expect(route.methods, {Method.get, Method.post});
      },
    );

    test(
      'when WidgetRoute is created with POST only then methods contains only POST.',
      () {
        final route = _PostOnlyRoute();
        expect(route.methods, {Method.post});
      },
    );

    test(
      'when WidgetRoute with custom methods is added to WebServer then it is accepted.',
      () {
        expect(
          () => pod.webServer.addRoute(_GetPostRoute(), '/test'),
          returnsNormally,
        );
      },
    );
  });
}

class _GetOnlyRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return _TestWidget();
  }
}

class _GetPostRoute extends WidgetRoute {
  _GetPostRoute() : super(methods: {Method.get, Method.post});

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return _TestWidget();
  }
}

class _PostOnlyRoute extends WidgetRoute {
  _PostOnlyRoute() : super(methods: {Method.post});

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return _TestWidget();
  }
}
