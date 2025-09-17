@Timeout.none
library;

import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  var directory = Directory(
      path.join(Directory.current.path, 'web', 'server_root_directory'));
  var nestedDirectory = Directory(path.join(directory.path, 'nested_dir'));

  late http.Client client;
  setUpAll(() async {
    client = http.IOClient(HttpClient()
      ..connectionTimeout = Duration(hours: 5)
      ..idleTimeout = Duration(hours: 5));

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
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path pattern '
          'then the cache-control header is set to default max age', () async {
        var response = await client.get(
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
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test(
          'when requesting a static file with a different path string '
          'then the cache-control header is set to default max age', () async {
        var response = await client.get(
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
        var response = await client.get(
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

    group('a request with', () {
      setUp(() async {
        serverpod.webServer.addRoute(
          RouteStaticDirectory(
            serverDirectory: 'server_root_directory',
          ),
          '/url_prefix/**',
        );
        await serverpod.start();
      });

      group('If-None-Match header', () {
        test('should return ETag header with initial request', () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(response.statusCode, 200);
          expect(response.headers['etag'], isNotNull);
          expect(response.body, 'contents');
        });

        test('should return 304 Not Modified when If-None-Match matches ETag',
            () async {
          // First request to get ETag
          var initialResponse = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );
          var etag = initialResponse.headers['etag'];
          expect(etag, isNotNull);

          // Second request with If-None-Match
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            headers: {
              'If-None-Match': etag!,
            },
          );

          expect(response.statusCode, 304);
          expect(response.body, isEmpty);
        });
      });

      group('If-Modified-Since header', () {
        test('should return Last-Modified header with initial request',
            () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(response.statusCode, 200);
          expect(response.headers['last-modified'], isNotNull);
          expect(response.body, 'contents');
        });

        test(
            'should return 304 Not Modified when If-Modified-Since is after last modification',
            () async {
          // First request to get Last-Modified
          var initialResponse = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );
          var lastModified = initialResponse.headers['last-modified'];
          expect(lastModified, isNotNull);

          // Move lastModified 1 second into the future to ensure it's after
          // the file's actual last modified time.
          lastModified = HttpDate.format(
            HttpDate.parse(lastModified!).add(Duration(seconds: 1)),
          );

          // Second request with If-Modified-Since set to lastModified
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            headers: {
              'If-Modified-Since': lastModified!,
            },
          );

          expect(response.statusCode, 304);
          expect(response.body, isEmpty);
        });
      });

      group('Range header for partial content', () {
        test('should support byte range requests', () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            headers: {
              'Range': 'bytes=0-3',
            },
          );
          expect(response.statusCode, 206); // Partial Content
          expect(response.headers['content-range'], contains('bytes 0-3/8'));
          expect(response.headers['accept-ranges'], 'bytes');
          expect(response.body, 'cont'); // First 4 bytes of 'contents'
        });

        test('should support range request for end of file', () async {
          var response = await http.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            headers: {
              'Range': 'bytes=4-7',
            },
          );

          expect(response.statusCode, 206);
          expect(response.headers['content-range'], contains('bytes 4-7/8'));
          expect(response.body, 'ents'); // Last 4 bytes of 'contents'
        });

        test('should return 416 for invalid range', () async {
          var response = await http.get(
              Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
              headers: {
                'Range': 'bytes=100-200', // Beyond file size
              });

          expect(response.statusCode, 416); // Range Not Satisfiable
        });
      });

      group('Content-Type header', () {
        test('should set correct content-type for text files', () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(response.statusCode, 200);
          expect(response.headers['content-type'], contains('text/plain'));
        });
      });

      group('HEAD method support', () {
        test('should support HEAD requests with same headers as GET', () async {
          // GET request for comparison
          var getResponse = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );
          expect(getResponse.statusCode, 200);

          // HEAD request
          var headResponse = await client.head(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(headResponse.statusCode, 200);
          expect(headResponse.body, isEmpty); // HEAD should have no body
          expect(headResponse.headers['content-length'],
              getResponse.headers['content-length']);
          expect(headResponse.headers['etag'], getResponse.headers['etag']);
          expect(headResponse.headers['last-modified'],
              getResponse.headers['last-modified']);
        });
      });
    });
  });
}
