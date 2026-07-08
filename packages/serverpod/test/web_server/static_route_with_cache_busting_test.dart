import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

import '../server/test_helpers/empty_endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a web server', () {
    late Directory tempDir;
    late Serverpod pod;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('static_route_test_');
      await File(
        p.join(tempDir.path, 'test.txt'),
      ).writeAsString('Hello, World!');

      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      await tempDir.delete(recursive: true);
    });

    test(
      'when StaticRoute.withCacheBusting is created with a mount prefix, '
      'then it serves files correctly',
      () async {
        pod.webServer.addRoute(
          StaticRoute.withCacheBusting(
            tempDir,
            mountPrefix: '/static',
          ),
          '/static',
        );

        await pod.start();
        var port = pod.webServer.port!;

        var response = await http.get(
          Uri.parse('http://localhost:$port/static/test.txt'),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'Hello, World!');
      },
    );

    test(
      'when StaticRoute.withCacheBusting is created without a cache control factory, '
      'then it defaults to public immutable with 1 year max age',
      () async {
        pod.webServer.addRoute(
          StaticRoute.withCacheBusting(
            tempDir,
            mountPrefix: '/static',
          ),
          '/static',
        );

        await pod.start();
        var port = pod.webServer.port!;

        var response = await http.get(
          Uri.parse('http://localhost:$port/static/test.txt'),
        );

        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], contains('public'));
        expect(response.headers['cache-control'], contains('immutable'));
        expect(response.headers['cache-control'], contains('max-age=31536000'));

        await pod.shutdown(exitProcess: false);
      },
    );

    test(
      'when StaticRoute.withCacheBusting is created with a custom cache control, '
      'then it uses the custom cache control',
      () async {
        pod.webServer.addRoute(
          StaticRoute.withCacheBusting(
            tempDir,
            mountPrefix: '/static',
            cacheControlFactory: StaticRoute.noStore(),
          ),
          '/static',
        );

        await pod.start();
        var port = pod.webServer.port!;

        var response = await http.get(
          Uri.parse('http://localhost:$port/static/test.txt'),
        );

        expect(response.statusCode, 200);
        expect(response.headers['cache-control'], 'no-store');

        await pod.shutdown(exitProcess: false);
      },
    );

    test(
      'when StaticRoute.withCacheBusting is created with a host parameter, '
      'then it only responds to that host',
      () async {
        pod.webServer.addRoute(
          StaticRoute.withCacheBusting(
            tempDir,
            mountPrefix: '/static',
            host: 'assets.example.com',
          ),
          '/static',
        );

        await pod.start();
        var port = pod.webServer.port!;

        var responseNoHost = await http.get(
          Uri.parse('http://localhost:$port/static/test.txt'),
        );
        expect(responseNoHost.statusCode, 404);

        var responseWithHost = await http.get(
          Uri.parse('http://localhost:$port/static/test.txt'),
          headers: {'Host': 'assets.example.com'},
        );
        expect(responseWithHost.statusCode, 200);
        expect(responseWithHost.body, 'Hello, World!');

        await pod.shutdown(exitProcess: false);
      },
    );
  });
}
