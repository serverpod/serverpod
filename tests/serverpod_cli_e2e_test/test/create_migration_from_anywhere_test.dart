@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
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

  group(
    'Given a serverpod project with a root pubspec when create-migration is called from project root',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

      late Process createProcess;
      late Process migrationProcess;
      late int exitCode;
      late List<String> stdout;
      late List<String> stderr;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
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
          path.join(d.sandbox, projectName, 'pubspec.yaml'),
        );
        rootPubspec.writeAsStringSync('''
name: _
environment:
  sdk: ^3.0.0
''');

        migrationProcess = await Process.start(
          'serverpod',
          ['create-migration', '--no-analytics'],
          workingDirectory: path.join(d.sandbox, projectName),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        stdout = <String>[];
        stderr = <String>[];

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

        exitCode = await migrationProcess.exitCode;
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-migration should succeed when run from project root.',
        () async {
          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();

          expect(
            allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          expect(
            exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

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
      late Process migrationProcess;
      late int exitCode;
      late List<String> stdout;
      late List<String> stderr;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
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

        migrationProcess = await Process.start(
          'serverpod',
          ['create-migration', '--no-analytics'],
          workingDirectory: path.join(d.sandbox, clientDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        stdout = <String>[];
        stderr = <String>[];

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

        exitCode = await migrationProcess.exitCode;
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-migration should succeed when run from client directory.',
        () async {
          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();

          expect(
            exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

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
    'Given a serverpod project with a root pubspec when create-repair-migration is called from project root',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

      late Process createProcess;
      late Process migrationProcess;
      late int exitCode;
      late List<String> stdout;
      late List<String> stderr;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
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
          path.join(d.sandbox, projectName, 'pubspec.yaml'),
        );
        rootPubspec.writeAsStringSync('''
name: _
environment:
  sdk: ^3.0.0
''');

        migrationProcess = await Process.start(
          'serverpod',
          ['create-repair-migration', '--no-analytics'],
          workingDirectory: path.join(d.sandbox, projectName),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        stdout = <String>[];
        stderr = <String>[];

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

        exitCode = await migrationProcess.exitCode;
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-repair-migration should fail gracefully when run from project root.',
        () async {
          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();

          expect(
            allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          if (exitCode != 0) {
            expect(
              allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );

  group(
    'Given a serverpod project when create-repair-migration is called from client directory',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var clientDir = path.join(projectName, '${projectName}_client');

      late Process createProcess;
      late Process migrationProcess;
      late int exitCode;
      late List<String> stdout;
      late List<String> stderr;

      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
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

        migrationProcess = await Process.start(
          'serverpod',
          ['create-repair-migration', '--no-analytics'],
          workingDirectory: path.join(d.sandbox, clientDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        stdout = <String>[];
        stderr = <String>[];

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

        exitCode = await migrationProcess.exitCode;
      });

      tearDown(() async {
        createProcess.kill();
      });

      test(
        'then create-repair-migration should fail gracefully when run from client directory.',
        () async {
          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();

          expect(
            allOutput.contains('not a server package'),
            isFalse,
            reason: 'Should not error about client package name',
          );

          if (exitCode != 0) {
            expect(
              allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );
}
