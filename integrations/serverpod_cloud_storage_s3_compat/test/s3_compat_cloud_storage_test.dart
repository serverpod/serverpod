import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  group('Given a TestableS3CompatCloudStorage', () {
    late TestableS3CompatCloudStorage storage;
    late MockS3Client mockClient;
    late MockUploadStrategy mockUploadStrategy;

    setUp(() {
      mockClient = MockS3Client();
      mockUploadStrategy = MockUploadStrategy();

      storage = TestableS3CompatCloudStorage(
        mockClient: mockClient,
        mockUploadStrategy: mockUploadStrategy,
      );
    });

    test(
      'when accessing storageId '
      'then it returns the configured value',
      () {
        expect(storage.storageId, 'test-storage');
      },
    );

    group('Given a file to store', () {
      test(
        'when storing it '
        'then it delegates to the upload strategy',
        () async {
          final data = ByteData(10);

          await storage.testStoreFile('test/file.txt', data);

          expect(mockUploadStrategy.uploadedPath, 'test/file.txt');
          expect(mockUploadStrategy.uploadedData, data);
          expect(mockUploadStrategy.uploadedPreventOverwrite, isFalse);
        },
      );

      test(
        'when storing it with preventOverwrite '
        'then it forwards preventOverwrite to the upload strategy',
        () async {
          final data = ByteData(10);

          await storage.testStoreFile(
            'test/file.txt',
            data,
            preventOverwrite: true,
          );

          expect(mockUploadStrategy.uploadedPreventOverwrite, isTrue);
        },
      );

      test(
        'when a conditional upload is rejected, '
        'then it throws a CloudStorageFileAlreadyExistsException',
        () async {
          mockUploadStrategy.uploadError = S3Exception(
            http.Response('', 412),
          );

          await expectLater(
            () => storage.testStoreFile(
              'test/file.txt',
              ByteData(1),
              preventOverwrite: true,
            ),
            throwsA(isA<CloudStorageFileAlreadyExistsException>()),
          );
        },
      );
    });

    group('Given an existing file', () {
      test(
        'when retrieving it '
        'then it returns the file data',
        () async {
          final fileContent = [1, 2, 3, 4, 5];
          mockClient.getObjectResponse = http.Response.bytes(fileContent, 200);

          final result = await storage.testRetrieveFile('existing/file.txt');

          expect(mockClient.lastGetKey, 'existing/file.txt');
          expect(result.buffer.asUint8List(), fileContent);
        },
      );

      test(
        'when checking if it exists '
        'then it returns true',
        () async {
          mockClient.headObjectResponse = http.Response(
            '',
            200,
            headers: {'content-length': '0'},
          );

          final exists = await storage.testFileExists('existing.txt');

          expect(mockClient.lastHeadKey, 'existing.txt');
          expect(exists, isTrue);
        },
      );

      test(
        'when getting its public URL '
        'then it returns the URL',
        () async {
          mockClient.headObjectResponse = http.Response(
            '',
            200,
            headers: {'content-length': '0'},
          );

          final url = await storage.testPublicDownloadUrl('path/to/file.txt');

          expect(url.toString(), contains('test-bucket'));
          expect(url.toString(), contains('path/to/file.txt'));
        },
      );

      test(
        'when deleting it '
        'then it calls deleteObject on the client',
        () async {
          mockClient.deleteObjectResponse = http.Response('', 204);

          await storage.testDeleteFile('to-delete.txt');

          expect(mockClient.lastDeleteKey, 'to-delete.txt');
        },
      );

      test(
        'when verifying direct file upload '
        'then it returns true',
        () async {
          mockClient.headObjectResponse = http.Response(
            '',
            200,
            headers: {'content-length': '0'},
          );

          final verified = await storage.testVerifyUpload('uploaded.txt');

          expect(mockClient.lastHeadKey, 'uploaded.txt');
          expect(verified, isTrue);
        },
      );
    });

    group('Given a missing file', () {
      test(
        'when retrieving it, '
        'then it throws a CloudStorageFileNotFoundException',
        () async {
          mockClient.getObjectResponse = http.Response('Not Found', 404);

          await expectLater(
            () => storage.testRetrieveFile('missing/file.txt'),
            throwsA(isA<CloudStorageFileNotFoundException>()),
          );
        },
      );

      test(
        'when checking if it exists '
        'then it returns false',
        () async {
          mockClient.headObjectResponse = http.Response('', 404);

          final exists = await storage.testFileExists('missing.txt');

          expect(exists, isFalse);
        },
      );

      test(
        'when getting its public URL, '
        'then it throws a CloudStorageFileNotFoundException',
        () async {
          mockClient.headObjectResponse = http.Response('', 404);

          await expectLater(
            () => storage.testPublicDownloadUrl('missing.txt'),
            throwsA(isA<CloudStorageFileNotFoundException>()),
          );
        },
      );

      test(
        'when verifying direct file upload '
        'then it returns false',
        () async {
          mockClient.headObjectResponse = http.Response('', 404);

          final verified = await storage.testVerifyUpload('not-uploaded.txt');

          expect(verified, isFalse);
        },
      );
    });

    test(
      'Given a storage error, '
      'when verifying the upload then it throws a CloudStorageException',
      () async {
        mockClient.headObjectResponse = http.Response('', 500);

        await expectLater(
          () => storage.testVerifyUpload('upload.txt'),
          throwsA(isA<CloudStorageException>()),
        );
      },
    );

    group('Given a direct upload description request', () {
      test(
        'when creating it '
        'then it delegates to the upload strategy',
        () async {
          mockUploadStrategy.directUploadDescriptionResult =
              BinaryUploadDescription(
                url: Uri.parse('https://example.com'),
              );

          final description = await storage.testCreateUploadDescription(
            'upload/target.txt',
            expiration: Duration(minutes: 5),
            maxFileSize: 1024 * 1024,
          );

          expect(mockUploadStrategy.directUploadPath, 'upload/target.txt');
          expect(
            mockUploadStrategy.directUploadExpiration,
            Duration(minutes: 5),
          );
          expect(mockUploadStrategy.directUploadMaxFileSize, 1024 * 1024);
          expect(
            description,
            same(mockUploadStrategy.directUploadDescriptionResult),
          );
        },
      );

      test(
        'when contentLength is within limit '
        'then it forwards contentLength to the upload strategy',
        () async {
          mockUploadStrategy.directUploadDescriptionResult =
              BinaryUploadDescription(
                url: Uri.parse('https://example.com'),
              );

          await storage.testCreateUploadDescription(
            'upload/target.txt',
            maxFileSize: 1024 * 1024,
            contentLength: 512 * 1024,
          );

          expect(mockUploadStrategy.directUploadContentLength, 512 * 1024);
        },
      );

      test(
        'when contentLength is not provided '
        'then it forwards null contentLength to the upload strategy',
        () async {
          mockUploadStrategy.directUploadDescriptionResult =
              BinaryUploadDescription(
                url: Uri.parse('https://example.com'),
              );

          await storage.testCreateUploadDescription(
            'upload/target.txt',
          );

          expect(mockUploadStrategy.directUploadContentLength, isNull);
        },
      );

      test(
        'when the strategy cannot enforce maxFileSize without contentLength '
        'then it throws unsupported',
        () {
          mockUploadStrategy.canEnforceMaxFileSize = false;

          expect(
            () => storage.createUploadDescription(
              session: _FakeSession(),
              path: 'upload/target.txt',
            ),
            throwsA(isA<CloudStorageUnsupportedOperationException>()),
          );
        },
      );

      test(
        'when contentLength exceeds maxFileSize '
        'then it throws a cloud storage exception',
        () async {
          expect(
            () => storage.testCreateUploadDescription(
              'upload/target.txt',
              maxFileSize: 1024 * 1024,
              contentLength: 2 * 1024 * 1024,
            ),
            throwsA(isA<CloudStorageException>()),
          );
        },
      );

      test(
        'when contentLength equals maxFileSize '
        'then it succeeds',
        () async {
          mockUploadStrategy.directUploadDescriptionResult =
              BinaryUploadDescription(
                url: Uri.parse('https://example.com'),
              );

          final description = await storage.testCreateUploadDescription(
            'upload/target.txt',
            maxFileSize: 1024 * 1024,
            contentLength: 1024 * 1024,
          );

          expect(description, isNotNull);
          expect(mockUploadStrategy.directUploadContentLength, 1024 * 1024);
        },
      );
    });
  });

  test(
    'Given a TestableS3CompatCloudStorage with custom endpoints '
    'when getting public URL '
    'then it produces correct custom URL format',
    () async {
      final mockClient = MockS3Client();
      mockClient.headObjectResponse = http.Response(
        '',
        200,
        headers: {'content-length': '0'},
      );

      final storage = TestableS3CompatCloudStorage(
        mockClient: mockClient,
        mockUploadStrategy: MockUploadStrategy(),
        storageId: 'localstack',
        bucket: 'local-bucket',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.http('localhost:4566', '/'),
        ),
      );

      final url = await storage.testPublicDownloadUrl('file.txt');

      expect(url.toString(), 'http://localhost:4566/local-bucket/file.txt');
    },
  );

  test(
    'Given a private TestableS3CompatCloudStorage, '
    'when requesting a public URL, '
    'then it throws a CloudStorageUnsupportedOperationException',
    () async {
      final privateStorage = TestableS3CompatCloudStorage(
        mockClient: MockS3Client(),
        mockUploadStrategy: MockUploadStrategy(),
        public: false,
      );

      await expectLater(
        () => privateStorage.publicDownloadUrl(
          session: _FakeSession(),
          path: 'file.txt',
        ),
        throwsA(isA<CloudStorageUnsupportedOperationException>()),
      );
    },
  );

  group('Given a public TestableS3CompatCloudStorage', () {
    late MockS3Client client;
    late TestableS3CompatCloudStorage storage;
    late Session session;

    setUp(() {
      client = MockS3Client();
      storage = TestableS3CompatCloudStorage(
        mockClient: client,
        mockUploadStrategy: MockUploadStrategy(),
      );
      session = _FakeSession();
    });

    test('when statting a file, then HEAD metadata is retained', () async {
      client.headObjectResponse = http.Response(
        '',
        200,
        headers: {
          'content-length': '42',
          'last-modified': 'Fri, 21 Aug 2026 12:00:00 GMT',
          'content-type': 'text/plain',
          'cache-control': 'max-age=60',
          'content-disposition': 'inline',
          'content-encoding': 'gzip',
          'etag': 'etag-value',
          'x-amz-meta-tenant': 'acme',
        },
      );

      final stat = await storage.statFile(
        session: session,
        path: 'file.txt',
      );

      expect(stat.size, 42);
      expect(stat.contentType, 'text/plain');
      expect(stat.cacheControl, 'max-age=60');
      expect(stat.contentDisposition, 'inline');
      expect(stat.contentEncoding, 'gzip');
      expect(stat.etag, 'etag-value');
      expect(stat.custom, {'tenant': 'acme'});
    });

    test(
      'when statting a non-existent file, '
      'then it throws a CloudStorageFileNotFoundException',
      () async {
        client.headObjectResponse = http.Response('', 404);

        await expectLater(
          () => storage.statFile(session: session, path: 'missing.txt'),
          throwsA(isA<CloudStorageFileNotFoundException>()),
        );
      },
    );

    test(
      'when creating a temporary URL, then response overrides are signed',
      () async {
        client.headObjectResponse = http.Response(
          '',
          200,
          headers: {
            'content-length': '42',
          },
        );

        final url = await storage.temporaryDownloadUrl(
          session: session,
          path: 'report.pdf',
          options: const TemporaryDownloadUrlOptions(
            expirationDuration: Duration(minutes: 5),
            downloadFileName: 'Quarterly report.pdf',
            contentType: 'application/pdf',
          ),
        );

        expect(url.queryParameters['X-Amz-Expires'], '300');
        expect(url.queryParameters, contains('X-Amz-Signature'));
        expect(
          url.queryParameters['response-content-type'],
          'application/pdf',
        );
        expect(
          url.queryParameters['response-content-disposition'],
          contains('Quarterly%20report.pdf'),
        );
      },
    );
  });

  test(
    'Given an S3CompatCloudStorage using presigned PUT uploads, '
    'when creating an upload description with default options, '
    'then it returns an upload description',
    () async {
      final storage = S3CompatCloudStorage(
        storageId: 'test-storage',
        accessKey: 'test-access-key',
        secretKey: 'test-secret-key',
        bucket: 'test-bucket',
        region: 'us-east-1',
        public: true,
        endpoints: CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        ),
        uploadStrategy: PresignedPutUploadStrategy(),
      );

      await expectLater(
        storage.createUploadDescription(
          session: _FakeSession(),
          path: 'uploads/file.txt',
        ),
        completion(isA<BinaryUploadDescription>()),
      );
    },
  );
}

