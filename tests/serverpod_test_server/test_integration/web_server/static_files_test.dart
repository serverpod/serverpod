import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  var directory = Directory(
    path.join(Directory.current.path, 'web', 'server_root_directory'),
  );
  var nestedDirectory = Directory(path.join(directory.path, 'nested_dir'));

  late http.Client client;
  setUpAll(() async {
    client = http.Client();

    await directory.create(recursive: true);
    await nestedDirectory.create(recursive: true);
    await File(
      path.join(directory.path, 'file1.txt'),
    ).writeAsString('contents');
    await File(
      path.join(directory.path, 'file2.test'),
    ).writeAsString('contents');
    await File(
      path.join(nestedDirectory.path, 'file3.txt'),
    ).writeAsString('nested contents');
  });

  tearDownAll(() async {
    await directory.delete(recursive: true);
  });

  group('Given a web server with a static directory', () {
    late Serverpod pod;

    setUp(() async {
      pod = IntegrationTestServer.create();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    group('and a path cache pattern having a max age of 1 second', () {
      setUp(() async {
        pod.webServer.addRoute(
          StaticRoute.directory(
            directory,
            cacheControlFactory: (ctx, fileInfo) =>
                RegExp(r'.*\.txt').hasMatch(ctx.remainingPath.path)
                ? CacheControlHeader(maxAge: 1)
                : null,
          ),
          '/url_prefix/**',
        );
        // Server should start after adding the route otherwise web server
        // will not be started.
        await pod.start();
      });

      test('when requesting a static file with the same path pattern '
          'then the cache-control header is set to max-age=1', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test('when requesting a static file with a different path pattern '
          'then the cache-control header is set to default max age', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file2.test',
          ),
        );

        expect(response.headers['cache-control'], null);
      });
    });

    group('and a path cache string having a max age of 1 second', () {
      setUp(() async {
        pod.webServer.addRoute(
          StaticRoute.directory(
            directory,
            cacheControlFactory: (ctx, fileInfo) =>
                RegExp(r'.*\.txt').hasMatch(ctx.remainingPath.path)
                ? CacheControlHeader(maxAge: 1)
                : null,
          ),
          '/url_prefix/**',
        );
        // Server should start after adding the route otherwise web server
        // will not be started.
        await pod.start();
      });

      test('when requesting a static file with the same path string '
          'then the cache-control header is set to max-age=1', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file1.txt',
          ),
        );

        expect(response.headers['cache-control'], 'max-age=1');
      });

      test('when requesting a static file with a different path string '
          'then the cache-control header is set to default max age', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/file2.test',
          ),
        );

        expect(response.headers['cache-control'], isNull);
      });
    });

    group('and cache busting config with ___ separator', () {
      late String file1AssetPath;

      setUp(() async {
        var cacheBustingConfig = CacheBustingConfig(
          mountPrefix: '/url_prefix',
          fileSystemRoot: directory,
          separator: '___',
        );
        pod.webServer.addRoute(
          StaticRoute.directory(
            directory,
            cacheBustingConfig: cacheBustingConfig,
          ),
          '/url_prefix/**',
        );
        await pod.start();

        file1AssetPath = await cacheBustingConfig.assetPath(
          '/url_prefix/file1.txt',
        );
      });

      test('then asset path contains ___', () {
        expect(file1AssetPath, contains('___'));
      });

      test('when requesting a static file with '
          'then the file is served correctly', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/$file1AssetPath',
          ),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'contents');
      });
    });

    group('when a nested static file is requested', () {
      setUp(() async {
        pod.webServer.addRoute(
          StaticRoute.directory(directory),
          '/url_prefix/**',
        );
        await pod.start();
      });

      test('then the file is served correctly', () async {
        var response = await client.get(
          Uri.parse(
            'http://localhost:8082/url_prefix/nested_dir/file3.txt',
          ),
        );

        expect(response.statusCode, 200);
        expect(response.body, 'nested contents');
        expect(response.headers['cache-control'], isNull);
      });
    });

    group('when a request is made with specific headers', () {
      setUp(() async {
        pod.webServer.addRoute(
          StaticRoute.directory(directory),
          '/url_prefix/**',
        );
        await pod.start();
      });

      group('and an If-None-Match header', () {
        test('then ETag header is returned with initial request', () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(response.statusCode, 200);
          expect(response.headers['etag'], isNotNull);
          expect(response.body, 'contents');
        });

        test(
          'then 304 Not Modified is returned when If-None-Match matches ETag',
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
          },
        );
      });

      group('and an If-Modified-Since header', () {
        test(
          'then Last-Modified header is returned with initial request',
          () async {
            var response = await client.get(
              Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            );

            expect(response.statusCode, 200);
            expect(response.headers['last-modified'], isNotNull);
            expect(response.body, 'contents');
          },
        );

        test(
          'then 304 Not Modified is returned when If-Modified-Since is after last modification',
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
                'If-Modified-Since': lastModified,
              },
            );

            expect(response.statusCode, 304);
            expect(response.body, isEmpty);
          },
        );
      });

      group('and a Range header for partial content', () {
        test('then byte range requests are supported', () async {
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

        test('then range request for end of file is supported', () async {
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

        test('then 416 is returned for invalid range', () async {
          var response = await http.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
            headers: {
              'Range': 'bytes=100-200', // Beyond file size
            },
          );

          expect(response.statusCode, 416); // Range Not Satisfiable
        });
      });

      group('and Content-Type header validation', () {
        test('then correct content-type is set for text files', () async {
          var response = await client.get(
            Uri.parse('http://localhost:8082/url_prefix/file1.txt'),
          );

          expect(response.statusCode, 200);
          expect(response.headers['content-type'], contains('text/plain'));
        });
      });

      group('and HEAD method is used', () {
        test(
          'then HEAD requests are supported with same headers as GET',
          () async {
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
            expect(
              headResponse.headers['content-length'],
              getResponse.headers['content-length'],
            );
            expect(headResponse.headers['etag'], getResponse.headers['etag']);
            expect(
              headResponse.headers['last-modified'],
              getResponse.headers['last-modified'],
            );
          },
        );
      });
    });
  });
}
