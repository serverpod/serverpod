import 'dart:convert';
import 'dart:io';

import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as p;
import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

void main() {
  setUp(() async {
    await d.file('index.html', '<html></html>').create();
    await d.file('root.txt', 'root txt').create();
    await d.file('random.unknown', 'no clue').create();

    const pngBytesContent =
        r'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAABmJLR0QA/wD/AP+gvae'
        r'TAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4AYRETkSXaxBzQAAAB1pVFh0Q2'
        r'9tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAAbUlEQVQI1wXBvwpBYRwA0'
        r'HO/kjBKJmXRLWXxJ4PsnsMTeAEPILvNZrybF7B4A6XvQW6k+DkHwqgM1TnMpoEoDMtw'
        r'OJE7pB/VXmF3CdseucmjxaAruR41Pl9p/Gbyoq5B9FeL2OR7zJ+3aC/X8QdQCyIArPs'
        r'HkQAAAABJRU5ErkJggg==';

    const webpBytesContent =
        r'UklGRiQAAABXRUJQVlA4IBgAAAAwAQCdASoBAAEAAQAcJaQAA3AA/v3AgAA=';

    await d.dir('files', [
      d.file('test.txt', 'test txt content'),
      d.file('with space.txt', 'with space content'),
      d.file('header_bytes_test_image', base64Decode(pngBytesContent)),
      d.file('header_bytes_test_webp', base64Decode(webpBytesContent))
    ]).create();
  });

  test('Given a root file when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/root.txt');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 8);
    expect(response.readAsString(), completion('root txt'));
  });

  test(
      'Given a HEAD request when made then it returns the correct headers without body',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response =
        await makeRequest(handler, '/root.txt', method: RequestMethod.head);
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 0);
    expect(await response.readAsString(), isEmpty);
  });

  test(
      'Given a root file with space when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/files/with%20space.txt');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 18);
    expect(response.readAsString(), completion('with space content'));
  });

  test(
      'Given a root file with unencoded space when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/files/with%20space.txt');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 18);
    expect(response.readAsString(), completion('with space content'));
  });

  test(
      'Given a file under directory when accessed then it returns the file content',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/files/test.txt');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body.contentLength, 16);
    expect(response.readAsString(), completion('test txt content'));
  });

  test('Given a non-existent file when accessed then it returns a 404 status',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final response = await makeRequest(handler, '/not_here.txt');
    expect(response.statusCode, HttpStatus.notFound);
  });

  test(
      'Given a file when accessed then it returns the correct last modified date',
      () async {
    final handler = createStaticHandler(d.sandbox);

    final rootPath = p.join(d.sandbox, 'root.txt');
    final modified = File(rootPath).statSync().modified.toUtc();

    final response = await makeRequest(handler, '/root.txt');
    expect(
      response.headers.lastModified,
      atSameTimeToSecond(modified),
    );
  });

  group('Given if modified since', () {
    test('when it is the same as last modified then it returns not modified',
        () async {
      final handler = createStaticHandler(d.sandbox);

      final rootPath = p.join(d.sandbox, 'root.txt');
      final modified = File(rootPath).statSync().modified.toUtc();

      final headers = Headers.request(
        ifModifiedSince: modified,
      );

      final response =
          await makeRequest(handler, '/root.txt', headers: headers);
      expect(response.statusCode, HttpStatus.notModified);
      expect(response.body.contentLength, 0);
    });

    test('when it is before last modified then it returns the file', () async {
      final handler = createStaticHandler(d.sandbox);

      final rootPath = p.join(d.sandbox, 'root.txt');
      final modified = File(rootPath).statSync().modified.toUtc();

      final headers = Headers.request(
        ifModifiedSince: modified.subtract(const Duration(seconds: 1)),
      );

      final response = await makeRequest(
        handler,
        '/root.txt',
        headers: headers,
      );
      expect(response.statusCode, HttpStatus.ok);
      expect(
        response.headers.lastModified,
        atSameTimeToSecond(modified),
      );
    });

    test('when it is after last modified then it returns not modified',
        () async {
      final handler = createStaticHandler(d.sandbox);

      final rootPath = p.join(d.sandbox, 'root.txt');
      final modified = File(rootPath).statSync().modified.toUtc();

      final headers = Headers.request(
        ifModifiedSince: modified,
      );

      final response = await makeRequest(
        handler,
        '/root.txt',
        headers: headers,
      );

      expect(response.statusCode, HttpStatus.notModified);
      expect(response.body.contentLength, 0);
    });

    test(
        'when file is modified after the request then it returns the updated file',
        () async {
      final handler = createStaticHandler(d.sandbox);
      final rootPath = p.join(d.sandbox, 'root.txt');

      final response1 = await makeRequest(handler, '/root.txt');
      final originalModificationDate = response1.headers.lastModified!;

      await Future<void>.delayed(const Duration(seconds: 2));
      File(rootPath).writeAsStringSync('updated root txt');

      final headers = Headers.request(
        ifModifiedSince: originalModificationDate,
      );

      final response2 = await makeRequest(
        handler,
        '/root.txt',
        headers: headers,
      );
      expect(response2.statusCode, HttpStatus.ok);
      expect(
        response2.headers.lastModified!.millisecondsSinceEpoch,
        greaterThan(originalModificationDate.millisecondsSinceEpoch),
      );
    });
  });

  group('Given content type', () {
    test('when accessing root.txt then it should be text/plain', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/root.txt');
      expect(response.mimeType?.primaryType, 'text');
      expect(response.mimeType?.subType, 'plain');
    });

    test('when accessing index.html then it should be text/html', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/index.html');
      expect(response.mimeType?.primaryType, 'text');
      expect(response.mimeType?.subType, 'html');
    });

    test('when accessing random.unknown then it should be null', () async {
      final handler = createStaticHandler(d.sandbox);

      final response = await makeRequest(handler, '/random.unknown');
      expect(response.mimeType, isNull);
    });

    test('when accessing header_bytes_test_image then it should be image/png',
        () async {
      final handler =
          createStaticHandler(d.sandbox, useHeaderBytesForContentType: true);

      final response =
          await makeRequest(handler, '/files/header_bytes_test_image');
      expect(response.mimeType?.primaryType, 'image');
      expect(response.mimeType?.subType, 'png');
    });

    test('when accessing header_bytes_test_webp then it should be image/webp',
        () async {
      final resolver = mime.MimeTypeResolver()
        ..addMagicNumber(
          <int>[
            0x52, 0x49, 0x46, 0x46, 0x00, 0x00, //
            0x00, 0x00, 0x57, 0x45, 0x42, 0x50
          ],
          'image/webp',
          mask: <int>[
            0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, //
            0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
          ],
        );
      final handler = createStaticHandler(d.sandbox,
          useHeaderBytesForContentType: true, contentTypeResolver: resolver);

      final response =
          await makeRequest(handler, '/files/header_bytes_test_webp');
      expect(response.mimeType?.primaryType, 'image');
      expect(response.mimeType?.subType, 'webp');
    });
  });
}
