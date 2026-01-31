import 's3_endpoint_config.dart';

/// AWS S3 endpoint configuration using virtual-hosted style URLs.
///
/// AWS S3 uses virtual-hosted style URLs where the bucket name is part of
/// the hostname: `bucket.s3.region.amazonaws.com`
class AwsEndpointConfig implements S3EndpointConfig {
  /// Optional custom public host for file URLs.
  ///
  /// If not provided, uses the default S3 URL pattern.
  /// Useful for CDN or custom domain configurations.
  final Uri? publicHost;

  /// Creates an AWS S3 endpoint configuration.
  const AwsEndpointConfig({this.publicHost});

  @override
  Uri buildBucketUri(String bucket, String region) =>
      Uri.https('$bucket.s3.$region.amazonaws.com', '/');

  @override
  Uri buildPublicUri(
    String bucket,
    String region,
    String path, {
    Uri? publicHost,
  }) {
    final effectiveHost = publicHost ?? this.publicHost;
    if (effectiveHost != null) {
      return effectiveHost.appendPath(path);
    }
    return Uri.https('$bucket.s3.$region.amazonaws.com', '/$path');
  }

  @override
  String get serviceName => 'AWS S3';
}
