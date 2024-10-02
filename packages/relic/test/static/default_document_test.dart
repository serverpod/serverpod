import 'dart:io';

import 'package:relic/src/static/static_handler.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

void main() {
  setUp(() async {
    await d.file('index.html', '<html></html>').create();
    await d.file('root.txt', 'root txt').create();
    await d.dir('files', [
      d.file('index.html', '<html><body>files</body></html>'),
      d.file('with space.txt', 'with space content')
    ]).create();
  });

  group('default document value', () {
    test('cannot contain slashes', () {
      final invalidValues = [
        'file/foo.txt',
        '/bar.txt',
        '//bar.txt',
        '//news/bar.txt',
        'foo/../bar.txt'
      ];

      for (var val in invalidValues) {
        expect(() => createStaticHandler(d.sandbox, defaultDocument: val),
            throwsArgumentError);
      }
    });
  });

  group('no default document specified', () {
    test('access "/index.html"', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
    });

    test('access "/"', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('access "/files"', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/files');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('access "/files/" dir', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/files/');
      expect(response.statusCode, HttpStatus.notFound);
    });
  });

  group('default document specified', () {
    test('access "/index.html"', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
      expect(response.mimeType, 'text/html');
    });

    test('access "/"', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
      expect(response.mimeType, 'text/html');
    });

    test('access "/files"', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/files');
      expect(response.statusCode, HttpStatus.movedPermanently);
      expect(
        response.headers.location,
        Uri.parse('http://localhost/files/'),
      );
    });

    test('access "/files/" dir', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/files/');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 31);
      expect(response.readAsString(),
          completion('<html><body>files</body></html>'));
      expect(response.mimeType, 'text/html');
    });
  });
}