class _FakeSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not implemented.');
}

// Simple mock S3Client for testing
class MockS3Client extends S3Client {
  http.Response? getObjectResponse;
  http.Response? headObjectResponse;
  http.Response? deleteObjectResponse;

  String? lastGetKey;
  String? lastHeadKey;
  String? lastDeleteKey;

  MockS3Client()
    : super(
        accessKey: 'test',
        secretKey: 'test',
        bucket: 'test',
        region: 'us-east-1',
        endpoints: CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        ),
      );

  @override
  Future<http.Response> getObject(String key) async {
    lastGetKey = key;
    return getObjectResponse ?? http.Response('', 404);
  }

  @override
  Future<http.Response> headObject(String key) async {
    lastHeadKey = key;
    return headObjectResponse ?? http.Response('', 404);
  }

  @override
  Future<http.Response> deleteObject(String key) async {
    lastDeleteKey = key;
    return deleteObjectResponse ?? http.Response('', 204);
  }
}

// Simple mock upload strategy for testing
class MockUploadStrategy implements S3UploadStrategy {
  Object? uploadError;
  bool canEnforceMaxFileSize = true;
  String? uploadedPath;
  ByteData? uploadedData;
  bool? uploadedPreventOverwrite;
  String? directUploadPath;
  Duration? directUploadExpiration;
  int? directUploadMaxFileSize;
  int? directUploadContentLength;

