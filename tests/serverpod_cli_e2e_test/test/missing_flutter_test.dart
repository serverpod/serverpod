@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

/// Runs `serverpod version` with only [pathDirectories] on PATH.
///
/// Nothing is inherited from this process' environment beyond what a process
/// needs to start: the Flutter check is skipped on CI, and CI is detected
/// from the environment.
Future<ProcessResult> _runServerpodWithPath(
  List<String> pathDirectories,
) async {
  final systemRoot = Platform.environment['SystemRoot'];
  return Process.run(
    await compiledServerpodCliExe,
    ['version', '--no-analytics'],
    workingDirectory: d.sandbox,
    includeParentEnvironment: false,
    environment: {
      'PATH': [
        ...pathDirectories,
        // `cmd.exe`, which Windows runs batch files and shell commands with.
        if (systemRoot != null) path.join(systemRoot, 'System32'),
      ].join(Platform.isWindows ? ';' : ':'),
      'SERVERPOD_HOME': serverpodHome,
      // The compiled CLI otherwise looks for `dart` on PATH.
      'DART_SDK': path.dirname(path.dirname(Platform.resolvedExecutable)),
      'HOME': d.sandbox,
      for (final key in const [
        'SystemRoot',
        'ComSpec',
        'PATHEXT',
        'TEMP',
        'TMP',
        'USERPROFILE',
        'APPDATA',
        'LOCALAPPDATA',
      ])
        if (Platform.environment[key] case final value?) key: value,
    },
  );
}

/// Creates a directory under the sandbox holding an `fvm` that succeeds.
Future<String> _createFakeFvm() async {
  final bin = path.join(d.sandbox, 'fvm_bin');
  Directory(bin).createSync();
  if (Platform.isWindows) {
    File(path.join(bin, 'fvm.bat')).writeAsStringSync('@exit /b 0\r\n');
  } else {
    final fvm = path.join(bin, 'fvm');
    File(fvm).writeAsStringSync('#!/bin/sh\nexit 0\n');
    final chmod = await Process.run('chmod', ['+x', fvm]);
    expect(chmod.exitCode, 0, reason: 'Could not make $fvm executable.');
  }
  return bin;
}

void main() {
  group('Given neither flutter nor fvm on PATH,', () {
    late String emptyBin;

    setUp(() {
      emptyBin = path.join(d.sandbox, 'empty_bin');
      Directory(emptyBin).createSync();
    });

    group('when a serverpod command is run,', () {
      late ProcessResult result;

      setUp(() async {
        result = await _runServerpodWithPath([emptyBin]);
      });

      test('then it exits with an error.', () {
        expect(result.exitCode, isNot(0));
      });

      test('then it reports that flutter is missing.', () {
        expect(
          result.stderr,
          contains(
            'Failed to run serverpod. You need to have flutter installed',
          ),
        );
      });

      test('then it prints no fvm instructions.', () {
        expect(result.stderr, isNot(contains('fvm')));
      });
    });
  });

  group('Given fvm but no flutter on PATH,', () {
    late String fvmBin;

    setUp(() async {
      fvmBin = await _createFakeFvm();
    });

    group('when a serverpod command is run,', () {
      late ProcessResult result;

      setUp(() async {
        result = await _runServerpodWithPath([fvmBin]);
      });

      test('then it exits with an error.', () {
        expect(result.exitCode, isNot(0));
      });

      test('then it reports that flutter is missing.', () {
        expect(
          result.stderr,
          contains(
            'Failed to run serverpod. You need to have flutter installed',
          ),
        );
      });

      test('then it prints the shim to create.', () {
        final lines = (result.stderr as String).split(RegExp(r'\r?\n'));

        expect(
          lines,
          contains(
            Platform.isWindows
                ? '  @fvm flutter %*'
                : '  printf \'#!/bin/sh\\nexec fvm flutter "\$@"\\n\' > '
                      '~/.fvm_shim/flutter',
          ),
        );
      });

      test('then it says where the shim goes on PATH.', () {
        expect(
          result.stderr,
          contains(
            Platform.isWindows
                ? 'Add that folder to the front of your PATH environment '
                      'variable'
                : '  export PATH="\$HOME/.fvm_shim:\$PATH"',
          ),
        );
      });

      test('then it says to set a global fvm version.', () {
        expect(
          result.stderr,
          contains('Also set a version with `fvm global <version>`'),
        );
      });

      test('then it prints how to verify the shim.', () {
        expect(
          result.stderr,
          contains(Platform.isWindows ? 'where.exe flutter' : 'which flutter'),
        );
      });
    });
  });
}
