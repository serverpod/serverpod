import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  group('Given an S3Exception', () {
    final response = http.Response(
      '<?xml version="1.0" encoding="UTF-8"?><Error><Code>NoSuchKey</Code></Error>',
      404,
      headers: {'x-amz-request-id': 'test-request-id'},
    );
    final exception = S3Exception(response);

    test('then it contains the response', () {
      expect(exception.response, response);
    });

    test('then toString includes status code', () {
      expect(exception.toString(), contains('404'));
    });

    test('then toString includes body', () {
      expect(exception.toString(), contains('NoSuchKey'));
    });

    test('then toString includes debug hint', () {
      expect(
        exception.toString(),
        contains('We got an unexpected response from S3'),
      );
    });
  });

  group('Given a NoPermissionsException', () {
    final response = http.Response('Access Denied', 403);
    final exception = NoPermissionsException(response);

    test('then it is an S3Exception', () {
      expect(exception, isA<S3Exception>());
    });

    test('then toString includes 403 hint', () {
      expect(
        exception.toString(),
        contains('S3 returned a 403 status code'),
      );
    });

    test('then toString mentions permissions', () {
      expect(
        exception.toString(),
        contains('right permissions'),
      );
    });
  });
}
