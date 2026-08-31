import 'dart:typed_data';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import '../client/exceptions.dart';
import '../config/s3_endpoint_config.dart';

/// Strategy for uploading files to S3-compatible storage.
///
/// Different S3-compatible providers may use different upload mechanisms:
/// - AWS S3, GCP, LocalStack: POST with presigned policy (multipart)
/// - Cloudflare R2: PUT with presigned URL
///
/// Implementations of this interface encapsulate these differences.
abstract class S3UploadStrategy {
  /// Upload file data directly from server.
  ///
  /// Throws [S3Exception] if the upload fails.
  Future<void> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    bool preventOverwrite = false,
  });

  /// Generate upload description for client-side direct uploads.
  ///
  /// Returns a typed description containing the upload URL and request data.
  Future<UploadDescription> createUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    int? contentLength,
    bool preventOverwrite = false,
  });

  /// The upload type identifier for client-side handling.
  ///
  /// Used by FileUploader to determine how to send the file.
  /// Common values: 'multipart', 'binary'
  String get uploadType;

  /// Whether this strategy can atomically prevent overwriting an object.
  bool get supportsPreventOverwrite;
}
