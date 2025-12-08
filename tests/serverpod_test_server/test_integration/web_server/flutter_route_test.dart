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
      path.join(Directory.current.path, 'web', 'flutter_route_test'),
    );
    await webDir.create(recursive: true);

    // Create test files
    indexFile = File(path.join(webDir.path, 'index.html'));
    await indexFile.writeAsString('<html><body>Flutter App</body></html>');

    appJsFile = File(path.join(webDir.path, 'main.dart.js'));
    await appJsFile.writeAsString('// Flutter web JS');
  });

  tearDownAll(() async {
    client.close();
    if (await webDir.exists()) {
      await webDir.delete(recursive: true);
    }
  });

  group('Given a web server with FlutterRoute', () {
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
        FlutterRoute(webDir),
        '/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting file then WASM headers are present', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    });

    test('when requesting index.html then served with WASM headers', () async {
      final response = await client.get(
        Uri.http('localhost:$port', '/index.html'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Flutter App'));
      expect(response.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    });

    test(
      'when requesting non-existent file then fallback with WASM headers',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/app/route/123'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Flutter App'));
        expect(response.headers['cross-origin-opener-policy'], 'same-origin');
        expect(
          response.headers['cross-origin-embedder-policy'],
          'require-corp',
        );
      },
    );

    test(
      'when FlutterRoute uses default index then index.html is used',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/non-existent-route'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Flutter App'));
      },
    );
  });

  group('Given a FlutterRoute with custom index file', () {
    late Serverpod pod;
    late int port;
    late File customIndex;

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

      customIndex = File(path.join(webDir.path, 'custom.html'));
      await customIndex.writeAsString(
        '<html><body>Custom Flutter</body></html>',
      );

      pod.webServer.addRoute(
        FlutterRoute(webDir, indexFile: customIndex),
        '/**',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (await customIndex.exists()) {
        await customIndex.delete();
      }
    });

    test(
      'when FlutterRoute uses custom index then custom file is used',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/non-existent-route'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Custom Flutter'));
        expect(response.headers['cross-origin-opener-policy'], 'same-origin');
        expect(
          response.headers['cross-origin-embedder-policy'],
          'require-corp',
        );
      },
    );
  });

  group('Given a FlutterRoute with cache control', () {
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
        FlutterRoute(
          webDir,
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
        Uri.http('localhost:$port', '/main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], contains('public'));
      expect(response.headers['cache-control'], contains('max-age=3600'));
    });
  });
}
