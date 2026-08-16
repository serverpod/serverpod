import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an S3Exception '
    'when accessing response property '
    'then it contains the original response',
    () {
      final response = http.Response(
        '<?xml version="1.0" encoding="UTF-8"?><Error><Code>NoSuchKey</Code></Error>',
        404,
        headers: {'x-amz-request-id': 'test-request-id'},
      );
      final exception = S3Exception(response);

      expect(exception.response, response);
    },
  );

  test(
    'Given an S3Exception '
    'when calling toString '
    'then it includes the status code',
    () {
      final response = http.Response('error', 404);
      final exception = S3Exception(response);

      expect(exception.toString(), contains('404'));
    },
  );

  test(
    'Given an S3Exception '
    'when calling toString '
    'then it includes the response body',
    () {
      final response = http.Response(
        '<?xml version="1.0" encoding="UTF-8"?><Error><Code>NoSuchKey</Code></Error>',
        404,
      );
      final exception = S3Exception(response);

      expect(exception.toString(), contains('NoSuchKey'));
    },
  );

  test(
    'Given an S3Exception '
    'when calling toString '
    'then it includes a debug hint',
    () {
      final response = http.Response('error', 500);
      final exception = S3Exception(response);

      expect(
        exception.toString(),
        contains('We got an unexpected response from S3'),
      );
    },
  );

  test(
    'Given a NoPermissionsException '
    'when checking its type '
    'then it is an S3Exception',
    () {
      final response = http.Response('Access Denied', 403);
      final exception = NoPermissionsException(response);

      expect(exception, isA<S3Exception>());
    },
  );

  test(
    'Given a NoPermissionsException '
    'when calling toString '
    'then it includes 403 hint',
    () {
      final response = http.Response('Access Denied', 403);
      final exception = NoPermissionsException(response);

      expect(
        exception.toString(),
        contains('S3 returned a 403 status code'),
      );
    },
  );

  test(
    'Given a NoPermissionsException '
    'when calling toString '
    'then it mentions permissions',
    () {
      final response = http.Response('Access Denied', 403);
      final exception = NoPermissionsException(response);

      expect(
        exception.toString(),
        contains('right permissions'),
      );
    },
  );
}
