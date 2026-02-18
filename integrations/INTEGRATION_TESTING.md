# Cloud Storage Integration Testing

This guide explains how to run integration tests for cloud storage providers and how to add tests for new providers.

## Quick Start

### Set Up Credentials

Create `integrations/.env.test` with your provider credentials:

```bash
# AWS S3
SERVERPOD_TEST_AWS_HMAC_ACCESS_KEY_ID=AKIA...
SERVERPOD_TEST_AWS_HMAC_SECRET_KEY=...
SERVERPOD_TEST_AWS_BUCKET=your-test-bucket
SERVERPOD_TEST_AWS_REGION=us-east-1

# Cloudflare R2
SERVERPOD_TEST_R2_HMAC_ACCESS_KEY_ID=...
SERVERPOD_TEST_R2_HMAC_SECRET_KEY=...
SERVERPOD_TEST_R2_BUCKET=your-r2-bucket
SERVERPOD_TEST_R2_ACCOUNT_ID=your-cloudflare-account-id

# GCP (S3-compatible HMAC)
SERVERPOD_TEST_GCP_HMAC_ACCESS_KEY_ID=GOOG...
SERVERPOD_TEST_GCP_HMAC_SECRET_KEY=...
SERVERPOD_TEST_GCP_BUCKET=your-gcs-bucket
SERVERPOD_TEST_GCP_REGION=us-central1

# GCP (Native API with service account)
SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON={"client_email":"...","private_key":"..."}
```

You only need credentials for the providers you want to test. Tests for unconfigured providers are skipped automatically.

### Run Tests

```bash
# Run all providers
util/run_tests_integration_cloud

# Run a specific provider
cd integrations/serverpod_cloud_storage_s3
dart test test/integration
```

## Getting Provider Credentials

### AWS S3

Create a test bucket:

```bash
aws s3 mb s3://my-serverpod-test-bucket --region us-east-1
```

Create an IAM user with minimal permissions. Go to IAM → Users → Create user, then attach this inline policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"],
    "Resource": [
      "arn:aws:s3:::my-serverpod-test-bucket",
      "arn:aws:s3:::my-serverpod-test-bucket/*"
    ]
  }]
}
```

Generate access keys at IAM → Users → your-user → Security credentials → Create access key.

### Cloudflare R2

Create a bucket in the Cloudflare Dashboard → R2.

Create an API token at R2 → Manage R2 API Tokens → Create API Token with Object Read & Write permissions.

Get your Account ID from the dashboard URL: `dash.cloudflare.com/<ACCOUNT_ID>/r2`

### Google Cloud Storage (S3-compatible)

Create a bucket:

```bash
gsutil mb -l us-central1 gs://my-serverpod-test-bucket
```

Create HMAC keys at Cloud Storage → Settings → Interoperability → Create a key. See https://cloud.google.com/storage/docs/authentication/hmackeys for details.

### Google Cloud Storage (Native)

Uses the same GCP project and bucket as the S3-compatible tests, but authenticates with a service account instead of HMAC keys.

Create a service account at IAM & Admin → Service Accounts → Create service account. Grant the `Storage Object Admin` role scoped to your test bucket.

Create a JSON key: click the service account → Keys → Add Key → Create new key → JSON. Download the file.

Set the `SERVERPOD_TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON` environment variable to the full JSON content of the key file.

## CI/CD Setup

### GitHub Secrets

Add these secrets to your repository (Settings → Secrets → Actions):

| Provider | Required Secrets |
|----------|------------------|
| AWS S3 | `TEST_AWS_HMAC_ACCESS_KEY_ID`, `TEST_AWS_HMAC_SECRET_KEY`, `TEST_AWS_BUCKET`, `TEST_AWS_REGION` |
| Cloudflare R2 | `TEST_R2_HMAC_ACCESS_KEY_ID`, `TEST_R2_HMAC_SECRET_KEY`, `TEST_R2_BUCKET`, `TEST_R2_ACCOUNT_ID` |
| GCP (S3-compatible) | `TEST_GCP_HMAC_ACCESS_KEY_ID`, `TEST_GCP_HMAC_SECRET_KEY`, `TEST_GCP_BUCKET`, `TEST_GCP_REGION` |
| GCP Native | `TEST_GCP_NATIVE_SERVICE_ACCOUNT_JSON`, `TEST_GCP_BUCKET` |

The CI workflow automatically skips providers without configured secrets and only runs on push events or same-repo PRs (not fork PRs, for security).

## Adding a New Provider

There are two approaches depending on whether your provider has an S3-compatible API.

### Option A: S3-Compatible Provider

If the provider supports the S3 API (e.g., MinIO, Backblaze B2, DigitalOcean Spaces), you can reuse the shared test suite from `serverpod_cloud_storage_s3_compat`. This gives you full test coverage with minimal code.

Create `integrations/serverpod_cloud_storage_<provider>/test/integration/<provider>_integration_test.dart`:

```dart
@TestOn('vm')
@Tags(['integration', '<provider>'])
library;

