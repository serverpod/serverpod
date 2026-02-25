import 'dart:convert';

import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a PresignedPutUploadStrategy '
    'when reading uploadType '
    'then it is binary',
    () {
      final strategy = PresignedPutUploadStrategy();

      expect(strategy.uploadType, 'binary');
    },
  );

  group('Given a PresignedPutUploadStrategy with R2 endpoints', () {
    late PresignedPutUploadStrategy strategy;
    late R2EndpointConfig endpoints;

    setUp(() {
      strategy = PresignedPutUploadStrategy();
      endpoints = R2EndpointConfig(accountId: 'abc123def456');
    });

    group('when creating direct upload description', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'r2accesskey',
          secretKey: 'r2secretkey',
          bucket: 'my-bucket',
          region: 'auto',
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

      test('then it specifies binary type', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['type'], 'binary');
      });

      test('then it specifies PUT method', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['method'], 'PUT');
      });

      test('then it contains the filename', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;

        expect(data['file-name'], 'test-file.txt');
      });

      test('then it contains a presigned URL', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final url = data['url'] as String;

        expect(url, contains('abc123def456.r2.cloudflarestorage.com'));
        expect(url, contains('my-bucket'));
        expect(url, contains('uploads/test-file.txt'));
        expect(url, contains('X-Amz-Signature='));
        expect(url, contains('X-Amz-Algorithm=AWS4-HMAC-SHA256'));
      });

      test('then it contains Content-Type header', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'text/plain');
      });
    });

    group('when creating upload description for image file', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'r2accesskey',
          secretKey: 'r2secretkey',
          bucket: 'my-bucket',
          region: 'auto',
          path: 'images/photo.jpg',
          expiration: Duration(minutes: 5),
          maxFileSize: 5 * 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it detects JPEG MIME type', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'image/jpeg');
      });
    });

    group('when creating upload description for PNG file', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'key',
          secretKey: 'secret',
          bucket: 'bucket',
          region: 'auto',
          path: 'images/logo.png',
          expiration: Duration(minutes: 10),
          maxFileSize: 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it detects PNG MIME type', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'image/png');
      });
    });

    group('when creating upload description for unknown file type', () {
      late String? description;

      setUp(() async {
        description = await strategy.createDirectUploadDescription(
          accessKey: 'key',
          secretKey: 'secret',
          bucket: 'bucket',
          region: 'auto',
          path: 'data/file.unknownext',
          expiration: Duration(minutes: 10),
          maxFileSize: 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it uses application/octet-stream as fallback', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'application/octet-stream');
      });
    });
  });

  group(
    'Given a PresignedPutUploadStrategy with R2 endpoints and contentLength',
    () {
      late PresignedPutUploadStrategy strategy;
      late R2EndpointConfig endpoints;

      setUp(() {
        strategy = PresignedPutUploadStrategy();
        endpoints = R2EndpointConfig(accountId: 'abc123def456');
      });

      group('when creating upload description with contentLength', () {
        late String? description;

        setUp(() async {
          description = await strategy.createDirectUploadDescription(
            accessKey: 'r2accesskey',
            secretKey: 'r2secretkey',
            bucket: 'my-bucket',
            region: 'auto',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
            contentLength: 5000,
          );
        });

        test('then it includes Content-Length in headers', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers['Content-Length'], '5000');
        });

        test('then the presigned URL signs content-length header', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('X-Amz-SignedHeaders=content-length'));
        });
      });

      group('when creating upload description without contentLength', () {
        late String? description;

        setUp(() async {
          description = await strategy.createDirectUploadDescription(
            accessKey: 'r2accesskey',
            secretKey: 'r2secretkey',
            bucket: 'my-bucket',
            region: 'auto',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
          );
        });

        test('then it does not include Content-Length in headers', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers.containsKey('Content-Length'), isFalse);
        });

        test('then the presigned URL does not sign content-length header', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, isNot(contains('content-length')));
        });
      });
    },
  );

  group(
    'Given a PresignedPutUploadStrategy with R2 endpoints and preventOverwrite',
    () {
      late PresignedPutUploadStrategy strategy;
      late R2EndpointConfig endpoints;

      setUp(() {
        strategy = PresignedPutUploadStrategy();
        endpoints = R2EndpointConfig(accountId: 'abc123def456');
      });

      group('when creating upload description with preventOverwrite', () {
        late String? description;

        setUp(() async {
          description = await strategy.createDirectUploadDescription(
            accessKey: 'r2accesskey',
            secretKey: 'r2secretkey',
            bucket: 'my-bucket',
            region: 'auto',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
            preventOverwrite: true,
          );
        });

        test('then it includes If-None-Match header set to *', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers['If-None-Match'], '*');
        });

        test('then the presigned URL signs if-none-match header', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('if-none-match'));
        });
      });

      group('when creating upload description without preventOverwrite', () {
        late String? description;

        setUp(() async {
          description = await strategy.createDirectUploadDescription(
            accessKey: 'r2accesskey',
            secretKey: 'r2secretkey',
            bucket: 'my-bucket',
            region: 'auto',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
          );
        });

        test('then it does not include If-None-Match header', () {
          final data = jsonDecode(description!) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers.containsKey('If-None-Match'), isFalse);
        });
      });
    },
  );

  group('Given a PresignedPutUploadStrategy with custom endpoints', () {
    late PresignedPutUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = PresignedPutUploadStrategy();
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

      test('then it contains the custom endpoint URL', () {
        final data = jsonDecode(description!) as Map<String, dynamic>;
        final url = data['url'] as String;

        expect(url, contains('localhost:4566'));
        expect(url, contains('test-bucket'));
      });
    });
  });
}
