import 's3_endpoint_config.dart';

/// Cloudflare R2 endpoint configuration.
///
/// R2 uses a different URL pattern than AWS S3:
/// - API endpoint: `accountId.r2.cloudflarestorage.com`
/// - Public URLs: `bucket.accountId.r2.dev` (or custom domain)
///
/// R2 uses 'auto' as the region for all operations.
class R2EndpointConfig implements S3EndpointConfig {
  /// The Cloudflare account ID.
  final String accountId;

  /// Optional custom public host for file URLs.
  ///
  /// If not provided, uses the default R2 public URL pattern.
  /// Useful for custom domain configurations.
  final Uri? publicHost;

  /// Creates an R2 endpoint configuration.
  ///
  /// [accountId] is the Cloudflare account ID (required for R2 URLs).
  /// [publicHost] optionally overrides the public URL host.
  const R2EndpointConfig({
    required this.accountId,
    this.publicHost,
  });

  @override
  Uri buildBucketUri(String bucket, String region) =>
      Uri.https('$accountId.r2.cloudflarestorage.com', '/$bucket');

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
    return Uri.https('$bucket.$accountId.r2.dev', '/$path');
  }

  @override
  String get serviceName => 'Cloudflare R2';
}
