import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  group('Given an S3Client with custom endpoints', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'AKIAIOSFODNN7EXAMPLE',
        secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
        bucket: 'my-bucket',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        ),
      );
    });

    group('when building signed params for GET request', () {
      late SignedRequestParams params;

      setUp(() {
        params = client.buildSignedParams(key: 'test/file.txt');
      });

      test('then the URI has the correct scheme', () {
        expect(params.uri.scheme, 'https');
      });

      test('then the URI has the correct host', () {
        expect(params.uri.host, 's3.us-east-1.amazonaws.com');
      });

      test('then the URI has the correct path', () {
        expect(params.uri.path, '/my-bucket/test/file.txt');
      });

      test('then the headers contain Authorization', () {
        expect(params.headers, contains('Authorization'));
        expect(params.headers['Authorization'], startsWith('AWS4-HMAC-SHA256'));
      });

      test('then the headers contain x-amz-date', () {
        expect(params.headers, contains('x-amz-date'));
        expect(
          params.headers['x-amz-date'],
          matches(RegExp(r'^\d{8}T\d{6}Z$')),
        );
      });

      test('then the headers contain x-amz-content-sha256', () {
        expect(params.headers, contains('x-amz-content-sha256'));
      });
    });

    test(
      'when building signed params for HEAD request '
      'then it generates valid params',
      () {
        final params = client.buildSignedParams(
          key: 'test.txt',
          method: 'HEAD',
        );

        expect(params.uri.path, '/my-bucket/test.txt');
        expect(params.headers['Authorization'], contains('AWS4-HMAC-SHA256'));
      },
    );

    test(
      'when building signed params for DELETE request '
      'then it generates valid params',
      () {
        final params = client.buildSignedParams(
          key: 'delete-me.txt',
          method: 'DELETE',
        );

        expect(params.uri.path, '/my-bucket/delete-me.txt');
        expect(params.headers['Authorization'], contains('AWS4-HMAC-SHA256'));
      },
    );

    test(
      'when building signed params with query parameters '
      'then the URI includes the query parameters',
      () {
        final params = client.buildSignedParams(
          key: 'test.txt',
          queryParams: {'list-type': '2', 'prefix': 'uploads/'},
        );

        expect(params.uri.queryParameters, containsPair('list-type', '2'));
        expect(params.uri.queryParameters, containsPair('prefix', 'uploads/'));
      },
    );
  });

  group('Given an S3Client with HTTP custom endpoints', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'testAccessKey',
        secretKey: 'testSecretKey',
        bucket: 'test-bucket',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.http('localhost:4566', '/'),
        ),
      );
    });

    test(
      'when building signed params '
      'then the URI has the custom host and port',
      () {
        final params = client.buildSignedParams(key: 'test.txt');

        expect(params.uri.scheme, 'http');
        expect(params.uri.host, 'localhost');
        expect(params.uri.port, 4566);
      },
    );
  });

  group('Given an S3Client', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'test',
        secretKey: 'test',
        bucket: 'bucket',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        ),
      );
    });

    test(
      'when checking a 200 response for errors '
      'then it does not throw',
      () {
        final response = http.Response('OK', 200);

        expect(() => client.checkResponseError(response), returnsNormally);
      },
    );

    test(
      'when checking a 204 response for errors '
      'then it does not throw',
      () {
        final response = http.Response('', 204);

        expect(() => client.checkResponseError(response), returnsNormally);
      },
    );

    test(
      'when checking a 403 response for errors '
      'then it throws NoPermissionsException',
      () {
        final response = http.Response('Forbidden', 403);

        expect(
          () => client.checkResponseError(response),
          throwsA(isA<NoPermissionsException>()),
        );
      },
    );

    test(
      'when checking a 404 response for errors '
      'then it throws S3Exception',
      () {
        final response = http.Response('Not Found', 404);

        expect(
          () => client.checkResponseError(response),
          throwsA(isA<S3Exception>()),
        );
      },
    );

    test(
      'when checking a 500 response for errors '
      'then it throws S3Exception',
      () {
        final response = http.Response('Internal Server Error', 500);

        expect(
          () => client.checkResponseError(response),
          throwsA(isA<S3Exception>()),
        );
      },
    );
  });
}
