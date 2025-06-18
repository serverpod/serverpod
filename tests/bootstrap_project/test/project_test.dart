@Timeout(Duration(minutes: 12))

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp';

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

    await Directory(tempPath).create();
  });

  tearDownAll(() async {
    try {
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    tearDown(() async {
      createProcess.kill();

      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );

      while (!await isNetworkPortAvailable(8090));
    });

    test(
        'when creating a new project then the project is created successfully and can be booted',
        () async {
      createProcess = await startProcess(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
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
            : null);
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;
    Process? startProjectProcess;

    tearDown(() async {
      createProcess.kill();
      startProjectProcess?.kill();

      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );

      while (!await isNetworkPortAvailable(8090));
    });

    test(
        'when creating a new project then the project can be booted without applying migrations',
        () async {
      createProcess = await startProcess(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
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

      startProjectProcess = await startProcess(
        'dart',
        ['bin/main.dart', '--apply-migrations'],
        workingDirectory: commandRoot,
      );

      var serverStarted = false;
      for (int retries = 0; retries < 10; retries++) {
        try {
          var response = await http.get(Uri.parse('http://localhost:8080'));
          serverStarted = response.statusCode == HttpStatus.ok;
          break;
        } catch (e) {
          print(e);
        }

        print('failed to get response from server, retrying...');
        await Future.delayed(Duration(seconds: 1));
      }

      expect(serverStarted, isTrue,
          reason: 'Failed to get 200 response from server.');
    },
        skip: Platform.isWindows
            ? 'Windows does not support postgres docker image in github actions'
            : null);
  });

  group('Given a clean state', () {
    var (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final (:serverDir, :flutterDir, :clientDir) =
        createProjectFolderPaths(projectName);

    tearDownAll(() async {
      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );
      while (!await isNetworkPortAvailable(8090));
    });

    group('when creating a new project', () {
      setUpAll(() async {
        var process = await startProcess(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var exitCode = await process.exitCode;
        assert(exitCode == 0);
      });

      test('then there are no linting errors in the new project', () async {
        final process = await startProcess(
          'dart',
          ['analyze', '--fatal-infos', '--fatal-warnings', projectName],
          workingDirectory: tempPath,
        );

        var exitCode = await process.exitCode;
        expect(exitCode, 0, reason: 'Linting errors in new project.');
      });

      group('then the server project', () {
        test('folder is created', () {
          expect(
            Directory(path.join(tempPath, serverDir)).existsSync(),
            isTrue,
            reason: 'Server folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(tempPath, serverDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Server pubspec file does not exist.',
          );
        });

        test('has a .gitignore file', () {
          expect(
            File(path.join(tempPath, serverDir, '.gitignore')).existsSync(),
            isTrue,
            reason: 'Server .gitignore file does not exist.',
          );
        });

        test('has a server.dart file', () {
          expect(
            File(path.join(tempPath, serverDir, 'lib', 'server.dart'))
                .existsSync(),
            isTrue,
            reason: 'Server server.dart file does not exist.',
          );
        });

        test('has an example_endpoint file', () {
          expect(
            File(path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'greeting_endpoint.dart',
            )).existsSync(),
            isTrue,
            reason: 'Server greeting_endpoint file does not exist.',
          );
        });

        test('has a generated endpoints file', () {
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

        test('has a generated test tools file', () {
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
            reason:
                'Server generated integration test tools file does not exist.',
          );
        });

        test('has a generated example file', () {
          expect(
            File(path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'generated',
              'greeting.dart',
            )).existsSync(),
            isTrue,
            reason: 'Server generated greeting endpoint file does not exist.',
          );
        });

        test('has the project migrations folder', () {
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

        test('has project migration registry', () {
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

        test('has a generated protocol.yaml file', () {
          expect(
            File(path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'generated',
              'protocol.yaml',
            )).existsSync(),
            isTrue,
            reason: 'Server generated protocol.yaml file does not exist.',
          );
        });
      });

      group('then the flutter project', () {
        test('folder is created', () {
          expect(
            Directory(path.join(tempPath, flutterDir)).existsSync(),
            isTrue,
            reason: 'Flutter folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(tempPath, flutterDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Flutter pubspec file does not exist.',
          );
        });
        test('macOS DebugProfile entitlements has network client tag and true',
            () {
          var entitlementsPath = path.join(tempPath, flutterDir, 'macos',
              'Runner', 'DebugProfile.entitlements');
          var file = File(entitlementsPath);
          var exists = file.existsSync();
          expect(exists, isTrue,
              reason: "DebugProfile entitlements does not exist.");
          String contents = file.readAsStringSync();
          String expected = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.network.server</key>
	<true/>
</dict>
</plist>
''';
          expect(contents.trim(), expected.trim(),
              reason: "DebugProfile entitlements is not as expected.");
        },
            skip: Platform.isWindows
                ? 'Return characters are generated on windows'
                : null);

        test('macOS Release entitlements has network client tag and true', () {
          var entitlementsPath = path.join(
              tempPath, flutterDir, 'macos', 'Runner', 'Release.entitlements');
          var file = File(entitlementsPath);
          var exists = file.existsSync();
          expect(exists, isTrue,
              reason: "Release entitlements does not exist.");
          String contents = file.readAsStringSync();
          String expected = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
</dict>
</plist>''';

          expect(contents.trim(), expected.trim(),
              reason: "Release entitlements is not as expected.");
        },
            skip: Platform.isWindows
                ? 'Return characters are generated on windows'
                : null);

        test('has a main file', () {
          expect(
            File(path.join(tempPath, flutterDir, 'lib', 'main.dart'))
                .existsSync(),
            isTrue,
            reason: 'Flutter main file does not exist.',
          );
        });
      });

      group('then the client project', () {
        test('folder is created', () {
          expect(
            Directory(path.join(tempPath, clientDir)).existsSync(),
            isTrue,
            reason: 'Client folder does not exist.',
          );
        });

        test('has a pubspec file', () {
          expect(
            File(path.join(tempPath, clientDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Client pubspec file does not exist.',
          );
        });

        test('has a project_client file', () {
          expect(
            File(
              path.join(
                  tempPath, clientDir, 'lib', '${projectName}_client.dart'),
            ).existsSync(),
            isTrue,
            reason: 'Client project_client file does not exist.',
          );
        });

        test('has a protocol client file', () {
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
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final (:serverDir, flutterDir: _, :clientDir) =
        createProjectFolderPaths(projectName);

    late Process createProcess;

    tearDown(() async {
      createProcess.kill();
    });

    test(
        'when removing generated files from a new project and running generate then the files are recreated successfully',
        () async {
      createProcess = await startProcess(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var createProjectExitCode = await createProcess.exitCode;
      expect(createProjectExitCode, 0);

      // Delete generated files
      var generatedServerDir = Directory(
        path.normalize(
            path.join(tempPath, serverDir, 'lib', 'src', 'generated')),
      );
      generatedServerDir.deleteSync(recursive: true);

      var generatedClientDir = Directory(
        path.normalize(
            path.join(tempPath, clientDir, 'lib', 'src', 'protocol')),
      );
      generatedClientDir.deleteSync(recursive: true);

      var generateProcess = await runProcess(
        'serverpod',
        ['generate'],
        workingDirectory: commandRoot,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      expect(
        generateProcess.exitCode,
        0,
        reason: 'Serverpod generate command failed.',
      );

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

      expect(
        File(path.join(
          tempPath,
          serverDir,
          'lib',
          'src',
          'generated',
          'greeting.dart',
        )).existsSync(),
        isTrue,
        reason: 'Server generated example file does not exist.',
      );

      expect(
        File(path.join(
          tempPath,
          clientDir,
          'lib',
          'src',
          'protocol',
          'client.dart',
        )).existsSync(),
        isTrue,
        reason: 'Client protocol client file does not exist.',
      );

      expect(
        File(path.join(
          tempPath,
          serverDir,
          'lib',
          'src',
          'generated',
          'protocol.yaml',
        )).existsSync(),
        isTrue,
        reason: 'Client protocol client file does not exist.',
      );
    });
  });

  group('Given a created project and a running docker environment', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    setUp(() async {
      createProcess = await startProcess(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      assert((await createProcess.exitCode) == 0);

      final docker = await startProcess(
        'docker',
        ['compose', 'up', '--build', '--detach'],
        workingDirectory: commandRoot,
        ignorePlatform: true,
      );

      assert((await docker.exitCode) == 0);
    });

    tearDown(() async {
      createProcess.kill();

      await runProcess(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
        skipBatExtentionOnWindows: true,
      );

      while (!await isNetworkPortAvailable(8090));
    });

    test('when running tests then example unit and integration tests passes',
        () async {
      var testProcess = await startProcess(
        'dart',
        ['test'],
        workingDirectory:
            path.join(tempPath, projectName, "${projectName}_server"),
      );

      await expectLater(testProcess.exitCode, completion(0));
    },
        skip: Platform.isWindows
            ? 'Windows does not support postgres docker image in github actions'
            : null);
  });
}
