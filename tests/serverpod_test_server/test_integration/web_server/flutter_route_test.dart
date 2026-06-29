import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  late Directory webDir;
  late http.Client client;

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

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addRoute(
        FlutterRoute(webDir),
      );

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting file then WASM headers are present', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    });

    test('when requesting index.html then served with WASM headers', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}index.html'),
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
          Uri.parse('${IntegrationTestServer.webUrl(pod)}app/route/123'),
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
          Uri.parse('${IntegrationTestServer.webUrl(pod)}non-existent-route'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Flutter App'));
      },
    );

    test(
      'when requesting / then index.html is used',
      () async {
        final response = await client.get(
          Uri.parse(IntegrationTestServer.webUrl(pod)),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Flutter App'));
      },
    );
  });

  group(
    'Given a web server with FlutterRoute configured without WASM headers',
    () {
      late Serverpod pod;

      setUp(() async {
        pod = IntegrationTestServer.create();

        pod.webServer.addRoute(
          FlutterRoute(webDir, enableWasmHeaders: false),
        );

        await IntegrationTestServer.start(pod);
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('when requesting file, then WASM headers are not present', () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}main.dart.js'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cross-origin-opener-policy'], isNull);
        expect(response.headers['cross-origin-embedder-policy'], isNull);
      });

      test(
        'when requesting non-existent file, then fallback does not have WASM headers',
        () async {
          final response = await client.get(
            Uri.parse('${IntegrationTestServer.webUrl(pod)}app/route/123'),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('Flutter App'));
          expect(response.headers['cross-origin-opener-policy'], isNull);
          expect(response.headers['cross-origin-embedder-policy'], isNull);
        },
      );
    },
  );

  group('Given a FlutterRoute with custom index file', () {
    late Serverpod pod;
    late File customIndex;

    setUp(() async {
      pod = IntegrationTestServer.create();

      await d
          .file('web/custom.html', '<html><body>Custom Flutter</body></html>')
          .create();
      customIndex = File(path.join(webDir.path, 'custom.html'));

      pod.webServer.addRoute(
        FlutterRoute(webDir, indexFile: customIndex),
      );

      await IntegrationTestServer.start(pod);
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
          Uri.parse('${IntegrationTestServer.webUrl(pod)}non-existent-route'),
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

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addRoute(
        FlutterRoute(
          webDir,
          cacheControlFactory: StaticRoute.public(
            maxAge: const Duration(hours: 1),
          ),
        ),
      );

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when cache control is set then headers are applied', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], contains('public'));
      expect(response.headers['cache-control'], contains('max-age=3600'));
    });
  });

  group('Given a FlutterRoute with default caching', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();

      await d.dir('web_cache_test', [
        d.file('index.html', '<html><body>Flutter App</body></html>'),
        d.file('flutter_service_worker.js', '// Service worker'),
        d.file('flutter_bootstrap.js', '// Bootstrap'),
        d.file('manifest.json', '{"name": "App"}'),
        d.file('version.json', '{"version": "1.0.0"}'),
        d.file('main.dart.js', '// Flutter web JS'),
        d.dir('assets', [
          d.file('image.png', 'fake image data'),
        ]),
      ]).create();

      final testWebDir = Directory(path.join(d.sandbox, 'web_cache_test'));
      pod.webServer.addRoute(
        FlutterRoute(testWebDir),
      );

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when index.html is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}index.html'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when flutter_service_worker.js is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse(
            '${IntegrationTestServer.webUrl(pod)}flutter_service_worker.js',
          ),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when flutter_bootstrap.js is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}flutter_bootstrap.js'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when manifest.json is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}manifest.json'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when version.json is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}version.json'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when main.dart.js is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}main.dart.js'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );

    test(
      'when assets/image.png is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}assets/image.png'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );
  });
}
