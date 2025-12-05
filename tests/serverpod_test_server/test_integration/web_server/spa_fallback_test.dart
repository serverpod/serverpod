import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

void main() {
  late Directory webDir;
  late File indexFile;
  late File appJsFile;
  late http.Client client;

  setUpAll(() async {
    client = http.Client();
    webDir = Directory(path.join(Directory.current.path, 'web', 'spa_test'));
    await webDir.create(recursive: true);

    // Create test files
    indexFile = File(path.join(webDir.path, 'index.html'));
    await indexFile.writeAsString('<html><body>SPA Index</body></html>');

    appJsFile = File(path.join(webDir.path, 'app.js'));
    await appJsFile.writeAsString('console.log("app");');
  });

  tearDownAll(() async {
    client.close();
    if (await webDir.exists()) {
      await webDir.delete(recursive: true);
    }
  });

  group(
    'Given a web server with SPA route configured using fallbackMiddleware',
    () {
      late Serverpod pod;
      late int port;

      final portZeroConfig = ServerConfig(
        port: 0,
        publicScheme: 'http',
        publicHost: 'localhost',
        publicPort: 0,
      );

      setUp(() async {
        pod = Serverpod(
          [],
          Protocol(),
          Endpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
          ),
        );

        // Add fallback middleware and static route
        pod.webServer.addMiddleware(
          FallbackMiddleware(
            fallback: StaticRoute.file(indexFile),
            on: (response) => response.statusCode == 404,
          ),
          '/**',
        );
        pod.webServer.addRoute(StaticRoute.directory(webDir), '/**');

        await pod.start();
        port = pod.webServer.port!;
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('when requesting existing file then file is served', () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/app.js'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('console.log'));
      });

      test('when requesting index.html then index is served', () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/index.html'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      });

      test(
        'when requesting non-existent file then index.html is served',
        () async {
          final response = await client.get(
            Uri.http('localhost:$port', '/users/123'),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('SPA Index'));
        },
      );

      test(
        'when requesting nested non-existent path then index.html is served',
        () async {
          final response = await client.get(
            Uri.http('localhost:$port', '/app/users/profile/settings'),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('SPA Index'));
        },
      );
    },
  );

  group('Given a fallbackMiddleware where the fallback also returns 404', () {
    late Serverpod pod;
    late int port;

    final portZeroConfig = ServerConfig(
      port: 0,
      publicScheme: 'http',
      publicHost: 'localhost',
      publicPort: 0,
    );

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Use a custom route that returns 404 as the fallback
      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: _NotFoundRoute(),
          on: (response) => response.statusCode == 404,
        ),
        '/**',
      );
      pod.webServer.addRoute(StaticRoute.directory(webDir), '/**');

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when primary and fallback both 404 then 404 is returned', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/does-not-exist'),
      );
      expect(response.statusCode, 404);
    });
  });

  group('Given multiple SPAs on different paths', () {
    late Serverpod pod;
    late int port;
    late Directory adminDir;
    late File adminIndexFile;

    final portZeroConfig = ServerConfig(
      port: 0,
      publicScheme: 'http',
      publicHost: 'localhost',
      publicPort: 0,
    );

    setUp(() async {
      pod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      // Create admin SPA directory
      adminDir = Directory(
        path.join(Directory.current.path, 'web', 'admin_test'),
      );
      await adminDir.create(recursive: true);
      adminIndexFile = File(path.join(adminDir.path, 'index.html'));
      await adminIndexFile.writeAsString('<html><body>Admin SPA</body></html>');

      // Admin SPA
      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: StaticRoute.file(adminIndexFile),
          on: (response) => response.statusCode == 404,
        ),
        '/admin/**',
      );
      pod.webServer.addRoute(
        StaticRoute.directory(adminDir),
        '/admin/**',
      );

      // Public SPA
      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: StaticRoute.file(indexFile),
          on: (response) => response.statusCode == 404,
        ),
        '/**',
      );
      pod.webServer.addRoute(StaticRoute.directory(webDir), '/**');

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (await adminDir.exists()) {
        await adminDir.delete(recursive: true);
      }
    });

    test('when requesting admin path then admin index is served', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/admin/users'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Admin SPA'));
    });

    test('when requesting public path then public index is served', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/users'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('SPA Index'));
    });
  });
}

/// Test route that always returns 404
class _NotFoundRoute extends Route {
  @override
  Result handleCall(Session session, Request request) {
    return Response.notFound();
  }
}
