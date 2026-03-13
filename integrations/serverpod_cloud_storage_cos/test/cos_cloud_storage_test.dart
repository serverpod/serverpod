import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_cos/serverpod_cloud_storage_cos.dart';
import 'package:serverpod_cloud_storage_cos/src/signing/cos_signer.dart';
import 'package:test/test.dart';

void main() {
  group('CosCloudStorage', () {
    group('public URL construction via signer', () {
      test('default virtual-hosted-style host', () {
        final signer = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
        );
        final url = signer.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(
          parsed.host,
          'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com',
        );
        expect(parsed.path, '/test/file.txt');
      });

      test('custom domain as bare hostname', () {
        final signer = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          publicHost: 'cdn.example.com',
        );
        final url = signer.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
        expect(parsed.path, '/test/file.txt');
      });

      test('custom domain with https:// prefix', () {
        final signer = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          publicHost: 'https://cdn.example.com',
        );
        final url = signer.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
      });
    });

    group('path normalization via signer', () {
      test('path without leading slash gets normalized', () {
        final signer = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'b',
          region: 'r',
        );
        final url = signer.generatePresignedUrl('GET', 'foo/bar.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/foo/bar.txt');
      });

      test('path with leading slash is preserved', () {
        final signer = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'b',
          region: 'r',
        );
        final url = signer.generatePresignedUrl('GET', '/foo/bar.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/foo/bar.txt');
      });
    });

    group('storeFileWithOptions validation', () {
      test('throws on content length mismatch', () async {
        final storage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: false,
          bucket: 'b',
          region: 'r',
          signer: CosSigner(
            secretId: 'id',
            secretKey: 'key',
            bucket: 'b',
            region: 'r',
          ),
        );

        final data = ByteData(100);

        expect(
          () => storage.storeFileWithOptions(
            session: MockSession(),
            path: 'test.bin',
            byteData: data,
            options: const CloudStorageOptions(contentLength: 999),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('Content length mismatch'),
            ),
          ),
        );
      });

      test('does not throw when content length matches', () async {
        final storage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: false,
          bucket: 'b',
          region: 'r',
          signer: CosSigner(
            secretId: 'id',
            secretKey: 'key',
            bucket: 'b',
            region: 'r',
          ),
        );

        final data = ByteData(100);

        // This will fail at the HTTP level (no real COS server), but the
        // content-length pre-check should pass without throwing
        // CloudStorageException with "Content length mismatch".
        expect(
          () => storage.storeFileWithOptions(
            session: MockSession(),
            path: 'test.bin',
            byteData: data,
            options: const CloudStorageOptions(contentLength: 100),
          ),
          throwsA(
            isNot(
              isA<CloudStorageException>().having(
                (e) => e.message,
                'message',
                contains('Content length mismatch'),
              ),
            ),
          ),
        );
      });
    });

    group('createDirectFileUploadDescription', () {
      test('returns null (not yet implemented)', () async {
        final storage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: false,
          bucket: 'b',
          region: 'r',
          signer: CosSigner(
            secretId: 'id',
            secretKey: 'key',
            bucket: 'b',
            region: 'r',
          ),
        );

        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'test.bin',
        );

        expect(result, isNull);
      });
    });

    group('createDirectFileUploadDescriptionWithOptions', () {
      test('returns null (not yet implemented)', () async {
        final storage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: false,
          bucket: 'b',
          region: 'r',
          signer: CosSigner(
            secretId: 'id',
            secretKey: 'key',
            bucket: 'b',
            region: 'r',
          ),
        );

        final result = await storage
            .createDirectFileUploadDescriptionWithOptions(
              session: MockSession(),
              path: 'test.bin',
              options: const CloudStorageOptions(),
            );

        expect(result, isNull);
      });
    });
  });
}

class MockSession extends Mock implements Session {}
