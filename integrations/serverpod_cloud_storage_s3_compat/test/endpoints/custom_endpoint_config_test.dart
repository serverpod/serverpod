import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/custom_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CustomEndpointConfig with HTTP base URI', () {
    final config = CustomEndpointConfig(
      baseUri: Uri.http('localhost:9000', '/'),
      serviceName: 'MinIO',
    );

    group('when building bucket URI', () {
      test('then it appends bucket to the base path', () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'http');
        expect(uri.host, 'localhost');
        expect(uri.port, 9000);
        expect(uri.path, '/my-bucket');
      });

      test('then it ignores the region parameter', () {
        final uri1 = config.buildBucketUri('my-bucket', 'us-east-1');
        final uri2 = config.buildBucketUri('my-bucket', 'eu-west-1');

        expect(uri1, uri2);
      });
    });

    group('when building public URI', () {
      test('then it builds path-style URL with bucket and file path', () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'http://localhost:9000/my-bucket/path/to/file.txt',
        );
      });
    });

    test('when getting service name then it returns the configured name', () {
      expect(config.serviceName, 'MinIO');
    });
  });

  group('Given a CustomEndpointConfig with HTTPS base URI and path prefix', () {
    final config = CustomEndpointConfig(
      baseUri: Uri.https('s3.example.com', '/v1/storage'),
      serviceName: 'Custom S3',
    );

    group('when building bucket URI', () {
      test('then it correctly joins the base path with bucket', () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'https');
        expect(uri.path, '/v1/storage/my-bucket');
      });
    });

    group('when building public URI', () {
      test('then it correctly joins all path components', () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/v1/storage/my-bucket/file.txt');
      });
    });
  });

  group('Given a CustomEndpointConfig with default service name', () {
    final config = CustomEndpointConfig(
      baseUri: Uri.http('localhost:9000', '/'),
    );

    test('when getting service name then it returns the default', () {
      expect(config.serviceName, 'S3-compatible storage');
    });
  });

  group(
    'Given a CustomEndpointConfig when building public URI with override',
    () {
      final config = CustomEndpointConfig(
        baseUri: Uri.http('localhost:9000', '/'),
      );

      test('then the override host takes precedence', () {
        final overrideHost = Uri.https('cdn.example.com', '/assets');

        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'file.txt',
          publicHost: overrideHost,
        );

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/assets/my-bucket/file.txt');
      });
    },
  );
}
