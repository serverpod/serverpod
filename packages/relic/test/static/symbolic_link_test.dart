import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:relic/src/static/static_handler.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

const _skipSymlinksOnWindows = {
  'windows': Skip('Skip tests for sym-linked files on Windows'),
};

void main() {
  setUp(() async {
    await d.dir('originals', [
      d.file('index.html', '<html></html>'),
    ]).create();

    await d.dir('alt_root').create();

    final originalsDir = p.join(d.sandbox, 'originals');
    final originalsIndex = p.join(originalsDir, 'index.html');

    Link(p.join(d.sandbox, 'link_index.html')).createSync(originalsIndex);

    Link(p.join(d.sandbox, 'link_dir')).createSync(originalsDir);

    Link(p.join(d.sandbox, 'alt_root', 'link_index.html'))
        .createSync(originalsIndex);

    Link(p.join(d.sandbox, 'alt_root', 'link_dir')).createSync(originalsDir);
  });

  group('access outside of root disabled', () {
    test('access real file', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/originals/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
    });

    group('links under root dir', () {
      test(
        'access sym linked file in real dir',
        () async {
          final handler = createStaticHandler(d.sandbox);

          final response = await makeRequest(handler, '/link_index.html');
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body.contentLength, 13);
          expect(response.readAsString(), completion('<html></html>'));
        },
        onPlatform: _skipSymlinksOnWindows,
      );

      test('access file in sym linked dir', () async {
        final handler = createStaticHandler(d.sandbox);

        final response = await makeRequest(handler, '/link_dir/index.html');
        expect(response.statusCode, HttpStatus.ok);
        expect(response.body.contentLength, 13);
        expect(response.readAsString(), completion('<html></html>'));
      });
    });

    group('links not under root dir', () {
      test('access sym linked file in real dir', () async {
        final handler = createStaticHandler(p.join(d.sandbox, 'alt_root'));

        final response = await makeRequest(handler, '/link_index.html');
        expect(response.statusCode, HttpStatus.notFound);
      });

      test('access file in sym linked dir', () async {
        final handler = createStaticHandler(p.join(d.sandbox, 'alt_root'));

        final response = await makeRequest(handler, '/link_dir/index.html');
        expect(response.statusCode, HttpStatus.notFound);
      });
    });
  });

  group('access outside of root enabled', () {
    test('access real file', () async {
      final handler =
          createStaticHandler(d.sandbox, serveFilesOutsidePath: true);

      final response = await makeRequest(handler, '/originals/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
    });

    group('links under root dir', () {
      test(
        'access sym linked file in real dir',
        () async {
          final handler =
              createStaticHandler(d.sandbox, serveFilesOutsidePath: true);

          final response = await makeRequest(handler, '/link_index.html');
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body.contentLength, 13);
          expect(response.readAsString(), completion('<html></html>'));
        },
        onPlatform: _skipSymlinksOnWindows,
      );

      test('access file in sym linked dir', () async {
        final handler =
            createStaticHandler(d.sandbox, serveFilesOutsidePath: true);

        final response = await makeRequest(handler, '/link_dir/index.html');
        expect(response.statusCode, HttpStatus.ok);
        expect(response.body.contentLength, 13);
        expect(response.readAsString(), completion('<html></html>'));
      });
    });

    group('links not under root dir', () {
      test(
        'access sym linked file in real dir',
        () async {
          final handler = createStaticHandler(p.join(d.sandbox, 'alt_root'),
              serveFilesOutsidePath: true);

          final response = await makeRequest(handler, '/link_index.html');
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body.contentLength, 13);
          expect(response.readAsString(), completion('<html></html>'));
        },
        onPlatform: _skipSymlinksOnWindows,
      );

      test('access file in sym linked dir', () async {
        final handler = createStaticHandler(p.join(d.sandbox, 'alt_root'),
            serveFilesOutsidePath: true);

        final response = await makeRequest(handler, '/link_dir/index.html');
        expect(response.statusCode, HttpStatus.ok);
        expect(response.body.contentLength, 13);
        expect(response.readAsString(), completion('<html></html>'));
      });
    });
  });
}
