@Timeout(Duration(minutes: 12))

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'util.dart';

const tempDirName = 'temp';

void main() {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final tempPath = path.join(rootPath, tempDirName);

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    await Process.run('mkdir', [tempDirName], workingDirectory: rootPath);
  });

  tearDownAll(() async {
    try {
      await Process.run(
        'rm',
        ['-rf', tempDirName],
        workingDirectory: rootPath,
      );
    } catch (e) {}
  });

  group('Given a clean state', () {
    var (projectName, commandRootPath) = createRandomProjectName(tempPath);
    final (serverDir, flutterDir, clientDir) =
        createProjectFolderPaths(projectName);

    tearDownAll(() async {
      await Process.run(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRootPath,
      );
      while (!await isNetworkPortAvailable(8090));
    });

    group('when creating a new project', () {
      setUpAll(() async {
        var process = await Process.start(
          'serverpod',
          [
            'create',
            '--template',
            'module',
            projectName,
            '-v',
            '--no-analytics'
          ],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        process.stdout.transform(Utf8Decoder()).listen(print);
        process.stderr.transform(Utf8Decoder()).listen(print);

        var exitCode = await process.exitCode;
        assert(exitCode == 0);
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

      test('then the server project folder is created', () {
        expect(
          Directory(path.join(tempPath, serverDir)).existsSync(),
          isTrue,
          reason: 'Server folder does not exist.',
        );
      });

      test('then the server project has a pubspec file', () {
        expect(
          File(path.join(tempPath, serverDir, 'pubspec.yaml')).existsSync(),
          isTrue,
          reason: 'Server pubspec file does not exist.',
        );
      });

      test('then the server project has a .gitignore file', () {
        expect(
          File(path.join(tempPath, serverDir, '.gitignore')).existsSync(),
          isTrue,
          reason: 'Server .gitignore file does not exist.',
        );
      });

      test('then the server project has an module_endpoint file', () {
        expect(
          File(path.join(
            tempPath,
            serverDir,
            'lib',
            'src',
            'endpoints',
            'module_endpoint.dart',
          )).existsSync(),
          isTrue,
          reason: 'Server module_endpoint file does not exist.',
        );
      });

      test('then the server project has a generated endpoints file', () {
        expect(
          File(path.join(
            tempPath,
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

      test('then the server project has a generated module_class file', () {
        expect(
          File(path.join(
            tempPath,
            serverDir,
            'lib',
            'src',
            'generated',
            'module_class.dart',
          )).existsSync(),
          isTrue,
          reason: 'Server generated module_class file does not exist.',
        );
      });

      test('then the server project has a generated test tools file', () {
        expect(
          File(path.join(
            tempPath,
            serverDir,
            'test',
            'integration',
            'test_tools',
            'serverpod_test_tools.dart',
          )).existsSync(),
          isTrue,
          reason: 'Server generated example file does not exist.',
        );
      });

      test('then the server project has the project migrations folder', () {
        expect(
          Directory(
            path.join(
              tempPath,
              serverDir,
              'migrations',
            ),
          ).existsSync(),
          isTrue,
          reason: 'Server migrations folder does not exist.',
        );
      });

      test('then the server project has project migration registry', () {
        expect(
          File(path.join(
            tempPath,
            serverDir,
            'migrations',
            'migration_registry.txt',
          )).existsSync(),
          isTrue,
          reason: 'Server migration registry does not exist.',
        );
      });

      test('then the client project folder is created', () {
        expect(
          Directory(path.join(tempPath, clientDir)).existsSync(),
          isTrue,
          reason: 'Client folder does not exist.',
        );
      });

      test('then the client project has a pubspec file', () {
        expect(
          File(path.join(tempPath, clientDir, 'pubspec.yaml')).existsSync(),
          isTrue,
          reason: 'Client pubspec file does not exist.',
        );
      });

      test('then the client project has a project_client file', () {
        expect(
          File(
            path.join(tempPath, clientDir, 'lib', '${projectName}_client.dart'),
          ).existsSync(),
          isTrue,
          reason: 'Client project_client file does not exist.',
        );
      });

      test('then the client project has a protocol client file', () {
        expect(
          File(
            path.join(
                tempPath, clientDir, 'lib', 'src', 'protocol', 'client.dart'),
          ).existsSync(),
          isTrue,
          reason: 'Client protocol client file does not exist.',
        );
      });
    });
  });

  group('Given a created module project', () {
    final (projectName, commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    setUp(() async {
      createProcess = await Process.start(
        'serverpod',
        ['create', '--template', 'module', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      assert((await createProcess.exitCode) == 0);

      final docker = await Process.start(
        'docker',
        ['compose', 'up', '--build', '--detach'],
        workingDirectory: commandRoot,
      );

      assert((await docker.exitCode) == 0);
    });

    tearDown(() async {
      createProcess.kill();

      await Process.run(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
      );

      while (!await isNetworkPortAvailable(8090));
    });

    test('when running tests then example unit and integration tests passes',
        () async {
      var testProcess = await Process.start(
        'dart',
        ['test'],
        workingDirectory:
            path.join(tempPath, projectName, "${projectName}_server"),
      );

      await expectLater(testProcess.exitCode, completion(0));
    });
  });
}
