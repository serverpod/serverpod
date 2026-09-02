import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_provider/src/serverpod_cloud_provider.dart';
import 'package:test/test.dart';

const _serviceAccountJson = '{"type":"service_account"}';

CloudStorage _testStorageFactory({
  required String storageId,
  required String bucket,
  required bool public,
  required String serviceAccountJson,
  String? publicHost,
}) => _TestCloudStorage(
  storageId: storageId,
  bucket: bucket,
  public: public,
  serviceAccountJson: serviceAccountJson,
  publicHost: publicHost,
);

class _TestCloudStorage extends CloudStorage {
  final String bucket;
  final bool public;
  final String serviceAccountJson;
  final String? publicHost;

  _TestCloudStorage({
    required String storageId,
    required this.bucket,
    required this.public,
    required this.serviceAccountJson,
    required this.publicHost,
  }) : super(storageId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Map<String, dynamic> _bucket({
  String? storageId,
  required String visibility,
  required String bucketName,
  String? publicUrl,
}) => {
  'storageId': storageId ?? visibility,
  'provider': 'gcp',
  'visibility': visibility,
  'bucketName': bucketName,
  'publicUrl': ?publicUrl,
};

Map<String, String> _environmentWithBuckets(List<Object?> buckets) => {
  'SERVERPOD_CLOUD_STORAGE_BUCKETS': jsonEncode(buckets),
  'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY': _serviceAccountJson,
};

void main() {
  test(
    'Given valid public storage configurations, '
    'when calling createServerpodCloudStorage with public storage ID, '
    'then a public storage instance is returned',
    () async {
      final storage = await createServerpodCloudStorage(
        storageId: 'public',
        environment: _environmentWithBuckets([
          _bucket(
            visibility: 'public',
            bucketName: 'public-bucket',
            publicUrl: 'https://cdn.example.com/public-bucket',
          ),
        ]),
        createStorage: _testStorageFactory,
      );

      expect(
        storage,
        isA<_TestCloudStorage>()
            .having((storage) => storage.storageId, 'storageId', 'public')
            .having((storage) => storage.bucket, 'bucket', 'public-bucket')
            .having((storage) => storage.public, 'public', isTrue)
            .having(
              (storage) => storage.serviceAccountJson,
              'serviceAccountJson',
              _serviceAccountJson,
            )
            .having(
              (storage) => storage.publicHost,
              'publicHost',
              'cdn.example.com/public-bucket',
            ),
      );
    },
  );

  test(
    'Given valid private storage configurations, '
    'when calling createServerpodCloudStorage with private storage ID, '
    'then a private storage instance is returned',
    () async {
      final storage = await createServerpodCloudStorage(
        storageId: 'private',
        environment: _environmentWithBuckets([
          _bucket(
            visibility: 'private',
            bucketName: 'private-bucket',
            publicUrl: 'https://cdn.example.com/private-bucket',
          ),
        ]),
        createStorage: _testStorageFactory,
      );

      expect(
        storage,
        isA<_TestCloudStorage>()
            .having((storage) => storage.storageId, 'storageId', 'private')
            .having((storage) => storage.bucket, 'bucket', 'private-bucket')
            .having((storage) => storage.public, 'public', isFalse)
            .having(
              (storage) => storage.publicHost,
              'publicHost',
              'cdn.example.com/private-bucket',
            ),
      );
    },
  );

  test(
    'Given no matching bucket configuration, '
    'when calling createServerpodCloudStorage, '
    'then database cloud storage is returned',
    () async {
      final storage = await createServerpodCloudStorage(
        storageId: 'public',
        environment: _environmentWithBuckets([
          _bucket(visibility: 'private', bucketName: 'private-bucket'),
        ]),
      );

      expect(storage, isA<DatabaseCloudStorage>());
    },
  );

  test(
    'Given a matching bucket without service account credentials, '
    'when calling createServerpodCloudStorage, '
    'then database cloud storage is returned',
    () async {
      final storage = await createServerpodCloudStorage(
        storageId: 'private-assets',
        environment: {
          'SERVERPOD_CLOUD_STORAGE_BUCKETS': jsonEncode([
            _bucket(
              storageId: 'private-assets',
              visibility: 'private',
              bucketName: 'private-bucket',
            ),
          ]),
        },
      );

      expect(storage, isA<DatabaseCloudStorage>());
      expect(storage.storageId, 'private-assets');
    },
  );

  test(
    'Given malformed bucket metadata, '
    'when calling createServerpodCloudStorage, '
    'then database cloud storage is returned',
    () async {
      final storage = await createServerpodCloudStorage(
        storageId: 'public',
        environment: const {
          'SERVERPOD_CLOUD_STORAGE_BUCKETS': 'not-json',
          'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY': _serviceAccountJson,
        },
      );

      expect(storage, isA<DatabaseCloudStorage>());
    },
  );
}
