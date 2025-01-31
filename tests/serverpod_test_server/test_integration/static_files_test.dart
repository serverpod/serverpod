import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  var directory = Directory(path.join(Directory.current.path, 'web', 'static'));
  setUp(() async {
    await directory.create();
    await File(path.join(directory.path, 'file1.txt'))
        .writeAsString('contents');
    await File(path.join(directory.path, 'file2.test'))
        .writeAsString('contents');
  });

  tearDownAll(() async {
    await directory.delete(recursive: true);
  });

  group('Given a web server with a static directory', () {
    late Serverpod serverpod;

    setUp(() async {
      serverpod = IntegrationTestServer.create();
    });

    tearDown(() async {
      await serverpod.shutdown(exitProcess: false);
    });

    group('and a path cache pattern having a max age of 1 second', () {
      setUp(() async {
        serverpod.webServer.addRoute(
          RouteStaticDirectory(
            serverDirectory: '/static',
            pathCachePatterns: [
              PathCacheMaxAge(
                pathPattern: RegExp(r'.*\.txt'),
                maxAge: Duration(seconds: 1),
              ),
            ],
          ),
          '/static/*',
        );
        // Server should start after adding the route otherwise web server
        // will not be started.
        await serverpod.start();
      });

      test(
          'when requesting a static file with the same path pattern '
          'then the cache-control header is set to max-age=1', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/static/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path pattern '
          'then the cache-control header is set to default max age', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/static/file2.test',
          ),
        );

        expect(
          response.headers['cache-control'],
          'max-age=${PathCacheMaxAge.oneYear.inSeconds}',
        );
      });
    });

    group('and a path cache string having a max age of 1 second', () {
      setUp(() async {
        serverpod.webServer.addRoute(
          RouteStaticDirectory(
            serverDirectory: '/static',
            pathCachePatterns: [
              PathCacheMaxAge(
                pathPattern: '/static/file1.txt',
                maxAge: Duration(seconds: 1),
              ),
            ],
          ),
          '/static/*',
        );
        // Server should start after adding the route otherwise web server
        // will not be started.
        await serverpod.start();
      });

      test(
          'when requesting a static file with the same path string '
          'then the cache-control header is set to max-age=1', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/static/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path string '
          'then the cache-control header is set to default max age', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/static/file2.test',
          ),
        );

        expect(
          response.headers['cache-control'],
          'max-age=${PathCacheMaxAge.oneYear.inSeconds}',
        );
      });
    });
  });
}
