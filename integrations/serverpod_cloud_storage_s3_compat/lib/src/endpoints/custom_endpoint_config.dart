import 's3_endpoint_config.dart';

/// Custom S3-compatible endpoint configuration.
///
/// Use this for self-hosted S3-compatible services like MinIO, LocalStack,
/// or other providers not covered by the built-in configurations.
class CustomEndpointConfig implements S3EndpointConfig {
  /// Base URI for the S3-compatible service.
  ///
  /// Example: `Uri.http('localhost:9000', '/')` for local MinIO.
  final Uri baseUri;

  final String _serviceName;

  /// Creates a custom S3-compatible endpoint configuration.
  ///
  /// [baseUri] is the base URI of the S3-compatible service.
  /// [serviceName] is used for error messages and logging.
  const CustomEndpointConfig({
    required this.baseUri,
    String serviceName = 'S3-compatible storage',
  }) : _serviceName = serviceName;

  @override
  Uri buildBucketUri(String bucket, String region) =>
      baseUri.appendPath(bucket);

  @override
  Uri buildPublicUri(
    String bucket,
    String region,
    String path, {
    Uri? publicHost,
  }) {
    final base = publicHost ?? baseUri;
    return base.appendPath(bucket).appendPath(path);
  }

  @override
  String get serviceName => _serviceName;
}
