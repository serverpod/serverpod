import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/web/routes/root.dart';
import 'package:test/test.dart';

void main() {
  group('Given a server with all services running on port zero', () {
    late Serverpod server;
    final portZeroConfig = ServerConfig(
      port: 0,
      publicScheme: 'http',
      publicHost: 'localhost',
      publicPort: 0,
    );

    setUpAll(() async {
      server = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
          // Skipped because insights requires a database. But it uses the same
          // implementation as the apiServer.
          // insightsServer: portZeroConfig,
        ),
      );

      /// Required to enable the web server.
      server.webServer.addRoute(RootRoute(), '/');

      await server.start();
    });

    tearDownAll(() async {
      await server.shutdown();
    });

    test('then api server reports actual port', () {
      expect(server.server.port, isNonZero);
    });

    test('then web server reports actual port', () {
      expect(server.webServer.port, isNonZero);
    });

    test(
      'then insights server reports actual port',
      () {
        expect(server.serviceServer.port, isNonZero);
      },
      skip:
          'Skipped because insights requires a database. But it uses the same '
          'implementation as the `server.server` so if that works, this works.',
    );
  });
}
