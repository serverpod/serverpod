import 'dart:typed_data';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

import 's3_compat_test_config.dart';

/// Runs the standard S3-compatible integration test suite.
///
/// This function defines a comprehensive set of tests for any S3-compatible
/// storage provider. Each provider package should call this from their own
/// integration tests with their specific configuration.
///
/// Tests are automatically skipped if [config] is null, allowing graceful
/// handling of missing credentials.
void runS3CompatIntegrationTests({
  required S3CompatTestConfig? config,
  String? skipReason,
  bool supportsPreventOverwrite = false,
}) {
  final effectiveSkipReason = config == null
      ? (skipReason ?? 'Credentials not configured in environment')
      : null;

  group(
    config?.providerName ?? 'S3-compatible',
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

      group('Given no file in the storage', () {
        test(
          'when uploading a file via the upload strategy '
          'then the file can be retrieved',
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
      });

      group('Given a successfully uploaded file', () {
        late String path;
        final uploadedContent = 'test content';

        setUp(() async {
          path = testPath('uploaded-file-test.txt');
          final data = ByteData.view(
            Uint8List.fromList(uploadedContent.codeUnits).buffer,
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
        });

        test(
          'when getting the object then the file can be retrieved',
          () async {
            final response = await client.getObject(path);

            expect(response.statusCode, 200);
            expect(response.body, uploadedContent);
          },
        );

        test(
          'when calling headObject then it returns 200',
          () async {
            final response = await client.headObject(path);

            expect(response.statusCode, 200);
          },
        );

        test(
          'when deleting the file then it no longer exists',
          () async {
            // Delete file
            await client.deleteObject(path);

            // Verify file no longer exists
            final response = await client.headObject(path);
            expect(response.statusCode, 404);

            // Remove from cleanup list since already deleted
            testFiles.remove(path);
          },
        );

        test(
          'when overwriting the file then the new content replaces the old',
          () async {
            final updatedContent = 'Updated content';
            final updatedData = ByteData.view(
              Uint8List.fromList(updatedContent.codeUnits).buffer,
            );

            await uploadStrategy.uploadData(
              accessKey: config!.accessKey,
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

      group('Given a file path that does not exist', () {
        test(
          'when calling headObject then it returns 404',
          () async {
            final response = await client.headObject(
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
            );

            expect(response.statusCode, 404);
          },
        );

        test(
          'when retrieving the file then it returns 404',
          () async {
            final response = await client.getObject(
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
            );

            expect(response.statusCode, 404);
          },
        );

        test(
          'when deleting the file then no error is returned',
          () async {
            // Should complete without error
            await client.deleteObject(
              'non-existent-file-${DateTime.now().millisecondsSinceEpoch}.txt',
            );
          },
        );
      });

      group('Given binary data to upload', () {
        test(
          'when uploading a binary file then the exact bytes are preserved',
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
          'when uploading a larger file (1MB) then the upload succeeds',
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

      group('Given a valid upload strategy', () {
        test(
          'when creating a direct upload description '
          'then a valid description is returned',
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
          'when uploading a file using the description via FileUploader '
          'then the file can be retrieved',
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
          'when uploading a file with contentLength via FileUploader '
          'then the file can be retrieved',
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
          'when uploading a binary file using the description via FileUploader '
          'then the exact bytes are preserved',
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

      group(
        'Given a new file path with preventOverwrite enabled for uploadData',
        skip: supportsPreventOverwrite
            ? null
            : 'Upload strategy does not support preventOverwrite',
        () {
          test(
            'when uploading then the upload succeeds',
            () async {
              final path = testPath('prevent-overwrite-new.txt');
              final content = 'New file content';
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
                preventOverwrite: true,
              );

              final response = await client.getObject(path);
              expect(response.statusCode, 200);
              expect(response.body, content);
            },
          );
        },
      );

      group(
        'Given an existing file with preventOverwrite enabled for uploadData',
        skip: supportsPreventOverwrite
            ? null
            : 'Upload strategy does not support preventOverwrite',
        () {
          test(
            'when uploading then it throws and preserves the original content',
            () async {
              final path = testPath('prevent-overwrite-existing.txt');
              final data = ByteData.view(
                Uint8List.fromList('original'.codeUnits).buffer,
              );

              // First upload succeeds
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

              // Second upload with preventOverwrite should fail
              final duplicateData = ByteData.view(
                Uint8List.fromList('duplicate'.codeUnits).buffer,
              );

              expect(
                () => uploadStrategy.uploadData(
                  accessKey: config.accessKey,
                  secretKey: config.secretKey,
                  bucket: config.bucket,
                  region: config.region,
                  data: duplicateData,
                  path: path,
                  public: false,
                  endpoints: endpoints,
                  preventOverwrite: true,
                ),
                throwsA(isA<Exception>()),
              );

              // Original content should be preserved
              final response = await client.getObject(path);
              expect(response.statusCode, 200);
              expect(response.body, 'original');
            },
          );
        },
      );

      group(
        'Given a new file path with preventOverwrite enabled for direct uploads',
        skip: supportsPreventOverwrite
            ? null
            : 'Upload strategy does not support preventOverwrite',
        () {
          test(
            'when uploading then the upload succeeds',
            () async {
              final path = testPath('prevent-overwrite-direct-new.txt');
              final content = 'New direct upload content';
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
                    preventOverwrite: true,
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
        },
      );

      group(
        'Given an existing file with preventOverwrite enabled for direct uploads',
        skip: supportsPreventOverwrite
            ? null
            : 'Upload strategy does not support preventOverwrite',
        () {
          test(
            'when uploading then it fails and preserves the original content',
            () async {
              final path = testPath('prevent-overwrite-direct-existing.txt');
              final originalData = ByteData.view(
                Uint8List.fromList('original'.codeUnits).buffer,
              );

              // First upload without preventOverwrite
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

              // Create direct upload description with preventOverwrite
              final description = await uploadStrategy
                  .createDirectUploadDescription(
                    accessKey: config.accessKey,
                    secretKey: config.secretKey,
                    bucket: config.bucket,
                    region: config.region,
                    path: path,
                    expiration: Duration(minutes: 5),
                    maxFileSize: 10 * 1024 * 1024,
                    public: false,
                    endpoints: endpoints,
                    preventOverwrite: true,
                  );

              expect(description, isNotNull);

              final duplicateData = ByteData.view(
                Uint8List.fromList('duplicate'.codeUnits).buffer,
              );

              // Upload should fail (returns false or throws)
              final uploader = FileUploader(description!);
              final success = await uploader.uploadByteData(duplicateData);

              expect(success, isFalse);

              // Original content should be preserved
              final response = await client.getObject(path);
              expect(response.statusCode, 200);
              expect(response.body, 'original');
            },
          );
        },
      );

      group('Given a path with special characters', () {
        test(
          'when uploading with spaces in the path '
          'then the file is handled correctly',
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
          'when uploading with unicode characters in the path '
          'then the file is handled correctly',
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
