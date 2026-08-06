import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  group('Given an S3Client configured for AWS', () {
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

    group('when generating a presigned GET URL', () {
      late Uri url;

      setUp(() {
        url = client.getPresignedUrl(key: 'test/file.txt');
      });

      test('then the URL has the correct scheme', () {
        expect(url.scheme, 'https');
      });

      test('then the URL has the correct host', () {
        expect(url.host, 's3.us-east-1.amazonaws.com');
      });

      test('then the URL has the correct path', () {
        expect(url.path, '/my-bucket/test/file.txt');
      });

      test('then the URL contains X-Amz-Algorithm', () {
        expect(
          url.queryParameters['X-Amz-Algorithm'],
          'AWS4-HMAC-SHA256',
        );
      });

      test('then the URL contains X-Amz-Credential', () {
        final credential = url.queryParameters['X-Amz-Credential']!;
        expect(credential, startsWith('AKIAIOSFODNN7EXAMPLE/'));
        expect(credential, contains('/us-east-1/s3/aws4_request'));
      });

      test('then the URL contains X-Amz-Date', () {
        expect(
          url.queryParameters['X-Amz-Date'],
          matches(RegExp(r'^\d{8}T\d{6}Z$')),
        );
      });

      test('then the URL contains X-Amz-Expires defaulting to 900', () {
        expect(url.queryParameters['X-Amz-Expires'], '900');
      });

      test('then the URL contains X-Amz-SignedHeaders', () {
        expect(url.queryParameters['X-Amz-SignedHeaders'], 'host');
      });

      test('then the URL contains X-Amz-Signature', () {
        expect(url.queryParameters['X-Amz-Signature'], isNotEmpty);
        expect(
          url.queryParameters['X-Amz-Signature'],
          matches(RegExp(r'^[a-f0-9]{64}$')),
        );
      });
    });

    test(
      'when generating a presigned PUT URL '
      'then it produces a valid signed URL',
      () {
        final url = client.getPresignedUrl(
          key: 'uploads/doc.pdf',
          method: 'PUT',
        );

        expect(url.path, '/my-bucket/uploads/doc.pdf');
        expect(url.queryParameters['X-Amz-Algorithm'], 'AWS4-HMAC-SHA256');
        expect(url.queryParameters['X-Amz-Signature'], isNotEmpty);
      },
    );

    test(
      'when generating a presigned URL with custom expiration '
      'then X-Amz-Expires reflects the duration',
      () {
        final url = client.getPresignedUrl(
          key: 'file.txt',
          expiration: const Duration(hours: 1),
        );

        expect(url.queryParameters['X-Amz-Expires'], '3600');
      },
    );
  });

  group('Given an S3Client with HTTP custom endpoints (LocalStack)', () {
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
      'when generating a presigned URL '
      'then the URL uses the custom host and port',
      () {
        final url = client.getPresignedUrl(key: 'local-file.txt');

        expect(url.scheme, 'http');
        expect(url.host, 'localhost');
        expect(url.port, 4566);
        expect(url.path, '/test-bucket/local-file.txt');
        expect(url.queryParameters['X-Amz-Algorithm'], 'AWS4-HMAC-SHA256');
      },
    );
  });

  group('Given an S3Client', () {
    late S3Client client;

    setUp(() {
      client = S3Client(
        accessKey: 'key',
        secretKey: 'secret',
        bucket: 'bucket',
        region: 'eu-west-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.https('s3.eu-west-1.amazonaws.com', '/'),
        ),
      );
    });

    test(
      'when generating a presigned URL for a key with special characters '
      'then the path segments are encoded',
      () {
        final url = client.getPresignedUrl(key: 'path/file name.txt');

        // Uri constructor percent-encodes the space in the path
        expect(url.path, '/bucket/path/file%20name.txt');
        expect(url.queryParameters['X-Amz-Signature'], isNotEmpty);
      },
    );

    test(
      'when generating two presigned URLs for the same key '
      'then they produce consistent signatures '
      '(same within the same second)',
      () {
        final url1 = client.getPresignedUrl(key: 'file.txt');
        final url2 = client.getPresignedUrl(key: 'file.txt');

        // Both should have the same date and therefore the same signature
        // (assuming they run within the same second).
        expect(
          url1.queryParameters['X-Amz-Signature'],
          url2.queryParameters['X-Amz-Signature'],
        );
      },
    );
  });
}
