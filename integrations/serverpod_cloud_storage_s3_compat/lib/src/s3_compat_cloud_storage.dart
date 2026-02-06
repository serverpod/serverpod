import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import 'client/s3_client.dart';
import 'endpoints/s3_endpoint_config.dart';
import 'upload/s3_upload_strategy.dart';

/// Base class for S3-compatible cloud storage implementations.
///
/// This class implements the [CloudStorage] interface using configurable
/// endpoint and upload strategy abstractions. Concrete implementations
/// only need to provide appropriate configuration.
///
/// Example:
/// ```dart
/// class MyS3Storage extends S3CompatCloudStorage {
///   MyS3Storage({required Serverpod serverpod, ...})
///     : super(
///         storageId: 'my-storage',
///         accessKey: ...,
///         secretKey: ...,
///         bucket: 'my-bucket',
///         region: 'us-east-1',
///         public: true,
///         endpoints: AwsEndpointConfig(),
///         uploadStrategy: MultipartPostUploadStrategy(),
///       );
/// }
/// ```
class S3CompatCloudStorage extends CloudStorage {
  /// The access key for S3 authentication.
  final String accessKey;

  /// The secret key for S3 authentication.
  final String secretKey;

  /// The bucket name.
  final String bucket;

  /// The region (e.g., 'us-east-1').
  final String region;

  /// Whether files in this storage are publicly accessible.
  final bool public;

  /// The endpoint configuration for this storage provider.
  final S3EndpointConfig endpoints;

  /// The upload strategy to use.
  final S3UploadStrategy uploadStrategy;

  late final S3Client _client;

  /// Creates a new S3-compatible cloud storage.
  ///
  /// [storageId] identifies this storage instance.
  /// [accessKey] and [secretKey] are the credentials for authentication.
  /// [bucket] is the target bucket name.
  /// [region] is the AWS region or equivalent.
  /// [public] indicates whether files should be publicly accessible.
  /// [endpoints] provides the URL patterns for this storage provider.
  /// [uploadStrategy] determines how files are uploaded.
  /// [client] can be provided for testing or custom HTTP handling.
  S3CompatCloudStorage({
    required String storageId,
    required this.accessKey,
    required this.secretKey,
    required this.bucket,
    required this.region,
    required this.public,
    required this.endpoints,
    required this.uploadStrategy,
    S3Client? client,
  }) : super(storageId) {
    _client =
        client ??
        S3Client(
          accessKey: accessKey,
          secretKey: secretKey,
          bucket: bucket,
          region: region,
          endpoints: endpoints,
        );
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await uploadStrategy.uploadData(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      data: byteData,
      path: path,
      public: public,
      endpoints: endpoints,
    );
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final response = await _client.getObject(path);
    if (response.statusCode == 200) {
      return ByteData.view(response.bodyBytes.buffer);
    }
    return null;
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (await fileExists(session: session, path: path)) {
      return endpoints.buildPublicUri(bucket, region, path);
    }
    return null;
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    final response = await _client.headObject(path);
    return response.statusCode == 200;
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    await _client.deleteObject(path);
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return uploadStrategy.createDirectUploadDescription(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: expirationDuration,
      maxFileSize: maxFileSize,
      public: public,
      endpoints: endpoints,
    );
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }
}
