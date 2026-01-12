import 'dart:io';

abstract final class TestTags {
  static const concurrencyOne = [
    'concurrency_one',
  ];

  /// To be used for tests that fail if running concurrently on Windows due to
  /// what seems to be isolation issues on Windows GitHub runners.
  static List<String> get concurrencyOneOnlyOnWindows => [
    if (Platform.isWindows) ...concurrencyOne,
  ];
}
