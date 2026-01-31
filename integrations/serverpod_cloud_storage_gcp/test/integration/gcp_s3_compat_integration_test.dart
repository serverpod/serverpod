@TestOn('vm')
@Tags(['integration', 'gcp'])
library;

import 'dart:io';

import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat_testing.dart';
import 'package:test/test.dart';

/// Integration tests for GCP using S3-compatible HMAC credentials.
///
/// For HMAC credential setup, see:
/// https://cloud.google.com/storage/docs/authentication/hmackeys
S3CompatTestConfig? _loadConfigFromEnvironment() {
  final accessKey =
      Platform.environment['SERVERPOD_TEST_GCP_HMAC_ACCESS_KEY_ID'];
  final secretKey = Platform.environment['SERVERPOD_TEST_GCP_HMAC_SECRET_KEY'];
  final bucket = Platform.environment['SERVERPOD_TEST_GCP_BUCKET'];
  final region =
      Platform.environment['SERVERPOD_TEST_GCP_REGION'] ?? 'us-central1';

  if (accessKey == null || secretKey == null || bucket == null) {
    return null;
  }

  return S3CompatTestConfig(
    accessKey: accessKey,
    secretKey: secretKey,
    bucket: bucket,
    region: region,
    endpoints: GcpEndpointConfig(),
    uploadStrategy: MultipartPostUploadStrategy(),
    providerName: 'GCP (S3-compatible)',
  );
}

void main() {
  runS3CompatIntegrationTests(
    config: _loadConfigFromEnvironment(),
    skipReason:
        'GCP HMAC credentials not configured in environment. '
        'Set SERVERPOD_TEST_GCP_HMAC_ACCESS_KEY_ID, SERVERPOD_TEST_GCP_HMAC_SECRET_KEY, '
        'and SERVERPOD_TEST_GCP_BUCKET to run these tests.',
  );
}
