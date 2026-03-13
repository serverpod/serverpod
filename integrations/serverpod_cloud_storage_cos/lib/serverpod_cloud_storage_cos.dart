/// Tencent Cloud Object Storage (COS) integration for Serverpod.
///
/// This package provides [CosCloudStorage] for storing files in Tencent COS
/// using COS-native XML API signatures (HMAC-SHA1), without relying on the
/// S3-compatible layer.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:serverpod_cloud_storage_cos/serverpod_cloud_storage_cos.dart';
///
/// pod.addCloudStorage(CosCloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   public: true,
///   bucket: 'my-bucket-1250000000',
///   region: 'ap-guangzhou',
/// ));
/// ```
///
/// ## Configuration
///
/// Set credentials via environment variables:
/// - `SERVERPOD_COS_ACCESS_KEY_ID`
/// - `SERVERPOD_COS_SECRET_KEY`
///
/// Or in `config/passwords.yaml`:
/// ```yaml
/// shared:
///   COSAccessKeyId: your_secret_id
///   COSSecretKey: your_secret_key
/// ```
library;

export 'src/cos_cloud_storage.dart';
