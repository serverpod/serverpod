import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_cos/serverpod_cloud_storage_cos.dart';
import 'package:serverpod_cloud_storage_cos/src/signing/cos_signer.dart';
import 'package:test/test.dart';

void main() {
  late CosSigner signer;
  late MockSession mockSession;
  late MockHttpClient mockHttpClient;
  late CosCloudStorage storage;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    signer = CosSigner(
      secretId: 'AKIDtest',
      secretKey: 'test_secret',
      bucket: 'my-bucket-1250000000',
      region: 'ap-guangzhou',
    );
    mockSession = MockSession();
    mockHttpClient = MockHttpClient();
    storage = CosCloudStorage.withSigner(
      storageId: 'test',
      public: true,
      bucket: 'my-bucket-1250000000',
      region: 'ap-guangzhou',
      signer: signer,
      httpClient: mockHttpClient,
    );
  });

  group('CosCloudStorage', () {
    // -----------------------------------------------------------------------
    // storeFile
    // -----------------------------------------------------------------------

    group('storeFile', () {
      test('when COS returns 200 then completes without error', () async {
        when(
          () => mockHttpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('', 200));

        await expectLater(
          storage.storeFile(
            session: mockSession,
            path: 'test/file.txt',
            byteData: ByteData(5),
          ),
          completes,
        );
      });

      test('when COS returns 500 then throws CloudStorageException', () async {
        when(
          () => mockHttpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(
          () => storage.storeFile(
            session: mockSession,
            path: 'test/file.txt',
            byteData: ByteData(5),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('status: 500'),
            ),
          ),
        );
      });

      test('sends PUT to COS default host, not publicHost', () async {
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
          httpClient: mockHttpClient,
        );

        when(
          () => mockHttpClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('', 200));

        await cdnStorage.storeFile(
          session: mockSession,
          path: 'file.bin',
          byteData: ByteData(1),
        );

        final captured = verify(
          () => mockHttpClient.put(
            captureAny(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).captured;
        final uri = captured.first as Uri;

        expect(
          uri.host,
          'b-123.cos.ap-shanghai.myqcloud.com',
          reason: 'storeFile must use COS endpoint, not CDN publicHost',
        );
      });
    });

    // -----------------------------------------------------------------------
    // storeFileWithOptions
    // -----------------------------------------------------------------------

    group('storeFileWithOptions', () {
      test('throws on content length mismatch', () async {
        expect(
          () => storage.storeFileWithOptions(
            session: mockSession,
            path: 'test.bin',
            byteData: ByteData(100),
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

      test(
        'sends x-cos-forbid-overwrite header when preventOverwrite is set',
        () async {
          when(
            () => mockHttpClient.put(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
              encoding: any(named: 'encoding'),
            ),
          ).thenAnswer((_) async => http.Response('', 200));

          await storage.storeFileWithOptions(
            session: mockSession,
            path: 'test.bin',
            byteData: ByteData(5),
            options: const CloudStorageOptions(preventOverwrite: true),
          );

          final captured = verify(
            () => mockHttpClient.put(
              any(),
              headers: captureAny(named: 'headers'),
              body: any(named: 'body'),
              encoding: any(named: 'encoding'),
            ),
          ).captured;
          final headers = captured.first as Map<String, String>;

          expect(headers['x-cos-forbid-overwrite'], 'true');
        },
      );

      test(
        'when COS returns 409 then throws with preventOverwrite message',
        () async {
          when(
            () => mockHttpClient.put(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
              encoding: any(named: 'encoding'),
            ),
          ).thenAnswer((_) async => http.Response('Conflict', 409));

          expect(
            () => storage.storeFileWithOptions(
              session: mockSession,
              path: 'test.bin',
              byteData: ByteData(5),
              options: const CloudStorageOptions(preventOverwrite: true),
            ),
            throwsA(
              isA<CloudStorageException>().having(
                (e) => e.message,
                'message',
                contains('already exists'),
              ),
            ),
          );
        },
      );
    });

    // -----------------------------------------------------------------------
    // retrieveFile
    // -----------------------------------------------------------------------

    group('retrieveFile', () {
      test('when COS returns 200 then returns file bytes', () async {
        final bodyBytes = [1, 2, 3, 4, 5];
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response.bytes(bodyBytes, 200));

        final result = await storage.retrieveFile(
          session: mockSession,
          path: 'existing/file.bin',
        );

        expect(result, isNotNull);
        expect(
          result!.buffer.asUint8List(
            result.offsetInBytes,
            result.lengthInBytes,
          ),
          bodyBytes,
        );
      });

      test('when COS returns 404 then returns null', () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await storage.retrieveFile(
          session: mockSession,
          path: 'missing/file.bin',
        );

        expect(result, isNull);
      });

      test('when COS returns 500 then throws CloudStorageException', () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(
          () => storage.retrieveFile(
            session: mockSession,
            path: 'error/file.bin',
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('status: 500'),
            ),
          ),
        );
      });

      test('sends GET to COS default host, not publicHost', () async {
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
          httpClient: mockHttpClient,
        );

        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response.bytes([1], 200));

        await cdnStorage.retrieveFile(session: mockSession, path: 'file.bin');

        final captured = verify(
          () =>
              mockHttpClient.get(captureAny(), headers: any(named: 'headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(
          uri.host,
          'b-123.cos.ap-shanghai.myqcloud.com',
          reason: 'retrieveFile must use COS endpoint, not CDN publicHost',
        );
      });
    });

    // -----------------------------------------------------------------------
    // fileExists
    // -----------------------------------------------------------------------

    group('fileExists', () {
      test('when COS returns 200 then returns true', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 200));

        final exists = await storage.fileExists(
          session: mockSession,
          path: 'existing/file.txt',
        );

        expect(exists, isTrue);
      });

      test('when COS returns 404 then returns false', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 404));

        final exists = await storage.fileExists(
          session: mockSession,
          path: 'missing/file.txt',
        );

        expect(exists, isFalse);
      });

      test('when COS returns 500 then throws CloudStorageException', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 500));

        expect(
          () =>
              storage.fileExists(session: mockSession, path: 'error/file.txt'),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('status: 500'),
            ),
          ),
        );
      });

      test('sends HEAD to COS default host, not publicHost', () async {
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
          httpClient: mockHttpClient,
        );

        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 200));

        await cdnStorage.fileExists(session: mockSession, path: 'file.txt');

        final captured = verify(
          () =>
              mockHttpClient.head(captureAny(), headers: any(named: 'headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(
          uri.host,
          'b-123.cos.ap-shanghai.myqcloud.com',
          reason: 'fileExists must use COS endpoint, not CDN publicHost',
        );
      });
    });

    // -----------------------------------------------------------------------
    // deleteFile
    // -----------------------------------------------------------------------

    group('deleteFile', () {
      test('when COS returns 204 then completes without error', () async {
        when(
          () => mockHttpClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        await expectLater(
          storage.deleteFile(session: mockSession, path: 'file.txt'),
          completes,
        );
      });

      test('when COS returns 200 then completes without error', () async {
        when(
          () => mockHttpClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('', 200));

        await expectLater(
          storage.deleteFile(session: mockSession, path: 'file.txt'),
          completes,
        );
      });

      test('when COS returns 404 then silently ignores (idempotent)', () async {
        when(
          () => mockHttpClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        await expectLater(
          storage.deleteFile(session: mockSession, path: 'already-deleted.txt'),
          completes,
        );
      });

      test('when COS returns 500 then throws CloudStorageException', () async {
        when(
          () => mockHttpClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(
          () =>
              storage.deleteFile(session: mockSession, path: 'error-file.txt'),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('status: 500'),
            ),
          ),
        );
      });

      test('sends DELETE to COS default host, not publicHost', () async {
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
          httpClient: mockHttpClient,
        );

        when(
          () => mockHttpClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        await cdnStorage.deleteFile(session: mockSession, path: 'file.txt');

        final captured = verify(
          () => mockHttpClient.delete(
            captureAny(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).captured;
        final uri = captured.first as Uri;

        expect(
          uri.host,
          'b-123.cos.ap-shanghai.myqcloud.com',
          reason: 'deleteFile must use COS endpoint, not CDN publicHost',
        );
      });
    });

    // -----------------------------------------------------------------------
    // getPublicUrl
    // -----------------------------------------------------------------------

    group('getPublicUrl', () {
      test('when public is false then returns null', () async {
        final privateStorage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: false,
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          signer: signer,
          httpClient: mockHttpClient,
        );

        final url = await privateStorage.getPublicUrl(
          session: mockSession,
          path: 'file.txt',
        );

        expect(url, isNull);
      });

      test('when file exists then returns default COS URL', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 200));

        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'photos/cat.jpg',
        );

        expect(url, isNotNull);
        expect(url!.scheme, 'https');
        expect(url.host, 'my-bucket-1250000000.cos.ap-guangzhou.myqcloud.com');
        expect(url.path, '/photos/cat.jpg');
      });

      test('when file does not exist then returns null', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 404));

        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'missing.txt',
        );

        expect(url, isNull);
      });

      test('when publicHost is set then uses custom domain for URL', () async {
        final cdnStorage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: true,
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          signer: signer,
          publicHost: 'cdn.example.com',
          httpClient: mockHttpClient,
        );

        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 200));

        final url = await cdnStorage.getPublicUrl(
          session: mockSession,
          path: 'photo.jpg',
        );

        expect(url, isNotNull);
        expect(url!.host, 'cdn.example.com');
        expect(url.path, '/photo.jpg');
      });

      test(
        'when publicHost has https:// prefix then strips protocol',
        () async {
          final cdnStorage = CosCloudStorage.withSigner(
            storageId: 'test',
            public: true,
            bucket: 'my-bucket-1250000000',
            region: 'ap-guangzhou',
            signer: signer,
            publicHost: 'https://cdn.example.com',
            httpClient: mockHttpClient,
          );

          when(
            () => mockHttpClient.head(any(), headers: any(named: 'headers')),
          ).thenAnswer((_) async => http.Response('', 200));

          final url = await cdnStorage.getPublicUrl(
            session: mockSession,
            path: 'photo.jpg',
          );

          expect(url, isNotNull);
          expect(url!.scheme, 'https');
          expect(url.host, 'cdn.example.com');
        },
      );
    });

    // -----------------------------------------------------------------------
    // verifyDirectFileUpload
    // -----------------------------------------------------------------------

    group('verifyDirectFileUpload', () {
      test('when file exists then returns true', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 200));

        final verified = await storage.verifyDirectFileUpload(
          session: mockSession,
          path: 'uploaded.txt',
        );

        expect(verified, isTrue);
      });

      test('when file does not exist then returns false', () async {
        when(
          () => mockHttpClient.head(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('', 404));

        final verified = await storage.verifyDirectFileUpload(
          session: mockSession,
          path: 'not-uploaded.txt',
        );

        expect(verified, isFalse);
      });
    });

    // -----------------------------------------------------------------------
    // createDirectFileUploadDescription
    // -----------------------------------------------------------------------

    group('createDirectFileUploadDescription', () {
      test('returns a valid binary PUT description JSON', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: mockSession,
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
          session: mockSession,
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
          session: mockSession,
          path: 'test.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final headers = (desc['headers'] as Map).cast<String, String>();
        expect(headers['Content-Type'], 'application/octet-stream');
      });

      test('description URL contains valid COS signature params', () async {
        final result = await storage.createDirectFileUploadDescription(
          session: mockSession,
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
          session: mockSession,
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
          session: mockSession,
          path: '/leading/slash.bin',
        );

        final desc = jsonDecode(result!) as Map<String, dynamic>;
        final url = Uri.parse(desc['url'] as String);
        expect(url.path, '/leading/slash.bin');
      });
    });

    // -----------------------------------------------------------------------
    // createDirectFileUploadDescriptionWithOptions
    // -----------------------------------------------------------------------

    group('createDirectFileUploadDescriptionWithOptions', () {
      test('returns a valid binary PUT description JSON', () async {
        final result = await storage
            .createDirectFileUploadDescriptionWithOptions(
              session: mockSession,
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
                session: mockSession,
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
                session: mockSession,
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
                session: mockSession,
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
            session: mockSession,
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
              session: mockSession,
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
                session: mockSession,
                path: 'file.bin',
                options: const CloudStorageOptions(),
              );

          final desc = jsonDecode(result!) as Map<String, dynamic>;
          final url = Uri.parse(desc['url'] as String);
          expect(url.host, 'b-123.cos.ap-shanghai.myqcloud.com');
        },
      );
    });

    // -----------------------------------------------------------------------
    // Path normalization
    // -----------------------------------------------------------------------

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

    // -----------------------------------------------------------------------
    // Public URL construction (signer-level, no HTTP mock needed)
    // -----------------------------------------------------------------------

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

    // -----------------------------------------------------------------------
    // close
    // -----------------------------------------------------------------------

    group('close', () {
      test('does not close externally injected httpClient', () {
        storage.close();

        verifyNever(() => mockHttpClient.close());
      });

      test('closes internally created httpClient', () {
        final internalClientStorage = CosCloudStorage.withSigner(
          storageId: 'test',
          public: true,
          bucket: 'my-bucket-1250000000',
          region: 'ap-guangzhou',
          signer: signer,
        );

        expect(() => internalClientStorage.close(), returnsNormally);
      });

      test('is idempotent — multiple calls do not throw', () {
        storage.close();
        storage.close();

        verifyNever(() => mockHttpClient.close());
      });
    });
  });
}

class MockHttpClient extends Mock implements http.Client {}

class MockSession extends Mock implements Session {}
