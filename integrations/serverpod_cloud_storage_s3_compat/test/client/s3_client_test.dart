import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
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

  group('Given an S3Client,', () {
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

    test(
      'when a presigned URL expiration exceeds 7 days, '
      'then it throws a CloudStorageException',
      () async {
        await expectLater(
          () => client.buildPresignedUri(
            key: 'file.txt',
            method: 'GET',
            expiration: const Duration(days: 8),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'S3 presigned URLs must expire between 1 second and 7 days.',
            ),
          ),
        );
      },
    );

    test(
      'when a presigned URL expiration is less than one second '
      'then it throws a CloudStorageException',
      () {
        expect(
          () => client.buildPresignedUri(
            key: 'file.txt',
            method: 'GET',
            expiration: const Duration(milliseconds: 500),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'S3 presigned URLs must expire between 1 second and 7 days.',
            ),
          ),
        );
      },
    );

    test(
      'when building a presigned URL with a query value containing a space, '
      'then the emitted query uses the encoding that was signed',
      () {
        const disposition = "attachment; filename*=UTF-8''report.pdf";

        final uri = client.buildPresignedUri(
          key: 'file.txt',
          method: 'GET',
          expiration: const Duration(minutes: 10),
          queryParams: const {'response-content-disposition': disposition},
        );

        expect(
          uri.query,
          contains(
            SigV4.buildCanonicalQueryString(const {
              'response-content-disposition': disposition,
            }),
          ),
        );
      },
    );
  });
}
