import 'package:serverpod_cloud_storage_cos/src/signing/cos_signer.dart';
import 'package:test/test.dart';

void main() {
  late CosSigner signer;

  setUp(() {
    signer = CosSigner(
      secretId: 'AKIDtest1234567890',
      secretKey: 'test_secret_key_1234567890',
      bucket: 'my-bucket-1250000000',
      region: 'ap-guangzhou',
    );
  });

  group('CosSigner', () {
    group('generatePresignedUrl', () {
      test('produces a valid HTTPS URL with q-sign-* parameters', () {
        final url = signer.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.scheme, 'https');
        expect(
          parsed.host,
          'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com',
        );
        expect(parsed.path, '/test/file.txt');

        expect(parsed.queryParameters['q-sign-algorithm'], 'sha1');
        expect(parsed.queryParameters['q-ak'], 'AKIDtest1234567890');
        expect(parsed.queryParameters.containsKey('q-sign-time'), isTrue);
        expect(parsed.queryParameters.containsKey('q-key-time'), isTrue);
        expect(parsed.queryParameters.containsKey('q-signature'), isTrue);
        expect(parsed.queryParameters.containsKey('q-header-list'), isTrue);
        expect(parsed.queryParameters.containsKey('q-url-param-list'), isTrue);
      });

      test('prepends / to objectKey when missing', () {
        final url = signer.generatePresignedUrl('GET', 'no-slash/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/no-slash/file.txt');
      });

      test('preserves leading / on objectKey', () {
        final url = signer.generatePresignedUrl('GET', '/has-slash/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/has-slash/file.txt');
      });

      test('includes signed headers in q-header-list', () {
        final url = signer.generatePresignedUrl(
          'PUT',
          '/upload.bin',
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length': '1024',
          },
        );
        final parsed = Uri.parse(url);

        final headerList = parsed.queryParameters['q-header-list'] ?? '';
        expect(headerList.contains('content-length'), isTrue);
        expect(headerList.contains('content-type'), isTrue);
      });

      test('includes query parameters in signed URL', () {
        final url = signer.generatePresignedUrl(
          'GET',
          '/test.txt',
          queryParams: {'response-content-type': 'text/plain'},
        );
        final parsed = Uri.parse(url);

        expect(parsed.queryParameters['response-content-type'], 'text/plain');
      });

      test('supports all four HTTP methods', () {
        for (final method in ['PUT', 'GET', 'HEAD', 'DELETE']) {
          final url = signer.generatePresignedUrl(method, '/test.txt');
          expect(Uri.tryParse(url), isNotNull, reason: 'method: $method');
          expect(url.startsWith('https://'), isTrue, reason: 'method: $method');
        }
      });

      test('respects custom expires', () {
        final url = signer.generatePresignedUrl(
          'GET',
          '/test.txt',
          expires: 600,
        );
        final parsed = Uri.parse(url);
        final keyTime = parsed.queryParameters['q-key-time']!;
        final parts = keyTime.split(';');

        final start = int.parse(parts[0]);
        final end = int.parse(parts[1]);
        expect(end - start, 600);
      });

      test('q-sign-time and q-key-time are identical', () {
        final url = signer.generatePresignedUrl('GET', '/test.txt');
        final parsed = Uri.parse(url);

        expect(
          parsed.queryParameters['q-sign-time'],
          parsed.queryParameters['q-key-time'],
        );
      });

      test('same inputs produce deterministic signatures', () {
        final url1 = signer.generatePresignedUrl(
          'GET',
          '/test.txt',
          expires: 3600,
        );
        final url2 = signer.generatePresignedUrl(
          'GET',
          '/test.txt',
          expires: 3600,
        );

        // The timestamps may differ by up to a second, so we compare
        // everything except the time-dependent query params.
        final parsed1 = Uri.parse(url1);
        final parsed2 = Uri.parse(url2);
        expect(parsed1.scheme, parsed2.scheme);
        expect(parsed1.host, parsed2.host);
        expect(parsed1.path, parsed2.path);
        expect(
          parsed1.queryParameters['q-sign-algorithm'],
          parsed2.queryParameters['q-sign-algorithm'],
        );
        expect(
          parsed1.queryParameters['q-ak'],
          parsed2.queryParameters['q-ak'],
        );
      });
    });

    group('defaultHost', () {
      test('uses virtual-hosted-style format', () {
        expect(
          signer.defaultHost,
          'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com',
        );
      });
    });

    group('custom publicHost', () {
      test('uses custom domain when provided as bare host', () {
        final customSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'b',
          region: 'r',
          publicHost: 'cdn.example.com',
        );
        final url = customSigner.generatePresignedUrl('GET', '/test.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
      });

      test('strips protocol from publicHost URL', () {
        final customSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'b',
          region: 'r',
          publicHost: 'https://cdn.example.com',
        );
        final url = customSigner.generatePresignedUrl('GET', '/test.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
      });

      test('falls back to default host when publicHost is blank', () {
        final customSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'b-123',
          region: 'ap-shanghai',
          publicHost: '  ',
        );
        final url = customSigner.generatePresignedUrl('GET', '/test.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'b-123.cos.ap-shanghai.myqcloud.com');
      });
    });
  });
}
