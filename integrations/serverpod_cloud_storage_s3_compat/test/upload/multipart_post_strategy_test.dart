import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a MultipartPostUploadStrategy '
    'when reading uploadType '
    'then it is multipart',
    () {
      final strategy = MultipartPostUploadStrategy();

      expect(strategy.uploadType, 'multipart');
    },
  );

  group('Given a MultipartPostUploadStrategy with custom endpoints,', () {
    late MultipartPostUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = CustomEndpointConfig(
        baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
      );
    });

    test(
      'when uploading data with preventOverwrite, '
      'then it throws a CloudStorageException',
      () async {
        await expectLater(
          () => strategy.uploadData(
            accessKey: 'AKIAIOSFODNN7EXAMPLE',
            secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
            bucket: 'my-bucket',
            region: 'us-east-1',
            data: ByteData(1),
            path: 'uploads/test-file.txt',
            public: true,
            endpoints: endpoints,
            preventOverwrite: true,
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('cannot prevent overwrites'),
            ),
          ),
        );
      },
    );

    test(
      'when creating an upload description with preventOverwrite, '
      'then it throws a CloudStorageException',
      () async {
        await expectLater(
          () => strategy.createUploadDescription(
            accessKey: 'AKIAIOSFODNN7EXAMPLE',
            secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
            bucket: 'my-bucket',
            region: 'us-east-1',
            path: 'uploads/test-file.txt',
            expiration: const Duration(minutes: 10),
            maxFileSize: 1024,
            public: true,
            endpoints: endpoints,
            preventOverwrite: true,
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('cannot prevent overwrites'),
            ),
          ),
        );
      },
    );

    group('when creating direct upload description', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'AKIAIOSFODNN7EXAMPLE',
          secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/test-file.txt',
          expiration: Duration(minutes: 10),
          maxFileSize: 10 * 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it returns a valid JSON', () {
        expect(() => jsonDecode(description.encode()), returnsNormally);
      });

      test('then it contains the correct upload URL', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(
          data['url'],
          'https://s3.us-east-1.amazonaws.com/my-bucket',
        );
      });

      test('then it specifies multipart type', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['type'], 'multipart');
      });

      test('then it specifies file as the field name', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['field'], 'file');
      });

      test('then it contains the filename', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['file-name'], 'test-file.txt');
      });

      test('then it contains required request fields', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;

        expect(fields, containsPair('key', 'uploads/test-file.txt'));
        expect(fields, containsPair('acl', 'public-read'));
        expect(fields, contains('X-Amz-Credential'));
        expect(fields, containsPair('X-Amz-Algorithm', 'AWS4-HMAC-SHA256'));
        expect(fields, contains('X-Amz-Date'));
        expect(fields, contains('Policy'));
        expect(fields, contains('X-Amz-Signature'));
      });
    });

    test(
      'when creating direct upload description with metadata, '
      'then metadata is included in request fields',
      () async {
        final description = await strategy.createUploadDescription(
          accessKey: 'AKIAIOSFODNN7EXAMPLE',
          secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/test-file.txt',
          expiration: const Duration(minutes: 10),
          maxFileSize: 1024,
          public: true,
          endpoints: endpoints,
          metadata: const FileMetadata(
            contentType: 'application/custom',
            custom: {'Tenant': 'acme'},
          ),
        );
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;

        expect(fields['Content-Type'], 'application/custom');
        expect(fields['x-amz-meta-tenant'], 'acme');
        expect(fields, isNot(contains('x-amz-meta-Tenant')));
      },
    );

    test(
      'when creating direct upload description with an explicit zero content length, '
      'then an empty content length range is encoded',
      () async {
        final description = await strategy.createUploadDescription(
          accessKey: 'AKIAIOSFODNN7EXAMPLE',
          secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/empty.txt',
          expiration: const Duration(minutes: 10),
          maxFileSize: 0,
          contentLength: 0,
          public: true,
          endpoints: endpoints,
        );
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;
        final policy =
            jsonDecode(
                  utf8.decode(base64.decode(fields['Policy'] as String)),
                )
                as Map<String, dynamic>;

        expect(
          policy['conditions'],
          contains(equals(['content-length-range', 0, 0])),
        );
      },
    );

    test(
      'when creating direct upload description that expires in under a minute, '
      'then the policy stays valid for the requested window',
      () async {
        const expiration = Duration(seconds: 30);
        final before = DateTime.now().toUtc();

        final description = await strategy.createUploadDescription(
          accessKey: 'AKIAIOSFODNN7EXAMPLE',
          secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/test-file.txt',
          expiration: expiration,
          maxFileSize: 1024,
          public: true,
          endpoints: endpoints,
        );
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;
        final policy =
            jsonDecode(
                  utf8.decode(base64.decode(fields['Policy'] as String)),
                )
                as Map<String, dynamic>;

        final expiresAt = DateTime.parse(policy['expiration'] as String);
        final stillValidAt = before.add(
          expiration - const Duration(seconds: 5),
        );

        expect(
          expiresAt.isAfter(stillValidAt),
          isTrue,
          reason: 'Policy expires at $expiresAt, before $stillValidAt.',
        );
      },
    );

    group('when creating private upload description', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'AKIAIOSFODNN7EXAMPLE',
          secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'private/secret.txt',
          expiration: Duration(minutes: 5),
          maxFileSize: 1024,
          public: false,
          endpoints: endpoints,
        );
      });

      test('then it contains private ACL', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;

        expect(fields['acl'], 'private');
      });
    });
  });

  group('Given a MultipartPostUploadStrategy with HTTP custom endpoints', () {
    late MultipartPostUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = CustomEndpointConfig(
        baseUri: Uri.http('localhost:4566', '/'),
        serviceName: 'LocalStack',
      );
    });

    group('when creating direct upload description', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'testAccessKey',
          secretKey: 'testSecretKey',
          bucket: 'test-bucket',
          region: 'us-east-1',
          path: 'test/file.txt',
          expiration: Duration(minutes: 10),
          maxFileSize: 1024 * 1024,
          public: false,
          endpoints: endpoints,
        );
      });

      test('then it contains the custom upload URL', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['url'], 'http://localhost:4566/test-bucket');
      });
    });
  });
}
