@TestOn('vm')
@Tags(['integration', 'aws'])
library;

import 'dart:io';

import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat_testing.dart';
import 'package:test/test.dart';

S3CompatTestConfig? _loadConfigFromEnvironment() {
  final accessKey =
      Platform.environment['SERVERPOD_TEST_AWS_HMAC_ACCESS_KEY_ID'];
  final secretKey = Platform.environment['SERVERPOD_TEST_AWS_HMAC_SECRET_KEY'];
  final bucket = Platform.environment['SERVERPOD_TEST_AWS_BUCKET'];
  final region =
      Platform.environment['SERVERPOD_TEST_AWS_REGION'] ?? 'us-east-1';

  if (accessKey == null || secretKey == null || bucket == null) {
    return null;
  }

  return S3CompatTestConfig(
    accessKey: accessKey,
    secretKey: secretKey,
    bucket: bucket,
    region: region,
    endpoints: AwsEndpointConfig(),
    uploadStrategy: MultipartPostUploadStrategy(),
    providerName: 'AWS S3',
  );
}

void main() {
  runS3CompatIntegrationTests(
    config: _loadConfigFromEnvironment(),
    skipReason:
        'AWS credentials not configured in environment. '
        'Set SERVERPOD_TEST_AWS_HMAC_ACCESS_KEY_ID, SERVERPOD_TEST_AWS_HMAC_SECRET_KEY, '
        'and SERVERPOD_TEST_AWS_BUCKET to run these tests.',
  );
}
