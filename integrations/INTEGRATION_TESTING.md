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

### Google Cloud Storage

Create a bucket:

```bash
gsutil mb -l us-central1 gs://my-serverpod-test-bucket
```

Create HMAC keys at Cloud Storage → Settings → Interoperability → Create a key. See https://cloud.google.com/storage/docs/authentication/hmackeys for details.

## CI/CD Setup

### GitHub Secrets

Add these secrets to your repository (Settings → Secrets → Actions):

| Provider | Required Secrets |
|----------|------------------|
| AWS S3 | `TEST_AWS_HMAC_ACCESS_KEY_ID`, `TEST_AWS_HMAC_SECRET_KEY`, `TEST_AWS_BUCKET`, `TEST_AWS_REGION` |
| Cloudflare R2 | `TEST_R2_HMAC_ACCESS_KEY_ID`, `TEST_R2_HMAC_SECRET_KEY`, `TEST_R2_BUCKET`, `TEST_R2_ACCOUNT_ID` |
| GCP | `TEST_GCP_HMAC_ACCESS_KEY_ID`, `TEST_GCP_HMAC_SECRET_KEY`, `TEST_GCP_BUCKET`, `TEST_GCP_REGION` |

The CI workflow automatically skips providers without configured secrets and only runs on push events or same-repo PRs (not fork PRs, for security).

## Adding a New Provider

### Create the Test File

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

### Update the Local Test Runner

Add your provider to `util/run_tests_integration_cloud`:

```bash
PROVIDERS=(
    "AWS S3|serverpod_cloud_storage_s3|AWS"
    "Cloudflare R2|serverpod_cloud_storage_r2|R2"
    "GCP|serverpod_cloud_storage_gcp|GCP"
    "<Provider Name>|serverpod_cloud_storage_<provider>|<PROVIDER>"  # Add this
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
```

Add to the env block:

```yaml
env:
  # ... existing env vars ...
  SERVERPOD_TEST_<PROVIDER>_HMAC_ACCESS_KEY_ID: ${{ secrets.TEST_<PROVIDER>_HMAC_ACCESS_KEY_ID }}
  SERVERPOD_TEST_<PROVIDER>_HMAC_SECRET_KEY: ${{ secrets.TEST_<PROVIDER>_HMAC_SECRET_KEY }}
  SERVERPOD_TEST_<PROVIDER>_BUCKET: ${{ secrets.TEST_<PROVIDER>_BUCKET }}
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