  UploadDescription directUploadDescriptionResult = BinaryUploadDescription(
    url: Uri.parse('https://example.com'),
  );

  @override
  String get uploadType => 'mock';

  @override
  bool get supportsPreventOverwrite => true;

  @override
  bool get supportsMaxFileSize => canEnforceMaxFileSize;

  @override
  Future<void> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    bool preventOverwrite = false,
  }) async {
    if (uploadError case final error?) throw error;
    uploadedPath = path;
    uploadedData = data;
    uploadedPreventOverwrite = preventOverwrite;
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    int? contentLength,
    bool preventOverwrite = false,
  }) async {
    directUploadPath = path;
    directUploadExpiration = expiration;
    directUploadMaxFileSize = maxFileSize;
    directUploadContentLength = contentLength;
    return directUploadDescriptionResult;
  }
}

/// Test wrapper that exposes internal methods for testing without Session.
class TestableS3CompatCloudStorage extends S3CompatCloudStorage {
  final MockS3Client mockClient;
  final MockUploadStrategy mockUploadStrategy;

  TestableS3CompatCloudStorage({
    required this.mockClient,
    required this.mockUploadStrategy,
    super.storageId = 'test-storage',
    super.accessKey = 'test-access-key',
    super.secretKey = 'test-secret-key',
    super.bucket = 'test-bucket',
    super.region = 'us-east-1',
    super.public = true,
    S3EndpointConfig? endpoints,
  }) : super(
         endpoints:
             endpoints ??
             CustomEndpointConfig(
               baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
             ),
         uploadStrategy: mockUploadStrategy,
         client: mockClient,
       );

