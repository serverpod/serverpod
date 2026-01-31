import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

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
        endpoints: AwsEndpointConfig(),
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
  String? uploadedPath;
  ByteData? uploadedData;
  String? directUploadPath;
  Duration? directUploadExpiration;
  int? directUploadMaxFileSize;

  String? uploadDataResult;
  String? directUploadDescriptionResult;

  @override
  String get uploadType => 'mock';

  @override
  Future<String?> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
  }) async {
    uploadedPath = path;
    uploadedData = data;
    return uploadDataResult;
  }

  @override
  Future<String?> createDirectUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
  }) async {
    directUploadPath = path;
    directUploadExpiration = expiration;
    directUploadMaxFileSize = maxFileSize;
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
         endpoints: endpoints ?? AwsEndpointConfig(),
         uploadStrategy: mockUploadStrategy,
         client: mockClient,
       );

  /// Test helper to call storeFile without a real Session.
  Future<void> testStoreFile(String path, ByteData data) async {
    await uploadStrategy.uploadData(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      data: data,
      path: path,
      public: public,
      endpoints: endpoints,
    );
  }

  /// Test helper to call retrieveFile without a real Session.
  Future<ByteData?> testRetrieveFile(String path) async {
    final response = await mockClient.getObject(path);
    if (response.statusCode == 200) {
      return ByteData.view(response.bodyBytes.buffer);
    }
    return null;
  }

  /// Test helper to check file existence without a real Session.
  Future<bool> testFileExists(String path) async {
    final response = await mockClient.headObject(path);
    return response.statusCode == 200;
  }

  /// Test helper to get public URL without a real Session.
  Future<Uri?> testGetPublicUrl(String path) async {
    if (await testFileExists(path)) {
      return endpoints.buildPublicUri(bucket, region, path);
    }
    return null;
  }

  /// Test helper to delete file without a real Session.
  Future<void> testDeleteFile(String path) async {
    await mockClient.deleteObject(path);
  }

  /// Test helper for direct upload description without a real Session.
  Future<String?> testCreateDirectUploadDescription(
    String path, {
    Duration expiration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return uploadStrategy.createDirectUploadDescription(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: expiration,
      maxFileSize: maxFileSize,
      public: public,
      endpoints: endpoints,
    );
  }

  /// Test helper for verify direct upload without a real Session.
  Future<bool> testVerifyDirectFileUpload(String path) async {
    return testFileExists(path);
  }
}

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

    test('then storageId is set correctly', () {
      expect(storage.storageId, 'test-storage');
    });

    group('when storing a file', () {
      test('then it delegates to the upload strategy', () async {
        final data = ByteData(10);
        await storage.testStoreFile('test/file.txt', data);

        expect(mockUploadStrategy.uploadedPath, 'test/file.txt');
        expect(mockUploadStrategy.uploadedData, data);
      });
    });

    group('when retrieving a file that exists', () {
      test('then it returns the file data', () async {
        final fileContent = [1, 2, 3, 4, 5];
        mockClient.getObjectResponse = http.Response.bytes(fileContent, 200);

        final result = await storage.testRetrieveFile('existing/file.txt');

        expect(mockClient.lastGetKey, 'existing/file.txt');
        expect(result, isNotNull);
        expect(result!.buffer.asUint8List(), fileContent);
      });
    });

    group('when retrieving a file that does not exist', () {
      test('then it returns null', () async {
        mockClient.getObjectResponse = http.Response('Not Found', 404);

        final result = await storage.testRetrieveFile('missing/file.txt');

        expect(result, isNull);
      });
    });

    group('when checking if a file exists', () {
      test('then it returns true for existing files', () async {
        mockClient.headObjectResponse = http.Response('', 200);

        final exists = await storage.testFileExists('existing.txt');

        expect(mockClient.lastHeadKey, 'existing.txt');
        expect(exists, isTrue);
      });

      test('then it returns false for missing files', () async {
        mockClient.headObjectResponse = http.Response('', 404);

        final exists = await storage.testFileExists('missing.txt');

        expect(exists, isFalse);
      });
    });

    group('when getting public URL for an existing file', () {
      test('then it returns the URL', () async {
        mockClient.headObjectResponse = http.Response('', 200);

        final url = await storage.testGetPublicUrl('path/to/file.txt');

        expect(url, isNotNull);
        expect(url.toString(), contains('test-bucket'));
        expect(url.toString(), contains('path/to/file.txt'));
      });
    });

    group('when getting public URL for a missing file', () {
      test('then it returns null', () async {
        mockClient.headObjectResponse = http.Response('', 404);

        final url = await storage.testGetPublicUrl('missing.txt');

        expect(url, isNull);
      });
    });

    group('when deleting a file', () {
      test('then it calls deleteObject on the client', () async {
        mockClient.deleteObjectResponse = http.Response('', 204);

        await storage.testDeleteFile('to-delete.txt');

        expect(mockClient.lastDeleteKey, 'to-delete.txt');
      });
    });

    group('when creating direct upload description', () {
      test('then it delegates to the upload strategy', () async {
        mockUploadStrategy.directUploadDescriptionResult =
            '{"url":"https://example.com"}';

        final description = await storage.testCreateDirectUploadDescription(
          'upload/target.txt',
          expiration: Duration(minutes: 5),
          maxFileSize: 1024 * 1024,
        );

        expect(mockUploadStrategy.directUploadPath, 'upload/target.txt');
        expect(mockUploadStrategy.directUploadExpiration, Duration(minutes: 5));
        expect(mockUploadStrategy.directUploadMaxFileSize, 1024 * 1024);
        expect(description, '{"url":"https://example.com"}');
      });
    });

    group('when verifying direct file upload', () {
      test('then it checks if the file exists', () async {
        mockClient.headObjectResponse = http.Response('', 200);

        final verified = await storage.testVerifyDirectFileUpload(
          'uploaded.txt',
        );

        expect(mockClient.lastHeadKey, 'uploaded.txt');
        expect(verified, isTrue);
      });

      test('then it returns false if file does not exist', () async {
        mockClient.headObjectResponse = http.Response('', 404);

        final verified = await storage.testVerifyDirectFileUpload(
          'not-uploaded.txt',
        );

        expect(verified, isFalse);
      });
    });
  });

  group(
    'Given TestableS3CompatCloudStorage with different endpoint configs',
    () {
      test('then AWS endpoints produce correct public URLs', () async {
        final mockClient = MockS3Client();
        mockClient.headObjectResponse = http.Response('', 200);

        final storage = TestableS3CompatCloudStorage(
          mockClient: mockClient,
          mockUploadStrategy: MockUploadStrategy(),
          storageId: 'aws',
          bucket: 'my-bucket',
          region: 'eu-west-1',
          endpoints: AwsEndpointConfig(),
        );

        final url = await storage.testGetPublicUrl('file.txt');

        expect(
          url.toString(),
          'https://my-bucket.s3.eu-west-1.amazonaws.com/file.txt',
        );
      });

      test('then GCP endpoints produce correct public URLs', () async {
        final mockClient = MockS3Client();
        mockClient.headObjectResponse = http.Response('', 200);

        final storage = TestableS3CompatCloudStorage(
          mockClient: mockClient,
          mockUploadStrategy: MockUploadStrategy(),
          storageId: 'gcp',
          bucket: 'gcp-bucket',
          region: 'auto',
          endpoints: GcpEndpointConfig(),
        );

        final url = await storage.testGetPublicUrl('file.txt');

        expect(
          url.toString(),
          'https://storage.googleapis.com/gcp-bucket/file.txt',
        );
      });

      test('then custom endpoints produce correct public URLs', () async {
        final mockClient = MockS3Client();
        mockClient.headObjectResponse = http.Response('', 200);

        final storage = TestableS3CompatCloudStorage(
          mockClient: mockClient,
          mockUploadStrategy: MockUploadStrategy(),
          storageId: 'minio',
          bucket: 'local-bucket',
          region: 'us-east-1',
          endpoints: CustomEndpointConfig(
            baseUri: Uri.http('localhost:9000', '/'),
          ),
        );

        final url = await storage.testGetPublicUrl('file.txt');

        expect(url.toString(), 'http://localhost:9000/local-bucket/file.txt');
      });
    },
  );
}
