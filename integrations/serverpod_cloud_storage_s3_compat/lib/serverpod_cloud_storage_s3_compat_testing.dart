/// Testing utilities for S3-compatible cloud storage integration tests.
///
/// This library provides shared test helpers for running integration tests
/// against S3-compatible storage providers (AWS S3, Cloudflare R2, GCP).
///
/// Import this library in your test files to use the shared test suite:
///
/// ```dart
/// import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat_testing.dart';
///
/// void main() {
///   final config = S3CompatTestConfig(...);
///   runS3CompatIntegrationTests(config: config);
/// }
/// ```
library;

export 'src/testing/s3_compat_integration_test_helper.dart';
