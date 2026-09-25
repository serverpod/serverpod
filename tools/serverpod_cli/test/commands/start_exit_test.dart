import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../test_util/endpoint_validation_helpers.dart';

const _header =
    '--- serverpod start stopped (exit code 1). Its last output was ---';

void main() {
  late String driver;

  setUpAll(() async {
    driver = p.join(
      await resolveServerpodRoot(),
      'tools',
      'serverpod_cli',
      'test',
      'test_util',
      'start_exit_driver.dart',
    );
  });

  group('Given a serverpod start session whose pod printed a warning,', () {
    test(
      'when its backend exits with an error code, '
      'then the log tail follows a string terminator and the code is kept.',
      () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          driver,
          '1',
          'ready',
        ]);

        final output = result.stdout as String;
        expect(result.exitCode, 1, reason: '${result.stderr}');
        expect(
          output,
          contains(
            '\x1b\\$_header\n'
            'WARNING: Database does not match target state.\n',
          ),
        );
      },
      // The child compiles the CLI libraries before exercising shutdown.
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'when its backend exits cleanly, '
      'then no log tail is printed.',
      () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          driver,
          '0',
          'ready',
        ]);

        expect(result.exitCode, 0, reason: '${result.stderr}');
        expect(result.stdout, isNot(contains('serverpod start stopped')));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });

  test(
    'Given a serverpod start session that stopped before its stack was ready, '
    'when its backend exits with code zero, '
    'then its startup diagnostics are still printed.',
    () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        driver,
        '0',
        'starting',
      ]);

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(
        result.stdout,
        contains(
          '\x1b\\--- serverpod start stopped (exit code 0). '
          'Its last output was ---\n'
          'WARNING: Database does not match target state.\n',
        ),
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a fatal startup crash with preceding CLI messages and no raw output, '
    'when the user quits the TUI, '
    'then the context is retained and the crash is reported once.',
    () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        driver,
        '0',
        'starting',
        '--fatal-error',
        '--no-raw-output',
      ]);

      final output = '${result.stdout}${result.stderr}';
      expect(result.exitCode, 0, reason: output);
      expect(output, contains('Checking startup prerequisites.'));
      expect('fatal-startup-marker'.allMatches(output), hasLength(1));
      expect('fatal-stack-marker'.allMatches(output), hasLength(1));
      expect(output, contains('https://github.com/serverpod/serverpod/issues'));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a fatal startup crash with raw server output, '
    'when the user quits the TUI, '
    'then the raw output and the crash report are retained.',
    () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        driver,
        '0',
        'starting',
        '--fatal-error',
      ]);

      final output = '${result.stdout}${result.stderr}';
      expect(result.exitCode, 0, reason: output);
      expect(
        output,
        contains('WARNING: Database does not match target state.'),
      );
      expect('fatal-startup-marker'.allMatches(output), hasLength(1));
      expect('fatal-stack-marker'.allMatches(output), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a fatal startup crash whose log history was cleared, '
    'when the user quits the TUI, '
    'then the captured crash is still reported once.',
    () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        driver,
        '0',
        'starting',
        '--fatal-error',
        '--clear-history',
      ]);

      final output = '${result.stdout}${result.stderr}';
      expect(result.exitCode, 0, reason: output);
      expect(output, isNot(contains('Its last output was')));
      expect('fatal-startup-marker'.allMatches(output), hasLength(1));
      expect('fatal-stack-marker'.allMatches(output), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'Given a fatal crash after the stack was ready, '
    'when the user quits the TUI with exit code zero, '
    'then the crash is reported even though no log tail is printed.',
    () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        driver,
        '0',
        'ready',
        '--fatal-error',
      ]);

      final output = '${result.stdout}${result.stderr}';
      expect(result.exitCode, 0, reason: output);
      expect(output, isNot(contains('Its last output was')));
      expect('fatal-startup-marker'.allMatches(output), hasLength(1));
      expect('fatal-stack-marker'.allMatches(output), hasLength(1));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
