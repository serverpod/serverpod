import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  late Directory webDir;
  late File indexFile;
  late http.Client client;

  setUpAll(() async {
    client = http.Client();

    await d.dir('web', [
      d.file('index.html', '<html><body>SPA Index</body></html>'),
      d.file('app.js', 'console.log("app");'),
    ]).create();

    webDir = Directory(path.join(d.sandbox, 'web'));
    indexFile = File(path.join(webDir.path, 'index.html'));
  });

  tearDownAll(() async {
    client.close();
  });

  group('Given a web server with SpaRoute', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addRoute(
        SpaRoute(webDir, fallback: indexFile),
      );

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting existing file then file is served', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}app.js'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('console.log'));
    });

    test('when requesting index.html then index is served', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}index.html'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('SPA Index'));
    });

    test(
      'when requesting non-existent file then fallback is served',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}users/123'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );

    test(
      'when requesting nested non-existent path then fallback is served',
      () async {
        final response = await client.get(
          Uri.parse(
            '${IntegrationTestServer.webUrl(pod)}app/users/profile/settings',
          ),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );

    test(
      'when requesting / then fallback is served',
      () async {
        final response = await client.get(
          Uri.parse(IntegrationTestServer.webUrl(pod)),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );
  });

  group('Given a SpaRoute with custom fallback', () {
    late Serverpod pod;
    late File customFallback;

    setUp(() async {
      pod = IntegrationTestServer.create();

      await d
          .file('web/custom.html', '<html><body>Custom Fallback</body></html>')
          .create();
      customFallback = File(path.join(webDir.path, 'custom.html'));

      pod.webServer.addRoute(SpaRoute(webDir, fallback: customFallback));

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (await customFallback.exists()) {
        await customFallback.delete();
      }
    });

    test('when fallback is triggered then custom fallback is used', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}non-existent'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Custom Fallback'));
    });
  });

  group('Given a SpaRoute mounted at a specific prefix path', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addRoute(SpaRoute(webDir, fallback: indexFile), '/app');

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting existing file then file is served', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}app/app.js'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('console.log'));
    });

    test(
      'when requesting non-existent nested path then fallback is served',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}app/nested/deep/path'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );

    test(
      'when requesting existing file without prefix then 404 is returned',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}app.js'),
        );
        expect(response.statusCode, 404);
      },
    );
  });

  group('Given multiple SpaRoutes on different paths', () {
    late Serverpod pod;
    late Directory adminDir;
    late File adminIndexFile;

    setUp(() async {
      pod = IntegrationTestServer.create();

      await d.dir('admin', [
        d.file('index.html', '<html><body>Admin SPA</body></html>'),
      ]).create();

      adminDir = Directory(path.join(d.sandbox, 'admin'));
      adminIndexFile = File(path.join(adminDir.path, 'index.html'));

      pod.webServer.addRoute(
        SpaRoute(adminDir, fallback: adminIndexFile),
        '/admin',
      );

      pod.webServer.addRoute(SpaRoute(webDir, fallback: indexFile));

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting admin path then admin fallback is served', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}admin/users'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Admin SPA'));
    });

    test(
      'when requesting public path then public fallback is served',
      () async {
        final response = await client.get(
          Uri.parse('${IntegrationTestServer.webUrl(pod)}users'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      },
    );
  });

  group('Given a SpaRoute with cache control', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addRoute(
        SpaRoute(
          webDir,
          fallback: indexFile,
          cacheControlFactory: StaticRoute.public(maxAge: Duration(hours: 1)),
        ),
      );

      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when cache control is set then headers are applied', () async {
      final response = await client.get(
        Uri.parse('${IntegrationTestServer.webUrl(pod)}app.js'),
      );
      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], contains('public'));
      expect(response.headers['cache-control'], contains('max-age=3600'));
    });
  });
}
