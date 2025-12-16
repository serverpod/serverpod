import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/scripts/script.dart';
import 'package:serverpod_cli/src/scripts/script_executor.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/mock_std.dart';

typedef ScriptResult = ({MockStdout stdout, MockStdout stderr, int exitCode});

Future<ScriptResult> _runScript(
  Script script,
  Directory workingDirectory,
) async {
  final stdout = MockStdout();
  final stderr = MockStdout();
  final stdin = MockStdin();
  final exitCode = await IOOverrides.runZoned(
    () async {
      return await ScriptExecutor.executeScript(
        script,
        workingDirectory,
      );
    },
    stdout: () => stdout,
    stderr: () => stderr,
    stdin: () => stdin,
  );

  return (stdout: stdout, stderr: stderr, exitCode: exitCode);
}

void main() {
  late Directory testDir;

  setUpAll(() async {
    await d.dir('test_script_executor', []).create();
    testDir = Directory(p.join(d.sandbox, 'test_script_executor'));
  });

  test(
    'Given a script that succeeds, '
    'when executing it, '
    'then it returns exit code 0',
    () async {
      const script = Script(name: 'test', command: 'exit 0');
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output, isEmpty);
      expect(stderr.output, isEmpty);
    },
  );

  test(
    'Given a script that fails, '
    'when executing it, '
    'then it returns non-zero exit code',
    () async {
      const script = Script(name: 'test', command: 'exit 42');
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 42);
      expect(stdout.output, isEmpty);
      expect(stderr.output, isEmpty);
    },
  );

  test(
    'Given a script with working directory, '
    'when executing it, '
    'then it executes in the correct directory',
    () async {
      final script = switch (Platform.isWindows) {
        true => const Script(
          name: 'test',
          command: 'echo %cd%',
        ),
        false => const Script(
          name: 'test',
          command: 'pwd',
        ),
      };
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output.trim(), testDir.path);
      expect(stderr.output, isEmpty);
    },
  );

  test(
    'Given a script that outputs to stdout, '
    'when executing it, '
    'then output is streamed',
    () async {
      const script = Script(
        name: 'test',
        command: 'echo "test output"',
      );
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output, contains('test output'));
      expect(stderr.output, isEmpty);
    },
  );

  test(
    'Given a script that outputs to stderr, '
    'when executing it, '
    'then error output is streamed',
    () async {
      const script = Script(
        name: 'test',
        command: 'echo "error output" >&2',
      );
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output, isEmpty);
      expect(stderr.output, contains('error output'));
    },
  );

  test(
    'Given a script with complex command, '
    'when executing it, '
    'then it handles shell features correctly',
    () async {
      const script = Script(
        name: 'test',
        command: 'echo "hello" && echo "world"',
      );
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output, contains('hello'));
      expect(stdout.output, contains('world'));
      expect(stderr.output, isEmpty);
    },
  );

  test(
    'Given a script with spaces in command, '
    'when executing it, '
    'then it handles quoting correctly',
    () async {
      const script = Script(
        name: 'test',
        command: 'echo "hello world"',
      );
      final (:stdout, :stderr, :exitCode) = await _runScript(script, testDir);

      expect(exitCode, 0);
      expect(stdout.output, contains('hello world'));
      expect(stderr.output, isEmpty);
    },
  );
}
