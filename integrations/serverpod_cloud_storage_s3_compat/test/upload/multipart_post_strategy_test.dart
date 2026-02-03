import 'dart:convert';

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

  group('Given a MultipartPostUploadStrategy with AWS endpoints', () {
    late MultipartPostUploadStrategy strategy;
    late AwsEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = AwsEndpointConfig();
    });

    group('when creating direct upload description', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
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

      test('then it returns a non-null description', () {
        expect(description, isNotNull);
      });

      test('then it is valid JSON', () {
        expect(() => jsonDecode(description!), returnsNormally);
      });

      test('then it contains the correct upload URL', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['url'], 'https://my-bucket.s3.us-east-1.amazonaws.com/');
      });

      test('then it specifies multipart type', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['type'], 'multipart');
      });

      test('then it specifies file as the field name', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['field'], 'file');
      });

      test('then it contains the filename', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['file-name'], 'test-file.txt');
      });

      test('then it contains required request fields', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
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

    group('when creating private upload description', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
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
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final fields = data['request-fields'] as Map<String, dynamic>;

        expect(fields['acl'], 'private');
      });
    });
  });

  group('Given a MultipartPostUploadStrategy with GCP endpoints', () {
    late MultipartPostUploadStrategy strategy;
    late GcpEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = GcpEndpointConfig();
    });

    group('when creating direct upload description', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'GOOGTS7C7FUP3AIRVEXAMPLE',
          secretKey: 'bGoa+V7g/yqDXvKRqq+JTFn4uQZbPiEXAMPLEKEY',
          bucket: 'my-gcp-bucket',
          region: 'auto',
          path: 'uploads/gcp-file.txt',
          expiration: Duration(minutes: 10),
          maxFileSize: 5 * 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it contains the GCP upload URL', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['url'], 'https://storage.googleapis.com/my-gcp-bucket');
      });

      test('then it specifies multipart type', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['type'], 'multipart');
      });
    });
  });

  group('Given a MultipartPostUploadStrategy with custom endpoints', () {
    late MultipartPostUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = CustomEndpointConfig(
        baseUri: Uri.http('localhost:9000', '/'),
        serviceName: 'MinIO',
      );
    });

    group('when creating direct upload description', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'minioadmin',
          secretKey: 'minioadmin',
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
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['url'], 'http://localhost:9000/test-bucket');
      });
    });
  });
}
