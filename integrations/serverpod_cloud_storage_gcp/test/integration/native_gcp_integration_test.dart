@TestOn('vm')
@Tags(['integration', 'gcp-native'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_cloud_storage_gcp/src/native/native_google_cloud_storage.dart';
import 'package:test/test.dart';

class _MockSession extends Mock implements Session {}

/// Loads native GCS configuration from environment variables.
///
/// Returns null if credentials are not configured, causing tests to skip.
NativeGoogleCloudStorage? _createStorageFromEnvironment() {
  final serviceAccountJson =
      Platform.environment['SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON'];
  final bucket = Platform.environment['SERVERPOD_TEST_GCP_BUCKET'];

  if (serviceAccountJson == null || bucket == null) {
    return null;
  }

  return NativeGoogleCloudStorage.withServiceAccountJson(
    storageId: 'test',
    bucket: bucket,
    public: false,
    serviceAccountJson: serviceAccountJson,
  );
}

void main() {
  final storage = _createStorageFromEnvironment();

  final skipReason = storage == null
      ? 'GCP native credentials not configured in environment. '
            'Set SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON and '
            'SERVERPOD_TEST_GCP_BUCKET to run these tests.'
      : null;

  group('Given a real GCP Native bucket', skip: skipReason, () {
    late Session session;
    final testFiles = <String>[];

    setUpAll(() {
      session = _MockSession();
    });

    tearDownAll(() async {
      for (final path in testFiles) {
        try {
          await storage!.deleteFile(session: session, path: path);
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

    group('when performing basic file operations', () {
      test(
        'then uploading a file succeeds and the file can be retrieved',
        () async {
          final path = testPath('upload-test.txt');
          final content = 'Hello, GCP Native! ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage!.storeFile(
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
            retrieved!.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'then fileExists returns true for an uploaded file',
        () async {
          final path = testPath('exists-test.txt');
          final data = ByteData.view(
            Uint8List.fromList('test content'.codeUnits).buffer,
          );

          await storage!.storeFile(
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
        'then fileExists returns false for a non-existent file',
        () async {
          final exists = await storage!.fileExists(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          expect(exists, isFalse);
        },
      );

      test(
        'then deleting an uploaded file removes it from the bucket',
        () async {
          final path = testPath('delete-test.txt');
          final data = ByteData.view(
            Uint8List.fromList('to be deleted'.codeUnits).buffer,
          );

          await storage!.storeFile(
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
    });

    group('when overwriting an existing file', () {
      test(
        'then the new content replaces the old content',
        () async {
          final path = testPath('overwrite-test.txt');
          final originalContent = 'Original content';
          final originalData = ByteData.view(
            Uint8List.fromList(originalContent.codeUnits).buffer,
          );

          await storage!.storeFile(
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
            retrieved!.buffer.asUint8List(),
          );
          expect(retrievedContent, updatedContent);
        },
      );
    });

    group('when retrieving or deleting non-existent files', () {
      test(
        'then retrieving a non-existent file returns null',
        () async {
          final retrieved = await storage!.retrieveFile(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          expect(retrieved, isNull);
        },
      );

      test(
        'then deleting a non-existent file does not throw',
        () async {
          // Should complete without error
          await storage!.deleteFile(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );
        },
      );
    });

    group('when working with binary data', () {
      test(
        'then uploading a binary file preserves the exact bytes',
        () async {
          final path = testPath('binary-test.bin');
          final bytes = Uint8List.fromList(List.generate(256, (i) => i));
          final data = ByteData.view(bytes.buffer);

          await storage!.storeFile(
            session: session,
            path: path,
            byteData: data,
          );

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          expect(retrieved!.buffer.asUint8List(), bytes);
        },
      );

      test(
        'then uploading a larger file (1MB) succeeds',
        () async {
          final path = testPath('large-file-test.bin');
          final bytes = Uint8List.fromList(
            List.generate(1024 * 1024, (i) => i % 256),
          );
          final data = ByteData.view(bytes.buffer);

          await storage!.storeFile(
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

    group('when creating direct upload descriptions', () {
      test(
        'then a valid upload description is returned',
        () async {
          final path = testPath('presigned-description-test.txt');

          final description = await storage!.createDirectFileUploadDescription(
            session: session,
            path: path,
            expirationDuration: Duration(minutes: 5),
            maxFileSize: 10 * 1024 * 1024,
          );

          expect(description, isNotNull);
          expect(description, isNotEmpty);

          // Remove from cleanup since we didn't actually upload
          testFiles.remove(path);
        },
      );

      test(
        'then a file can be uploaded using the description via FileUploader',
        () async {
          final path = testPath('direct-upload-test.txt');
          final content = 'Direct upload content ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage!.createDirectFileUploadDescription(
            session: session,
            path: path,
            expirationDuration: Duration(minutes: 5),
            maxFileSize: 10 * 1024 * 1024,
          );

          expect(description, isNotNull);

          // Use FileUploader to upload (simulates client-side)
          final uploader = FileUploader(description!);
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          // Verify the file was actually uploaded
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved!.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'then a file can be uploaded with contentLength via FileUploader',
        () async {
          final path = testPath('direct-upload-content-length-test.txt');
          final content = 'Content with known length ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage!.createDirectFileUploadDescription(
            session: session,
            path: path,
            expirationDuration: Duration(minutes: 5),
            maxFileSize: 10 * 1024 * 1024,
            contentLength: data.lengthInBytes,
          );

          expect(description, isNotNull);

          final uploader = FileUploader(description!);
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          final retrievedContent = String.fromCharCodes(
            retrieved!.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'then verifyDirectFileUpload returns true for an uploaded file',
        () async {
          final path = testPath('verify-upload-test.txt');
          final content = 'Verify upload content ${DateTime.now()}';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          final description = await storage!.createDirectFileUploadDescription(
            session: session,
            path: path,
            expirationDuration: Duration(minutes: 5),
            maxFileSize: 10 * 1024 * 1024,
          );

          expect(description, isNotNull);

          final uploader = FileUploader(description!);
          final success = await uploader.uploadByteData(data);
          expect(success, isTrue);

          final verified = await storage.verifyDirectFileUpload(
            session: session,
            path: path,
          );

          expect(verified, isTrue);
        },
      );

      test(
        'then verifyDirectFileUpload returns false for a non-existent file',
        () async {
          final verified = await storage!.verifyDirectFileUpload(
            session: session,
            path:
                'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
          );

          expect(verified, isFalse);
        },
      );

      test(
        'then a binary file can be uploaded using the description via FileUploader',
        () async {
          final path = testPath('direct-upload-binary-test.bin');
          final bytes = Uint8List.fromList(
            List.generate(1024, (i) => i % 256),
          );
          final data = ByteData.view(bytes.buffer);

          final description = await storage!.createDirectFileUploadDescription(
            session: session,
            path: path,
            expirationDuration: Duration(minutes: 5),
            maxFileSize: 10 * 1024 * 1024,
          );

          expect(description, isNotNull);

          // Use FileUploader to upload
          final uploader = FileUploader(description!);
          final success = await uploader.uploadByteData(data);

          expect(success, isTrue);

          // Verify the file content matches
          final retrieved = await storage.retrieveFile(
            session: session,
            path: path,
          );

          expect(retrieved, isNotNull);
          expect(retrieved!.buffer.asUint8List(), bytes);
        },
      );
    });

    group('when working with paths containing special characters', () {
      test(
        'then paths with spaces are handled correctly',
        () async {
          final path = testPath('path with spaces/file name.txt');
          final content = 'Content with spaces in path';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage!.storeFile(
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
            retrieved!.buffer.asUint8List(),
          );
          expect(retrievedContent, content);
        },
      );

      test(
        'then paths with unicode characters are handled correctly',
        () async {
          final path = testPath('unicode-test-file.txt');
          final content = 'Unicode content: Hello World';
          final data = ByteData.view(
            Uint8List.fromList(content.codeUnits).buffer,
          );

          await storage!.storeFile(
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
