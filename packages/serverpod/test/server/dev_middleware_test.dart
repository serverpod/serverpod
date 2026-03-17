import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/dev_auto_refresh_script.dart';
import 'package:test/test.dart';

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}

class _DummyRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return Response.ok();
  }
}

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a WebServer started in dev mode', () {
    late Serverpod pod;
    late int port;

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

      pod.webServer.addRoute(_DummyRoute(), '/dummy');
      pod.webServer.setDevModeForTesting(true);

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when GET /__dev/version is called, '
      'then it returns the static change count as text',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/__dev/version'),
        );

        expect(response.statusCode, 200);
        expect(response.body, '0');
      },
    );

    test(
      'when the dev auto-refresh script is inspected, '
      'then it contains a polling fetch to /__dev/version',
      () {
        expect(devAutoRefreshScript, contains('/__dev/version'));
        expect(devAutoRefreshScript, contains('location.reload()'));
      },
    );
  });

  group('Given a WebServer started without dev mode', () {
    late Serverpod pod;
    late int port;

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

      pod.webServer.addRoute(_DummyRoute(), '/dummy');
      pod.webServer.setDevModeForTesting(false);

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when GET /__dev/version is called, '
      'then it returns 404',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/__dev/version'),
        );

        expect(response.statusCode, isNot(200));
      },
    );
  });
}
