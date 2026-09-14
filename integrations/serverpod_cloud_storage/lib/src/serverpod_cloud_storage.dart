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
  /// Returns [fallback] when Serverpod Cloud storage is not configured.
  /// Invalid configuration throws a [CloudStorageException].
  static Future<CloudStorage> private({
    required FutureOr<CloudStorage> Function() fallback,
  }) => createServerpodCloudStorage(
    storageId: 'private',
    environment: Platform.environment,
    fallback: fallback,
  );

  /// Creates the public cloud storage configured by Serverpod Cloud.
  ///
  /// Returns [fallback] when Serverpod Cloud storage is not configured.
  /// Invalid configuration throws a [CloudStorageException].
  static Future<CloudStorage> public({
    required FutureOr<CloudStorage> Function() fallback,
  }) => createServerpodCloudStorage(
    storageId: 'public',
    environment: Platform.environment,
    fallback: fallback,
  );
}

/// Creates a Serverpod Cloud storage for [storageId].
///
/// The [fallback] is returned when the Serverpod Cloud environment
/// variables are absent. Invalid configuration and storage creation
/// failures throw a [CloudStorageException].
Future<CloudStorage> createServerpodCloudStorage({
  required String storageId,
  required Map<String, String> environment,
  required FutureOr<CloudStorage> Function() fallback,
  ServerpodCloudStorageFactory createStorage = _createNativeStorage,
}) async {
  final bucketsJson = environment[_bucketsEnvironmentVariable];
  final serviceAccountJson = environment[_serviceAccountEnvironmentVariable];

  if (bucketsJson == null && serviceAccountJson == null) {
    return await fallback();
  }

  final validBucketsJson = _nonEmptyString(bucketsJson);
  if (validBucketsJson == null) {
    throw CloudStorageException(
      '$_bucketsEnvironmentVariable is missing or empty while Serverpod Cloud '
      'storage is configured.',
    );
  }

  final validServiceAccountJson = _nonEmptyString(serviceAccountJson);
  if (validServiceAccountJson == null) {
    throw CloudStorageException(
      '$_serviceAccountEnvironmentVariable is missing or empty while '
      'Serverpod Cloud storage is configured.',
    );
  }

  final configuration = _configurationForStorageId(
    validBucketsJson,
    storageId,
  );
  if (configuration == null) {
    throw CloudStorageException(
      'No GCP cloud storage configuration found for storage ID "$storageId".',
    );
  }

  return await createStorage(
    storageId: storageId,
    bucket: configuration.bucket,
    public: configuration.public,
    serviceAccountJson: validServiceAccountJson,
    publicHost: configuration.publicUrl,
  );
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
  String bucketsJson,
  String storageId,
) {
  List decoded;
  try {
    decoded = List.from(jsonDecode(bucketsJson));
  } catch (error) {
    throw CloudStorageException(
      'Invalid JSON in $_bucketsEnvironmentVariable: $error',
    );
  }

  for (final value in decoded) {
    if (value is! Map ||
        value['provider'] != 'gcp' ||
        value['storageId'] != storageId) {
      continue;
    }

    final bucket = _nonEmptyString(value['bucketName']);
    final visibility = _nonEmptyString(value['visibility']);
    if (bucket == null || (visibility != 'public' && visibility != 'private')) {
      throw CloudStorageException(
        'Invalid GCP cloud storage configuration for storage ID "$storageId".',
      );
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
