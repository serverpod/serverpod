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

  group('Given a MultipartPostUploadStrategy with custom endpoints', () {
    late MultipartPostUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = MultipartPostUploadStrategy();
      endpoints = CustomEndpointConfig(
        baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
      );
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

        expect(
          data['url'],
          'https://s3.us-east-1.amazonaws.com/my-bucket',
        );
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
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
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
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['url'], 'http://localhost:4566/test-bucket');
      });
    });
  });
}
