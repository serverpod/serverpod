import 'package:serverpod_test/serverpod_test.dart';

abstract final class TestTags {
  // Tag for concurrency=1 is aligned with `test_server` package.
  // We also need to retain the "integration" test marker, in order to not run these as unit tests.
  static const concurrencyOneTestTags = [
    'concurrency_one',
    defaultIntegrationTestTag,
  ];
}
