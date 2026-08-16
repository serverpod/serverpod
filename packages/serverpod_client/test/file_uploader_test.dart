import 'dart:convert';

import 'package:serverpod_client/src/file_uploader.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a multipart upload description '
    'when constructing FileUploader '
    'then it parses without error',
    () {
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
    },
  );

  test(
    'Given a binary POST upload description '
    'when constructing FileUploader '
    'then it parses without error',
    () {
      final description = jsonEncode({
        'url': 'https://example.com/upload',
        'type': 'binary',
      });

      expect(() => FileUploader(description), returnsNormally);
    },
  );

  test(
    'Given a binary PUT upload description '
    'when constructing FileUploader '
    'then it parses without error',
    () {
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
    },
  );

  test(
    'Given an invalid description with non-JSON input '
    'when constructing FileUploader '
    'then it throws FormatException',
    () {
      expect(
        () => FileUploader('not json'),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test(
    'Given an invalid description with missing type '
    'when constructing FileUploader '
    'then it throws FormatException',
    () {
      final description = jsonEncode({
        'url': 'https://example.com',
      });

      expect(
        () => FileUploader(description),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test(
    'Given an invalid description with unknown type '
    'when constructing FileUploader '
    'then it throws FormatException',
    () {
      final description = jsonEncode({
        'url': 'https://example.com',
        'type': 'unknown',
      });

      expect(
        () => FileUploader(description),
        throwsA(isA<FormatException>()),
      );
    },
  );
}
