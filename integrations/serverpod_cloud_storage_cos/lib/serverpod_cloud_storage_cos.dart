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
/// ## Bucket Naming
///
/// COS bucket names must include the APPID suffix, e.g.
/// `my-bucket-1250000000`. You can find your APPID in the Tencent Cloud
/// console under Account Info.
///
/// ## Credential Resolution
///
/// Credentials are resolved in the following order (first non-null wins):
///
/// 1. **Environment variable** — `SERVERPOD_COS_ACCESS_KEY_ID` /
///    `SERVERPOD_COS_SECRET_KEY`
/// 2. **passwords.yaml alias** — `COSAccessKeyId` / `COSSecretKey`
/// 3. **Legacy alias** — `tencentCosSecretId` / `tencentCosSecretKey`
///
/// Example `config/passwords.yaml`:
/// ```yaml
/// shared:
///   COSAccessKeyId: your_secret_id
///   COSSecretKey: your_secret_key
/// ```
///
/// ## publicHost Semantics
///
/// The optional `publicHost` parameter only affects URLs returned by
/// `getPublicUrl()`. All internal server-side operations (`storeFile`,
/// `retrieveFile`, `fileExists`, `deleteFile`) and direct upload
/// presigned URLs always target the COS bucket endpoint
/// (`<bucket>.cos.<region>.myqcloud.com`), because CDN / custom domains
/// typically do not accept PUT/HEAD/DELETE requests.
library;

export 'src/cos_cloud_storage.dart';
