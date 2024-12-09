import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:relic/relic.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'test_util.dart';

void main() {
  setUp(() async {
    await d.file('file.txt', 'contents').create();
    await d.file('random.unknown', 'no clue').create();
  });

  test('Given a file when served then it returns the file contents', () async {
    final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
    final response = await makeRequest(handler, '/file.txt');
    expect(response.statusCode, equals(HttpStatus.ok));
    expect(response.body.contentLength, equals(8));
    expect(response.readAsString(), completion(equals('contents')));
  });

  test('Given a non-matching URL when served then it returns a 404', () async {
    final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
    final response = await makeRequest(handler, '/foo/file.txt');
    expect(response.statusCode, equals(HttpStatus.notFound));
  });

  test(
      'Given a file under a custom URL when served then it returns the file contents',
      () async {
    final handler =
        createFileHandler(p.join(d.sandbox, 'file.txt'), url: 'foo/bar');
    final response = await makeRequest(handler, '/foo/bar');
    expect(response.statusCode, equals(HttpStatus.ok));
    expect(response.body.contentLength, equals(8));
    expect(response.readAsString(), completion(equals('contents')));
  });

  test(
      "Given a custom URL that isn't matched when served then it returns a 404",
      () async {
    final handler =
        createFileHandler(p.join(d.sandbox, 'file.txt'), url: 'foo/bar');
    final response = await makeRequest(handler, '/file.txt');
    expect(response.statusCode, equals(HttpStatus.notFound));
  });

  group('Given the content type header', () {
    test('when inferred from the file path then it is set correctly', () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(handler, '/file.txt');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.mimeType?.primaryType, equals('text'));
      expect(response.mimeType?.subType, equals('plain'));
    });

    test("when it can't be inferred then it is omitted", () async {
      final handler = createFileHandler(p.join(d.sandbox, 'random.unknown'));
      final response = await makeRequest(handler, '/random.unknown');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.mimeType, isNull);
    });

    test('when provided by the contentType parameter then it is used',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'),
          contentType: MimeType.parse('something/weird'));
      final response = await makeRequest(handler, '/file.txt');
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.mimeType?.primaryType, equals('something'));
      expect(response.mimeType?.subType, equals('weird'));
    });
  });

  group('Given the content range header', () {
    test('when bytes from 0 to 4 are requested then it returns partial content',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(
        handler,
        '/file.txt',
        headers: Headers.request(
          range: RangeHeader.parse('bytes=0-4'),
        ),
      );
      expect(response.statusCode, equals(HttpStatus.partialContent));
      expect(
        response.headers.acceptRanges?.isBytes,
        isTrue,
      );
      expect(response.headers.contentRange?.start, 0);
      expect(response.headers.contentRange?.end, 4);
      expect(response.headers.contentRange?.size, 8);
    });

    test(
        'when range at the end overflows from 0 to 9 then it returns partial content',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(
        handler,
        '/file.txt',
        headers: Headers.request(
          range: RangeHeader.parse('bytes=0-9'),
        ),
      );
      expect(
        response.statusCode,
        equals(HttpStatus.partialContent),
      );
      expect(
        response.headers.acceptRanges?.isBytes,
        isTrue,
      );

      expect(response.headers.contentRange?.start, 0);
      expect(response.headers.contentRange?.end, 7);
      expect(response.headers.contentRange?.size, 8);

      expect(response.body.contentLength, 8);
    });

    test(
        'when range at the start overflows from 8 to 9 then it returns requested range not satisfiable',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(
        handler,
        '/file.txt',
        headers: Headers.request(
          range: RangeHeader.parse('bytes=8-9'),
        ),
      );

      expect(
        response.body.contentLength,
        0,
      );

      expect(
        response.headers.acceptRanges?.isBytes,
        isTrue,
      );
      expect(
        response.statusCode,
        HttpStatus.requestedRangeNotSatisfiable,
      );
    });

    test(
        'when invalid request with start > end is ignored then it returns the full content',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(
        handler,
        '/file.txt',
        headers: Headers.request(
          range: RangeHeader.parse('bytes=2-1'),
        ),
      );
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body.contentLength, equals(8));
      expect(response.readAsString(), completion(equals('contents')));
    });

    test(
        'when request with start > end is ignored then it returns the full content',
        () async {
      final handler = createFileHandler(p.join(d.sandbox, 'file.txt'));
      final response = await makeRequest(
        handler,
        '/file.txt',
        headers: Headers.request(
          range: RangeHeader.parse('bytes=2-1'),
        ),
      );
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body.contentLength, equals(8));
      expect(response.readAsString(), completion(equals('contents')));
    });
  });

  group('Given an ArgumentError is thrown for', () {
    test("when a file doesn't exist then it throws an ArgumentError", () {
      expect(
        () => createFileHandler(p.join(d.sandbox, 'nothing.txt')),
        throwsArgumentError,
      );
    });

    test('when an absolute URL is provided then it throws an ArgumentError',
        () {
      expect(
        () => createFileHandler(p.join(d.sandbox, 'nothing.txt'),
            url: '/foo/bar'),
        throwsArgumentError,
      );
    });
  });
}
