@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() async {
  late Directory tempDir;
  var rootPath = path.join(Directory.current.path, '..', '..');
  var cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  var cliBinPath = path.join(cliPath, 'bin', 'serverpod_cli.dart');

  setUpAll(() async {
    // Run pub get to ensure dependencies are available
    await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: cliPath,
    );
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group(
    'Given a serverpod project with an initial migration',
    () {
      late String projectName;
      late String serverDir;
      late Process createProcess;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

        createProcess = await Process.start(
          'dart',
          ['run', cliBinPath, 'create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempDir.path,
          environment: {'SERVERPOD_HOME': rootPath},
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );

        serverDir = path.join(
          tempDir.path,
          projectName,
          '${projectName}_server',
        );
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'when create-migration is called with no changes then exit code is 0.',
        () async {
          var migrationProcess = await Process.start(
            'dart',
            ['run', cliBinPath, 'create-migration', '--no-analytics'],
            workingDirectory: serverDir,
            environment: {'SERVERPOD_HOME': rootPath},
          );

          var stdout = <String>[];
          var stderr = <String>[];

          migrationProcess.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stdout.add(line);
                print('stdout: $line');
              });

          migrationProcess.stderr
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stderr.add(line);
                print('stderr: $line');
              });

          var exitCode = await migrationProcess.exitCode;

          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();
          expect(
            allOutput.contains('no changes detected'),
            isTrue,
            reason: 'Should indicate no changes detected',
          );

          expect(
            exitCode,
            equals(0),
            reason: 'Empty migration (no changes) should exit with code 0',
          );
        },
      );
    },
  );

  group(
    'Given a serverpod project with a migration that has warnings',
    () {
      late String projectName;
      late String serverDir;
      late Process createProcess;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

        createProcess = await Process.start(
          'dart',
          ['run', cliBinPath, 'create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempDir.path,
          environment: {'SERVERPOD_HOME': rootPath},
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );

        serverDir = path.join(
          tempDir.path,
          projectName,
          '${projectName}_server',
        );

        // Add a model with a table
        var modelFile = File(
          path.join(serverDir, 'lib', 'src', 'protocol', 'example.yaml'),
        );
        modelFile.parent.createSync(recursive: true);
        modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
  toBeDropped: String?
''');

        // Create initial migration with the column
        var initialMigrationProcess = await Process.start(
          'dart',
          [
            'run',
            cliBinPath,
            'create-migration',
            '--force',
            '--no-analytics',
          ],
          workingDirectory: serverDir,
          environment: {'SERVERPOD_HOME': rootPath},
        );

        initialMigrationProcess.stdout
            .transform(const Utf8Decoder())
            .listen(print);
        initialMigrationProcess.stderr
            .transform(const Utf8Decoder())
            .listen(print);

        var initialMigrationExitCode = await initialMigrationProcess.exitCode;
        assert(
          initialMigrationExitCode == 0,
          'Failed to create initial migration.',
        );

        // Remove the column to trigger a warning
        modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
''');
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'when create-migration is called without --force then exit code is 1.',
        () async {
          var migrationProcess = await Process.start(
            'dart',
            ['run', cliBinPath, 'create-migration', '--no-analytics'],
            workingDirectory: serverDir,
            environment: {'SERVERPOD_HOME': rootPath},
          );

          var stdout = <String>[];
          var stderr = <String>[];

          migrationProcess.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stdout.add(line);
                print('stdout: $line');
              });

          migrationProcess.stderr
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stderr.add(line);
                print('stderr: $line');
              });

          var exitCode = await migrationProcess.exitCode;

          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();
          expect(
            allOutput.contains('warning') || allOutput.contains('aborted'),
            isTrue,
            reason: 'Should indicate migration was aborted due to warnings',
          );

          expect(
            exitCode,
            equals(1),
            reason: 'Aborted migration should exit with code 1',
          );
        },
      );

      test(
        'when create-migration is called with --force then exit code is 0.',
        () async {
          var migrationProcess = await Process.start(
            'dart',
            [
              'run',
              cliBinPath,
              'create-migration',
              '--force',
              '--no-analytics',
            ],
            workingDirectory: serverDir,
            environment: {'SERVERPOD_HOME': rootPath},
          );

          var stdout = <String>[];
          var stderr = <String>[];

          migrationProcess.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stdout.add(line);
                print('stdout: $line');
              });

          migrationProcess.stderr
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen((line) {
                stderr.add(line);
                print('stderr: $line');
              });

          var exitCode = await migrationProcess.exitCode;

          expect(
            exitCode,
            equals(0),
            reason: 'Migration with --force should succeed with exit code 0',
          );
        },
      );
    },
  );
}
