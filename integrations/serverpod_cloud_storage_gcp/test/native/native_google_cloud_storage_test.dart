import 'dart:convert';
import 'dart:typed_data';

// Version 17 deprecated this library in favor of `package:google_cloud_storage`
// ignore: deprecated_member_use
import 'package:googleapis/storage/v1.dart' as gcs;
import 'package:googleapis_auth/auth_io.dart' as gcs;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_gcp/serverpod_cloud_storage_gcp.dart';
import 'package:test/test.dart';

/// Test-only service account JSON with a generated RSA key (not a real credential).
const _testServiceAccountJson = {
  'type': 'service_account',
  'client_id': '123456789',
  'client_email': 'test@test-project.iam.gserviceaccount.com',
  'private_key':
      '-----BEGIN PRIVATE KEY-----\n'
      'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxkSpRCFvuTbtG\n'
      'bVSwbxyr8UrkvOuiK37/Svmr55UKXL7ISTXTisr1S0SMpgolCYRHcE2WWXTAdyP9\n'
      'Qu9kOIiaa6puFtpSrUE3Lr89tyE9L9BR1NJmbQZO2eK4p802+gwSrhsk8W2eRgQp\n'
      '6jvGhfZOhc/JCRFQiaI71G15gjntLHoVeDmwzmUv0OBkxmpa6I7OHzUEcU00W8CX\n'
      'MuPUX69SDY7+yIwtjJWkr4/Shzvwcq0HEwT9lQnvS16l8UvWKuFW/0q0O5P5pEMY\n'
      'GfEJM7UwapEZFxeFQ5RPG9Q8dhOonOpelzW95oVY8uIwgpvWUnjHlR8B2feT1hXk\n'
      '1wjVX09tAgMBAAECggEABDiWctnZ75q0ReVm8uZtSM7CBZknw9GODGJl+CwXkFO/\n'
      'QEfHP7RdWe0/ClXkc1gcJ3jtYJKB/T+dINHfcCM3khjW8r+DKJ3QPqV969O84Uq6\n'
      'mcYPS1qHoMZlW+zh6rmRIbzhoyREbhOtg9PliwpXs4BS/cKEAXAIJdfJU28Lp/jm\n'
      'y8XSIydW4dbFpvCbgrG00nZpngHiNFojzVbkcCzCHM4o5W6FfKvIcVzeTd8et8vN\n'
      'ApCW+696QVrr1tpp3YKDi6UEqFEDmevn85LSlyjOb9BbbssL/f9Z4PmxY+DKzJeC\n'
      'w00Tuh/9qe7r1etQNohOO/J9kU8mCyzGNVcz+XjRCQKBgQDgx3Q6ZX+d9MwPeQ3V\n'
      'PYuMVsqcGsxdqKN7ky6xnW9yuZ0xyFGUbXKMamb/PU0PFYUkRcC/ZDUAcOxZkrz6\n'
      '3Y1hhrLYWjV2dYYPP64iAURD7nAA2iTY5QUpkPF6yYru+W6vO0jOq2FX+90WqZBc\n'
      'IuGcdTfLQ9onvBjf693oPqFgaQKBgQDKOvnkfIopO6aXs6+GiU0KU2o4TfL0MLKB\n'
      'tWzBU/o6EL8RkYo/dYKKMk3ErLXamTIrpdJ2aYzaGbxrK3SAvyZX0PkLcd0MXmQk\n'
      'dQ6f+Cnl2hC01m1X6Rr1GmSfqFITWot+cetoXg8Qe5gO5eLgbubeVY8uxnenedTk\n'
      'czBCpKlWZQKBgQCJL3HySgwPHV6Fev5ETOGkbzwM9hYQe2H7g6KV6F4iiMI1peqU\n'
      'ShAFPtNJp+Il+J5fuuqeZMwsTr8RFAuemCU3hnwUq0nB2IxPNjBStK8zPozBGGIw\n'
      'teXmrn2S0PqoSzeQXwBakiJBDoiq0iY29Vr4oFnDBtBYO+Z6k3vFyKO5MQKBgEHS\n'
      'blGrI4EGNFP+HSxp9hRdUB5haKmITCGhvnMydSh/GOGMAHZlNgbrFprkKBCtekHw\n'
      'qA74jerTI5uyOipJjR5aGyVZezwyYN/o5ci1ilWQ440omdBaQ/bxDz1UGNrJxsty\n'
      'ItAGhVq1D6oRswWfsy88o+zyljGBmwR8ZYHbfG5tAoGAcbcNzQ0SZvIfqhcT9TqB\n'
      'CVk3VFaNgZtK4kqvJ3Mz63NFwSz7Oc2evcrVpZ0DGznFP84CUEUNNK7Q2DFiGurS\n'
      'KU0ofhHRXHfCqrM1rFT3WgrhwuZ/I8MiSJ01lf2UHFgjlFubZYYsViUidzEXeBdN\n'
      'pj/dFNrOpQf2Ekt+C9xN6p4=\n'
      '-----END PRIVATE KEY-----\n',
};

