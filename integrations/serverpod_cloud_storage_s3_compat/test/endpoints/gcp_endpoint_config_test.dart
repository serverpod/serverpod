import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/gcp_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given a GcpEndpointConfig with default settings', () {
    late GcpEndpointConfig config;

    setUp(() {
      config = GcpEndpointConfig();
    });

    test(
      'when building bucket URI '
      'then it returns path-style URL with bucket in path',
      () {
        final uri = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri.scheme, 'https');
        expect(uri.host, 'storage.googleapis.com');
        expect(uri.path, '/my-bucket');
      },
    );

    test(
      'when building bucket URI with different regions '
      'then it ignores the region parameter',
      () {
        final uri1 = config.buildBucketUri('my-bucket', 'us-east-1');
        final uri2 = config.buildBucketUri('my-bucket', 'eu-west-1');

        expect(uri1.host, uri2.host);
        expect(uri1.path, uri2.path);
      },
    );

    test(
      'when building public URI '
      'then it returns path-style public URL',
      () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'us-east-1',
          'path/to/file.txt',
        );

        expect(
          uri.toString(),
          'https://storage.googleapis.com/my-bucket/path/to/file.txt',
        );
      },
    );

    test(
      'when building public URI with simple file path '
      'then it handles the path correctly',
      () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.path, '/my-bucket/file.txt');
      },
    );

    test(
      'when getting service name '
      'then it returns Google Cloud Storage',
      () {
        expect(config.serviceName, 'Google Cloud Storage');
      },
    );
  });

  group('Given a GcpEndpointConfig with custom public host', () {
    late GcpEndpointConfig config;

    setUp(() {
      config = GcpEndpointConfig(
        publicHost: Uri.https('cdn.example.com', '/storage'),
      );
    });

    test(
      'when building public URI '
      'then it uses the custom public host',
      () {
        final uri = config.buildPublicUri('my-bucket', 'us-east-1', 'file.txt');

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/storage/file.txt');
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
}
