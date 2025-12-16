@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final cliBinPath = path.join(cliPath, 'bin', 'serverpod_cli.dart');

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: cliPath,
    );
  });

  group(
    'Given a serverpod project with a root pubspec',
    () {
      late String projectName;
      late Process createProcess;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

        createProcess = await Process.start(
          'dart',
          ['run', cliBinPath, 'create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        final createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );

        // Create a root pubspec.yaml with name: _ (simulating workspace)
        await d.dir(projectName, [
          d.file('pubspec.yaml', '''
name: _
environment:
  sdk: ^3.0.0
'''),
        ]).create();
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'when create-migration is called from project root then it should succeed.',
        () async {
          final result = await _runServerpodCommand(
            cliBinPath,
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, projectName),
            environment: {'SERVERPOD_HOME': rootPath},
          );

          expect(
            result.allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          expect(
            result.allOutput.contains('no changes detected') ||
                result.allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );

      test(
        'when create-repair-migration is called from project root then it should not fail due to root pubspec.',
        () async {
          final result = await _runServerpodCommand(
            cliBinPath,
            ['create-repair-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, projectName),
            environment: {'SERVERPOD_HOME': rootPath},
          );

          expect(
            result.allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          if (result.exitCode != 0) {
            expect(
              result.allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );

  group(
    'Given a serverpod project without a root pubspec',
    () {
      late String projectName;
      late String clientDir;
      late Process createProcess;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
        clientDir = path.join(projectName, '${projectName}_client');

        createProcess = await Process.start(
          'dart',
          ['run', cliBinPath, 'create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        final createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'when create-migration is called from client directory then it should succeed.',
        () async {
          final result = await _runServerpodCommand(
            cliBinPath,
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, clientDir),
            environment: {'SERVERPOD_HOME': rootPath},
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          expect(
            result.allOutput.contains('no changes detected') ||
                result.allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );

      test(
        'when create-repair-migration is called from client directory then it should not fail due to package detection.',
        () async {
          final result = await _runServerpodCommand(
            cliBinPath,
            ['create-repair-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, clientDir),
            environment: {'SERVERPOD_HOME': rootPath},
          );

          expect(
            result.allOutput.contains('not a server package'),
            isFalse,
            reason: 'Should not error about client package name',
          );

          if (result.exitCode != 0) {
            expect(
              result.allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );
}

class _ProcessResult {
  final int exitCode;
  final List<String> stdout;
  final List<String> stderr;

  _ProcessResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  String get allOutput => [...stdout, ...stderr].join('\n').toLowerCase();
}

// TODO: Remove once https://github.com/serverpod/serverpod/issues/4459 is implemented.
Future<_ProcessResult> _runServerpodCommand(
  String cliBinPath,
  List<String> args, {
  required String workingDirectory,
  required Map<String, String> environment,
}) async {
  final process = await Process.start(
    'dart',
    ['run', cliBinPath, ...args],
    workingDirectory: workingDirectory,
    environment: environment,
  );

  final stdout = <String>[];
  final stderr = <String>[];

  process.stdout
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen((line) {
        stdout.add(line);
        print('stdout: $line');
      });

  process.stderr
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen((line) {
        stderr.add(line);
        print('stderr: $line');
      });

  final exitCode = await process.exitCode;

  return _ProcessResult(
    exitCode: exitCode,
    stdout: stdout,
    stderr: stderr,
  );
}
