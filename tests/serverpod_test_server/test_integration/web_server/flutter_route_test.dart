import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';

void main() {
  late Directory webDir;
  late http.Client client;

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  setUpAll(() async {
    client = http.Client();

    await d.dir('web', [
      d.file('index.html', '<html><body>Flutter App</body></html>'),
      d.file('main.dart.js', '// Flutter web JS'),
    ]).create();

    webDir = Directory(path.join(d.sandbox, 'web'));
  });

  tearDownAll(() async {
    client.close();
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

    test(
      'when requesting / then index.html is used',
      () async {
        final response = await client.get(
          Uri.http('localhost:$port', '/'),
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

      await d
          .file('web/custom.html', '<html><body>Custom Flutter</body></html>')
          .create();
      customIndex = File(path.join(webDir.path, 'custom.html'));

      pod.webServer.addRoute(
        FlutterRoute(webDir, indexFile: customIndex),
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
