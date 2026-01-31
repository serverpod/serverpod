/// Base package for S3-compatible cloud storage integrations with Serverpod.
///
/// This package provides abstractions for building cloud storage integrations
/// that work with S3-compatible APIs, including AWS S3, Google Cloud Storage
/// (via S3 compatibility), MinIO, and other providers.
///
/// ## Key Components
///
/// ### Endpoint Configuration
/// - [S3EndpointConfig] - Abstract interface for endpoint URLs
/// - [AwsEndpointConfig] - AWS S3 endpoint configuration
/// - [GcpEndpointConfig] - GCP S3-compatible endpoint configuration
/// - [CustomEndpointConfig] - Custom S3-compatible endpoint configuration
///
/// ### Upload Strategy
/// - [S3UploadStrategy] - Abstract interface for upload mechanisms
/// - [MultipartPostUploadStrategy] - POST with presigned policy (AWS, GCP, MinIO)
library;

// Endpoint configurations
export 'src/endpoints/aws_endpoint_config.dart';
export 'src/endpoints/custom_endpoint_config.dart';
export 'src/endpoints/gcp_endpoint_config.dart';
export 'src/endpoints/s3_endpoint_config.dart';

// Upload strategies
export 'src/upload/multipart_post_strategy.dart';
export 'src/upload/policy.dart';
export 'src/upload/s3_upload_strategy.dart';
