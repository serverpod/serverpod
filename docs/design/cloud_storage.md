# Design: Cloud Storage Improvements

This document proposes improvements to Serverpod's cloud storage integration to address code duplication, extensibility limitations, and the lack of native GCP support.

## Current State

Serverpod has two cloud storage packages:

1. **`serverpod_cloud_storage_s3`** - AWS S3 integration using IAM credentials
2. **`serverpod_cloud_storage_gcp`** - GCP integration using S3-compatible API with HMAC credentials

Limitations:
- **~98% code duplication** between packages (same SigV4 signing, same upload mechanism)
- **No native GCP support** - GCP package uses S3 compatibility layer
- **Limited extensibility** - Adding new providers requires duplicating the entire codebase

Community demand exists for additional providers (Cloudflare R2, local filesystem).

### Related Issues and PRs

- Issue #4623: Cloud storage improvements (light)
- Issue #3128: Cloud storage improvements RFC (comprehensive)
- PR #4200: S3Options abstraction for LocalStack
- PR #3938: Cloudflare R2 support
- PR #4525: Local filesystem storage

## Proposal

Create a layered architecture with a shared base package (`serverpod_cloud_storage_s3_compat`) that provider-specific packages extend as thin wrappers. Add native GCP implementation using Google Cloud's JSON API.

> [!NOTE]
> Open question: Is `serverpod_cloud_storage_s3_compat` the right name?

## Architecture

## Package Structure

```
integrations/
├── serverpod_cloud_storage_s3_compat/    # Shared base package (new)
├── serverpod_cloud_storage_s3/           # AWS-specific thin wrapper
├── serverpod_cloud_storage_gcp/          # GCP S3-compat + native implementation
└── serverpod_cloud_storage_r2/           # Cloudflare R2 support (new)
```

## Key Abstractions

### Endpoint Configuration (`S3EndpointConfig`)

Different providers use different URL patterns:
- **AWS**: Virtual-hosted style (`bucket.s3.region.amazonaws.com`)
- **GCP**: Path style (`storage.googleapis.com/bucket`)
- **Custom**: Configurable base URI for LocalStack, etc.

```dart
abstract class S3EndpointConfig {
  /// URI for the bucket (API operations and uploads).
  Uri buildBucketUri(String bucket, String region);

  /// Public URI for accessing a file.
  Uri buildPublicUri(String bucket, String region, String path, {Uri? publicHost});

  /// Service name for error messages and logging.
  String get serviceName;
}
```

Built-in implementations: `AwsEndpointConfig`, `GcpEndpointConfig`, `R2EndpointConfig`, `CustomEndpointConfig`

### Upload Strategy (`S3UploadStrategy`)

| Provider           | Upload Method | Request Format                       |
| ------------------ | ------------- | ------------------------------------ |
| AWS S3, GCP, LocalStack | POST          | Multipart form with presigned policy |
| Cloudflare R2      | PUT           | Raw bytes with presigned URL         |

```dart
abstract class S3UploadStrategy {
  /// Upload file data directly from server. Throws [S3Exception] on failure.
  Future<String> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
  });

  /// Generate upload description for client-side direct uploads.
  Future<String?> createDirectUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
  });

  /// Upload type identifier for client-side handling ('multipart' or 'binary').
  String get uploadType;
}
```

Built-in implementations: `MultipartPostUploadStrategy`, `PresignedPutUploadStrategy`

### Base Implementation (`S3CompatCloudStorage`)

Will implement all `CloudStorage` methods using configurable endpoints and upload strategy. Takes `accessKey` and `secretKey` as constructor parameters.

Provider-specific packages will become thin wrappers that load credentials from Serverpod's password configuration (e.g., `AWSAccessKeyId` from passwords.yaml or `SERVERPOD_AWS_ACCESS_KEY_ID` env var) and configure the appropriate endpoint and upload strategy.

### Native GCP Implementation (`NativeGoogleCloudStorage`)

Will use Google Cloud's JSON API directly via `googleapis` package:
- Service account credentials (JSON stored in passwords.yaml)
- V4 signed URLs for direct uploads (GOOG4-RSA-SHA256 signing)
- Full GCP feature support without S3 compatibility limitations

# Backwards Compatibility

The refactored packages will maintain full backwards compatibility:
- Same constructor parameters for `S3CloudStorage` and `GoogleCloudStorage`
- Same environment variable names
- Existing code will work without modifications
