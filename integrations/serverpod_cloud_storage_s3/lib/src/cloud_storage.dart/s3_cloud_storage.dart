import 'package:serverpod/serverpod.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

/// AWS S3 cloud storage implementation for Serverpod.
///
/// This implementation uses AWS S3's native API with IAM credentials.
///
/// ## Configuration
///
/// Set the following environment variables or add to `config/passwords.yaml`:
/// - `SERVERPOD_AWS_ACCESS_KEY_ID` or `AWSAccessKeyId`
/// - `SERVERPOD_AWS_SECRET_KEY` or `AWSSecretKey`
///
/// ## Example
///
/// ```dart
/// pod.addCloudStorage(S3CloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   public: true,
///   region: 'us-east-1',
///   bucket: 'my-bucket',
/// ));
/// ```
class S3CloudStorage extends S3CompatCloudStorage {
  /// Creates a new AWS S3 cloud storage.
  ///
  /// [serverpod] is the Serverpod instance for loading credentials.
  /// [storageId] identifies this storage (typically 'public' or 'private').
  /// [public] indicates whether files should be publicly accessible.
  /// [region] is the AWS region (e.g., 'us-east-1').
  /// [bucket] is the S3 bucket name.
  /// [publicHost] optionally overrides the public URL host (e.g., for CDN).
  S3CloudStorage({
    required Serverpod serverpod,
    required super.storageId,
    required super.public,
    required super.region,
    required super.bucket,
    String? publicHost,
  }) : super(
         accessKey: _loadAccessKey(serverpod),
         secretKey: _loadSecretKey(serverpod),
         endpoints: AwsEndpointConfig(
           publicHost: publicHost != null
               ? Uri.parse('https://$publicHost')
               : null,
         ),
         uploadStrategy: MultipartPostUploadStrategy(),
       );

  static String _loadAccessKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_AWS_ACCESS_KEY_ID', alias: 'AWSAccessKeyId'),
    ]);
    final accessKey = serverpod.getPassword('AWSAccessKeyId');
    if (accessKey == null) {
      throw StateError(
        'AWS access key not configured. '
        'Set AWSAccessKeyId in passwords.yaml or '
        'SERVERPOD_AWS_ACCESS_KEY_ID environment variable.',
      );
    }
    return accessKey;
  }

  static String _loadSecretKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_AWS_SECRET_KEY', alias: 'AWSSecretKey'),
    ]);
    final secretKey = serverpod.getPassword('AWSSecretKey');
    if (secretKey == null) {
      throw StateError(
        'AWS secret key not configured. '
        'Set AWSSecretKey in passwords.yaml or '
        'SERVERPOD_AWS_SECRET_KEY environment variable.',
      );
    }
    return secretKey;
  }
}
