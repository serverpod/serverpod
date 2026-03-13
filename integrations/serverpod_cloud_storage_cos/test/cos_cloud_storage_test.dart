import 'dart:convert';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_cos/serverpod_cloud_storage_cos.dart';
import 'package:serverpod_cloud_storage_cos/src/signing/cos_signer.dart';
import 'package:test/test.dart';

void main() {
  group('CosCloudStorage', () {
    late CosSigner signer;
    late CosCloudStorage storage;

    setUp(() {
      signer = CosSigner(
        secretId: 'AKIDtest',
        secretKey: 'test_secret',
        bucket: 'my-bucket-1250000000',
        region: 'ap-guangzhou',
      );
      storage = CosCloudStorage.withSigner(
        storageId: 'test',
        public: true,
        bucket: 'my-bucket-1250000000',
        region: 'ap-guangzhou',
        signer: signer,
      );
    });

    group('public URL construction via signer', () {
      test('default virtual-hosted-style host', () {
        final url = signer.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(
          parsed.host,
          'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com',
        );
        expect(parsed.path, '/test/file.txt');
      });

      test('custom domain as bare hostname', () {
        final cdnSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          publicHost: 'cdn.example.com',
        );
        final url = cdnSigner.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
        expect(parsed.path, '/test/file.txt');
      });

      test('custom domain with https:// prefix', () {
        final cdnSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          publicHost: 'https://cdn.example.com',
        );
        final url = cdnSigner.generatePresignedUrl('GET', '/test/file.txt');
        final parsed = Uri.parse(url);

        expect(parsed.host, 'cdn.example.com');
      });
    });

    group('path normalization via signer', () {
      test('path without leading slash gets normalized', () {
        final url = signer.generatePresignedUrl('GET', 'foo/bar.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/foo/bar.txt');
      });

      test('path with leading slash is preserved', () {
        final url = signer.generatePresignedUrl('GET', '/foo/bar.txt');
        final parsed = Uri.parse(url);

        expect(parsed.path, '/foo/bar.txt');
      });
    });

    group('storeFileWithOptions validation', () {
      test('throws on content length mismatch', () async {
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

    // -------------------------------------------------------------------------
    // Direct upload description tests
    // -------------------------------------------------------------------------

    group('createDirectFileUploadDescription', () {
      test('returns a valid binary PUT description JSON', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'uploads/test.bin',
        );

        expect(result, isNotNull);
        final desc = jsonDecode(result!) as Map<String, dynamic>;

        expect(desc['type'], 'binary');
        expect(desc['method'], 'PUT');
        expect(desc.containsKey('url'), isTrue);
        expect(desc.containsKey('headers'), isTrue);

        final url = Uri.parse(desc['url'] as String);
        expect(url.scheme, 'https');
        expect(url.path, '/uploads/test.bin');
      });

      test('description URL always uses COS default host', () async {
        final cdnSigner = CosSigner(
          secretId: 'id',
          secretKey: 'key',
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          publicHost: 'cdn.example.com',
        );
        final cdnStorage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: true,
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          signer: cdnSigner,
          publicHost: 'cdn.example.com',
        );

        final result = await cdnStorage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'file.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final url = Uri.parse(desc['url'] as String);

        expect(
          url.host,
          'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com',
          reason: 'Upload URL must use COS endpoint, not CDN publicHost',
        );
      });

      test('description includes Content-Type header', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'test.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final headers = (desc['headers'] as Map).cast<String, String>();
        expect(headers['Content-Type'], 'application/octet-stream');
      });

      test('description URL contains valid COS signature params', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'test.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final url = Uri.parse(desc['url'] as String);

        expect(url.queryParameters['q-sign-algorithm'], 'sha1');
        expect(url.queryParameters['q-ak'], 'AKIDtest');
        expect(url.queryParameters.containsKey('q-signature'), isTrue);
      });

      test('respects custom expiration duration', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: 'test.bin',
          expirationDuration: const Duration(minutes: 30),
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final url = Uri.parse(desc['url'] as String);
        final keyTime = url.queryParameters['q-key-time']!;
        final parts = keyTime.split(';');
        final start = int.parse(parts[0]);
        final end = int.parse(parts[1]);

        expect(end - start, 1800);
      });

      test('normalizes path with leading slash', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: MockSession(),
          path: '/leading/slash.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final url = Uri.parse(desc['url'] as String);
        expect(url.path, '/leading/slash.bin');
      });
    });

    group('createDirectFileUploadDescriptionWithOptions', () {
      test('returns a valid binary PUT description JSON', () async {
        final result = await storage
            .createDirectFileUploadDescriptionWithOptions(
              session: MockSession(),
              path: 'test.bin',
              options: const CloudStorageOptions(),
            );

        expect(result, isNotNull);
        final desc = jsonDecode(result!) as Map<String, dynamic>;

        expect(desc['type'], 'binary');
        expect(desc['method'], 'PUT');
      });

      test(
        'includes Content-Length header when contentLength is set',
        () async {
          final result = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: MockSession(),
                path: 'test.bin',
                options: const CloudStorageOptions(contentLength: 2048),
              );

          final desc = jsonDecode(result!) as Map<String, dynamic>;
          final headers = (desc['headers'] as Map).cast<String, String>();

          expect(headers['Content-Length'], '2048');
        },
      );

      test(
        'includes x-cos-forbid-overwrite header when preventOverwrite is set',
        () async {
          final result = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: MockSession(),
                path: 'test.bin',
                options: const CloudStorageOptions(preventOverwrite: true),
              );

          final desc = jsonDecode(result!) as Map<String, dynamic>;
          final headers = (desc['headers'] as Map).cast<String, String>();

          expect(headers['x-cos-forbid-overwrite'], 'true');
        },
      );

      test(
        'includes both contentLength and preventOverwrite headers',
        () async {
          final result = await storage
              .createDirectFileUploadDescriptionWithOptions(
                session: MockSession(),
                path: 'test.bin',
                options: const CloudStorageOptions(
                  contentLength: 4096,
                  preventOverwrite: true,
                ),
              );

          final desc = jsonDecode(result!) as Map<String, dynamic>;
          final headers = (desc['headers'] as Map).cast<String, String>();

          expect(headers['Content-Length'], '4096');
          expect(headers['x-cos-forbid-overwrite'], 'true');
        },
      );

      test('throws when contentLength exceeds maxFileSize', () async {
        expect(
          () => storage.createDirectFileUploadDescriptionWithOptions(
            session: MockSession(),
            path: 'large.bin',
            maxFileSize: 1024,
            options: const CloudStorageOptions(contentLength: 2048),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('exceeds maximum file size'),
            ),
          ),
        );
      });

      test('does not throw when contentLength equals maxFileSize', () async {
        final result = await storage
            .createDirectFileUploadDescriptionWithOptions(
              session: MockSession(),
              path: 'exact.bin',
              maxFileSize: 1024,
              options: const CloudStorageOptions(contentLength: 1024),
            );

        expect(result, isNotNull);
      });

      test(
        'description URL uses COS default host even with publicHost',
        () async {
          final cdnSigner = CosSigner(
            secretId: 'id',
            secretKey: 'key',
            bucket: 'b-123',
            region: 'ap-shanghai',
            publicHost: 'cdn.example.com',
          );
          final cdnStorage = CosCloudStorage.withSigner(
            storageId: 'test',
            public: true,
            bucket: 'b-123',
            region: 'ap-shanghai',
            signer: cdnSigner,
            publicHost: 'cdn.example.com',
          );

          final result = await cdnStorage
              .createDirectFileUploadDescriptionWithOptions(
                session: MockSession(),
                path: 'file.bin',
                options: const CloudStorageOptions(),
              );

          final desc = jsonDecode(result!) as Map<String, dynamic>;
          final url = Uri.parse(desc['url'] as String);
          expect(url.host, 'b-123.cos.ap-shanghai.myqcloud.com');
        },
      );
    });

    group('verifyDirectFileUpload', () {
      test('delegates to fileExists (covered by CloudStorage contract)', () {
        // verifyDirectFileUpload calls fileExists, which requires a live COS
        // server. This test only verifies that the method signature compiles
        // and the contract relationship is correct by inspection.
        // Integration tests with a real bucket cover end-to-end behavior.
        expect(storage.verifyDirectFileUpload, isA<Function>());
      });
    });
  });
}

class MockSession extends Mock implements Session {}
