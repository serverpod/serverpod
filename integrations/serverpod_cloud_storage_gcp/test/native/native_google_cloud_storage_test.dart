import 'dart:typed_data';

import 'package:googleapis/storage/v1.dart' as gcs;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_gcp/serverpod_cloud_storage_gcp.dart';
import 'package:test/test.dart';

class MockStorageApi extends Mock implements gcs.StorageApi {}

class MockObjectsResource extends Mock implements gcs.ObjectsResource {}

class MockObject extends Mock implements gcs.Object {}

class MockSession extends Mock implements Session {}

void main() {
  late MockSession mockSession;

  setUpAll(() {
    registerFallbackValue(gcs.DownloadOptions.metadata);
    registerFallbackValue(gcs.Object());
    registerFallbackValue(gcs.Media(Stream.empty(), 0));
  });

  setUp(() {
    mockSession = MockSession();
  });

  group('Given a NativeGoogleCloudStorage with public bucket', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      storage = NativeGoogleCloudStorage.withStorageApi(
        storageId: 'test-storage',
        bucket: 'test-bucket',
        public: true,
        storageApi: mockStorageApi,
      );
    });

    test('then storageId is set correctly', () {
      expect(storage.storageId, 'test-storage');
    });

    test('then bucket is set correctly', () {
      expect(storage.bucket, 'test-bucket');
    });

    test('then public is set correctly', () {
      expect(storage.public, isTrue);
    });

    group('when checking if a file exists', () {
      test('then it returns true when the object exists', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => MockObject());

        final exists = await storage.fileExists(
          session: mockSession,
          path: 'existing/file.txt',
        );

        expect(exists, isTrue);
        verify(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).called(1);
      });

      test('then it returns false when the object does not exist', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));

        final exists = await storage.fileExists(
          session: mockSession,
          path: 'missing/file.txt',
        );

        expect(exists, isFalse);
      });

      test('then it rethrows non-404 errors', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'error/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(500, 'Server Error'));

        expect(
          () =>
              storage.fileExists(session: mockSession, path: 'error/file.txt'),
          throwsA(isA<gcs.DetailedApiRequestError>()),
        );
      });
    });

    group('when storing a file', () {
      test('then it uploads with publicRead ACL', () async {
        when(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
          ),
        ).thenAnswer((_) async => MockObject());

        final data = ByteData(5);
        await storage.storeFile(
          session: mockSession,
          path: 'upload/test.txt',
          byteData: data,
        );

        verify(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: 'publicRead',
          ),
        ).called(1);
      });
    });

    group('when retrieving a file', () {
      test('then it returns the file data', () async {
        final fileContent = [1, 2, 3, 4, 5];
        final media = gcs.Media(
          Stream.value(fileContent),
          fileContent.length,
        );

        when(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => media);

        final result = await storage.retrieveFile(
          session: mockSession,
          path: 'existing/file.txt',
        );

        expect(result, isNotNull);
        expect(result!.buffer.asUint8List(), fileContent);
      });

      test('then it returns null for missing files', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));

        final result = await storage.retrieveFile(
          session: mockSession,
          path: 'missing/file.txt',
        );

        expect(result, isNull);
      });
    });

    group('when getting public URL', () {
      test('then it returns the URL for existing files', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => MockObject());

        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'file.txt',
        );

        expect(url, isNotNull);
        expect(
          url.toString(),
          'https://storage.googleapis.com/test-bucket/file.txt',
        );
      });

      test('then it returns null for missing files', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));

        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'missing.txt',
        );

        expect(url, isNull);
      });
    });

    group('when deleting a file', () {
      test('then it calls delete on the objects resource', () async {
        when(
          () => mockObjects.delete('test-bucket', 'to-delete.txt'),
        ).thenAnswer((_) async {});

        await storage.deleteFile(
          session: mockSession,
          path: 'to-delete.txt',
        );

        verify(
          () => mockObjects.delete('test-bucket', 'to-delete.txt'),
        ).called(1);
      });

      test('then it silently ignores 404 errors', () async {
        when(
          () => mockObjects.delete('test-bucket', 'already-deleted.txt'),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));

        await expectLater(
          storage.deleteFile(
            session: mockSession,
            path: 'already-deleted.txt',
          ),
          completes,
        );
      });

      test('then it rethrows non-404 errors', () async {
        when(
          () => mockObjects.delete('test-bucket', 'error.txt'),
        ).thenThrow(gcs.DetailedApiRequestError(500, 'Server Error'));

        expect(
          () => storage.deleteFile(session: mockSession, path: 'error.txt'),
          throwsA(isA<gcs.DetailedApiRequestError>()),
        );
      });
    });

    group('when creating direct upload description', () {
      test(
        'then it returns null when signing credentials are unavailable',
        () async {
          final description = await storage.createDirectFileUploadDescription(
            session: mockSession,
            path: 'upload.txt',
          );

          expect(description, isNull);
        },
      );
    });

    group('when verifying direct file upload', () {
      test('then it returns true when file exists', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'uploaded.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => MockObject());

        final verified = await storage.verifyDirectFileUpload(
          session: mockSession,
          path: 'uploaded.txt',
        );

        expect(verified, isTrue);
      });

      test('then it returns false when file does not exist', () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'not-uploaded.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));

        final verified = await storage.verifyDirectFileUpload(
          session: mockSession,
          path: 'not-uploaded.txt',
        );

        expect(verified, isFalse);
      });
    });
  });

  group('Given a NativeGoogleCloudStorage with private bucket', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      storage = NativeGoogleCloudStorage.withStorageApi(
        storageId: 'private-storage',
        bucket: 'private-bucket',
        public: false,
        storageApi: mockStorageApi,
      );
    });

    group('when storing a file', () {
      test('then it uploads without publicRead ACL', () async {
        when(
          () => mockObjects.insert(
            any(),
            'private-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
          ),
        ).thenAnswer((_) async => MockObject());

        final data = ByteData(5);
        await storage.storeFile(
          session: mockSession,
          path: 'private/file.txt',
          byteData: data,
        );

        verify(
          () => mockObjects.insert(
            any(),
            'private-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: null,
          ),
        ).called(1);
      });
    });

    group('when getting public URL', () {
      test('then it returns null for private buckets', () async {
        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'file.txt',
        );

        expect(url, isNull);
      });
    });
  });

  group('Given a NativeGoogleCloudStorage with custom public host', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      storage = NativeGoogleCloudStorage.withStorageApi(
        storageId: 'custom-host-storage',
        bucket: 'my-bucket',
        public: true,
        publicHost: 'cdn.example.com',
        storageApi: mockStorageApi,
      );
    });

    group('when getting public URL', () {
      test('then it uses the custom host', () async {
        when(
          () => mockObjects.get(
            'my-bucket',
            'file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => MockObject());

        final url = await storage.getPublicUrl(
          session: mockSession,
          path: 'file.txt',
        );

        expect(url, isNotNull);
        expect(url.toString(), 'https://cdn.example.com/file.txt');
      });
    });
  });
}
