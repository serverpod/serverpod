import 's3_endpoint_config.dart';

/// GCP Cloud Storage endpoint configuration using S3-compatible API.
///
/// GCP provides an S3-compatible API using path-style URLs:
/// `storage.googleapis.com/bucket`
class GcpEndpointConfig extends S3EndpointConfig {
  /// Optional custom public host for file URLs.
  ///
  /// If not provided, uses the default GCP Storage URL pattern.
  /// Useful for CDN or custom domain configurations.
  final Uri? publicHost;

  /// Creates a GCP S3-compatible endpoint configuration.
  const GcpEndpointConfig({this.publicHost});

  @override
  Uri buildBucketUri(String bucket, String region) =>
      Uri.https('storage.googleapis.com', '/$bucket');

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
    return Uri.https('storage.googleapis.com', '/$bucket/$path');
  }

  @override
  bool get supportsObjectAcl => false;

  @override
  String get serviceName => 'Google Cloud Storage';
}
