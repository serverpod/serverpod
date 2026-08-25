import 'dart:convert';

import 'package:serverpod_cloud_storage_s3_compat/src/upload/policy.dart';
import 'package:test/test.dart';

void main() {
  group('Given a public Policy created with fromS3PresignedPost', () {
    late Policy policy;

    setUp(() {
      policy = Policy.fromS3PresignedPost(
        'uploads/test-file.txt',
        'my-bucket',
        'AKIAIOSFODNN7EXAMPLE',
        Duration(minutes: 15),
        10 * 1024 * 1024,
        region: 'us-east-1',
        public: true,
      );
    });

    test(
      'when accessing bucket property '
      'then it has the correct bucket',
      () {
        expect(policy.bucket, 'my-bucket');
      },
    );

    test(
      'when accessing key property '
      'then it has the correct key',
      () {
        expect(policy.key, 'uploads/test-file.txt');
      },
    );

    test(
      'when accessing region property '
      'then it has the correct region',
      () {
        expect(policy.region, 'us-east-1');
      },
    );

    test(
      'when accessing maxFileSize property '
      'then it has the correct max file size',
      () {
        expect(policy.maxFileSize, 10 * 1024 * 1024);
      },
    );

    test(
      'when accessing public property '
      'then it has public set to true',
      () {
        expect(policy.public, true);
      },
    );

    test(
      'when accessing credential property '
      'then it contains the access key',
      () {
        expect(policy.credential, startsWith('AKIAIOSFODNN7EXAMPLE/'));
      },
    );

    test(
      'when accessing credential property '
      'then it contains the region',
      () {
        expect(policy.credential, contains('us-east-1'));
      },
    );

    test(
      'when accessing datetime property '
      'then it is in AWS format',
      () {
        // AWS datetime format: YYYYMMDDTHHMMSSZ
        expect(policy.datetime, matches(RegExp(r'^\d{8}T\d{6}Z$')));
      },
    );
  });

  group('Given a non-public Policy created with fromS3PresignedPost', () {
    late Policy policy;

    setUp(() {
      policy = Policy.fromS3PresignedPost(
        'test.txt',
        'bucket',
        'AKIAIOSFODNN7EXAMPLE',
        Duration(minutes: 15),
        1024,
        region: 'us-west-2',
        public: false,
      );
    });

    test(
      'when encoding it '
      'then it returns a valid base64 string',
      () {
        final encoded = policy.encode();

        expect(() => base64.decode(encoded), returnsNormally);
      },
    );

    test(
      'when encoding and decoding it '
      'then it contains the bucket',
      () {
        final encoded = policy.encode();
        final decoded =
            jsonDecode(utf8.decode(base64.decode(encoded)))
                as Map<String, dynamic>;
        final conditions = decoded['conditions'] as List<dynamic>;

        expect(conditions, contains(equals({'bucket': 'bucket'})));
      },
    );

    test(
      'when encoding and decoding it '
      'then it contains private ACL',
      () {
        final encoded = policy.encode();
        final decoded =
            jsonDecode(utf8.decode(base64.decode(encoded)))
                as Map<String, dynamic>;
        final conditions = decoded['conditions'] as List<dynamic>;

        expect(conditions, contains(equals({'acl': 'private'})));
      },
    );
  });

  group('Given a public Policy created with fromS3PresignedPost', () {
    late Policy policy;

    setUp(() {
      policy = Policy.fromS3PresignedPost(
        'path/to/file.txt',
        'test-bucket',
        'AKIAIOSFODNN7EXAMPLE',
        Duration(minutes: 10),
        5000,
        public: true,
      );
    });

    test(
      'when converting to string '
      'then it contains public-read ACL',
      () {
        final decoded = jsonDecode(policy.toString()) as Map<String, dynamic>;
        final conditions = decoded['conditions'] as List<dynamic>;

        expect(conditions, contains(equals({'acl': 'public-read'})));
      },
    );

    test(
      'when converting to string '
      'then it contains the expiration',
      () {
        final decoded = jsonDecode(policy.toString()) as Map<String, dynamic>;

        expect(decoded['expiration'], policy.expiration);
      },
    );

    test(
      'when converting to string '
      'then it contains content-length-range condition',
      () {
        final decoded = jsonDecode(policy.toString()) as Map<String, dynamic>;
        final conditions = decoded['conditions'] as List<dynamic>;

        expect(
          conditions,
          contains(equals(['content-length-range', 1, 5000])),
        );
      },
    );

    test(
      'when converting to string '
      'then it contains the key starts-with condition',
      () {
        final decoded = jsonDecode(policy.toString()) as Map<String, dynamic>;
        final conditions = decoded['conditions'] as List<dynamic>;

        expect(
          conditions,
          contains(equals(['starts-with', r'$key', 'path/to/file.txt'])),
        );
      },
    );
  });

  test(
    'Given a Policy created with eu-west-1 region '
    'when accessing region property '
    'then it is correctly set',
    () {
      final policy = Policy.fromS3PresignedPost(
        'test.txt',
        'bucket',
        'AKIAIOSFODNN7EXAMPLE',
        Duration(minutes: 15),
        1024,
        region: 'eu-west-1',
      );

      expect(policy.region, 'eu-west-1');
      expect(policy.credential, contains('eu-west-1'));
    },
  );

  test(
    'Given a Policy created with default constructor '
    'when accessing region property '
    'then the default region is us-east-1',
    () {
      final policy = Policy(
        key: 'test.txt',
        bucket: 'bucket',
        datetime: '20240101T000000Z',
        expiration: '2024-01-01T00:15:00Z',
        credential: 'cred',
        maxFileSize: 1024,
      );

      expect(policy.region, 'us-east-1');
    },
  );

  test(
    'Given a Policy with additional fields, '
    'when converting to string, '
    'then the conditions contain the fields',
    () {
      final policy = Policy(
        key: 'uploads/file "one".txt',
        bucket: 'bucket',
        datetime: '20240101T000000Z',
        expiration: '2024-01-01T00:15:00Z',
        credential: 'cred',
        minFileSize: 10,
        maxFileSize: 1024,
        fields: const {'x-amz-meta-label': 'value "one"'},
      );

      final decoded = jsonDecode(policy.toString()) as Map<String, dynamic>;
      final conditions = decoded['conditions'] as List<dynamic>;

      expect(
        conditions,
        contains(equals({'x-amz-meta-label': 'value "one"'})),
      );
    },
  );
}
