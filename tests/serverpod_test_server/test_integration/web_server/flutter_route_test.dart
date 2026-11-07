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

      await pod.startWithDatabase();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting file then WASM headers are present', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cross-origin-opener-policy'], 'same-origin');
      expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    });

    test('when requesting index.html then served with WASM headers', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}index.html'),
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
          Uri.parse('${pod.webUrl}app/route/123'),
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
          Uri.parse('${pod.webUrl}non-existent-route'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('Flutter App'));
      },
    );

    test(
      'when requesting / then index.html is used',
      () async {
        final response = await client.get(
          Uri.parse(pod.webUrl),
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

        await pod.startWithDatabase();
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('when requesting file, then WASM headers are not present', () async {
        final response = await client.get(
          Uri.parse('${pod.webUrl}main.dart.js'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cross-origin-opener-policy'], isNull);
        expect(response.headers['cross-origin-embedder-policy'], isNull);
      });

      test(
        'when requesting non-existent file, then fallback does not have WASM headers',
        () async {
          final response = await client.get(
            Uri.parse('${pod.webUrl}app/route/123'),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('Flutter App'));
          expect(response.headers['cross-origin-opener-policy'], isNull);
          expect(response.headers['cross-origin-embedder-policy'], isNull);
        },
      );
    },
  );

  group(
    'Given a web server with FlutterRoute configured with '
    'sameOriginAllowPopups COOP policy',
    () {
      late Serverpod pod;

      setUp(() async {
        pod = IntegrationTestServer.create();

        pod.webServer.addRoute(
          FlutterRoute(
            webDir,
            crossOriginOpenerPolicy:
                CrossOriginOpenerPolicyHeader.sameOriginAllowPopups,
          ),
        );

        await pod.startWithDatabase();
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when requesting file then the configured COOP policy is used',
        () async {
          final response = await client.get(
            Uri.parse('${pod.webUrl}main.dart.js'),
          );
          expect(response.statusCode, 200);
          expect(
            response.headers['cross-origin-opener-policy'],
            'same-origin-allow-popups',
          );
          expect(
            response.headers['cross-origin-embedder-policy'],
            'require-corp',
          );
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

      await pod.startWithDatabase();
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
          Uri.parse('${pod.webUrl}non-existent-route'),
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

      await pod.startWithDatabase();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when cache control is set then headers are applied', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}main.dart.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], contains('public'));
      expect(response.headers['cache-control'], contains('max-age=3600'));
    });
  });

  const _environmentCacheControlTestName =
      'Given a Flutter cache control environment variable and no Dart factory, '
      'when a Flutter asset is requested, '
      'then the environment cache control is applied.';
  test(_environmentCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: _environmentCacheControlTestName,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final pod = IntegrationTestServer.create(
      config: ServerpodConfig(
        apiServer: ServerConfig(
          port: 0,
          publicHost: 'localhost',
          publicPort: 0,
          publicScheme: 'http',
        ),
        webServer: ServerConfig(
          port: 0,
          publicHost: 'localhost',
          publicPort: 0,
          publicScheme: 'http',
        ),
      ),
    );
    pod.webServer.addRoute(FlutterRoute(webDir));

    await pod.start();
    addTearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    final response = await client.get(
      Uri.parse('${pod.webUrl}main.dart.js'),
    );

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=60'));
    expect(response.headers['cache-control'], contains('s-maxage=86400'));
  });

  const _dartCacheControlTestName =
      'Given a Flutter cache control environment variable and a Dart factory, '
      'when a Flutter asset is requested, '
      'then the Dart cache control takes precedence.';
  test(_dartCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: _dartCacheControlTestName,
      value: 'max-age=not-a-number',
    )) {
      return;
    }

    final pod = IntegrationTestServer.create(
      config: ServerpodConfig(
        apiServer: ServerConfig(
          port: 0,
          publicHost: 'localhost',
          publicPort: 0,
          publicScheme: 'http',
        ),
        webServer: ServerConfig(
          port: 0,
          publicHost: 'localhost',
          publicPort: 0,
          publicScheme: 'http',
        ),
      ),
    );
    pod.webServer.addRoute(
      FlutterRoute(
        webDir,
        cacheControlFactory: StaticRoute.noStore(),
      ),
    );

    await pod.start();
    addTearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    final response = await client.get(
      Uri.parse('${pod.webUrl}main.dart.js'),
    );

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('no-store'));
    expect(response.headers['cache-control'], isNot(contains('public')));
  });

  const _invalidEnvironmentCacheControlTestName =
      'Given an invalid Flutter cache control environment variable and no Dart factory, '
      'when FlutterRoute is created, '
      'then a FormatException is thrown.';
  test(_invalidEnvironmentCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: _invalidEnvironmentCacheControlTestName,
      value: 'invalid-directive',
    )) {
      return;
    }

    expect(() => FlutterRoute(webDir), throwsFormatException);
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

      await pod.startWithDatabase();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when index.html is requested then no-cache headers are present',
      () async {
        final response = await client.get(
          Uri.parse('${pod.webUrl}index.html'),
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
            '${pod.webUrl}flutter_service_worker.js',
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
          Uri.parse('${pod.webUrl}flutter_bootstrap.js'),
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
          Uri.parse('${pod.webUrl}manifest.json'),
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
          Uri.parse('${pod.webUrl}version.json'),
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
          Uri.parse('${pod.webUrl}main.dart.js'),
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
          Uri.parse('${pod.webUrl}assets/image.png'),
        );
        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('no-cache'));
        expect(response.headers['cache-control'], contains('private'));
      },
    );
  });
}

Future<bool> _rerunWithCacheControlEnvironment({
  required String testName,
  required String value,
}) async {
  const cacheControlEnvVarName = 'SERVERPOD_WEB_SERVER_FLUTTER_CACHE_CONTROL';

  if (Platform.environment[cacheControlEnvVarName] == value) {
    return false;
  }

  final result = await Process.run(
    Platform.resolvedExecutable,
    [
      'test',
      '--plain-name',
      testName,
      'test_integration/web_server/flutter_route_test.dart',
    ],
    workingDirectory: Directory.current.path,
    environment: {cacheControlEnvVarName: value},
  );

  expect(
    result.exitCode,
    0,
    reason:
        'Nested test failed.\nstdout:\n${result.stdout}\nstderr:\n${result.stderr}',
  );
  return true;
}
