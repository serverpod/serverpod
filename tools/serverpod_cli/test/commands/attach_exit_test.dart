import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../test_util/endpoint_validation_helpers.dart';

const _header = '--- the runner stopped (exit code 1). Its last output was ---';

void main() {
  group('Given an attach session whose pod printed a warning,', () {
    late String driver;

    setUpAll(() async {
      driver = p.join(
        await resolveServerpodRoot(),
        'tools',
        'serverpod_cli',
        'test',
        'test_util',
        'attach_exit_driver.dart',
      );
    });

    test(
      'when its backend exits with an error code, '
      'then the log tail follows a string terminator and the code is kept',
      () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          driver,
          '1',
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
      'then no log tail is printed',
      () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          driver,
          '0',
        ]);

        expect(result.exitCode, 0, reason: '${result.stderr}');
        expect(result.stdout, isNot(contains('the runner stopped')));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
