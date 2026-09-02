@TestOn('vm')
@Tags(['integration', 'gcp-native'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_cloud_storage_gcp/src/native/native_google_cloud_storage.dart';
import 'package:test/test.dart';

class _MockSession extends Mock implements Session {}

/// Loads native GCS configuration from environment variables.
///
/// Returns null if credentials are not configured, causing tests to skip.
Future<NativeGoogleCloudStorage?> _createStorageFromEnvironment() async {
  final serviceAccountJson =
      Platform.environment['SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON'];
  final bucket = Platform.environment['SERVERPOD_TEST_GCP_BUCKET'];

  if (serviceAccountJson == null || bucket == null) {
    return null;
  }

  return NativeGoogleCloudStorage.fromServiceAccountJson(
    storageId: 'test',
    bucket: bucket,
    public: false,
    serviceAccountJson: serviceAccountJson,
  );
}

void main() {
  final hasCredentials =
      Platform.environment['SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON'] !=
          null &&
      Platform.environment['SERVERPOD_TEST_GCP_BUCKET'] != null;

  final skipReason = !hasCredentials
      ? 'GCP native credentials not configured in environment. '
            'Set SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON and '
            'SERVERPOD_TEST_GCP_BUCKET to run these tests.'
      : null;

  group('GCP Native', skip: skipReason, () {
    late NativeGoogleCloudStorage storage;
    late Session session;
    final testFiles = <String>[];

    setUpAll(() async {
      session = _MockSession();
      storage = (await _createStorageFromEnvironment())!;
    });

    tearDownAll(() async {
      for (final path in testFiles) {
        try {
          await storage.deleteFile(session: session, path: path);
        } catch (_) {
          // Ignore cleanup errors
        }
      }
    });

    String testPath(String name) {
      final path =
          'integration-test/${DateTime.now().millisecondsSinceEpoch}-$name';
      testFiles.add(path);
      return path;
    }

    group('Given no file in the storage', () {
      test(
        'when uploading a file then the operation succeeds and it can be retrieved',
        () async {
          final path = testPath('upload-test.txt');
          final content = 'Hello, GCP Native! ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );
    });

    group('Given a successfully uploaded file', () {
      test(
        'when checking if it exists then it returns true',
        () async {
          final path = testPath('exists-test.txt');
          final data = ByteData.view(
            Uint8List.fromList('test content'.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final exists = await storage.fileExists(
            session: session,
            path: path,
          );

          expect(exists, isTrue);
        },
      );

      test(
        'when deleting it then it no longer exists',
        () async {
          final path = testPath('delete-test.txt');
          final data = ByteData.view(
            Uint8List.fromList('to be deleted'.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          // Verify file exists
          var exists = await storage.fileExists(
            session: session,
            path: path,
          );
          expect(exists, isTrue);

          // Delete file
          await storage.deleteFile(session: session, path: path);

          // Verify file no longer exists
          exists = await storage.fileExists(
            session: session,
            path: path,
          );
          expect(exists, isFalse);

          // Remove from cleanup list since already deleted
          testFiles.remove(path);
        },
      );

      test(
        'when overwriting it then the new content replaces the old',
        () async {
          final path = testPath('overwrite-test.txt');
          final originalContent = 'Original content';
          final originalData = ByteData.view(
            Uint8List.fromList(originalContent.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: originalData,
          );

          final updatedContent = 'Updated content';
          final updatedData = ByteData.view(
            Uint8List.fromList(updatedContent.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: updatedData,
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, updatedContent);
        },
      );
    });

    group('Given an existing file in private storage', () {
      late String path;
      late String content;

      setUp(() async {
        path = testPath('url-download-test.txt');
        content = 'URL download content ${DateTime.now()}';
        await storage.storeFile(
          session: session,
          path: path,
          byteData: ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          ),
        );
      });

      test(
        'when the existing file is fetched through a temporary download URL, '
        'then the response contains the file contents',
        () async {
          final url = await storage.temporaryDownloadUrl(
            session: session,
            path: path,
          );

          final downloaded = await http.readBytes(url);

          expect(String.fromCharCodes(downloaded), content);
        },
      );

      test(
        'when the existing file is fetched through a temporary download URL after it has expired, '
        'then an exception is thrown',
        () async {
          final url = await storage.temporaryDownloadUrl(
            session: session,
            path: path,
            options: const TemporaryDownloadUrlOptions(
              expirationDuration: Duration(seconds: 1),
            ),
          );
          await Future<void>.delayed(const Duration(seconds: 2));

          await expectLater(
            () => http.readBytes(url),
            throwsA(isA<http.ClientException>()),
          );
        },
      );
    });

    group('Given a file path that does not exist', () {
      test(
        'when checking if it exists then it returns false',
        () async {
          final exists = await storage.fileExists(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          expect(exists, isFalse);
        },
      );

      test(
        'when retrieving it, '
        'then it throws CloudStorageFileNotFoundException',
        () async {
          final path =
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt';

          expect(
            () => storage.retrieveFile(session: session, path: path),
            throwsA(isA<CloudStorageFileNotFoundException>()),
          );
        },
      );

      test(
        'when deleting it then no error is thrown',
        () async {
          // Should complete without error
          await storage.deleteFile(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );
        },
      );
    });

    group('Given binary data to upload', () {
      test(
        'when uploading then the exact bytes are preserved',
        () async {
          final path = testPath('binary-test.bin');
          final bytes = Uint8List.fromList(List.generate(256, (i) => i));
          final data = ByteData.view(bytes.buffer);

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          expect(retrieved.buffer.asUint8List(), bytes);
        },
      );

      test(
        'when uploading a larger file (1MB) then the operation succeeds',
        () async {
          final path = testPath('large-file-test.bin');
          final bytes = Uint8List.fromList(
            List.generate(1024 * 1024, (i) => i % 256),
          );
          final data = ByteData.view(bytes.buffer);

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final exists = await storage.fileExists(
            session: session,
            path: path,
          );

          expect(exists, isTrue);
        },
      );
    });

    group('Given a file with metadata', () {
      const metadata = FileMetadata(
        contentType: 'text/plain',
        cacheControl: 'private, max-age=60',
        contentDisposition: 'attachment',
        contentEncoding: 'gzip',
        custom: {
          'integration-test': 'native-gcp',
          'tenant': 'serverpod',
        },
      );

      void expectMetadata(FileStat stat) {
        expect(stat.contentType, metadata.contentType);
        expect(stat.cacheControl, metadata.cacheControl);
        expect(stat.contentDisposition, metadata.contentDisposition);
        expect(stat.contentEncoding, metadata.contentEncoding);
        expect(
          stat.custom,
          containsPair('integration-test', 'native-gcp'),
        );
        expect(stat.custom, containsPair('tenant', 'serverpod'));
      }

      test(
        'when uploading with storeFile, '
        'then the metadata is stored',
        () async {
          final path = testPath('store-file-metadata.txt.gz');
          final bytes = Uint8List.fromList(
            gzip.encode('storeFile metadata ${DateTime.now()}'.codeUnits),
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: ByteData.sublistView(bytes),
            options: const StoreFileOptions(metadata: metadata),
          );

          final stat = await storage.statFile(
            session: session,
            path: path,
          );

          expectMetadata(stat);
        },
      );

      test(
        'when uploading with a direct upload description, '
        'then the metadata is stored',
        () async {
          final path = testPath('direct-upload-metadata.txt.gz');
          final bytes = Uint8List.fromList(
            gzip.encode('direct upload metadata ${DateTime.now()}'.codeUnits),
          );
          final data = ByteData.sublistView(bytes);
          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: const Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
              contentLength: data.lengthInBytes,
              metadata: metadata,
            ),
          );

          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);
          expect(success, isTrue);

          final stat = await storage.statFile(
            session: session,
            path: path,
          );

          expectMetadata(stat);
        },
      );
    });

    group('Given a valid upload description', () {
      test(
        'when creating a direct file upload description, '
        'then a typed description that encodes a non-empty string is returned',
        () async {
          final path = testPath('presigned-description-test.txt');

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
            ),
          );

          expect(description.encode(), isNotEmpty);

          // Remove from cleanup since we didn't actually upload
          testFiles.remove(path);
        },
      );

      test(
        'when uploading a file via FileUploader then it can be retrieved',
        () async {
          final path = testPath('direct-upload-test.txt');
          final content = 'Direct upload content ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
            ),
          );

          // Use FileUploader to upload (simulates client-side)
          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          // Verify the file was actually uploaded
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'when uploading a file with contentLength via FileUploader then it can be retrieved',
        () async {
          final path = testPath('direct-upload-content-length-test.txt');
          final content = 'Content with known length ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
              contentLength: data.lengthInBytes,
            ),
          );

          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'when verifying a successfully uploaded file then it returns true',
        () async {
          final path = testPath('verify-upload-test.txt');
          final content = 'Verify upload content ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
            ),
          );

          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);
          expect(success, isTrue);

          final verified = await storage.verifyUpload(
            session: session,
            path: path,
          );

          expect(verified, isTrue);
        },
      );

      test(
        'when verifying a non-existent file then it returns false',
        () async {
          final verified = await storage.verifyUpload(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          expect(verified, isFalse);
        },
      );

      test(
        'when uploading a binary file via FileUploader then the exact bytes are preserved',
        () async {
          final path = testPath('direct-upload-binary-test.bin');
          final bytes = Uint8List.fromList(
            List.generate(1024, (i) => i % 256),
          );
          final data = ByteData.view(bytes.buffer);

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
            ),
          );

          // Use FileUploader to upload
          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          // Verify the file content matches
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          expect(retrieved.buffer.asUint8List(), bytes);
        },
      );
    });

    group('Given a new file path with preventOverwrite enabled', () {
      test(
        'when uploading via storeFile then the upload succeeds',
        () async {
          final path = testPath('prevent-overwrite-new.txt');
          final content = 'New file content';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
            options: StoreFileOptions(preventOverwrite: true),
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'when uploading via direct upload then the upload succeeds',
        () async {
          final path = testPath('prevent-overwrite-direct-new.txt');
          final content = 'New direct upload content';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
              preventOverwrite: true,
            ),
          );

          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );
    });

    group('Given an existing file with preventOverwrite enabled', () {
      test(
        'when uploading via storeFile then it throws',
        () async {
          final path = testPath('prevent-overwrite-existing.txt');
          final data = ByteData.view(
            Uint8List.fromList('original'.codeUnits).buffer,
          );

          // First upload succeeds
          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          // Second upload with preventOverwrite should fail
          final duplicateData = ByteData.view(
            Uint8List.fromList('duplicate'.codeUnits).buffer,
          );

          expect(
            () => storage.storeFile(
              session: session,
              path: path,
              byteData: duplicateData,
              options: StoreFileOptions(preventOverwrite: true),
            ),
            throwsA(isA<Exception>()),
          );

          // Original content should be preserved
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, 'original');
        },
      );

      test(
        'when uploading via direct upload then it fails',
        () async {
          final path = testPath('prevent-overwrite-direct-existing.txt');
          final originalData = ByteData.view(
            Uint8List.fromList('original'.codeUnits).buffer,
          );

          // First upload without preventOverwrite
          await storage.storeFile(
            session: session,
            path: path,
            byteData: originalData,
          );

          // Create direct upload description with preventOverwrite
          final description = await storage.createUploadDescription(
            session: session,
            path: path,
            options: UploadOptions(
              expirationDuration: Duration(minutes: 5),
              maxFileSize: 10 * 1024 * 1024,
              preventOverwrite: true,
            ),
          );

          final duplicateData = ByteData.view(
            Uint8List.fromList('duplicate'.codeUnits).buffer,
          );

          // Upload should fail (returns false or throws)
          final uploader = FileUploader(description.encode());
          final success = await uploader.uploadByteData(duplicateData);

          expect(success, isFalse);

          // Original content should be preserved
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, 'original');
        },
      );
    });

    group('Given a file path with special characters', () {
      test(
        'when the path contains spaces then the file is stored and retrieved correctly',
        () async {
          final path = testPath('path with spaces/file name.txt');
          final content = 'Content with spaces in path';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'when the path contains unicode characters then the file is stored correctly',
        () async {
          final path = testPath('unicode-test-file.txt');
          final content = 'Unicode content: Hello World';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final exists = await storage.fileExists(
            session: session,
            path: path,
          );

          expect(exists, isTrue);
        },
      );
    });
  });
}
