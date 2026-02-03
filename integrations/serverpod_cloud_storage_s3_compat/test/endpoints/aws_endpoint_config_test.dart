import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/aws_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given an AwsEndpointConfig with default settings', () {
    late AwsEndpointConfig config;

    setUp(() {
      config = AwsEndpointConfig();
    });

    test(
      'when building bucket URI '
      'then it returns virtual-hosted style URL with bucket in hostname',
      () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'https');
        expect(uri.host, 'my-bucket.s3.us-east-1.amazonaws.com');
      },
    );

    test(
      'when building bucket URI with different region '
      'then it uses that region in the hostname',
      () {
        final uri = config.buildBucketUri('my-bucket', 'eu-west-2');

        expect(uri.host, 'my-bucket.s3.eu-west-2.amazonaws.com');
      },
    );

    test(
      'when building public URI '
      'then it returns the correct public URL for the file',
      () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'https://my-bucket.s3.us-east-1.amazonaws.com/path/to/file.txt',
        );
      },
    );

    test(
      'when building public URI with path without leading slash '
      'then it handles the path correctly',
      () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/file.txt');
      },
    );

    test(
      'when getting service name '
      'then it returns AWS S3',
      () {
        expect(config.serviceName, 'AWS S3');
      },
    );
  });

  group('Given an AwsEndpointConfig with custom public host', () {
    late AwsEndpointConfig config;

    setUp(() {
      config = AwsEndpointConfig(
        publicHost: Uri.https('cdn.example.com', '/assets'),
      );
    });

    test(
      'when building public URI '
      'then it uses the custom public host',
      () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/assets/file.txt');
      },
    );

    test(
      'when building public URI with override host '
      'then the override takes precedence',
      () {
        final overrideHost = Uri.https('override.example.com', '/');

        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'file.txt',
          publicHost: overrideHost,
        );

        expect(uri.host, 'override.example.com');
      },
    );
  });

  test(
    'Given an AwsEndpointConfig with custom public host with trailing slash '
    'when building public URI '
    'then it correctly joins paths',
    () {
      final config = AwsEndpointConfig(
        publicHost: Uri.https('cdn.example.com', '/assets/'),
      );

      final uri = config.buildPublicUri(
        'my-bucket',
        'us-east-1',
        'file.txt',
      );

      expect(uri.path, '/assets/file.txt');
    },
  );
}
