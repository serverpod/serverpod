@Tags(['timing'])
library;

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

void main() async {
  test(
    'Given that withServerpod can not find the database and has a timeout set to 1 millisecond '
    'when running the test '
    'then should timeout immediately',
    () async {
      final result = await runTest('test_that_will_timeout.dart');

      expect(result.exitCode, 1);
      expect(
        _combinedOutput(result),
        contains(
          'Serverpod did not start within the timeout of ${const Duration(milliseconds: 1)}',
        ),
      );
    },
    tags: [defaultIntegrationTestTag],
  );

  test(
    'Given that withServerpod can not reach the database '
    'when running the test '
    'then fails fast with a clear database error',
    () async {
      var timer = Stopwatch()..start();
      final result = await runTest(
        'test_that_will_timeout_after_default.dart',
        embeddedDatabase: false,
      );

      expect(result.exitCode, 1);
      expect(
        _combinedOutput(result),
        contains('Failed to set up the test database'),
      );
      // Each group's database is created up front, so an unreachable database
      // fails immediately instead of waiting out the default start timeout.
      expect(timer.elapsed.inSeconds, lessThan(30));
    },
    timeout: Timeout(Duration(seconds: 40)),
    tags: [defaultIntegrationTestTag],
  );

  test(
    'Given that withServerpod can find the database and has a timeout set to 30 seconds '
    'when running the test '
    'then should pass',
    () async {
      final result = await runTest('test_that_will_not_timeout.dart');

      expect(result.exitCode, 0);
    },
    timeout: Timeout(Duration(minutes: 2)),
    tags: [defaultIntegrationTestTag],
  );
}

String _combinedOutput(ProcessResult result) =>
    '${result.stdout}${result.stderr}';

Future<ProcessResult> runTest(String testFile, {bool embeddedDatabase = true}) {
  // When the suite runs against an embedded PostgreSQL, SERVERPOD_DATABASE_DATA_PATH
  // is set and would otherwise leak into this spawned `dart test`, starting an
  // embedded postmaster and making the database reachable - which defeats the
  // unreachable-database cases. Drop it for those.
  final environment = Map<String, String>.from(Platform.environment);
  if (!embeddedDatabase) {
    environment.remove('SERVERPOD_DATABASE_DATA_PATH');
  }
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
    environment: environment,
    includeParentEnvironment: false,
  );
}
