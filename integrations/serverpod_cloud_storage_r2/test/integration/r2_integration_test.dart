@TestOn('vm')
@Tags(['integration', 'r2'])
library;

import 'dart:io';

import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat_testing.dart';
import 'package:test/test.dart';

S3CompatTestConfig? _loadConfigFromEnvironment() {
  final accessKey =
      Platform.environment['SERVERPOD_TEST_R2_HMAC_ACCESS_KEY_ID'];
  final secretKey = Platform.environment['SERVERPOD_TEST_R2_HMAC_SECRET_KEY'];
  final bucket = Platform.environment['SERVERPOD_TEST_R2_BUCKET'];
  final accountId = Platform.environment['SERVERPOD_TEST_R2_ACCOUNT_ID'];

  if (accessKey == null ||
      secretKey == null ||
      bucket == null ||
      accountId == null) {
    return null;
  }

  return S3CompatTestConfig(
    accessKey: accessKey,
    secretKey: secretKey,
    bucket: bucket,
    region: 'auto',
    endpoints: R2EndpointConfig(accountId: accountId),
    uploadStrategy: PresignedPutUploadStrategy(),
    providerName: 'Cloudflare R2',
  );
}

void main() {
  runS3CompatIntegrationTests(
    config: _loadConfigFromEnvironment(),
    skipReason:
        'R2 credentials not configured in environment. '
        'Set SERVERPOD_TEST_R2_HMAC_ACCESS_KEY_ID, SERVERPOD_TEST_R2_HMAC_SECRET_KEY, '
        'SERVERPOD_TEST_R2_BUCKET, and SERVERPOD_TEST_R2_ACCOUNT_ID to run these tests.',
  );
}
