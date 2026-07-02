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

  group(
    'Given a web server with SPA route configured using fallbackMiddleware',
    () {
      late Serverpod pod;

      setUp(() async {
        pod = IntegrationTestServer.create();

        pod.webServer.addMiddleware(
          FallbackMiddleware(
            fallback: StaticRoute.file(indexFile),
            on: (response) => response.statusCode == 404,
          ),
          '/',
        );
        pod.webServer.addRoute(StaticRoute.directory(webDir));

        await pod.startWithDatabase();
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('when requesting existing file then file is served', () async {
        final response = await client.get(
          Uri.parse('${pod.webUrl}app.js'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('console.log'));
      });

      test('when requesting index.html then index is served', () async {
        final response = await client.get(
          Uri.parse('${pod.webUrl}index.html'),
        );
        expect(response.statusCode, 200);
        expect(response.body, contains('SPA Index'));
      });

      test(
        'when requesting non-existent file then index.html is served',
        () async {
          final response = await client.get(
            Uri.parse('${pod.webUrl}users/123'),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('SPA Index'));
        },
      );

      test(
        'when requesting nested non-existent path then index.html is served',
        () async {
          final response = await client.get(
            Uri.parse(
              '${pod.webUrl}app/users/profile/settings',
            ),
          );
          expect(response.statusCode, 200);
          expect(response.body, contains('SPA Index'));
        },
      );
    },
  );

  group('Given a fallbackMiddleware where the fallback also returns 404', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();

      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: _NotFoundRoute(),
          on: (response) => response.statusCode == 404,
        ),
        '/',
      );
      pod.webServer.addRoute(StaticRoute.directory(webDir));

      await pod.startWithDatabase();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when primary and fallback both 404 then 404 is returned', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}does-not-exist'),
      );
      expect(response.statusCode, 404);
    });
  });

  group('Given multiple SPAs on different paths', () {
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

      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: StaticRoute.file(adminIndexFile),
          on: (response) => response.statusCode == 404,
        ),
        '/admin',
      );
      pod.webServer.addRoute(
        StaticRoute.directory(adminDir),
        '/admin',
      );

      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: StaticRoute.file(indexFile),
          on: (response) => response.statusCode == 404,
        ),
        '/',
      );
      pod.webServer.addRoute(StaticRoute.directory(webDir));

      await pod.startWithDatabase();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when requesting admin path then admin index is served', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}admin/users'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains('Admin SPA'));
    });

    test('when requesting public path then public index is served', () async {
      final response = await client.get(
        Uri.parse('${pod.webUrl}users'),
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
