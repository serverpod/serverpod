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

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  setUpAll(() async {
    client = http.Client();
    webDir = Directory(
      path.join(Directory.current.path, 'web', 'spa_route_test'),
    );
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

  group('Given a web server with SpaRoute', () {
    late Serverpod pod;
    late int port;

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

      pod.webServer.addRoute(
        SpaRoute(webDir, fallback: indexFile),
        '/**',
      );

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
      'when requesting non-existent file then fallback is served',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/users/123'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );

    test(
      'when requesting nested non-existent path then fallback is served',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/app/users/profile/settings'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );
  });

  group('Given a SpaRoute with custom fallback', () {
    late Serverpod pod;
    late int port;
    late File customFallback;

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

      customFallback = File(path.join(webDir.path, 'custom.html'));
      await customFallback.writeAsString(
        '<html><body>Custom Fallback</body></html>',
      );

      pod.webServer.addRoute(
        SpaRoute(webDir, fallback: customFallback),
        '/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (await customFallback.exists()) {
        await customFallback.delete();
      }
    });

    test('when fallback is triggered then custom fallback is used', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/non-existent'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Custom Fallback'));
    });
  });

  group('Given a SpaRoute mounted at a specific prefix path', () {
    late Serverpod pod;
    late int port;

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

      pod.webServer.addRoute(
        SpaRoute(webDir, fallback: indexFile),
        '/app/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting existing file then file is served', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/app/app.js'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('console.log'));
    });

    test(
      'when requesting non-existent nested path then fallback is served',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/app/nested/deep/path'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );

    test(
      'when requesting existing file without prefix then 404 is returned',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/app.js'),
        );
        expect(response.statusCode, 404);
      },
    );
  });

  group('Given multiple SpaRoutes on different paths', () {
    late Serverpod pod;
    late int port;
    late Directory adminDir;
    late File adminIndexFile;

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
        path.join(Directory.current.path, 'web', 'admin_spa_test'),
      );
      await adminDir.create(recursive: true);
      adminIndexFile = File(path.join(adminDir.path, 'index.html'));
      await adminIndexFile.writeAsString('<html><body>Admin SPA</body></html>');

      // Admin SPA
      pod.webServer.addRoute(
        SpaRoute(adminDir, fallback: adminIndexFile),
        '/admin/**',
      );

      // Public SPA
      pod.webServer.addRoute(
        SpaRoute(webDir, fallback: indexFile),
        '/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (await adminDir.exists()) {
        await adminDir.delete(recursive: true);
      }
    });

    test('when requesting admin path then admin fallback is served', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/admin/users'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Admin SPA'));
    });

    test(
      'when requesting public path then public fallback is served',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/users'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );
  });

  group('Given a SpaRoute with cache control', () {
    late Serverpod pod;
    late int port;

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

      pod.webServer.addRoute(
        SpaRoute(
          webDir,
          fallback: indexFile,
          cacheControlFactory: StaticRoute.public(maxAge: Duration(hours: 1)),
        ),
        '/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when cache control is set then headers are applied', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/app.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], contains('public'));
      expect(response.headers['cache-control'], contains('max-age=3600'));
    });
  });
}
