/// Google Cloud Storage integration for Serverpod.
///
/// This package provides two implementations:
///
/// 1. [GoogleCloudStorage] - Uses GCP's S3-compatible API with HMAC credentials.
///    This is the original implementation and is compatible with existing setups.
///
/// 2. [NativeGoogleCloudStorage] - Uses Google Cloud's native JSON API with
///    service account credentials. This provides full GCP feature support.
library;

export 'src/cloud_storage/google_cloud_storage.dart';
export 'src/native/native_google_cloud_storage.dart';
