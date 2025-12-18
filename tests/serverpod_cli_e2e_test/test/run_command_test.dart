@TestOn('!windows')
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli_e2e_test/src/matchers/contains_lines.dart';
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  late String serverDir;

  setUpAll(() async {
    // Create a single test server with all scripts needed by tests
    await d.dir('test_server', [
      d.file('pubspec.yaml', '''
name: test_server
environment:
  sdk: ^3.0.0
dependencies:
  serverpod: any

serverpod:
  scripts:
    hello: echo "Hello from script"
    fail: exit 42
    start: dart bin/main.dart
    test: dart test
    trap: trap "echo SIGINT; exit 0" INT; echo "Trap Running"; while :; do sleep 0.1; done
'''),
    ]).create();
    serverDir = p.join(d.sandbox, 'test_server');
  });

  test(
    'when running a script, then the script executes',
    () async {
      final result = await runServerpod(
        ['run', 'hello'],
        workingDirectory: serverDir,
      );

      expect(result.exitCode, 0);
      expect(result.stdout, contains('Hello from script'));
    },
  );

  test(
    'when running a script that fails, then the exit code is propagated',
    () async {
      final result = await runServerpod(
        ['run', 'fail'],
        workingDirectory: serverDir,
      );

      expect(result.exitCode, 42);
    },
  );

  test(
    'when running with --list flag, then all scripts are listed',
    () async {
      final result = await runServerpod(
        ['run', '--list'],
        workingDirectory: serverDir,
      );

      expect(result.exitCode, 0);
      expect(
        result.stdout,
        containsLines(['hello:', 'fail:', 'start:', 'test:']),
      );
    },
  );

  group('when running a non-existent script', () {
    late ProcessResult result;

    setUpAll(() async {
      result = await runServerpod(
        ['run', 'nonexistent'],
        workingDirectory: serverDir,
      );
    });

    test('then the exit code is non-zero', () {
      expect(result.exitCode, isNot(0));
    });

    test('then an error message is shown', () {
      final output = '${result.stdout}${result.stderr}';
      expect(output, contains('Script "nonexistent" not found'));
    });

    test('then all available scripts are listed', () {
      expect(
        result.stdout,
        containsLines(['hello:', 'fail:', 'start:', 'test:']),
      );
    });
  });

  test(
    'when running without script name, then available scripts are listed',
    () async {
      final result = await runServerpod(
        ['run'],
        workingDirectory: serverDir,
      );

      expect(result.exitCode, 0);
      expect(result.stdout, contains('Available scripts:'));
      expect(
        result.stdout,
        containsLines(['hello:', 'fail:', 'start:', 'test:']),
      );
    },
  );

  test(
    'when sending SIGINT, then it is forwarded to the child process',
    () async {
      final process = await startServerpod(
        ['run', 'trap'],
        workingDirectory: serverDir,
      );

      // Collect stdout incrementally
      final stdoutBuffer = StringBuffer();
      process.stdout.transform(systemEncoding.decoder).listen((data) {
        stdoutBuffer.write(data);
      });

      // Wait for the script to start (look for "Running" message)
      while (!stdoutBuffer.toString().contains('Trap Running')) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      // Send SIGINT to serverpod process
      process.kill(ProcessSignal.sigint);

      final exitCode = await process.exitCode;
      final stdout = stdoutBuffer.toString();

      expect(stdout, contains('SIGINT'));
      expect(exitCode, 0);
    },
    timeout: Timeout(const Duration(minutes: 3)), // allow time to compile
  );

  group('given pubspec without serverpod namespace', () {
    late String serverDirNoNamespace;

    setUpAll(() async {
      await d.dir('test_server_no_namespace', [
        d.file('pubspec.yaml', '''
name: test_server_no_namespace
environment:
  sdk: ^3.0.0
dependencies:
  serverpod: any
'''),
      ]).create();
      serverDirNoNamespace = p.join(d.sandbox, 'test_server_no_namespace');
    });

    test(
      'when running a script, then an error about no scripts is shown',
      () async {
        final result = await runServerpod(
          ['run', 'hello'],
          workingDirectory: serverDirNoNamespace,
        );

        expect(result.exitCode, isNot(0));
        expect(result.stdout, contains('No scripts defined'));
      },
    );

    test(
      'when running with --list flag, then an error about no scripts is shown',
      () async {
        final result = await runServerpod(
          ['run', '--list'],
          workingDirectory: serverDirNoNamespace,
        );

        expect(result.exitCode, isNot(0));
        expect(result.stdout, contains('No scripts defined'));
      },
    );

    test(
      'when running without script name, then an error about no scripts is shown',
      () async {
        final result = await runServerpod(
          ['run'],
          workingDirectory: serverDirNoNamespace,
        );

        expect(result.exitCode, isNot(0));
        expect(result.stdout, contains('No scripts defined'));
      },
    );
  });
}
