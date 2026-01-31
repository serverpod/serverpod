import 'dart:convert';

import 'package:serverpod_client/src/file_uploader.dart';
import 'package:test/test.dart';

void main() {
  group('Given a multipart upload description', () {
    test('when constructing FileUploader then it parses without error', () {
      final description = jsonEncode({
        'url': 'https://bucket.s3.amazonaws.com/',
        'type': 'multipart',
        'field': 'file',
        'file-name': 'test.txt',
        'request-fields': {
          'key': 'uploads/test.txt',
          'Policy': 'base64policy',
          'X-Amz-Signature': 'signature',
        },
      });

      expect(() => FileUploader(description), returnsNormally);
    });
  });

  group('Given a binary POST upload description', () {
    test('when constructing FileUploader then it parses without error', () {
      final description = jsonEncode({
        'url': 'https://example.com/upload',
        'type': 'binary',
      });

      expect(() => FileUploader(description), returnsNormally);
    });
  });

  group('Given a binary PUT upload description', () {
    test('when constructing FileUploader then it parses without error', () {
      final description = jsonEncode({
        'url':
            'https://bucket.r2.cloudflarestorage.com/path?X-Amz-Signature=abc',
        'type': 'binary',
        'method': 'PUT',
        'file-name': 'test.txt',
        'headers': {
          'Content-Type': 'text/plain',
        },
      });

      expect(() => FileUploader(description), returnsNormally);
    });
  });

  group('Given an invalid description', () {
    test('when input is non-JSON then it throws FormatException', () {
      expect(
        () => FileUploader('not json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('when type is missing then it throws FormatException', () {
      final description = jsonEncode({
        'url': 'https://example.com',
      });
      expect(
        () => FileUploader(description),
        throwsA(isA<FormatException>()),
      );
    });

    test('when type is invalid then it throws FormatException', () {
      final description = jsonEncode({
        'url': 'https://example.com',
        'type': 'unknown',
      });
      expect(
        () => FileUploader(description),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
