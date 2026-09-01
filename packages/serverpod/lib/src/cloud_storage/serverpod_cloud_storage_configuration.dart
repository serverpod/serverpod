import 'dart:async';
import 'dart:convert';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

const _bucketsEnvironmentVariable = 'SERVERPOD_CLOUD_STORAGE_BUCKETS';
const _serviceAccountEnvironmentVariable =
    'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY';

/// Creates a cloud storage instance from Serverpod Cloud bucket metadata.
typedef ServerpodCloudStorageFactory =
    FutureOr<CloudStorage> Function({
      required String storageId,
      required String bucket,
      required bool public,
      required String serviceAccountJson,
      String? publicHost,
    });

/// Creates the cloud storages configured by Serverpod Cloud's environment.
///
/// Invalid or incomplete entries are reported through [onWarning] and omitted
/// so that Serverpod retains its existing storage for the affected storage ID.
Future<Map<String, CloudStorage>> createServerpodCloudStorages({
  required Map<String, String> environment,
  required ServerpodCloudStorageFactory createStorage,
  required void Function(String message) onWarning,
}) async {
  final bucketsJson = environment[_bucketsEnvironmentVariable];
  if (bucketsJson == null || bucketsJson.trim().isEmpty) return const {};

  final serviceAccountJson = environment[_serviceAccountEnvironmentVariable];
  if (serviceAccountJson == null || serviceAccountJson.trim().isEmpty) {
    onWarning(
      '$_bucketsEnvironmentVariable is configured, but '
      '$_serviceAccountEnvironmentVariable is missing.',
    );
    return const {};
  }

  final Object? decodedBuckets;
  try {
    decodedBuckets = jsonDecode(bucketsJson);
  } catch (error) {
    onWarning(
      'Unable to parse value for $_bucketsEnvironmentVariable. '
      'Error: $error',
    );
    return const {};
  }

  if (decodedBuckets is! List) {
    onWarning(
      'Invalid value for $_bucketsEnvironmentVariable: $decodedBuckets',
    );
    return const {};
  }

  final storages = <String, CloudStorage>{};
  for (var index = 0; index < decodedBuckets.length; index++) {
    final value = decodedBuckets[index];
    if (value is! Map<String, dynamic>) {
      onWarning(
        'Ignoring storage bucket at index $index: invalid entry $value',
      );
      continue;
    }

    final provider = value['provider'];
    if (provider != 'gcp') {
      onWarning(
        'Ignoring storage bucket at index $index: unsupported provider '
        '"$provider"',
      );
      continue;
    }

    final storageId = _nonEmptyString(value['storageId']);
    final bucket = _nonEmptyString(value['bucketName']);
    final visibility = value['visibility'];
    if (storageId == null ||
        bucket == null ||
        (visibility != 'public' && visibility != 'private')) {
      onWarning(
        'Ignoring storage bucket at index $index: storageId, bucketName, '
        'and visibility (public or private) are required.',
      );
      continue;
    }

    final publicUrl = _nonEmptyString(value['publicUrl']);
    if (publicUrl == null) {
      onWarning(
        'Ignoring storage bucket "$storageId": invalid publicUrl $publicUrl',
      );
      continue;
    }

    if (storages.containsKey(storageId)) {
      onWarning(
        'Cloud storage ID "$storageId" is configured more than once; using '
        'the last configuration.',
      );
    }
    try {
      storages[storageId] = await createStorage(
        storageId: storageId,
        bucket: bucket,
        public: visibility == 'public',
        serviceAccountJson: serviceAccountJson,
        publicHost: publicUrl,
      );
    } catch (error) {
      onWarning(
        'Failed to create Serverpod cloud storage for storageId: "$storageId". '
        'Error: $error',
      );
    }
  }

  return storages;
}

String? _nonEmptyString(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value;
}
