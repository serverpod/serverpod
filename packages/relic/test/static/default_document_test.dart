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

  group('Given a default document value', () {
    test('when it contains slashes then it throws an ArgumentError', () {
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

  group('Given no default document specified', () {
    test('when accessing "/index.html" then it returns the file content',
        () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
    });

    test('when accessing "/" then it returns a 404', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('when accessing "/files" then it returns a 404', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/files');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('when accessing "/files/" dir then it returns a 404', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/files/');
      expect(response.statusCode, HttpStatus.notFound);
    });
  });

  group('Given a default document specified', () {
    test('when accessing "/index.html" then it returns the file content',
        () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/index.html');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
      expect(response.mimeType?.primaryType, 'text');
      expect(response.mimeType?.subType, 'html');
    });

    test('when accessing "/" then it returns the default document', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 13);
      expect(response.readAsString(), completion('<html></html>'));
      expect(response.mimeType?.primaryType, 'text');
      expect(response.mimeType?.subType, 'html');
    });

    test('when accessing "/files" then it redirects to "/files/"', () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/files');
      expect(response.statusCode, HttpStatus.movedPermanently);
      expect(
        response.headers.location,
        Uri.parse('http://localhost/files/'),
      );
    });

    test('when accessing "/files/" dir then it returns the default document',
        () async {
      final handler =
          createStaticHandler(d.sandbox, defaultDocument: 'index.html');

      final response = await makeRequest(handler, '/files/');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body.contentLength, 31);
      expect(response.readAsString(),
          completion('<html><body>files</body></html>'));
      expect(response.mimeType?.primaryType, 'text');
      expect(response.mimeType?.subType, 'html');
    });
  });
}
