import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/aws_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given an AwsEndpointConfig with default settings', () {
    final config = AwsEndpointConfig();

    group('when building bucket URI', () {
      test(
        'then it returns virtual-hosted style URL with bucket in hostname',
        () {
          final uri = config.buildBucketUri('my-bucket', 'us-east-1');

          expect(uri.scheme, 'https');
          expect(uri.host, 'my-bucket.s3.us-east-1.amazonaws.com');
        },
      );

      test('then it works with different regions', () {
        final uri = config.buildBucketUri('my-bucket', 'eu-west-2');

        expect(uri.host, 'my-bucket.s3.eu-west-2.amazonaws.com');
      });
    });

    group('when building public URI', () {
      test('then it returns the correct public URL for the file', () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'https://my-bucket.s3.us-east-1.amazonaws.com/path/to/file.txt',
        );
      });

      test('then it handles paths without leading slash', () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/file.txt');
      });
    });

    test('when getting service name then it returns AWS S3', () {
      expect(config.serviceName, 'AWS S3');
    });
  });

  group('Given an AwsEndpointConfig with custom public host', () {
    final customHost = Uri.https('cdn.example.com', '/assets');
    final config = AwsEndpointConfig(publicHost: customHost);

    group('when building public URI', () {
      test('then it uses the custom public host', () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/assets/file.txt');
      });

      test('then it correctly joins paths with trailing slashes', () {
        final hostWithSlash = Uri.https('cdn.example.com', '/assets/');
        final configWithSlash = AwsEndpointConfig(publicHost: hostWithSlash);

        final uri = configWithSlash.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'file.txt',
        );

        expect(uri.path, '/assets/file.txt');
      });
    });

    group('when building public URI with override host', () {
      test('then the override takes precedence over configured host', () {
        final overrideHost = Uri.https('override.example.com', '/');

        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'file.txt',
          publicHost: overrideHost,
        );

        expect(uri.host, 'override.example.com');
      });
    });
  });
}
