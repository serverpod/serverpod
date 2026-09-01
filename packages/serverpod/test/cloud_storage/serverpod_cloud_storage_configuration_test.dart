import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cloud_storage/serverpod_cloud_storage_configuration.dart';
import 'package:test/test.dart';

/// Test-only service account JSON (not a real credential).
const _testServiceAccountJson = {
  'type': 'service_account',
  'client_id': '123456789',
  'client_email': 'test@test-project.iam.gserviceaccount.com',
};

Map<String, String> _validEnvironment = {
  'SERVERPOD_CLOUD_STORAGE_BUCKETS': jsonEncode([
    {
      'storageId': 'public',
      'provider': 'gcp',
      'visibility': 'public',
      'bucketName': 'public-bucket',
      'publicUrl': 'https://cdn.example.com/public-bucket',
    },
    {
      'storageId': 'private',
      'provider': 'gcp',
      'visibility': 'private',
      'bucketName': 'private-bucket',
      'publicUrl': 'https://cdn.example.com/private-bucket',
    },
  ]),
  'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY': jsonEncode(
    _testServiceAccountJson,
  ),
};

void main() {
  test(
    'Given an environment without configured buckets, '
    'when storages are created with createServerpodCloudStorages, '
    'then no storage instance or warning is returned.',
    () async {
      final warnings = <String>[];

      final storages = await createServerpodCloudStorages(
        environment: const {},
        onWarning: warnings.add,
        createStorage:
            ({
              required storageId,
              required bucket,
              required public,
              required serviceAccountJson,
              publicHost,
            }) => _TestCloudStorage(storageId),
      );

      expect(storages, isEmpty);
      expect(warnings, isEmpty);
    },
  );

  test(
    'Given an environment with only a public bucket and a service account, '
    'when storages are created with createServerpodCloudStorages, '
    'then only the public storage intance is returned.',
    () async {
      final calls = <_FactoryCall>[];
      final serviceAccount = jsonEncode({'type': 'service_account'});

      final storages = await createServerpodCloudStorages(
        onWarning: fail,
        environment: {
          'SERVERPOD_CLOUD_STORAGE_BUCKETS': jsonEncode([
            {
              'storageId': 'public',
              'provider': 'gcp',
              'visibility': 'public',
              'bucketName': 'public-bucket',
              'publicUrl': 'https://cdn.example.com/public-bucket',
            },
          ]),
          'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY': serviceAccount,
        },
        createStorage:
            ({
              required storageId,
              required bucket,
              required public,
              required serviceAccountJson,
              publicHost,
            }) {
              calls.add(
                _FactoryCall(
                  storageId: storageId,
                  bucket: bucket,
                  public: public,
                  serviceAccountJson: serviceAccountJson,
                  publicHost: publicHost,
                ),
              );
              return _TestCloudStorage(storageId);
            },
      );

      expect(storages.keys, ['public']);
      expect(
        calls.single,
        isA<_FactoryCall>()
            .having((e) => e.storageId, 'storageId', 'public')
            .having((e) => e.public, 'public', isTrue)
            .having(
              (e) => e.serviceAccountJson,
              'serviceAccountJson',
              serviceAccount,
            )
            .having(
              (e) => e.publicHost,
              'publicHost',
              'https://cdn.example.com/public-bucket',
            ),
      );
    },
  );

  test(
    'Given an environment with public and private buckets and a service account, '
    'when storages are created with createServerpodCloudStorages, '
    'then a storage instance is returned for each bucket',
    () async {
      final calls = <_FactoryCall>[];

      final storages = await createServerpodCloudStorages(
        onWarning: fail,
        environment: _validEnvironment,
        createStorage:
            ({
              required storageId,
              required bucket,
              required public,
              required serviceAccountJson,
              publicHost,
            }) {
              calls.add(
                _FactoryCall(
                  storageId: storageId,
                  bucket: bucket,
                  public: public,
                  serviceAccountJson: serviceAccountJson,
                  publicHost: publicHost,
                ),
              );
              return _TestCloudStorage(storageId);
            },
      );

      expect(storages.keys, ['public', 'private']);
      expect(calls.map((call) => call.public), [true, false]);
    },
  );

  group(
    'Given an environment with public and private buckets and a service account, '
    'when storages are created with createServerpodCloudStorages, '
    'and the private factory throws',
    () {
      late List<String> warnings;
      late Map<String, CloudStorage> storages;

      setUp(() async {
        warnings = [];
        storages = await createServerpodCloudStorages(
          onWarning: warnings.add,
          environment: _validEnvironment,
          createStorage:
              ({
                required storageId,
                required bucket,
                required public,
                required serviceAccountJson,
                publicHost,
              }) {
                if (storageId == 'private') throw StateError('invalid key');
                return _TestCloudStorage(storageId);
              },
        );
      });

      test(
        'then only the public storage instance is returned',
        () async {
          expect(storages.keys, ['public']);
        },
      );

      test(
        'then a warning is produced for the failing private storage instance',
        () async {
          expect(
            warnings.single,
            'Failed to create Serverpod cloud storage for storageId: "private". '
            'Error: Bad state: invalid key',
          );
        },
      );
    },
  );

  group(
    'Given an environment with buckets but without a service account, '
    'when storages are created with createServerpodCloudStorages',
    () {
      late List<String> warnings;
      late Map<String, CloudStorage> storages;

      setUp(() async {
        warnings = [];
        storages = await createServerpodCloudStorages(
          onWarning: warnings.add,
          environment: {
            'SERVERPOD_CLOUD_STORAGE_BUCKETS': jsonEncode([
              {
                'storageId': 'public',
                'provider': 'gcp',
                'visibility': 'public',
                'bucketName': 'public-bucket',
                'publicUrl': 'https://cdn.example.com/public-bucket',
              },
              {
                'storageId': 'private',
                'provider': 'gcp',
                'visibility': 'private',
                'bucketName': 'private-bucket',
                'publicUrl': 'https://cdn.example.com/private-bucket',
              },
            ]),
          },
          createStorage:
              ({
                required storageId,
                required bucket,
                required public,
                required serviceAccountJson,
                publicHost,
              }) => _TestCloudStorage(storageId),
        );
      });

      test('then no storage instance is returned', () {
        expect(storages, isEmpty);
      });

      test('then a warning is produced', () async {
        expect(warnings.single, contains('SERVICE_ACCOUNT_KEY is missing'));
      });
    },
  );

  group(
    'Given an environment with malformed bucket JSON, '
    'when storages are created with createServerpodCloudStorages',
    () {
      late List<String> warnings;
      late Map<String, CloudStorage> storages;

      setUp(() async {
        warnings = [];
        storages = await createServerpodCloudStorages(
          onWarning: warnings.add,
          environment: const {
            'SERVERPOD_CLOUD_STORAGE_BUCKETS': 'not-json',
            'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY': 'service-account',
          },
          createStorage:
              ({
                required storageId,
                required bucket,
                required public,
                required serviceAccountJson,
                publicHost,
              }) => _TestCloudStorage(storageId),
        );
      });

      test('then no storage instance is returned', () {
        expect(storages, isEmpty);
      });

      test(
        'then a warning is produced',
        () {
          expect(
            warnings.single,
            contains(
              'Unable to parse value for SERVERPOD_CLOUD_STORAGE_BUCKETS',
            ),
          );
        },
      );
    },
  );
}

final class _FactoryCall {
  final String storageId;
  final String bucket;
  final bool public;
  final String serviceAccountJson;
  final String? publicHost;

  const _FactoryCall({
    required this.storageId,
    required this.bucket,
    required this.public,
    required this.serviceAccountJson,
    required this.publicHost,
  });
}

class _TestCloudStorage extends CloudStorage {
  _TestCloudStorage(super.storageId);

  @override
  Future<UploadDescription> createUploadDescription({
    required CloudStorageSession session,
    required String path,
    UploadOptions options = const UploadOptions(),
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFile({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> fileExists({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Uri> publicDownloadUrl({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ByteData> retrieveFile({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<FileStat> statFile({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> storeFile({
    required CloudStorageSession session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Uri> temporaryDownloadUrl({
    required CloudStorageSession session,
    required String path,
    TemporaryDownloadUrlOptions options = const TemporaryDownloadUrlOptions(),
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyUpload({
    required CloudStorageSession session,
    required String path,
  }) {
    throw UnimplementedError();
  }
}
