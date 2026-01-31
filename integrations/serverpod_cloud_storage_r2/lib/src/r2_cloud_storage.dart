import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

/// Cloudflare R2 cloud storage implementation for Serverpod.
///
/// This implementation uses Cloudflare's S3-compatible API with R2-specific
/// endpoint configuration and PUT-based uploads (R2 doesn't support POST
/// multipart uploads like AWS S3).
///
/// ## Configuration
///
/// Set the following environment variables or add to `config/passwords.yaml`:
/// - `SERVERPOD_R2_ACCESS_KEY_ID` or `R2AccessKeyId`
/// - `SERVERPOD_R2_SECRET_KEY` or `R2SecretKey`
///
/// ## Example
///
/// ```dart
/// pod.addCloudStorage(R2CloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   public: true,
///   bucket: 'my-bucket',
///   accountId: 'your-cloudflare-account-id',
/// ));
/// ```
class R2CloudStorage extends S3CompatCloudStorage {
  /// Creates a new Cloudflare R2 cloud storage.
  ///
  /// [serverpod] is the Serverpod instance for loading credentials.
  /// [storageId] identifies this storage (typically 'public' or 'private').
  /// [public] indicates whether files should be publicly accessible.
  /// [bucket] is the R2 bucket name.
  /// [accountId] is your Cloudflare account ID.
  /// [publicHost] optionally overrides the public URL host (e.g., for custom domain).
  R2CloudStorage({
    required Serverpod serverpod,
    required super.storageId,
    required super.public,
    required super.bucket,
    required String accountId,
    String? publicHost,
  }) : super(
         accessKey: _loadAccessKey(serverpod),
         secretKey: _loadSecretKey(serverpod),
         region: 'auto', // R2 uses 'auto' as the region
         endpoints: R2EndpointConfig(
           accountId: accountId,
           publicHost: publicHost != null
               ? Uri.parse('https://$publicHost')
               : null,
         ),
         uploadStrategy: PresignedPutUploadStrategy(),
       );

  static String _loadAccessKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_R2_ACCESS_KEY_ID', alias: 'R2AccessKeyId'),
    ]);
    final accessKey = serverpod.getPassword('R2AccessKeyId');
    if (accessKey == null) {
      throw StateError(
        'R2 access key not configured. '
        'Set R2AccessKeyId in passwords.yaml or '
        'SERVERPOD_R2_ACCESS_KEY_ID environment variable.',
      );
    }
    return accessKey;
  }

  static String _loadSecretKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_R2_SECRET_KEY', alias: 'R2SecretKey'),
    ]);
    final secretKey = serverpod.getPassword('R2SecretKey');
    if (secretKey == null) {
      throw StateError(
        'R2 secret key not configured. '
        'Set R2SecretKey in passwords.yaml or '
        'SERVERPOD_R2_SECRET_KEY environment variable.',
      );
    }
    return secretKey;
  }
}
