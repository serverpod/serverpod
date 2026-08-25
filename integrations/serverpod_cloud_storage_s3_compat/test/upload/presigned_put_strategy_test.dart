import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
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

  group('Given a PresignedPutUploadStrategy with custom endpoints', () {
    late PresignedPutUploadStrategy strategy;
    late CustomEndpointConfig endpoints;

    setUp(() {
      strategy = PresignedPutUploadStrategy();
      endpoints = CustomEndpointConfig(
        baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
      );
    });

    group('when creating direct upload description', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'testAccessKey',
          secretKey: 'testSecretKey',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/test-file.txt',
          expiration: Duration(minutes: 10),
          maxFileSize: 10 * 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it returns valid JSON', () {
        expect(() => jsonDecode(description.encode()), returnsNormally);
      });

      test('then it specifies binary type', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['type'], 'binary');
      });

      test('then it specifies PUT method', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['method'], 'PUT');
      });

      test('then it contains the filename', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;

        expect(data['file-name'], 'test-file.txt');
      });

      test('then it contains a presigned URL', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final url = data['url'] as String;

        expect(url, contains('s3.us-east-1.amazonaws.com'));
        expect(url, contains('my-bucket'));
        expect(url, contains('uploads/test-file.txt'));
        expect(url, contains('X-Amz-Signature='));
        expect(url, contains('X-Amz-Algorithm=AWS4-HMAC-SHA256'));
      });

      test('then it contains Content-Type header', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'text/plain');
      });
    });

    test(
      'when creating direct upload description with metadata, '
      'then the metadata is included in headers and URL',
      () async {
        final description = await strategy.createUploadDescription(
          accessKey: 'testAccessKey',
          secretKey: 'testSecretKey',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'uploads/test-file.txt',
          expiration: const Duration(minutes: 10),
          maxFileSize: 1024,
          public: true,
          endpoints: endpoints,
          metadata: const FileMetadata(
            contentType: 'application/custom',
            cacheControl: 'max-age=60',
            custom: {'tenant': 'acme'},
          ),
        );
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'application/custom');
        expect(headers['cache-control'], 'max-age=60');
        expect(headers['x-amz-meta-tenant'], 'acme');
        expect(data['url'], contains('cache-control'));
        expect(data['url'], contains('x-amz-meta-tenant'));
      },
    );

    group('when creating upload description for image file', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'key',
          secretKey: 'secret',
          bucket: 'my-bucket',
          region: 'us-east-1',
          path: 'images/photo.jpg',
          expiration: Duration(minutes: 5),
          maxFileSize: 5 * 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it detects JPEG MIME type', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'image/jpeg');
      });
    });

    group('when creating upload description for PNG file', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'key',
          secretKey: 'secret',
          bucket: 'bucket',
          region: 'us-east-1',
          path: 'images/logo.png',
          expiration: Duration(minutes: 10),
          maxFileSize: 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it detects PNG MIME type', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'image/png');
      });
    });

    group('when creating upload description for unknown file type', () {
      late UploadDescription description;

      setUp(() async {
        description = await strategy.createUploadDescription(
          accessKey: 'key',
          secretKey: 'secret',
          bucket: 'bucket',
          region: 'us-east-1',
          path: 'data/file.unknownext',
          expiration: Duration(minutes: 10),
          maxFileSize: 1024 * 1024,
          public: true,
          endpoints: endpoints,
        );
      });

      test('then it uses application/octet-stream as fallback', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final headers = data['headers'] as Map<String, dynamic>;

        expect(headers['Content-Type'], 'application/octet-stream');
      });
    });
  });

  group(
    'Given a PresignedPutUploadStrategy with custom endpoints and contentLength',
    () {
      late PresignedPutUploadStrategy strategy;
      late CustomEndpointConfig endpoints;

      setUp(() {
        strategy = PresignedPutUploadStrategy();
        endpoints = CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        );
      });

      group('when creating upload description with contentLength', () {
        late UploadDescription description;

        setUp(() async {
          description = await strategy.createUploadDescription(
            accessKey: 'testAccessKey',
            secretKey: 'testSecretKey',
            bucket: 'my-bucket',
            region: 'us-east-1',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
            contentLength: 5000,
          );
        });

        test('then it includes Content-Length in headers', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers['Content-Length'], '5000');
        });

        test('then the presigned URL signs content-length header', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('X-Amz-SignedHeaders=content-length'));
        });
      });

      group('when creating upload description without contentLength', () {
        late UploadDescription description;

        setUp(() async {
          description = await strategy.createUploadDescription(
            accessKey: 'testAccessKey',
            secretKey: 'testSecretKey',
            bucket: 'my-bucket',
            region: 'us-east-1',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
          );
        });

        test('then it does not include Content-Length in headers', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers.containsKey('Content-Length'), isFalse);
        });

        test('then the presigned URL does not sign content-length header', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, isNot(contains('content-length')));
        });
      });
    },
  );

  group(
    'Given a PresignedPutUploadStrategy with custom endpoints and preventOverwrite',
    () {
      late PresignedPutUploadStrategy strategy;
      late CustomEndpointConfig endpoints;

      setUp(() {
        strategy = PresignedPutUploadStrategy();
        endpoints = CustomEndpointConfig(
          baseUri: Uri.https('s3.us-east-1.amazonaws.com', '/'),
        );
      });

      group('when creating upload description with preventOverwrite', () {
        late UploadDescription description;

        setUp(() async {
          description = await strategy.createUploadDescription(
            accessKey: 'testAccessKey',
            secretKey: 'testSecretKey',
            bucket: 'my-bucket',
            region: 'us-east-1',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
            preventOverwrite: true,
          );
        });

        test('then it includes If-None-Match header set to *', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers['If-None-Match'], '*');
        });

        test('then the presigned URL signs if-none-match header', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final url = data['url'] as String;

          expect(url, contains('if-none-match'));
        });
      });

      group('when creating upload description without preventOverwrite', () {
        late UploadDescription description;

        setUp(() async {
          description = await strategy.createUploadDescription(
            accessKey: 'testAccessKey',
            secretKey: 'testSecretKey',
            bucket: 'my-bucket',
            region: 'us-east-1',
            path: 'uploads/test-file.txt',
            expiration: Duration(minutes: 10),
            maxFileSize: 10 * 1024 * 1024,
            public: true,
            endpoints: endpoints,
          );
        });

        test('then it does not include If-None-Match header', () {
          final data = jsonDecode(description.encode()) as Map<String, dynamic>;
          final headers = data['headers'] as Map<String, dynamic>;

          expect(headers.containsKey('If-None-Match'), isFalse);
        });
      });
    },
  );

  group('Given a PresignedPutUploadStrategy with HTTP custom endpoints', () {
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

      test('then it contains the custom endpoint URL', () {
        final data = jsonDecode(description.encode()) as Map<String, dynamic>;
        final url = data['url'] as String;

        expect(url, contains('localhost:4566'));
        expect(url, contains('test-bucket'));
      });
    });
  });

  test(
    'Given a PresignedPutUploadStrategy, '
    'when uploading data with custom metadata, '
    'then the signed header names are lower case',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      final authorization = server.first.then((request) async {
        await request.drain<void>();
        request.response.statusCode = 200;
        await request.response.close();
        return request.headers.value('authorization')!;
      });

      await PresignedPutUploadStrategy().uploadData(
        accessKey: 'testAccessKey',
        secretKey: 'testSecretKey',
        bucket: 'test-bucket',
        region: 'us-east-1',
        data: ByteData(1),
        path: 'uploads/test-file.txt',
        public: false,
        endpoints: CustomEndpointConfig(
          baseUri: Uri.http('localhost:${server.port}', '/'),
        ),
        metadata: const FileMetadata(custom: {'UserId': '5'}),
      );

      final signedHeaders = RegExp(
        r'SignedHeaders=([^,]+)',
      ).firstMatch(await authorization)!.group(1);

      expect(signedHeaders, contains('x-amz-meta-userid'));
    },
  );
}