class MockStorageApi extends Mock implements gcs.StorageApi {}

class MockObjectsResource extends Mock implements gcs.ObjectsResource {}

class MockObject extends Mock implements gcs.Object {}

class MockSession extends Mock implements Session {}

class MockAuthClient extends Mock implements gcs.AuthClient {}

void main() {
  late MockSession mockSession;

  setUpAll(() {
    registerFallbackValue(gcs.DownloadOptions.metadata);
    registerFallbackValue(gcs.Object());
    registerFallbackValue(gcs.Media(Stream.empty(), 0));
    registerFallbackValue(Uri.parse('https://example.com'));
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

    test(
      'when accessing storageId '
      'then it returns the configured value',
      () {
        expect(storage.storageId, 'test-storage');
      },
    );

    test(
      'when accessing bucket '
      'then it returns the configured value',
      () {
        expect(storage.bucket, 'test-bucket');
      },
    );

    test(
      'when accessing public '
      'then it returns the configured value',
      () {
        expect(storage.public, isTrue);
      },
    );

    group('Given an existing file', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '0'));
      });

      test(
        'when checking if it exists then it returns true',
        () async {
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
        },
      );

      test('when statting it, then it returns metadata', () async {
        final object = gcs.Object()
          ..size = '42'
          ..updated = DateTime.utc(2026, 8, 21)
          ..contentType = 'text/plain'
          ..cacheControl = 'max-age=60'
          ..contentDisposition = 'inline'
          ..contentEncoding = 'gzip'
          ..etag = 'etag-value'
          ..metadata = {'tenant': 'acme'};
        when(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => object);

        final stat = await storage.statFile(
          session: mockSession,
          path: 'existing/file.txt',
        );

        expect(stat.size, 42);
        expect(stat.contentType, 'text/plain');
        expect(stat.cacheControl, 'max-age=60');
        expect(stat.contentDisposition, 'inline');
        expect(stat.contentEncoding, 'gzip');
        expect(stat.etag, 'etag-value');
        expect(stat.custom, {'tenant': 'acme'});
      });
    });

    group('Given a file that does not exist', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));
      });

      test(
        'when checking if it exists then it returns false',
        () async {
          final exists = await storage.fileExists(
            session: mockSession,
            path: 'missing/file.txt',
          );

          expect(exists, isFalse);
        },
      );
    });

    group('Given a server error', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'error/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(500, 'Server Error'));
      });

      test(
        'when checking if a file exists, '
        'then it throws a CloudStorageException',
        () {
          expect(
            () => storage.fileExists(
              session: mockSession,
              path: 'error/file.txt',
            ),
            throwsA(isA<CloudStorageException>()),
          );
        },
      );
    });

    test(
      'when storing a file then it uploads with publicRead ACL',
      () async {
        when(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
            ifGenerationMatch: any(named: 'ifGenerationMatch'),
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
            ifGenerationMatch: null,
          ),
        ).called(1);
      },
    );

    test('when storing metadata then it maps it to the GCS object', () async {
      when(
        () => mockObjects.insert(
          any(),
          'test-bucket',
          uploadMedia: any(named: 'uploadMedia'),
          predefinedAcl: any(named: 'predefinedAcl'),
          ifGenerationMatch: any(named: 'ifGenerationMatch'),
        ),
      ).thenAnswer((_) async => MockObject());

      await storage.storeFile(
        session: mockSession,
        path: 'upload/metadata.txt',
        byteData: ByteData(5),
        options: const StoreFileOptions(
          metadata: FileMetadata(
            contentType: 'text/custom',
            cacheControl: 'max-age=60',
            contentDisposition: 'inline',
            contentEncoding: 'gzip',
            custom: {'tenant': 'acme'},
          ),
        ),
      );

      final captured = verify(
        () => mockObjects.insert(
          captureAny(),
          'test-bucket',
          uploadMedia: captureAny(named: 'uploadMedia'),
          predefinedAcl: any(named: 'predefinedAcl'),
          ifGenerationMatch: any(named: 'ifGenerationMatch'),
        ),
      ).captured;
      final object = captured[0] as gcs.Object;
      final media = captured[1] as gcs.Media;
      expect(object.contentType, 'text/custom');
      expect(object.cacheControl, 'max-age=60');
      expect(object.contentDisposition, 'inline');
      expect(object.contentEncoding, 'gzip');
      expect(object.metadata, {'tenant': 'acme'});
      expect(media.contentType, 'text/custom');
    });

    test(
      'when storing a file with preventOverwrite '
      'then it passes ifGenerationMatch 0',
      () async {
        when(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
            ifGenerationMatch: any(named: 'ifGenerationMatch'),
          ),
        ).thenAnswer((_) async => MockObject());

        final data = ByteData(5);
        await storage.storeFile(
          session: mockSession,
          path: 'upload/test.txt',
          byteData: data,
          options: StoreFileOptions(preventOverwrite: true),
        );

        verify(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: 'publicRead',
            ifGenerationMatch: '0',
          ),
        ).called(1);
      },
    );

    group('Given an existing file with content', () {
      final fileContent = [1, 2, 3, 4, 5];

      setUp(() {
        final httpResponseBytes = Uint8List.fromList([
          72,
          84,
          84,
          80,
          ...fileContent,
        ]);
        final responseBody = Uint8List.sublistView(
          httpResponseBytes,
          4,
        );
        final media = gcs.Media(
          Stream.value(responseBody),
          fileContent.length,
        );

        when(
          () => mockObjects.get(
            'test-bucket',
            'existing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => media);
      });

      test(
        'when retrieving the file then it returns the file data',
        () async {
          final result = await storage.retrieveFile(
            session: mockSession,
            path: 'existing/file.txt',
          );

          expect(result, isNotNull);
          expect(result.buffer.asUint8List(), fileContent);
          expect(result.offsetInBytes, 0);
          expect(result.lengthInBytes, fileContent.length);
          expect(result.buffer.lengthInBytes, fileContent.length);
        },
      );
    });

    group('Given a missing file', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing/file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));
      });

      test(
        'when retrieving the file, '
        'then it throws a CloudStorageFileNotFoundException',
        () async {
          await expectLater(
            () => storage.retrieveFile(
              session: mockSession,
              path: 'missing/file.txt',
            ),
            throwsA(isA<CloudStorageFileNotFoundException>()),
          );
        },
      );
    });

    group('Given an existing file in the bucket', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '0'));
      });

      test(
        'when getting the public URL then it returns the URL',
        () async {
          final url = await storage.publicDownloadUrl(
            session: mockSession,
            path: 'file.txt',
          );

          expect(url, isNotNull);
          expect(
            url.toString(),
            'https://storage.googleapis.com/test-bucket/file.txt',
          );
        },
      );
    });

    group('Given a missing file in the bucket', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'missing.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));
      });

      test(
        'when getting the public URL, '
        'then it throws a CloudStorageFileNotFoundException',
        () async {
          await expectLater(
            () => storage.publicDownloadUrl(
              session: mockSession,
              path: 'missing.txt',
            ),
            throwsA(isA<CloudStorageFileNotFoundException>()),
          );
        },
      );
    });

    group('Given a file to delete', () {
      setUp(() {
        when(
          () => mockObjects.delete('test-bucket', 'to-delete.txt'),
        ).thenAnswer((_) async {});
      });

      test(
        'when deleting the file then it calls delete on the objects resource',
        () async {
          await storage.deleteFile(
            session: mockSession,
            path: 'to-delete.txt',
          );

          verify(
            () => mockObjects.delete('test-bucket', 'to-delete.txt'),
          ).called(1);
        },
      );
    });

    group('Given a file that has already been deleted', () {
      setUp(() {
        when(
          () => mockObjects.delete('test-bucket', 'already-deleted.txt'),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));
      });

      test(
        'when deleting the file then it silently ignores the 404 error',
        () async {
          await expectLater(
            storage.deleteFile(
              session: mockSession,
              path: 'already-deleted.txt',
            ),
            completes,
          );
        },
      );
    });

    group('Given a server error on delete', () {
      setUp(() {
        when(
          () => mockObjects.delete('test-bucket', 'error.txt'),
        ).thenThrow(gcs.DetailedApiRequestError(500, 'Server Error'));
      });

      test(
        'when deleting a file, then it throws a CloudStorageException',
        () async {
          expect(
            () => storage.deleteFile(session: mockSession, path: 'error.txt'),
            throwsA(isA<CloudStorageException>()),
          );
        },
      );
    });

    group('Given no signing credentials', () {
      test(
        'when creating a direct upload description, '
        'then it throws a CloudStorageUnsupportedOperationException',
        () async {
          await expectLater(
            () => storage.createUploadDescription(
              session: mockSession,
              path: 'upload.txt',
            ),
            throwsA(isA<CloudStorageUnsupportedOperationException>()),
          );
        },
      );
    });

    group('Given an uploaded file', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'uploaded.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '0'));
      });

      test(
        'when verifying the direct file upload then it returns true',
        () async {
          final verified = await storage.verifyUpload(
            session: mockSession,
            path: 'uploaded.txt',
          );

          expect(verified, isTrue);
        },
      );
    });

    group('Given a file that was not uploaded', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'not-uploaded.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(404, 'Not Found'));
      });

      test(
        'when verifying the direct file upload then it returns false',
        () async {
          final verified = await storage.verifyUpload(
            session: mockSession,
            path: 'not-uploaded.txt',
          );

          expect(verified, isFalse);
        },
      );
    });

    group('Given a storage error when retrieving a file', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'test-bucket',
            'upload.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenThrow(gcs.DetailedApiRequestError(500, 'Internal error'));
      });

      test(
        'when verifying an upload, '
        'then it throws a CloudStorageException',
        () async {
          await expectLater(
            () => storage.verifyUpload(
              session: mockSession,
              path: 'upload.txt',
            ),
            throwsA(
              isA<CloudStorageException>().having(
                (e) => e.message,
                'message',
                contains('DetailedApiRequestError'),
              ),
            ),
          );
        },
      );
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

    test(
      'when storing a file then it uploads without publicRead ACL',
      () async {
        when(
          () => mockObjects.insert(
            any(),
            'private-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
            ifGenerationMatch: any(named: 'ifGenerationMatch'),
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
            ifGenerationMatch: null,
          ),
        ).called(1);
      },
    );

    test(
      'when getting public URL, '
      'then it throws a CloudStorageUnsupportedOperationException',
      () async {
        await expectLater(
          () => storage.publicDownloadUrl(
            session: mockSession,
            path: 'file.txt',
          ),
          throwsA(isA<CloudStorageUnsupportedOperationException>()),
        );
      },
    );
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

    group('Given an existing file', () {
      setUp(() {
        when(
          () => mockObjects.get(
            'my-bucket',
            'file.txt',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '0'));
      });

      test(
        'when getting the public URL then it uses the custom host',
        () async {
          final url = await storage.publicDownloadUrl(
            session: mockSession,
            path: 'file.txt',
          );

          expect(url, isNotNull);
          expect(url.toString(), 'https://cdn.example.com/file.txt');
        },
      );
    });
  });

  group('Given a NativeGoogleCloudStorage with signing credentials,', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;
    late MockSession mockSession;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      mockSession = MockSession();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      final credentials = gcs.ServiceAccountCredentials.fromJson(
        _testServiceAccountJson,
      );

      storage = NativeGoogleCloudStorage.withSigningCredentials(
        storageId: 'signed-storage',
        bucket: 'test-bucket',
        public: true,
        storageApi: mockStorageApi,
        credentials: credentials,
      );
    });

    test(
      'when creating a direct upload description '
      'then it returns a valid upload description',
      () async {
        final description = await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/test-file.txt',
        );

        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        expect(data['type'], 'binary');
        expect(data['method'], 'PUT');
        expect(data['file-name'], 'test-file.txt');
        expect(data['headers'], isA<Map>());
        expect(data['headers']['Content-Type'], 'text/plain');
      },
    );

    test(
      'when creating a direct upload description '
      'then the URL contains required GCP signed URL parameters',
      () async {
        final description = await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/image.png',
          options: UploadOptions(
            expirationDuration: Duration(minutes: 15),
          ),
        );

        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final url = data['url'] as String;

        expect(url, startsWith('https://storage.googleapis.com/'));
        expect(url, contains('test-bucket'));
        expect(url, contains('uploads/image.png'));
        expect(url, contains('X-Goog-Algorithm=GOOG4-RSA-SHA256'));
        expect(url, contains('X-Goog-Credential='));
        expect(url, contains('X-Goog-Date='));
        expect(url, contains('X-Goog-Expires=900')); // 15 minutes
        expect(
          url,
          contains(
            'X-Goog-SignedHeaders=content-type%3Bhost%3Bx-goog-acl%3B'
            'x-goog-content-length-range',
          ),
        );
        expect(url, contains('X-Goog-Signature='));
      },
    );

    test(
      'when creating a temporary download URL, '
      'then it signs response overrides and expiration',
      () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'downloads/report.pdf',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '10'));

        final url = await storage.temporaryDownloadUrl(
          session: mockSession,
          path: 'downloads/report.pdf',
          options: const TemporaryDownloadUrlOptions(
            expirationDuration: Duration(minutes: 5),
            downloadFileName: 'Quarterly report.pdf',
            contentType: 'application/pdf',
          ),
        );

        expect(url.queryParameters['X-Goog-Expires'], '300');
        expect(
          url.queryParameters['response-content-type'],
          'application/pdf',
        );
        expect(
          url.queryParameters['response-content-disposition'],
          contains('Quarterly%20report.pdf'),
        );
        expect(url.queryParameters, contains('X-Goog-Signature'));
      },
    );

    test(
      'when creating a temporary download URL with a download file name, '
      'then the signed query percent-encodes reserved characters',
      () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'downloads/report.pdf',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '10'));

        final url = await storage.temporaryDownloadUrl(
          session: mockSession,
          path: 'downloads/report.pdf',
          options: const TemporaryDownloadUrlOptions(
            downloadFileName: 'report.pdf',
          ),
        );

        // GCS V4 signing requires everything outside A-Za-z0-9-._~ to be
        // percent-encoded in the canonical query string.
        expect(url.query, isNot(matches(RegExp(r"[!*'()]"))));
      },
    );

    test(
      'when a temporary download URL expiration exceeds 7 days, '
      'then it throws a CloudStorageException',
      () async {
        when(
          () => mockObjects.get(
            'test-bucket',
            'downloads/report.pdf',
            downloadOptions: any(named: 'downloadOptions'),
          ),
        ).thenAnswer((_) async => (gcs.Object()..size = '10'));

        await expectLater(
          () => storage.temporaryDownloadUrl(
            session: mockSession,
            path: 'downloads/report.pdf',
            options: const TemporaryDownloadUrlOptions(
              expirationDuration: Duration(days: 8),
            ),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'GCS signed URLs cannot be valid for more than 7 days.',
            ),
          ),
        );
      },
    );

    test(
      'when creating a direct upload description '
      'then it detects MIME types correctly',
      () async {
        final pngDescription = await storage.createUploadDescription(
          session: mockSession,
          path: 'images/photo.png',
        );
        final pngData =
            jsonDecode(pngDescription.encode()) as Map<String, dynamic>;
        expect(pngData['headers']['Content-Type'], 'image/png');

        final jpgDescription = await storage.createUploadDescription(
          session: mockSession,
          path: 'images/photo.jpg',
        );
        final jpgData =
            jsonDecode(jpgDescription.encode()) as Map<String, dynamic>;
        expect(jpgData['headers']['Content-Type'], 'image/jpeg');

        final pdfDescription = await storage.createUploadDescription(
          session: mockSession,
          path: 'docs/document.pdf',
        );
        final pdfData =
            jsonDecode(pdfDescription.encode()) as Map<String, dynamic>;
        expect(pdfData['headers']['Content-Type'], 'application/pdf');

        final unknownDescription = await storage.createUploadDescription(
          session: mockSession,
          path: 'data/file.unknownext',
        );
        final unknownData =
            jsonDecode(unknownDescription.encode()) as Map<String, dynamic>;
        expect(
          unknownData['headers']['Content-Type'],
          'application/octet-stream',
        );
      },
    );

    test(
      'when creating a direct upload description '
      'then it includes public-read ACL header when public is true',
      () async {
        final description = await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/test-file.txt',
        );

        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        expect(data['headers']['x-goog-acl'], 'public-read');
      },
    );

    group('Given a contentLength option', () {
      test(
        'when creating a direct upload description '
        'then it includes Content-Length in headers',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(contentLength: 5000),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          expect(data['headers']['Content-Length'], '5000');
          expect(data['headers']['x-goog-content-length-range'], '5000,5000');
        },
      );

      test(
        'when creating a direct upload description '
        'then the signed URL includes content-length in signed headers',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(contentLength: 5000),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('content-length'));
        },
      );
    });

    group('Given a contentLength exceeding maxFileSize', () {
      test(
        'when creating a direct upload description '
        'then it throws',
        () async {
          expect(
            () => storage.createUploadDescription(
              session: mockSession,
              path: 'uploads/test-file.txt',
              options: UploadOptions(
                maxFileSize: 1024,
                contentLength: 2048,
              ),
            ),
            throwsA(isA<CloudStorageException>()),
          );
        },
      );
    });

    group('Given a contentLength equal to maxFileSize', () {
      test(
        'when creating a direct upload description '
        'then it succeeds',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(
              maxFileSize: 5000,
              contentLength: 5000,
            ),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          expect(data['headers']['Content-Length'], '5000');
        },
      );
    });

    group('Given no contentLength option', () {
      test(
        'when creating a direct upload description '
        'then it does not include Content-Length in headers',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers.containsKey('Content-Length'), isFalse);
          expect(
            headers['x-goog-content-length-range'],
            '0,${10 * 1024 * 1024}',
          );
        },
      );

      test(
        'when maxFileSize is specified, '
        'then it constrains the signed upload range',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(maxFileSize: 2048),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          expect(data['headers']['x-goog-content-length-range'], '0,2048');
        },
      );
    });

    group('Given a preventOverwrite option', () {
      test(
        'when creating a direct upload description '
        'then it includes x-goog-if-generation-match header set to 0',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(preventOverwrite: true),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;
          expect(headers['x-goog-if-generation-match'], '0');
        },
      );

      test(
        'when creating a direct upload description '
        'then the signed URL includes x-goog-if-generation-match in signed headers',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
            options: UploadOptions(preventOverwrite: true),
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('x-goog-if-generation-match'));
        },
      );
    });

    group('Given no preventOverwrite option', () {
      test(
        'when creating a direct upload description '
        'then it does not include x-goog-if-generation-match header',
        () async {
          final description = await storage.createUploadDescription(
            session: mockSession,
            path: 'uploads/test-file.txt',
          );

          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(
            headers.containsKey('x-goog-if-generation-match'),
            isFalse,
          );
        },
      );
    });
  });

  group('Given a NativeGoogleCloudStorage with public set to false', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;
    late MockSession mockSession;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      mockSession = MockSession();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      final credentials = gcs.ServiceAccountCredentials.fromJson(
        _testServiceAccountJson,
      );

      storage = NativeGoogleCloudStorage.withSigningCredentials(
        storageId: 'private-storage',
        bucket: 'test-bucket',
        public: false,
        storageApi: mockStorageApi,
        credentials: credentials,
      );
    });

    test(
      'when creating a direct upload description, '
      'then it omits legacy object ACL headers',
      () async {
        final description = await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/private-file.txt',
        );

        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        expect(data['headers'], isNot(contains('x-goog-acl')));
      },
    );
  });

  group('Given a NativeGoogleCloudStorage with ADC (authClient) signing,', () {
    late NativeGoogleCloudStorage storage;
    late MockStorageApi mockStorageApi;
    late MockObjectsResource mockObjects;
    late MockAuthClient mockAuthClient;
    late MockSession mockSession;

    setUp(() {
      mockStorageApi = MockStorageApi();
      mockObjects = MockObjectsResource();
      mockAuthClient = MockAuthClient();
      mockSession = MockSession();
      when(() => mockStorageApi.objects).thenReturn(mockObjects);

      // Mock the IAM signBlob response - return a fixed signature for any
      // request to the signBlob endpoint.
      when(
        () => mockAuthClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
          encoding: any(named: 'encoding'),
        ),
      ).thenAnswer((_) async {
        return http.Response(
          jsonEncode({
            'signedBlob': base64.encode([1, 2, 3, 4]),
          }),
          200,
        );
      });

      storage = NativeGoogleCloudStorage.withAuthClient(
        storageId: 'adc-storage',
        bucket: 'test-bucket',
        public: true,
        storageApi: mockStorageApi,
        email: 'sa@project.iam.gserviceaccount.com',
        authClient: mockAuthClient,
      );
    });

    test(
      'when creating a direct upload description '
      'then it calls IAM signBlob API',
      () async {
        await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/test-file.txt',
        );

        // Verify signBlob was called with the correct endpoint
        final captured = verify(
          () => mockAuthClient.post(
            captureAny(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).captured;

        final url = captured.first as Uri;
        expect(url.host, 'iamcredentials.googleapis.com');
        expect(
          url.path,
          contains('sa@project.iam.gserviceaccount.com:signBlob'),
        );
      },
    );

    test(
      'when creating a direct upload description '
      'then it returns a valid upload description with signed URL',
      () async {
        final description = await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/test-file.txt',
        );

        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        expect(data['type'], 'binary');
        expect(data['method'], 'PUT');
        expect(data['file-name'], 'test-file.txt');

        final url = data['url'] as String;
        expect(url, startsWith('https://storage.googleapis.com/'));
        expect(url, contains('X-Goog-Algorithm=GOOG4-RSA-SHA256'));
        expect(url, contains('X-Goog-Signature='));
        expect(
          url,
          contains(
            Uri.encodeComponent('sa@project.iam.gserviceaccount.com'),
          ),
        );
      },
    );

    test(
      'when creating a direct upload description '
      'then the signBlob request contains the payload',
      () async {
        await storage.createUploadDescription(
          session: mockSession,
          path: 'uploads/test-file.txt',
        );

        final captured = verify(
          () => mockAuthClient.post(
            any(),
            headers: any(named: 'headers'),
            body: captureAny(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).captured;

        final body =
            jsonDecode(captured.first as String) as Map<String, dynamic>;
        expect(body, contains('payload'));
        // payload should be base64-encoded string-to-sign
        expect(body['payload'], isA<String>());
        expect(() => base64.decode(body['payload'] as String), returnsNormally);
      },
    );

    group('Given a signBlob error response', () {
      setUp(() {
        when(
          () => mockAuthClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          ),
        ).thenAnswer((_) async {
          return http.Response('Permission denied', 403);
        });
      });

      test(
        'when creating a direct upload description then it throws',
        () async {
          expect(
            () => storage.createUploadDescription(
              session: mockSession,
              path: 'uploads/test-file.txt',
            ),
            throwsA(isA<CloudStorageException>()),
          );
        },
      );
    });

    test(
      'when storing a file '
      'then it works the same as with service account credentials',
      () async {
        when(
          () => mockObjects.insert(
            any(),
            'test-bucket',
            uploadMedia: any(named: 'uploadMedia'),
            predefinedAcl: any(named: 'predefinedAcl'),
            ifGenerationMatch: any(named: 'ifGenerationMatch'),
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
            ifGenerationMatch: null,
          ),
        ).called(1);
      },
    );
  });
}
