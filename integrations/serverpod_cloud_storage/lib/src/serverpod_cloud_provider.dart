import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_gcp/serverpod_cloud_storage_gcp.dart';

const _bucketsEnvironmentVariable = 'SERVERPOD_CLOUD_STORAGE_BUCKETS';
const _serviceAccountEnvironmentVariable =
    'SERVERPOD_CLOUD_STORAGE_SERVICE_ACCOUNT_KEY';

/// Cloud storage integrations managed by Serverpod Cloud.
abstract final class ServerpodCloudProvider {
  /// Creates the private cloud storage configured by Serverpod Cloud.
  ///
  /// Returns a [DatabaseCloudStorage] when the environment does not
  /// contain valid configurations.
  static Future<CloudStorage> private() => createServerpodCloudStorage(
    storageId: 'private',
    environment: Platform.environment,
  );

  /// Creates the public cloud storage configured by Serverpod Cloud.
  ///
  /// Returns a [DatabaseCloudStorage] when the environment does not
  /// contain valid configurations.
  static Future<CloudStorage> public() => createServerpodCloudStorage(
    storageId: 'public',
    environment: Platform.environment,
  );
}

/// Creates a Serverpod Cloud storage for [storageId].
Future<CloudStorage> createServerpodCloudStorage({
  required String storageId,
  required Map<String, String> environment,
  ServerpodCloudStorageFactory createStorage = _createNativeStorage,
}) async {
  try {
    final configuration = _configurationForStorageId(
      environment[_bucketsEnvironmentVariable],
      storageId,
    );
    if (configuration == null) return DatabaseCloudStorage(storageId);

    final serviceAccountJson = _nonEmptyString(
      environment[_serviceAccountEnvironmentVariable],
    );
    if (serviceAccountJson == null) return DatabaseCloudStorage(storageId);

    return await createStorage(
      storageId: storageId,
      bucket: configuration.bucket,
      public: configuration.public,
      serviceAccountJson: serviceAccountJson,
      publicHost: configuration.publicUrl,
    );
  } catch (_) {
    return DatabaseCloudStorage(storageId);
  }
}

/// Creates a cloud storage instance from Serverpod Cloud configuration.
typedef ServerpodCloudStorageFactory =
    FutureOr<CloudStorage> Function({
      required String storageId,
      required String bucket,
      required bool public,
      required String serviceAccountJson,
      String? publicHost,
    });

Future<CloudStorage> _createNativeStorage({
  required String storageId,
  required String bucket,
  required bool public,
  required String serviceAccountJson,
  String? publicHost,
}) => NativeGoogleCloudStorage.fromServiceAccountJson(
  storageId: storageId,
  bucket: bucket,
  public: public,
  serviceAccountJson: serviceAccountJson,
  publicHost: publicHost,
);

_BucketConfiguration? _configurationForStorageId(
  String? bucketsJson,
  String storageId,
) {
  if (_nonEmptyString(bucketsJson) == null) return null;

  final decoded = jsonDecode(bucketsJson!);
  if (decoded is! List) return null;

  for (final value in decoded) {
    if (value is! Map ||
        value['provider'] != 'gcp' ||
        value['storageId'] != storageId) {
      continue;
    }

    final bucket = _nonEmptyString(value['bucketName']);
    final visibility = _nonEmptyString(value['visibility']);
    if (bucket == null || (visibility != 'public' && visibility != 'private')) {
      return null;
    }

    return _BucketConfiguration(
      bucket: bucket,
      public: visibility == 'public',
      publicUrl: _publicHost(value['publicUrl']),
    );
  }

  return null;
}

String? _nonEmptyString(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value;
}

String? _publicHost(Object? value) {
  final publicUrl = _nonEmptyString(value);
  if (publicUrl == null) return null;

  final uri = Uri.tryParse(publicUrl);
  if (uri == null || !uri.hasScheme) return publicUrl;
  if (uri.host.isEmpty) return null;

  return '${uri.authority}${uri.path}';
}

final class _BucketConfiguration {
  final String bucket;
  final bool public;
  final String? publicUrl;

  const _BucketConfiguration({
    required this.bucket,
    required this.public,
    required this.publicUrl,
  });
}
