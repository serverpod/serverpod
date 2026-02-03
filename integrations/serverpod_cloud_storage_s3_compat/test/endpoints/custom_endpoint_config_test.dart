import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/custom_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CustomEndpointConfig with HTTP base URI', () {
    late CustomEndpointConfig config;

    setUp(() {
      config = CustomEndpointConfig(
        baseUri: Uri.http('localhost:9000', '/'),
        serviceName: 'MinIO',
      );
    });

    test(
      'when building bucket URI '
      'then it appends bucket to the base path',
      () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'http');
        expect(uri.host, 'localhost');
        expect(uri.port, 9000);
        expect(uri.path, '/my-bucket');
      },
    );

    test(
      'when building bucket URI with different regions '
      'then it ignores the region parameter',
      () {
        final uri1 = config.buildBucketUri('my-bucket', 'us-east-1');
        final uri2 = config.buildBucketUri('my-bucket', 'eu-west-1');

        expect(uri1, uri2);
      },
    );

    test(
      'when building public URI '
      'then it builds path-style URL with bucket and file path',
      () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'http://localhost:9000/my-bucket/path/to/file.txt',
        );
      },
    );

    test(
      'when getting service name '
      'then it returns the configured name',
      () {
        expect(config.serviceName, 'MinIO');
      },
    );

    test(
      'when building public URI with override host '
      'then the override host takes precedence',
      () {
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
      },
    );
  });

  group('Given a CustomEndpointConfig with HTTPS base URI and path prefix', () {
    late CustomEndpointConfig config;

    setUp(() {
      config = CustomEndpointConfig(
        baseUri: Uri.https('s3.example.com', '/v1/storage'),
        serviceName: 'Custom S3',
      );
    });

    test(
      'when building bucket URI '
      'then it correctly joins the base path with bucket',
      () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'https');
        expect(uri.path, '/v1/storage/my-bucket');
      },
    );

    test(
      'when building public URI '
      'then it correctly joins all path components',
      () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/v1/storage/my-bucket/file.txt');
      },
    );
  });

  test(
    'Given a CustomEndpointConfig with default service name '
    'when getting service name '
    'then it returns the default',
    () {
      final config = CustomEndpointConfig(
        baseUri: Uri.http('localhost:9000', '/'),
      );

      expect(config.serviceName, 'S3-compatible storage');
    },
  );
}
