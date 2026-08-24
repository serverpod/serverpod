import 'dart:io' show HttpDate;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import 'client/exceptions.dart';
import 'client/s3_client.dart';
import 'config/s3_endpoint_config.dart';
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

  /// Closes the underlying HTTP client.
  ///
  /// Call this when the storage instance is no longer needed to free
  /// resources. After calling [close], no further operations should be
  /// performed on this instance.
  void close() {
    _client.close();
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) async {
    if (options.expiration != null) {
      throw CloudStorageUnsupportedOperationException(
        storageId: storageId,
        operation: 'per-file expiration',
      );
    }
    _checkPreventOverwrite(options.preventOverwrite);

    try {
      await uploadStrategy.uploadData(
        accessKey: accessKey,
        secretKey: secretKey,
        bucket: bucket,
        region: region,
        data: byteData,
        path: path,
        public: public,
        endpoints: endpoints,
        metadata: options.metadata,
        preventOverwrite: options.preventOverwrite,
      );
    } on S3Exception catch (error) {
      if (options.preventOverwrite && error.response.statusCode == 412) {
        throw CloudStorageFileAlreadyExistsException(
          storageId: storageId,
          path: path,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ByteData> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final response = await _client.getObject(path);
    if (response.statusCode == 200) {
      return ByteData.sublistView(response.bodyBytes);
    }
    if (response.statusCode == 404) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }
    _throwForResponse(response);
  }

  @override
  Future<FileStat> statFile({
    required Session session,
    required String path,
  }) async {
    final response = await _client.headObject(path);
    if (response.statusCode == 404) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }
    if (response.statusCode != 200) _throwForResponse(response);

    final size = int.tryParse(response.headers['content-length'] ?? '');
    if (size == null) {
      throw CloudStorageException(
        'S3 did not return Content-Length for file "$path".',
      );
    }
    DateTime? lastModified;
    final lastModifiedHeader = response.headers['last-modified'];
    if (lastModifiedHeader != null) {
      try {
        lastModified = HttpDate.parse(lastModifiedHeader);
      } on FormatException catch (error) {
        throw CloudStorageException(
          'S3 returned an invalid Last-Modified value for file "$path". '
          '($error)',
        );
      }
    }
    final custom = <String, String>{};
    for (final entry in response.headers.entries) {
      if (entry.key.startsWith('x-amz-meta-')) {
        custom[entry.key.substring('x-amz-meta-'.length)] = entry.value;
      }
    }

    return FileStat(
      size: size,
      lastModified: lastModified,
      contentType: response.headers['content-type'],
      cacheControl: response.headers['cache-control'],
      contentDisposition: response.headers['content-disposition'],
      contentEncoding: response.headers['content-encoding'],
      etag: response.headers['etag'],
      custom: custom,
    );
  }

  @override
  Future<Uri> publicDownloadUrl({
    required Session session,
    required String path,
  }) async {
    if (!public) {
      throw CloudStorageUnsupportedOperationException(
        storageId: storageId,
        operation: 'public download URLs',
      );
    }
    await statFile(session: session, path: path);
    return endpoints.buildPublicUri(bucket, region, path);
  }

  @override
  Future<Uri> temporaryDownloadUrl({
    required Session session,
    required String path,
    TemporaryDownloadUrlOptions options = const TemporaryDownloadUrlOptions(),
  }) async {
    options.validate();
    await statFile(session: session, path: path);
    final responseOverrides = <String, String>{
      if (options.contentType != null)
        'response-content-type': options.contentType!,
      if (options.downloadFileName != null)
        'response-content-disposition':
            "attachment; filename*=UTF-8''${Uri.encodeComponent(options.downloadFileName!)}",
    };
    return _client.buildPresignedUri(
      key: path,
      method: 'GET',
      expiration: options.expirationDuration,
      queryParams: responseOverrides,
    );
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    final response = await _client.deleteObject(path);
    // 204 = deleted, 404 = already gone — both are success.
    if (response.statusCode == 204 || response.statusCode == 404) return;
    _throwForResponse(response);
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required Session session,
    required String path,
    UploadOptions options = const UploadOptions(),
  }) async {
    options.validate();
    _checkPreventOverwrite(options.preventOverwrite);
    if (options.contentLength == null && !uploadStrategy.supportsMaxFileSize) {
      throw CloudStorageUnsupportedOperationException(
        storageId: storageId,
        operation: 'maxFileSize enforcement without an exact contentLength',
      );
    }
    return uploadStrategy.createUploadDescription(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: options.expirationDuration,
      maxFileSize: options.maxFileSize,
      public: public,
      endpoints: endpoints,
      metadata: options.metadata,
      contentLength: options.contentLength,
      preventOverwrite: options.preventOverwrite,
    );
  }

  @override
  Future<bool> verifyUpload({
    required Session session,
    required String path,
  }) async {
    try {
      await statFile(session: session, path: path);
      return true;
    } on CloudStorageFileNotFoundException {
      return false;
    }
  }

  void _checkPreventOverwrite(bool preventOverwrite) {
    if (preventOverwrite && !uploadStrategy.supportsPreventOverwrite) {
      throw CloudStorageUnsupportedOperationException(
        storageId: storageId,
        operation: 'preventOverwrite uploads',
      );
    }
  }

  Never _throwForResponse(http.Response response) {
    if (response.statusCode == 403) {
      throw NoPermissionsException(response);
    }
    throw S3Exception(response);
  }
}
