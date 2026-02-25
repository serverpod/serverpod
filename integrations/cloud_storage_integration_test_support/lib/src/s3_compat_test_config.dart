import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

/// Configuration for running S3-compatible integration tests.
class S3CompatTestConfig {
  /// The access key for authentication.
  final String accessKey;

  /// The secret key for authentication.
  final String secretKey;

  /// The bucket name.
  final String bucket;

  /// The region (or 'auto' for R2).
  final String region;

  /// The endpoint configuration for the provider.
  final S3EndpointConfig endpoints;

  /// The upload strategy for the provider.
  final S3UploadStrategy uploadStrategy;

  /// Human-readable provider name for test descriptions.
  final String providerName;

  /// Creates a new test configuration.
  S3CompatTestConfig({
    required this.accessKey,
    required this.secretKey,
    required this.bucket,
    required this.region,
    required this.endpoints,
    required this.uploadStrategy,
    required this.providerName,
  });
}
