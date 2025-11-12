import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

void main() async {
  test(
    'Given that withServerpod can not find the database and has a timeout set to 0 seconds '
    'when running the test '
    'then should timeout immediately',
    () async {
      final result = await runTest('test_that_will_timeout.dart');

      expect(result.exitCode, 1);
      expect(
        result.stdout,
        contains(
          'Serverpod did not start within the timeout of 0:00:00.000000',
        ),
      );
    },
    tags: [defaultIntegrationTestTag],
  );

  test(
    'Given that withServerpod can not find the database and does not have timeout set '
    'when running the test '
    'then should timeout after the 30 seconds default timeout',
    () async {
      var timer = Stopwatch()..start();
      final result = await runTest('test_that_will_timeout_after_default.dart');

      expect(result.exitCode, 1);
      expect(
        result.stdout,
        contains(
          'Serverpod did not start within the timeout of 0:00:30.000000',
        ),
      );
      expect(
        timer.elapsed.inSeconds,
        greaterThanOrEqualTo(30),
      );
    },
    timeout: Timeout(Duration(seconds: 40)),
    tags: [defaultIntegrationTestTag],
  );

  test(
    'Given that withServerpod can find the database and has a timeout set to 4 seconds '
    'when running the test '
    'then should pass',
    () async {
      final result = await runTest('test_that_will_not_timeout.dart');

      expect(result.exitCode, 0);
      expect(
        result.stdout,
        contains(
          'All tests passed!',
        ),
      );
    },
    tags: [defaultIntegrationTestTag],
  );
}

Future<ProcessResult> runTest(String testFile) {
  return Process.run(
    'dart',
    [
      'test',
      path.joinAll([
        'test_integration',
        'test_tools',
        'start_timeout_test',
        testFile,
      ]),
    ],
    runInShell: true,
  );
}
