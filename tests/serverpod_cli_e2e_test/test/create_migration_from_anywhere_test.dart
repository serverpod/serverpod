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

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    // Run command and activate again to force cache pub dependencies.
    await Process.run(
      'serverpod',
      ['version'],
      workingDirectory: cliPath,
    );

    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
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
    'Given a serverpod project with a root pubspec when create-migration is called from project root',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

      late Process createProcess;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempDir.path,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );

        // Create a root pubspec.yaml with name: _ (simulating workspace)
        var rootPubspec = File(
          path.join(tempDir.path, projectName, 'pubspec.yaml'),
        );
        rootPubspec.writeAsStringSync('''
name: _
environment:
  sdk: ^3.0.0
''');
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-migration should succeed when run from project root.',
        () async {
          var migrationProcess = await Process.start(
            'serverpod',
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(tempDir.path, projectName),
            environment: {
              'SERVERPOD_HOME': rootPath,
            },
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

          // Should not contain error about not being a server package
          expect(
            allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          // Should succeed (either no changes or migration created)
          expect(
            exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          // Should either detect no changes or create migration
          expect(
            allOutput.contains('no changes detected') ||
                allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );
    },
  );

  group(
    'Given a serverpod project when create-migration is called from client directory',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var clientDir = path.join(projectName, '${projectName}_client');

      late Process createProcess;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempDir.path,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-migration should succeed when run from client directory.',
        () async {
          var migrationProcess = await Process.start(
            'serverpod',
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(tempDir.path, clientDir),
            environment: {
              'SERVERPOD_HOME': rootPath,
            },
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

          // Should succeed (either no changes or migration created)
          expect(
            exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          // Should either detect no changes or create migration
          expect(
            allOutput.contains('no changes detected') ||
                allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );
    },
  );
}
