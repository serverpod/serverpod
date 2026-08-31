import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a binary upload description', () {
    test(
      'when optional values are omitted then it encodes the minimum payload',
      () {
        final description = BinaryUploadDescription(
          url: Uri.parse('https://storage.example.com/upload'),
        );

        expect(jsonDecode(description.encode()), {
          'url': 'https://storage.example.com/upload',
          'type': 'binary',
          'headers': {},
        });
      },
    );

    test('when optional values are provided then it encodes all values', () {
      final description = BinaryUploadDescription(
        url: Uri.parse('https://storage.example.com/upload'),
        fileName: 'example.txt',
        method: 'PUT',
        headers: const {'Content-Type': 'text/plain'},
      );

      expect(jsonDecode(description.encode()), {
        'url': 'https://storage.example.com/upload',
        'type': 'binary',
        'file-name': 'example.txt',
        'method': 'PUT',
        'headers': {'Content-Type': 'text/plain'},
      });
    });
  });

  test(
    'Given a multipart upload description then it encodes all required fields',
    () {
      final description = MultipartUploadDescription(
        url: Uri.parse('https://storage.example.com/upload'),
        field: 'file',
        fileName: 'example.txt',
        requestFields: const {'policy': 'signed-policy'},
      );

      expect(jsonDecode(description.encode()), {
        'url': 'https://storage.example.com/upload',
        'type': 'multipart',
        'field': 'file',
        'file-name': 'example.txt',
        'request-fields': {'policy': 'signed-policy'},
      });
    },
  );

  test(
    'Given a multipart upload description without request fields '
    'then it encodes an empty request fields map',
    () {
      final description = MultipartUploadDescription(
        url: Uri.parse('https://storage.example.com/upload'),
        field: 'file',
        fileName: 'example.txt',
      );

      expect(jsonDecode(description.encode()), {
        'url': 'https://storage.example.com/upload',
        'type': 'multipart',
        'field': 'file',
        'file-name': 'example.txt',
        'request-fields': <String, String>{},
      });
    },
  );
}
