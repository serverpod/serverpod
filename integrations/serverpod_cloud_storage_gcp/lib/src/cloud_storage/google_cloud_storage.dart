import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

/// Google Cloud Storage implementation using S3-compatible API with HMAC credentials.
///
/// This implementation uses GCP's S3-compatible API endpoint, which allows
/// using the same SigV4 signing mechanism as AWS S3. Requires HMAC credentials
/// to be configured in Serverpod's password system.
///
/// For HMAC credential setup, see:
/// https://cloud.google.com/storage/docs/authentication/hmackeys
class GoogleCloudStorage extends S3CompatCloudStorage {
  /// Creates a new [GoogleCloudStorage] reference.
  ///
  /// The [serverpod] instance is used to load HMAC credentials from the
  /// password system. Credentials can be set via:
  /// - `passwords.yaml`: `HMACAccessKeyId` and `HMACSecretKey`
  /// - Environment variables: `SERVERPOD_HMAC_ACCESS_KEY_ID` and
  ///   `SERVERPOD_HMAC_SECRET_KEY`
  ///
  /// The [storageId] uniquely identifies this storage configuration.
  ///
  /// Set [public] to true if files should be publicly accessible.
  ///
  /// The [region] should be the GCS region (e.g., 'us-central1').
  ///
  /// The [bucket] is the name of the GCS bucket.
  ///
  /// Optionally specify [publicHost] to use a custom domain for public URLs.
  GoogleCloudStorage({
    required Serverpod serverpod,
    required super.storageId,
    required super.public,
    required super.region,
    required super.bucket,
    String? publicHost,
  }) : super(
         accessKey: _loadAccessKey(serverpod),
         secretKey: _loadSecretKey(serverpod),
         endpoints: GcpEndpointConfig(
           publicHost: publicHost != null
               ? Uri.parse('https://$publicHost')
               : null,
         ),
         uploadStrategy: MultipartPostUploadStrategy(),
       );

  static String _loadAccessKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_HMAC_ACCESS_KEY_ID', alias: 'HMACAccessKeyId'),
    ]);
    var accessKey = serverpod.getPassword('HMACAccessKeyId');
    if (accessKey == null) {
      throw StateError('HMACAccessKeyId must be configured in your passwords.');
    }
    return accessKey;
  }

  static String _loadSecretKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_HMAC_SECRET_KEY', alias: 'HMACSecretKey'),
    ]);
    var secretKey = serverpod.getPassword('HMACSecretKey');
    if (secretKey == null) {
      throw StateError('HMACSecretKey must be configured in your passwords.');
    }
    return secretKey;
  }
}
