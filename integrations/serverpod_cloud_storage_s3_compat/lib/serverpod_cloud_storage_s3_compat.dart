/// Base package for S3-compatible cloud storage integrations with Serverpod.
///
/// This package provides abstractions for building cloud storage integrations
/// that work with S3-compatible APIs, including AWS S3, Google Cloud Storage
/// (via S3 compatibility), MinIO, and other providers.
///
/// ## Key Components
///
/// - [S3EndpointConfig] - Configuration for endpoint URLs
/// - [AwsEndpointConfig] - AWS S3 endpoint configuration
/// - [GcpEndpointConfig] - GCP S3-compatible endpoint configuration
/// - [CustomEndpointConfig] - Custom S3-compatible endpoint configuration
library;

export 'src/endpoints/aws_endpoint_config.dart';
export 'src/endpoints/custom_endpoint_config.dart';
export 'src/endpoints/gcp_endpoint_config.dart';
export 'src/endpoints/s3_endpoint_config.dart';
