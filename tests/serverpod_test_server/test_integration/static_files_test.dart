@Timeout.none
library;

import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  var directory = Directory(
      path.join(Directory.current.path, 'web', 'server_root_directory'));
  var nestedDirectory = Directory(path.join(directory.path, 'nested_dir'));

  setUp(() async {
    await directory.create(recursive: true);
    await nestedDirectory.create(recursive: true);
    await File(path.join(directory.path, 'file1.txt'))
        .writeAsString('contents');
    await File(path.join(directory.path, 'file2.test'))
        .writeAsString('contents');
    await File(path.join(nestedDirectory.path, 'file3.txt'))
        .writeAsString('nested contents');
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
            serverDirectory: 'server_root_directory',
            pathCachePatterns: [
              PathCacheMaxAge(
                pathPattern: RegExp(r'.*\.txt'),
                maxAge: Duration(seconds: 1),
              ),
            ],
          ),
          '/url_prefix/**',
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
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path pattern '
          'then the cache-control header is set to default max age', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file2.test',
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
            serverDirectory: 'server_root_directory',
            pathCachePatterns: [
              PathCacheMaxAge(
                pathPattern: '/file1.txt',
                maxAge: Duration(seconds: 1),
              ),
            ],
          ),
          '/url_prefix/**',
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
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path string '
          'then the cache-control header is set to default max age', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file2.test',
          ),
        );

        expect(
          response.headers['cache-control'],
          'max-age=${PathCacheMaxAge.oneYear.inSeconds}',
        );
      });
    });

    group('when requesting a nested static file', () {
      setUp(() async {
        serverpod.webServer.addRoute(
          RouteStaticDirectory(
            serverDirectory: 'server_root_directory',
          ),
          '/url_prefix/**',
        );
        await serverpod.start();
      });

      test('then the file is served correctly', () async {
        var response = await http.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/nested_dir/file3.txt',
          ),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'nested contents');
        expect(
          response.headers['cache-control'],
          'max-age=${PathCacheMaxAge.oneYear.inSeconds}',
        );
      });
    });
  });
}
