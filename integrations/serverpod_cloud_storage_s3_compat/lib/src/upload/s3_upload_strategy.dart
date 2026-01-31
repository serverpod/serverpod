import 'dart:typed_data';

import '../client/exceptions.dart';
import '../endpoints/s3_endpoint_config.dart';

/// Strategy for uploading files to S3-compatible storage.
///
/// Different S3-compatible providers may use different upload mechanisms:
/// - AWS S3, GCP, MinIO: POST with presigned policy (multipart)
/// - Cloudflare R2: PUT with presigned URL
///
/// Implementations of this interface encapsulate these differences.
abstract class S3UploadStrategy {
  /// Upload file data directly from server.
  ///
  /// Returns the URL of the uploaded file on success.
  ///
  /// Throws [S3Exception] if the upload fails.
  Future<String> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
  });

  /// Generate upload description for client-side direct uploads.
  ///
  /// Returns a JSON-encoded description containing the upload URL,
  /// required fields, and other information needed by the client
  /// to upload directly to the storage provider.
  Future<String?> createDirectUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
  });

  /// The upload type identifier for client-side handling.
  ///
  /// Used by FileUploader to determine how to send the file.
  /// Common values: 'multipart', 'binary'
  String get uploadType;
}
