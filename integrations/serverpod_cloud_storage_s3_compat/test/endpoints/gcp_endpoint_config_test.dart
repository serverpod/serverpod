import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/gcp_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given a GcpEndpointConfig with default settings', () {
    final config = GcpEndpointConfig();

    group('when building bucket URI', () {
      test('then it returns path-style URL with bucket in path', () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'https');
        expect(uri.host, 'storage.googleapis.com');
        expect(uri.path, '/my-bucket');
      });

      test('then it ignores the region parameter', () {
        final uri1 = config.buildBucketUri('my-bucket', 'us-east-1');
        final uri2 = config.buildBucketUri('my-bucket', 'eu-west-1');

        expect(uri1.host, uri2.host);
        expect(uri1.path, uri2.path);
      });
    });

    group('when building public URI', () {
      test('then it returns path-style public URL', () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'https://storage.googleapis.com/my-bucket/path/to/file.txt',
        );
      });

      test('then it handles simple file paths', () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/my-bucket/file.txt');
      });
    });

    test('when getting service name then it returns Google Cloud Storage', () {
      expect(config.serviceName, 'Google Cloud Storage');
    });
  });

  group('Given a GcpEndpointConfig with custom public host', () {
    final customHost = Uri.https('cdn.example.com', '/storage');
    final config = GcpEndpointConfig(publicHost: customHost);

    group('when building public URI', () {
      test('then it uses the custom public host', () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/storage/file.txt');
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
