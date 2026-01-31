/// Cloudflare R2 cloud storage integration for Serverpod.
///
/// This package provides [R2CloudStorage] for storing files in Cloudflare R2.
///
/// R2 uses a PUT-based upload mechanism (via presigned URLs) instead of
/// POST multipart uploads like AWS S3. This is handled automatically.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:serverpod_cloud_storage_r2/serverpod_cloud_storage_r2.dart';
///
/// pod.addCloudStorage(R2CloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   public: true,
///   bucket: 'my-bucket',
///   accountId: 'your-cloudflare-account-id',
/// ));
/// ```
///
/// ## Configuration
///
/// Set credentials via environment variables:
/// - `SERVERPOD_R2_ACCESS_KEY_ID`
/// - `SERVERPOD_R2_SECRET_KEY`
///
/// Or in `config/passwords.yaml`:
/// ```yaml
/// shared:
///   R2AccessKeyId: your_access_key
///   R2SecretKey: your_secret_key
/// ```
library;

export 'src/r2_cloud_storage.dart';
