import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

void main() {
  Directory.current = path.join(Directory.current.path, '..', '..');
  final rootPath = Directory.current.path;
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final tempPath = path.join(rootPath, 'temp');

  final timeout = Timeout(Duration(minutes: 3));

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    await Process.run('mkdir', ['temp'], workingDirectory: rootPath);
    Directory.current = tempPath;
  });

  group('Given a clean state', () {
    final (projectName, commandRoot) = createRandomProjectName(tempPath);

    tearDown(() async {
      try {
        await Process.run(
          'docker',
          ['compose', 'down', '-v'],
          workingDirectory: commandRoot,
        );
      } catch (e) {}
    });

    test(
        'when creating a new project then the project is created successfully and can be booted',
        () async {
      var createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '-v'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
        runInShell: true,
      );

      createProcess.stdout.transform(Utf8Decoder()).listen(print);
      createProcess.stderr.transform(Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      expect(createProjectExitCode, 0);

      final docker = await Process.start(
        'docker',
        ['compose', 'up', '--build', '--detach'],
        workingDirectory: commandRoot,
        runInShell: true,
      );

      docker.stdout.transform(Utf8Decoder()).listen(print);
      docker.stderr.transform(Utf8Decoder()).listen(print);

      var dockerExitCode = await docker.exitCode;
      expect(
        dockerExitCode,
        0,
        reason: 'Docker with postgres failed to start.',
      );

      var startProcess = await Process.start(
        'dart',
        ['bin/main.dart', '--role', 'maintenance'],
        workingDirectory: commandRoot,
        runInShell: true,
      );

      startProcess.stdout.transform(Utf8Decoder()).listen(print);
      startProcess.stderr.transform(Utf8Decoder()).listen(print);

      var startProjectExitCode = await startProcess.exitCode;
      expect(startProjectExitCode, 0);
    });
  }, timeout: timeout);

  group('Given a clean state', () {
    final (projectName, commandRootPath) = createRandomProjectName(tempPath);
    final (serverDir, flutterDir, clientDir) =
        createProjectFolderPaths(projectName);

    tearDownAll(() async {
      try {
        await Process.run(
          'docker',
          ['compose', 'down', '-v'],
          workingDirectory: commandRootPath,
        );
      } catch (e) {}
    });

    group('when creating a new project', () {
      setUpAll(() async {
        await Process.run(
          'serverpod',
          ['create', projectName, '-v'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
          runInShell: true,
        );
      });

      test('then there are no linting errors in the new project', () async {
        final process = await Process.start(
          'dart',
          ['analyze', '--fatal-infos', '--fatal-warnings', projectName],
          workingDirectory: tempPath,
        );

        process.stdout.transform(Utf8Decoder()).listen(print);
        process.stderr.transform(Utf8Decoder()).listen(print);

        var exitCode = await process.exitCode;
        expect(exitCode, 0, reason: 'Linting errors in new project.');
      });

      group('then the server project', () {
        test('folder is created', () {
          expect(
            Directory(serverDir).existsSync(),
            isTrue,
            reason: 'Server folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(serverDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Server pubspec file does not exist.',
          );
        });

        test('has a .gitignore file', () {
          expect(
            File(path.join(serverDir, '.gitignore')).existsSync(),
            isTrue,
            reason: 'Server .gitignore file does not exist.',
          );
        });

        test('has a server.dart file', () {
          expect(
            File(path.join(serverDir, 'lib', 'server.dart')).existsSync(),
            isTrue,
            reason: 'Server server.dart file does not exist.',
          );
        });

        test('has an example_endpoint file', () {
          expect(
            File(path.join(
              serverDir,
              'lib',
              'src',
              'endpoints',
              'example_endpoint.dart',
            )).existsSync(),
            isTrue,
            reason: 'Server example_endpoint file does not exist.',
          );
        });

        test('has a generated endpoints file', () {
          expect(
            File(path.join(
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            )).existsSync(),
            isTrue,
            reason: 'Server generated endpoints file does not exist.',
          );
        });

        test('has a generated example file', () {
          expect(
            File(path.join(
              serverDir,
              'lib',
              'src',
              'generated',
              'example.dart',
            )).existsSync(),
            isTrue,
            reason: 'Server generated example file does not exist.',
          );
        });

        test('has the serverpod migrations folder', () {
          expect(
            Directory(
              path.join(serverDir, 'migrations', 'serverpod'),
            ).existsSync(),
            isTrue,
            reason: 'Server migrations folder does not exist.',
          );
        });

        test('has the project migrations folder', () {
          expect(
            Directory(
              path.join(serverDir, 'migrations', projectName),
            ).existsSync(),
            isTrue,
            reason: 'Server migrations folder does not exist.',
          );
        });

        test('has project migration registry', () {
          expect(
            File(path.join(
              serverDir,
              'migrations',
              projectName,
              'migration_registry.json',
            )).existsSync(),
            isTrue,
            reason: 'Server migration registry does not exist.',
          );
        });
      });

      group('then the flutter project', () {
        test('folder is created', () {
          expect(
            Directory(flutterDir).existsSync(),
            isTrue,
            reason: 'Flutter folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(flutterDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Flutter pubspec file does not exist.',
          );
        });

        test('has a main file', () {
          expect(
            File(path.join(flutterDir, 'lib', 'main.dart')).existsSync(),
            isTrue,
            reason: 'Flutter main file does not exist.',
          );
        });
      });

      group('then the client project', () {
        test('folder is created', () {
          expect(
            Directory(clientDir).existsSync(),
            isTrue,
            reason: 'Client folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(clientDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Client pubspec file does not exist.',
          );
        });

        test('has a project_client file', () {
          expect(
            File(
              path.join(clientDir, 'lib', '${projectName}_client.dart'),
            ).existsSync(),
            isTrue,
            reason: 'Client project_client file does not exist.',
          );
        });

        test('has a protocol client file', () {
          expect(
            File(
              path.join(clientDir, 'lib', 'src', 'protocol', 'client.dart'),
            ).existsSync(),
            isTrue,
            reason: 'Client protocol client file does not exist.',
          );
        });
      });
    });
  }, timeout: timeout);

  group('Given a clean state', () {
    final (projectName, commandRoot) = createRandomProjectName(tempPath);
    final (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

    tearDown(() async {
      try {
        await Process.run(
          'docker',
          ['compose', 'down', '-v'],
          workingDirectory: commandRoot,
        );
      } catch (e) {}
    });

    test(
        'when removing generated files from a new project and running generate then the files are recreated successfully',
        () async {
      var createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '-v'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
        runInShell: true,
      );

      createProcess.stdout.transform(Utf8Decoder()).listen(print);
      createProcess.stderr.transform(Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      expect(createProjectExitCode, 0);

      // Delete generated files
      await Process.run('rm', ['-f', '${serverDir}/lib/src/generated/*.dart']);
      await Process.run('rm', ['-f', '${clientDir}/lib/src/protocol/*.dart']);

      var generateProcess = await Process.run(
        'serverpod',
        ['generate'],
        workingDirectory: commandRoot,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
        runInShell: true,
      );
      expect(
        generateProcess.exitCode,
        0,
        reason: 'Serverpod generate command failed.',
      );

      expect(
        File(path.join(
          serverDir,
          'lib',
          'src',
          'generated',
          'endpoints.dart',
        )).existsSync(),
        isTrue,
        reason: 'Server generated endpoints file does not exist.',
      );

      expect(
        File(path.join(
          serverDir,
          'lib',
          'src',
          'generated',
          'example.dart',
        )).existsSync(),
        isTrue,
        reason: 'Server generated example file does not exist.',
      );

      expect(
        File(path.join(
          clientDir,
          'lib',
          'src',
          'protocol',
          'client.dart',
        )).existsSync(),
        isTrue,
        reason: 'Client protocol client file does not exist.',
      );
    });
  }, timeout: timeout);

  tearDownAll(() async {
    try {
      await Process.run(
        'rm',
        ['-rf', 'temp'],
        workingDirectory: rootPath,
      );
    } catch (e) {}
  });
}

(String, String) createRandomProjectName(String root) {
  final projectName = 'test_${Uuid().v4().replaceAll('-', '_').toLowerCase()}';
  final commandRoot = path.join(root, projectName, '${projectName}_server');

  return (projectName, commandRoot);
}

(String, String, String) createProjectFolderPaths(String projectName) {
  final serverDir = path.join(projectName, '${projectName}_server');
  final flutterDir = path.join(projectName, '${projectName}_flutter');
  final clientDir = path.join(projectName, '${projectName}_client');

  return (serverDir, flutterDir, clientDir);
}
