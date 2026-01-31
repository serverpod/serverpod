import 'dart:convert';

import 'package:serverpod_cloud_storage_s3_compat/src/upload/policy.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Policy created with fromS3PresignedPost', () {
    final policy = Policy.fromS3PresignedPost(
      'uploads/test-file.txt',
      'my-bucket',
      'AKIAIOSFODNN7EXAMPLE',
      15,
      10 * 1024 * 1024,
      region: 'us-east-1',
      public: true,
    );

    test('then it has the correct bucket', () {
      expect(policy.bucket, 'my-bucket');
    });

    test('then it has the correct key', () {
      expect(policy.key, 'uploads/test-file.txt');
    });

    test('then it has the correct region', () {
      expect(policy.region, 'us-east-1');
    });

    test('then it has the correct max file size', () {
      expect(policy.maxFileSize, 10 * 1024 * 1024);
    });

    test('then it has public set to true', () {
      expect(policy.public, true);
    });

    test('then the credential contains the access key', () {
      expect(policy.credential, startsWith('AKIAIOSFODNN7EXAMPLE/'));
    });

    test('then the credential contains the region', () {
      expect(policy.credential, contains('us-east-1'));
    });

    test('then the datetime is in AWS format', () {
      // AWS datetime format: YYYYMMDDTHHMMSSZ
      expect(policy.datetime, matches(RegExp(r'^\d{8}T\d{6}Z$')));
    });
  });

  group('Given a Policy when encoded', () {
    final policy = Policy.fromS3PresignedPost(
      'test.txt',
      'bucket',
      'AKIAIOSFODNN7EXAMPLE',
      15,
      1024,
      region: 'us-west-2',
      public: false,
    );

    test('then it returns a valid base64 string', () {
      final encoded = policy.encode();

      // Should be valid base64
      expect(() => base64.decode(encoded), returnsNormally);
    });

    test('then the decoded string contains the bucket', () {
      final encoded = policy.encode();
      final decoded = utf8.decode(base64.decode(encoded));

      expect(decoded, contains('"bucket": "bucket"'));
    });

    test('then the decoded string contains private ACL for non-public', () {
      final encoded = policy.encode();
      final decoded = utf8.decode(base64.decode(encoded));

      expect(decoded, contains('"acl": "private"'));
    });
  });

  group('Given a public Policy when converted to string', () {
    final policy = Policy.fromS3PresignedPost(
      'path/to/file.txt',
      'test-bucket',
      'AKIAIOSFODNN7EXAMPLE',
      10,
      5000,
      public: true,
    );

    test('then it contains public-read ACL', () {
      expect(policy.toString(), contains('"acl": "public-read"'));
    });

    test('then it contains the expiration', () {
      expect(policy.toString(), contains('"expiration":'));
    });

    test('then it contains content-length-range condition', () {
      expect(policy.toString(), contains('["content-length-range", 1, 5000]'));
    });

    test('then it contains the key starts-with condition', () {
      expect(
        policy.toString(),
        contains('["starts-with", "\$key", "path/to/file.txt"]'),
      );
    });
  });

  group('Given a Policy with different regions', () {
    test('then eu-west-1 is correctly set', () {
      final policy = Policy.fromS3PresignedPost(
        'test.txt',
        'bucket',
        'AKIAIOSFODNN7EXAMPLE',
        15,
        1024,
        region: 'eu-west-1',
      );

      expect(policy.region, 'eu-west-1');
      expect(policy.credential, contains('eu-west-1'));
    });

    test('then default region is us-east-1', () {
      final policy = Policy(
        key: 'test.txt',
        bucket: 'bucket',
        datetime: '20240101T000000Z',
        expiration: '2024-01-01T00:15:00Z',
        credential: 'cred',
        maxFileSize: 1024,
      );

      expect(policy.region, 'us-east-1');
    });
  });
}
