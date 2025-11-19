@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp-mini';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final tempPath = path.join(rootPath, tempDirName);

  setUpAll(() async {
    await runProcess(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    // Run command and activate again to force cache pub dependencies.
    await runProcess(
      'serverpod',
      ['version'],
      workingDirectory: cliPath,
    );

    await runProcess(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    await Directory(tempPath).create();
  });

  tearDownAll(() async {
    try {
      Directory(tempPath).deleteSync(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    test(
      'when creating a new project with the mini template then the project is created successfully and can be booted in maintenance mode.',
      () async {
        createProcess = await startProcess(
          'serverpod',
          ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        expect(
          createProjectExitCode,
          0,
          reason: 'Failed to create the serverpod project.',
        );

        var startProjectProcess = await startProcess(
          'dart',
          ['bin/main.dart', '--role', 'maintenance'],
          workingDirectory: commandRoot,
        );

        var startProjectExitCode = await startProjectProcess.exitCode;
        expect(startProjectExitCode, 0);
      },
    );
  });

  group('Given a clean state', () {
    final (:projectName, commandRoot: _) = createRandomProjectName(tempPath);

    late Process createProcess;

    test(
      'when creating a new project with the mini template then the project is created successfully without the full configuration of a full project.',
      () async {
        createProcess = await startProcess(
          'serverpod',
          ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        expect(
          createProjectExitCode,
          0,
          reason: 'Failed to create the serverpod project.',
        );

        final serverDir = createServerFolderPath(projectName);

        var configDir = Directory(
          path.join(tempPath, serverDir, 'config'),
        ).existsSync();
        expect(
          configDir,
          isFalse,
          reason: 'No config directory should exist but it was found.',
        );

        var deployDir = Directory(
          path.join(tempPath, serverDir, 'deploy'),
        ).existsSync();
        expect(
          deployDir,
          isFalse,
          reason: 'No deploy directory should exist but it was found.',
        );

        var webDir = Directory(
          path.join(tempPath, serverDir, 'web'),
        ).existsSync();
        expect(
          webDir,
          isFalse,
          reason: 'No web directory should exist but it was found.',
        );

        var dockerComposeFile = File(
          path.join(tempPath, serverDir, 'docker-compose.yaml'),
        ).existsSync();
        expect(
          dockerComposeFile,
          isFalse,
          reason: 'No docker-compose.yml should exist but it was found.',
        );

        var gcloudIgnoreFile = File(
          path.join(tempPath, serverDir, '.gcloudignore'),
        ).existsSync();
        expect(
          gcloudIgnoreFile,
          isFalse,
          reason: 'No .gcloudignore should exist but it was found.',
        );
      },
    );
  });

  group('Given a mini project', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final serverDir = createServerFolderPath(projectName);
    late Process createProcess;

    setUpAll(() async {
      createProcess = await startProcess(
        'serverpod',
        ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod mini project.',
      );
    });

    tearDown(() async {
      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );
    });

    test(
      'when upgrading the project to a full project '
      'then the project is created successfully and can be booted in maintenance mode with the apply-migrations flag.',
      () async {
        var upgradeProcess = await startProcess(
          'serverpod',
          ['create', '--template', 'server', '.', '-v', '--no-analytics'],
          workingDirectory: path.join(tempPath, serverDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var upgradeProjectExitCode = await upgradeProcess.exitCode;
        expect(
          upgradeProjectExitCode,
          0,
          reason: 'Failed to create the serverpod project.',
        );

        final docker = await startProcess(
          'docker',
          ['compose', 'up', '--build', '--detach'],
          workingDirectory: commandRoot,
          ignorePlatform: true,
        );

        var dockerExitCode = await docker.exitCode;

        expect(
          dockerExitCode,
          0,
          reason: 'Docker with postgres failed to start.',
        );

        var startProjectProcess = await startProcess(
          'dart',
          ['bin/main.dart', '--apply-migrations', '--role', 'maintenance'],
          workingDirectory: commandRoot,
        );

        var startProjectExitCode = await startProjectProcess.exitCode;
        expect(startProjectExitCode, 0);
      },
      skip: Platform.isWindows
          ? 'Windows does not support postgres docker image in github actions'
          : null,
    );
  });

  group('Given a mini project', () {
    final (:projectName, commandRoot: _) = createRandomProjectName(tempPath);
    final serverDir = createServerFolderPath(projectName);
    late Process createProcess;
    setUpAll(() async {
      createProcess = await startProcess(
        'serverpod',
        ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod mini project.',
      );
    });

    tearDown(() async {
      createProcess.kill();
    });

    group(
      'when creating a new project with the mini template and upgrading it to a full project',
      () {
        late Process upgradeProcess;
        setUpAll(() async {
          upgradeProcess = await startProcess(
            'serverpod',
            ['create', '--template', 'server', '.', '-v', '--no-analytics'],
            workingDirectory: path.join(tempPath, serverDir),
            environment: {
              'SERVERPOD_HOME': rootPath,
            },
          );

          await upgradeProcess.exitCode;
        });

        test('then the upgrade command completes successfully', () async {
          var upgradeProjectExitCode = await upgradeProcess.exitCode;
          expect(
            upgradeProjectExitCode,
            0,
            reason: 'Failed to create the serverpod project.',
          );
        });

        test('then the project contains a config directory', () {
          var configDir = Directory(
            path.join(tempPath, serverDir, 'config'),
          ).existsSync();
          expect(
            configDir,
            isTrue,
            reason: 'Config directory should exist but it was not found.',
          );
        });

        test('then the project contains a deploy directory', () {
          var deployDir = Directory(
            path.join(tempPath, serverDir, 'deploy'),
          ).existsSync();
          expect(
            deployDir,
            isTrue,
            reason: 'Deploy directory should exist but it was not found.',
          );
        });

        test('then the project contains a web directory', () {
          var webDir = Directory(
            path.join(tempPath, serverDir, 'web'),
          ).existsSync();
          expect(
            webDir,
            isTrue,
            reason: 'Web directory should exist but it was not found.',
          );
        });

        test('then the project contains a dockerfile', () {
          var dockerFile = File(
            path.join(tempPath, serverDir, 'Dockerfile'),
          ).existsSync();
          expect(
            dockerFile,
            isTrue,
            reason: 'Dockerfile should exist but it was not found.',
          );
        });

        test('then the project contains a docker-compose.yaml file', () {
          var dockerComposeFile = File(
            path.join(tempPath, serverDir, 'docker-compose.yaml'),
          ).existsSync();
          expect(
            dockerComposeFile,
            isTrue,
            reason: 'docker-compose.yml should exist but it was not found.',
          );
        });

        test('then the project contains a .gcloudignore file', () {
          var gcloudIgnoreFile = File(
            path.join(tempPath, serverDir, '.gcloudignore'),
          ).existsSync();
          expect(
            gcloudIgnoreFile,
            isTrue,
            reason: '.gcloudignore should exist but it was not found.',
          );
        });
      },
    );
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final serverDir = createServerFolderPath(projectName);
    late Process createProcess;
    tearDown(() async {
      createProcess.kill();

      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );

      while (!await isNetworkPortAvailable(8090)) ;
    });

    test(
      'when creating a new project with the mini template and upgrading it to a full project then the tests are passing.',
      () async {
        createProcess = await startProcess(
          'serverpod',
          ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        expect(
          createProjectExitCode,
          0,
          reason: 'Failed to create the serverpod project.',
        );

        var upgradeProcess = await startProcess(
          'serverpod',
          ['create', '--template', 'server', '.', '-v', '--no-analytics'],
          workingDirectory: path.join(tempPath, serverDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var upgradeProjectExitCode = await upgradeProcess.exitCode;
        expect(
          upgradeProjectExitCode,
          0,
          reason: 'Failed to upgrade the serverpod project.',
        );

        final docker = await startProcess(
          'docker',
          ['compose', 'up', '--build', '--detach'],
          workingDirectory: commandRoot,
          ignorePlatform: true,
        );

        var dockerExitCode = await docker.exitCode;

        expect(
          dockerExitCode,
          0,
          reason: 'Docker with postgres failed to start.',
        );

        var startProjectProcess = await startProcess(
          'dart',
          ['bin/main.dart', '--apply-migrations', '--role', 'maintenance'],
          workingDirectory: commandRoot,
        );

        var startProjectExitCode = await startProjectProcess.exitCode;

        expect(
          startProjectExitCode,
          0,
          reason: 'Failed to start the serverpod project.',
        );

        var testProcess = await runProcess(
          'dart',
          ['test'],
          workingDirectory: path.join(
            tempPath,
            projectName,
            "${projectName}_server",
          ),
        );

        expect(testProcess.exitCode, 0, reason: 'Tests are failing.');
      },
      skip: Platform.isWindows
          ? 'Windows does not support postgres docker image in github actions'
          : null,
    );
  });

  group('Given a created mini project', () {
    final (:projectName, commandRoot: _) = createRandomProjectName(tempPath);

    setUp(() async {
      var createProcess = await runProcess(
        'serverpod',
        ['create', '--template', 'mini', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      assert((await createProcess.exitCode) == 0);
    });

    test(
      'when running tests then example unit and integration tests passes',
      () async {
        var testProcess = await runProcess(
          'dart',
          ['test'],
          workingDirectory: path.join(
            tempPath,
            projectName,
            "${projectName}_server",
          ),
        );

        expect(testProcess.exitCode, 0);
      },
    );
  });
}
