/// Extension for appending paths to URIs.
extension UriPathExtension on Uri {
  /// Appends a path to this URI, returning a new URI.
  ///
  /// Unlike [Uri.resolve], this always appends regardless of trailing slash.
  /// Resolves `.` and `..` segments per RFC 3986.
  ///
  /// Example:
  /// ```dart
  /// final base = Uri.parse('https://cdn.example.com/assets');
  /// final result = base.appendPath('images/../icons/logo.png');
  /// // Result: https://cdn.example.com/assets/icons/logo.png
  /// ```
  Uri appendPath(String path) {
    // Ensure trailing slash so resolve() appends rather than replaces
    final baseWithSlash = this.path.endsWith('/')
        ? this
        : replace(path: '${this.path}/');
    return baseWithSlash.resolve(path);
  }
}

/// Configuration for S3-compatible endpoint URLs.
///
/// Different S3-compatible providers use different URL patterns:
/// - AWS S3: Virtual-hosted style (bucket.s3.region.amazonaws.com)
/// - GCP: Path-style (storage.googleapis.com/bucket)
/// - LocalStack: Custom host with path-style
///
/// Implementations of this interface encapsulate these differences.
abstract class S3EndpointConfig {
  /// URI for the bucket, used for both API operations and uploads.
  ///
  /// For API operations (GET, HEAD, DELETE), the object key is appended
  /// to this URI's path.
  ///
  /// For uploads, this URI is used as the POST target with the key
  /// specified in form data.
  ///
  /// Example (AWS): `https://mybucket.s3.us-east-1.amazonaws.com`
  /// Example (GCP): `https://storage.googleapis.com/mybucket`
  Uri buildBucketUri(String bucket, String region);

  /// Public URI for accessing a file.
  ///
  /// [publicHost] can be provided to override the default public URL
  /// (e.g., for CDN or custom domain).
  Uri buildPublicUri(
    String bucket,
    String region,
    String path, {
    Uri? publicHost,
  });

  /// Service name for error messages and logging.
  String get serviceName;
}
