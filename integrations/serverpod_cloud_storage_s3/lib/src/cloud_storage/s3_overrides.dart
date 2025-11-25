/// Configuration for S3 or S3-compatible storage endpoint overrides.
///
/// Use this class to configure connections to S3-compatible storage services
/// like MinIO, LocalStack, or custom S3 implementations.
class S3Overrides {
  S3Overrides({
    this.endpointUrl,
    this.host,
    this.useHttps = true,
  });

  /// Custom endpoint URL for upload operations.
  /// Example: 'http://localhost:9000' for MinIO
  final String? endpointUrl;

  /// Custom host for S3 API operations.
  /// Example: 'localhost:9000' for MinIO
  final String? host;

  /// Whether to use HTTPS. Defaults to true for AWS S3.
  final bool useHttps;

  /// Builds the host string for S3 client API operations.
  ///
  /// Returns custom [host] if provided, otherwise returns standard AWS S3 host.
  String buildClientHost({required String region}) {
    return host ?? 's3.$region.amazonaws.com';
  }

  /// Builds the public host for generating public URLs.
  ///
  /// Returns custom host if provided, otherwise returns standard AWS S3 format.
  String buildPublicHost({
    required String bucket,
    required String region,
    String? publicHost,
  }) {
    return publicHost ?? host ?? '$bucket.s3.$region.amazonaws.com';
  }

  /// Builds the full endpoint URL for upload operations.
  ///
  /// Returns the complete endpoint URL including the bucket.
  /// For custom endpoints, appends the bucket to the endpointUrl.
  /// For AWS S3, returns the standard AWS S3 endpoint format.
  String buildUploadEndpoint({
    required String bucket,
    required String region,
  }) {
    final endpoint = endpointUrl;
    if (endpoint != null && endpoint.isNotEmpty) {
      return '${endpoint.endsWith('/') ? endpoint : '$endpoint/'}$bucket';
    }
    return 'https://$bucket.s3-$region.amazonaws.com';
  }
}
