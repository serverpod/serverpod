import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  group('Given an S3Client with AWS endpoints', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'AKIAIOSFODNN7EXAMPLE',
        secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
        bucket: 'my-bucket',
        region: 'us-east-1',
        endpoints: AwsEndpointConfig(),
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

      test('then the URI has the correct host with bucket', () {
        expect(params.uri.host, 'my-bucket.s3.us-east-1.amazonaws.com');
      });

      test('then the URI has the correct path', () {
        expect(params.uri.path, '/test/file.txt');
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

        expect(params.uri.path, '/test.txt');
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

        expect(params.uri.path, '/delete-me.txt');
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

  group('Given an S3Client with GCP endpoints', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'GOOGTS7C7FUP3AIRVEXAMPLE',
        secretKey: 'bGoa+V7g/yqDXvKRqq+JTFn4uQZbPiEXAMPLEKEY',
        bucket: 'my-gcp-bucket',
        region: 'auto',
        endpoints: GcpEndpointConfig(),
      );
    });

    test(
      'when building signed params '
      'then the URI has the GCP host',
      () {
        final params = client.buildSignedParams(key: 'file.txt');

        expect(params.uri.host, 'storage.googleapis.com');
      },
    );

    test(
      'when building signed params '
      'then the URI path includes the bucket and file',
      () {
        final params = client.buildSignedParams(key: 'path/to/file.txt');

        expect(params.uri.path, '/my-gcp-bucket/path/to/file.txt');
      },
    );
  });

  group('Given an S3Client with custom endpoints', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'minioadmin',
        secretKey: 'minioadmin',
        bucket: 'test-bucket',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.http('localhost:9000', '/'),
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
        expect(params.uri.port, 9000);
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
        endpoints: AwsEndpointConfig(),
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
