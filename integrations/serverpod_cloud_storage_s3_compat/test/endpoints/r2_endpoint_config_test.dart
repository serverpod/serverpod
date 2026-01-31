import 'package:serverpod_cloud_storage_s3_compat/src/endpoints/r2_endpoint_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given an R2EndpointConfig with default settings', () {
    final config = R2EndpointConfig(accountId: 'abc123def456');

    group('when building bucket URI', () {
      test('then it returns the R2 API endpoint with bucket in path', () {
        final uri = config.buildBucketUri('my-bucket', 'auto');

        expect(uri.scheme, 'https');
        expect(uri.host, 'abc123def456.r2.cloudflarestorage.com');
        expect(uri.path, '/my-bucket');
      });

      test('then it ignores the region parameter', () {
        final uri1 = config.buildBucketUri('my-bucket', 'auto');
        final uri2 = config.buildBucketUri('my-bucket', 'us-east-1');

        expect(uri1.host, uri2.host);
        expect(uri1.path, uri2.path);
      });
    });

    group('when building public URI', () {
      test('then it returns the R2 public URL format', () {
        final uri = config.buildPublicUri(
          'my-bucket',
          'auto',
          'path/to/file.txt',
        );

        expect(uri.scheme, 'https');
        expect(uri.host, 'my-bucket.abc123def456.r2.dev');
        expect(uri.path, '/path/to/file.txt');
      });

      test('then it handles simple file paths', () {
        final uri = config.buildPublicUri('my-bucket', 'auto', 'file.txt');

        expect(uri.path, '/file.txt');
      });
    });

    test('when getting service name then it returns Cloudflare R2', () {
      expect(config.serviceName, 'Cloudflare R2');
    });
  });

  group('Given an R2EndpointConfig with custom public host', () {
    final customHost = Uri.https('cdn.example.com', '/assets');
    final config = R2EndpointConfig(
      accountId: 'abc123def456',
      publicHost: customHost,
    );

    group('when building public URI', () {
      test('then it uses the custom public host', () {
        final uri = config.buildPublicUri('my-bucket', 'auto', 'file.txt');

        expect(uri.scheme, 'https');
        expect(uri.host, 'cdn.example.com');
        expect(uri.path, '/assets/file.txt');
      });
    });

    group('when building public URI with override host', () {
      test('then the override takes precedence over configured host', () {
        final overrideHost = Uri.https('override.example.com', '/');

        final uri = config.buildPublicUri(
          'my-bucket',
          'auto',
          'file.txt',
          publicHost: overrideHost,
        );

        expect(uri.host, 'override.example.com');
      });
    });
  });

  group('Given an R2EndpointConfig with different account IDs', () {
    test('then the account ID is correctly used in bucket URI', () {
      final config = R2EndpointConfig(accountId: 'different123');

      final uri = config.buildBucketUri('bucket', 'auto');

      expect(uri.host, 'different123.r2.cloudflarestorage.com');
    });

    test('then the account ID is correctly used in public URI', () {
      final config = R2EndpointConfig(accountId: 'different123');

      final uri = config.buildPublicUri('bucket', 'auto', 'file.txt');

      expect(uri.host, 'bucket.different123.r2.dev');
    });
  });
}