import 'dart:io';

import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat_testing.dart';
import 'package:test/test.dart';

S3CompatTestConfig? _loadConfigFromEnvironment() {
  final accessKey =
      Platform.environment['SERVERPOD_TEST_<PROVIDER>_HMAC_ACCESS_KEY_ID'];
  final secretKey =
      Platform.environment['SERVERPOD_TEST_<PROVIDER>_HMAC_SECRET_KEY'];
  final bucket = Platform.environment['SERVERPOD_TEST_<PROVIDER>_BUCKET'];
  // Add any provider-specific variables (e.g., region, account ID)

  if (accessKey == null || secretKey == null || bucket == null) {
    return null;
  }

  return S3CompatTestConfig(
    accessKey: accessKey,
    secretKey: secretKey,
    bucket: bucket,
    region: '<region-or-auto>',
    endpoints: <YourEndpointConfig>(),       // e.g., CustomEndpointConfig(...)
    uploadStrategy: <YourUploadStrategy>(),  // e.g., PresignedPutUploadStrategy()
    providerName: '<Provider Name>',
  );
}

void main() {
  runS3CompatIntegrationTests(
    config: _loadConfigFromEnvironment(),
    skipReason: '<Provider> credentials not configured. '
        'Set SERVERPOD_TEST_<PROVIDER>_HMAC_ACCESS_KEY_ID and related variables.',
  );
}
```

### Option B: Non-S3 Provider (Custom `CloudStorage` Implementation)

If the provider uses its own API (e.g., GCP Native, local filesystem), you need to write your own integration tests. The tests should cover the same operations as the shared S3-compat suite:

- **Basic operations**: `storeFile`, `retrieveFile`, `fileExists`, `deleteFile`
- **Binary data**: exact byte preservation, large files (1MB)
- **Direct uploads**: `createDirectFileUploadDescription` + upload via `FileUploader` + `verifyDirectFileUpload` (if supported)
- **Special characters**: paths with spaces and unicode

See `serverpod_cloud_storage_gcp/test/integration/native_gcp_integration_test.dart` for an example. Key patterns:

- Load credentials from environment variables, return `null` to skip if missing
- Use a mock `Session` (the `CloudStorage` methods require it but most implementations don't use it)
- Track created files and clean up in `tearDownAll`

### Update the Local Test Runner

Add your provider to `util/run_tests_integration_cloud`:

```bash
PROVIDERS=(
    # ... existing providers ...
    "<Provider Name>|serverpod_cloud_storage_<provider>|<PROVIDER>|test/integration"  # Add this
)
```

### Update GitHub Actions

In `.github/workflows/dart-tests.yaml`, add to the `cloud_storage_integration_tests` job.

Add to the matrix:

```yaml
provider:
  # ... existing providers ...
  - name: <Provider Name>
    package: serverpod_cloud_storage_<provider>
    env_prefix: <PROVIDER>
    test_path: test/integration
```

Add to the env block:

```yaml
env:
  # ... existing env vars ...
  SERVERPOD_TEST_<PROVIDER>_<CREDENTIAL>: ${{ secrets.TEST_<PROVIDER>_<CREDENTIAL> }}
  # Add any provider-specific variables
```

### Add Test Dependency

Ensure the package's `pubspec.yaml` template includes `test` as a dev dependency and has the `serverpod_client` override (for the `FileUploader` used in direct upload tests).

## Test Coverage

The shared test suite (`runS3CompatIntegrationTests`) covers:

- Basic operations: upload, retrieve, check existence, delete
- Binary data: verifies exact byte preservation
- Large files: 1MB upload test
- Direct uploads: uses `FileUploader` to simulate client-side uploads
- Special characters: paths with spaces and unicode

## Security Notes

- Never commit `.env.test` - it's gitignored
- Use dedicated test buckets - never test against production
- Minimal permissions - only grant what's needed for tests
- Rotate credentials periodically
