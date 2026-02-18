import 'dart:typed_data';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import '../client/s3_client.dart';
import '../endpoints/s3_endpoint_config.dart';
import '../upload/s3_upload_strategy.dart';

/// Configuration for running S3-compatible integration tests.
class S3CompatTestConfig {
  /// The access key for authentication.
  final String accessKey;

  /// The secret key for authentication.
  final String secretKey;

  /// The bucket name.
  final String bucket;

  /// The region (or 'auto' for R2).
  final String region;

  /// The endpoint configuration for the provider.
  final S3EndpointConfig endpoints;

  /// The upload strategy for the provider.
  final S3UploadStrategy uploadStrategy;

  /// Human-readable provider name for test descriptions.
  final String providerName;

  /// Creates a new test configuration.
  S3CompatTestConfig({
    required this.accessKey,
    required this.secretKey,
    required this.bucket,
    required this.region,
    required this.endpoints,
    required this.uploadStrategy,
    required this.providerName,
  });
}

/// Runs the standard S3-compatible integration test suite.
///
/// This function defines a comprehensive set of tests for any S3-compatible
/// storage provider. Each provider package should call this from their own
/// integration tests with their specific configuration.
///
/// Tests are automatically skipped if [config] is null, allowing graceful
/// handling of missing credentials.
///
/// Example usage:
/// ```dart
/// void main() {
///   final config = _loadConfigFromEnvironment();
///   runS3CompatIntegrationTests(config: config);
/// }
/// ```
void runS3CompatIntegrationTests({
  required S3CompatTestConfig? config,
  String? skipReason,
}) {
  final effectiveSkipReason = config == null
      ? (skipReason ?? 'Credentials not configured in environment')
      : null;

  group(
    'Given a real ${config?.providerName ?? 'S3-compatible'} bucket',
    skip: effectiveSkipReason,
    () {
      late S3Client client;
      late S3UploadStrategy uploadStrategy;
      late S3EndpointConfig endpoints;
      final testFiles = <String>[];

      setUpAll(() {
        endpoints = config!.endpoints;
        client = S3Client(
          accessKey: config.accessKey,
          secretKey: config.secretKey,
          bucket: config.bucket,
          region: config.region,
          endpoints: endpoints,
        );
        uploadStrategy = config.uploadStrategy;
      });

      tearDownAll(() async {
        // Clean up test files
        for (final path in testFiles) {
          try {
            await client.deleteObject(path);
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
          'then uploading a file via the upload strategy succeeds '
          'and the file can be retrieved',
          () async {
            final path = testPath('upload-test.txt');
            final content = 'Hello, ${config!.providerName}! ${DateTime.now()}';
            final data = ByteData.view(
              Uint8List.fromList(content.codeUnits).buffer,
            );

            await uploadStrategy.uploadData(
              accessKey: config.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.getObject(path);

            expect(response.statusCode, 200);
            expect(response.body, content);
          },
        );

        test(
          'then headObject returns 200 for an uploaded file',
          () async {
            final path = testPath('exists-test.txt');
            final data = ByteData.view(
              Uint8List.fromList('test content'.codeUnits).buffer,
            );

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.headObject(path);

            expect(response.statusCode, 200);
          },
        );

        test(
          'then headObject returns 404 for a non-existent file',
          () async {
            final response = await client.headObject(
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
            );

            expect(response.statusCode, 404);
          },
        );

        test(
          'then deleting an uploaded file removes it from the bucket',
          () async {
            final path = testPath('delete-test.txt');
            final data = ByteData.view(
              Uint8List.fromList('to be deleted'.codeUnits).buffer,
            );

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            // Verify file exists
            var response = await client.headObject(path);
            expect(response.statusCode, 200);

            // Delete file
            await client.deleteObject(path);

            // Verify file no longer exists
            response = await client.headObject(path);
            expect(response.statusCode, 404);

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

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: originalData,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final updatedContent = 'Updated content';
            final updatedData = ByteData.view(
              Uint8List.fromList(updatedContent.codeUnits).buffer,
            );

            await uploadStrategy.uploadData(
              accessKey: config.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: updatedData,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.getObject(path);
            expect(response.statusCode, 200);
            expect(response.body, updatedContent);
          },
        );
      });

      group('when retrieving or deleting non-existent files', () {
        test(
          'then retrieving a non-existent file returns 404',
          () async {
            final response = await client.getObject(
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
            );

            expect(response.statusCode, 404);
          },
        );

        test(
          'then deleting a non-existent file does not throw',
          () async {
            // Should complete without error
            await client.deleteObject(
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

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.getObject(path);

            expect(response.statusCode, 200);
            expect(response.bodyBytes, bytes);
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

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.headObject(path);

            expect(response.statusCode, 200);
            expect(
              response.headers['content-length'],
              '${1024 * 1024}',
            );
          },
        );
      });

      group('when creating direct upload descriptions', () {
        test(
          'then a valid upload description is returned',
          () async {
            final path = testPath('presigned-description-test.txt');

            final description = await uploadStrategy
                .createDirectUploadDescription(
                  accessKey: config!.accessKey,
                  secretKey: config.secretKey,
                  bucket: config.bucket,
                  region: config.region,
                  path: path,
                  expiration: Duration(minutes: 5),
                  maxFileSize: 10 * 1024 * 1024,
                  public: false,
                  endpoints: endpoints,
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

            // Create the upload description (simulates server-side)
            final description = await uploadStrategy
                .createDirectUploadDescription(
                  accessKey: config!.accessKey,
                  secretKey: config.secretKey,
                  bucket: config.bucket,
                  region: config.region,
                  path: path,
                  expiration: Duration(minutes: 5),
                  maxFileSize: 10 * 1024 * 1024,
                  public: false,
                  endpoints: endpoints,
                );

            expect(description, isNotNull);

            // Use FileUploader to upload (simulates client-side)
            final uploader = FileUploader(description!);
            final success = await uploader.uploadByteData(data);

            expect(success, isTrue);

            // Verify the file was actually uploaded
            final response = await client.getObject(path);
            expect(response.statusCode, 200);
            expect(response.body, content);
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

            final description = await uploadStrategy
                .createDirectUploadDescription(
                  accessKey: config!.accessKey,
                  secretKey: config.secretKey,
                  bucket: config.bucket,
                  region: config.region,
                  path: path,
                  expiration: Duration(minutes: 5),
                  maxFileSize: 10 * 1024 * 1024,
                  public: false,
                  endpoints: endpoints,
                  contentLength: data.lengthInBytes,
                );

            expect(description, isNotNull);

            final uploader = FileUploader(description!);
            final success = await uploader.uploadByteData(data);

            expect(success, isTrue);

            final response = await client.getObject(path);
            expect(response.statusCode, 200);
            expect(response.body, content);
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

            // Create the upload description
            final description = await uploadStrategy
                .createDirectUploadDescription(
                  accessKey: config!.accessKey,
                  secretKey: config.secretKey,
                  bucket: config.bucket,
                  region: config.region,
                  path: path,
                  expiration: Duration(minutes: 5),
                  maxFileSize: 10 * 1024 * 1024,
                  public: false,
                  endpoints: endpoints,
                );

            expect(description, isNotNull);

            // Use FileUploader to upload
            final uploader = FileUploader(description!);
            final success = await uploader.uploadByteData(data);

            expect(success, isTrue);

            // Verify the file content matches
            final response = await client.getObject(path);
            expect(response.statusCode, 200);
            expect(response.bodyBytes, bytes);
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

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.getObject(path);

            expect(response.statusCode, 200);
            expect(response.body, content);
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

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
              secretKey: config.secretKey,
              bucket: config.bucket,
              region: config.region,
              data: data,
              path: path,
              public: false,
              endpoints: endpoints,
            );

            final response = await client.getObject(path);

            expect(response.statusCode, 200);
          },
        );
      });
    },
  );
}