  /// Test helper to call storeFile without a real Session.
  Future<void> testStoreFile(
    String path,
    ByteData data, {
    bool preventOverwrite = false,
  }) => storeFile(
    session: _FakeSession(),
    path: path,
    byteData: data,
    options: StoreFileOptions(preventOverwrite: preventOverwrite),
  );

  /// Test helper to call retrieveFile without a real Session.
  Future<ByteData> testRetrieveFile(String path) =>
      retrieveFile(session: _FakeSession(), path: path);

  /// Test helper to check file existence without a real Session.
  Future<bool> testFileExists(String path) =>
      fileExists(session: _FakeSession(), path: path);

  /// Test helper to get public URL without a real Session.
  Future<Uri> testPublicDownloadUrl(String path) =>
      publicDownloadUrl(session: _FakeSession(), path: path);

  /// Test helper to delete file without a real Session.
  Future<void> testDeleteFile(String path) async {
    await mockClient.deleteObject(path);
  }

  /// Test helper for an upload description without a real Session.
  Future<UploadDescription> testCreateUploadDescription(
    String path, {
    Duration expiration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
    int? contentLength,
    bool preventOverwrite = false,
  }) async {
    UploadOptions(
      maxFileSize: maxFileSize,
      contentLength: contentLength,
    ).validate();

    return uploadStrategy.createUploadDescription(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: expiration,
      maxFileSize: maxFileSize,
      public: public,
      endpoints: endpoints,
      contentLength: contentLength,
      preventOverwrite: preventOverwrite,
    );
  }

  /// Test helper for upload verification without a real Session.
  Future<bool> testVerifyUpload(String path) =>
      verifyUpload(session: _FakeSession(), path: path);
}
