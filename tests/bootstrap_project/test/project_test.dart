@Timeout(Duration(minutes: 15))
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);
  final tempPath = Directory.systemTemp
      .createTempSync('serverpod_bootstrap_')
      .path;

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  tearDownAll(() async {
    try {
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    tearDown(() {
      createProcess.kill();
    });

    test(
      'when creating a new project then the project is created successfully and can be booted',
      () async {
        createProcess = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
            '--no-interactive',
          ],
          rootPath: rootPath,
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

        // The server boots against embedded PostgreSQL (config/development.yaml
        // sets `dataPath`), so no external database needs provisioning.
        var startProjectProcess = await startProcess(
          'dart',
          ['bin/main.dart', '--apply-migrations', '--role', 'maintenance'],
          workingDirectory: commandRoot,
        );

        var startProjectExitCode = await startProjectProcess.exitCode;
        expect(startProjectExitCode, 0);
      },
      // The generated server now uses embedded PostgreSQL; drop this skip once
      // embedded PG is verified on Windows CI.
      skip: Platform.isWindows
          ? 'Pending: verify embedded PostgreSQL on Windows CI'
          : null,
    );
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;
    Process? startProjectProcess;

    tearDown(() {
      createProcess.kill();
      startProjectProcess?.kill();
    });

    test(
      'when creating a new project then the project can be booted without applying migrations',
      () async {
        createProcess = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
            '--no-interactive',
          ],
          rootPath: rootPath,
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

        // The server boots against embedded PostgreSQL (config/development.yaml
        // sets `dataPath`), so no external database needs provisioning.
        startProjectProcess = await startProcess(
          'dart',
          ['bin/main.dart', '--apply-migrations'],
          workingDirectory: commandRoot,
        );

        var serverStarted = false;
        // A fresh project's first `dart run` compiles the whole server graph
        // (now including embedded-postgres support), so give the cold boot a
        // generous budget.
        for (int retries = 0; retries < 60; retries++) {
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

        expect(
          serverStarted,
          isTrue,
          reason: 'Failed to get 200 response from server.',
        );
      },
      skip: Platform.isWindows
          ? 'Windows does not support postgres docker image in github actions'
          : null,
    );
  });

  group('Given a clean state', () {
    var (:projectName, commandRoot: _) = createRandomProjectName(tempPath);
    final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
      projectName,
    );

    group('when creating a new project', () {
      setUpAll(() async {
        var process = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
            '--no-interactive',
          ],
          rootPath: rootPath,
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
            File(
              path.join(tempPath, serverDir, 'lib', 'server.dart'),
            ).existsSync(),
            isTrue,
            reason: 'Server server.dart file does not exist.',
          );
        });

        test('has a Dockerfile', () {
          expect(
            File(path.join(tempPath, serverDir, 'Dockerfile')).existsSync(),
            isTrue,
            reason: 'Server Dockerfile does not exist.',
          );
        });

        test('has an example_endpoint file', () {
          expect(
            File(
              path.join(
                tempPath,
                serverDir,
                'lib',
                'src',
                'greetings',
                'greeting_endpoint.dart',
              ),
            ).existsSync(),
            isTrue,
            reason: 'Server greeting_endpoint file does not exist.',
          );
        });

        test('has a generated endpoints file', () {
          expect(
            File(
              path.join(
                tempPath,
                serverDir,
                'lib',
                'src',
                'generated',
                'endpoints.dart',
              ),
            ).existsSync(),
            isTrue,
            reason: 'Server generated endpoints file does not exist.',
          );
        });

        test('has a generated test tools file', () {
          expect(
            File(
              path.join(
                tempPath,
                serverDir,
                'test',
                'integration',
                'test_tools',
                'serverpod_test_tools.dart',
              ),
            ).existsSync(),
            isTrue,
            reason:
                'Server generated integration test tools file does not exist.',
          );
        });

        test('has a generated example file', () {
          expect(
            File(
              path.join(
                tempPath,
                serverDir,
                'lib',
                'src',
                'generated',
                'greetings',
                'greeting.dart',
              ),
            ).existsSync(),
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
            File(
              path.join(
                tempPath,
                serverDir,
                'migrations',
                'migration_registry.txt',
              ),
            ).existsSync(),
            isTrue,
            reason: 'Server migration registry does not exist.',
          );
        });

        test('has a generated protocol.yaml file', () {
          expect(
            File(
              path.join(
                tempPath,
                serverDir,
                'lib',
                'src',
                'generated',
                'protocol.yaml',
              ),
            ).existsSync(),
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

        test(
          'has a pubspec file with serverpod_auth_idp_flutter dependency',
          () {
            final pubspec = File(
              path.join(tempPath, flutterDir, 'pubspec.yaml'),
            );

            expect(
              pubspec.existsSync(),
              isTrue,
              reason: 'Flutter pubspec file does not exist.',
            );

            expect(
              pubspec.readAsStringSync(),
              contains('serverpod_auth_idp_flutter:'),
              reason:
                  'Flutter pubspec file does not have serverpod_auth_idp_flutter dependency.',
            );
          },
        );

        test(
          'has a pubspec file with flutter_secure_storage dependency override',
          () {
            final pubspec = File(
              path.join(tempPath, flutterDir, 'pubspec.yaml'),
            );
            final content = pubspec.readAsStringSync();

            expect(
              content,
              contains('dependency_overrides:'),
              reason:
                  'Flutter pubspec file does not have dependency overrides.',
            );

            expect(
              content,
              contains('flutter_secure_storage: ^10.0.0'),
              reason:
                  'Flutter pubspec file does not have flutter_secure_storage override.',
            );
          },
        );

        test(
          'macOS DebugProfile entitlements has network client tag and true',
          () {
            var entitlementsPath = path.join(
              tempPath,
              flutterDir,
              'macos',
              'Runner',
              'DebugProfile.entitlements',
            );
            var file = File(entitlementsPath);
            var exists = file.existsSync();
            expect(
              exists,
              isTrue,
              reason: "DebugProfile entitlements does not exist.",
            );
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
            expect(
              contents.trim(),
              expected.trim(),
              reason: "DebugProfile entitlements is not as expected.",
            );
          },
          skip: Platform.isWindows
              ? 'Return characters are generated on windows'
              : null,
        );

        test(
          'macOS Release entitlements has network client tag and true',
          () {
            var entitlementsPath = path.join(
              tempPath,
              flutterDir,
              'macos',
              'Runner',
              'Release.entitlements',
            );
            var file = File(entitlementsPath);
            var exists = file.existsSync();
            expect(
              exists,
              isTrue,
              reason: "Release entitlements does not exist.",
            );
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

            expect(
              contents.trim(),
              expected.trim(),
              reason: "Release entitlements is not as expected.",
            );
          },
          skip: Platform.isWindows
              ? 'Return characters are generated on windows'
              : null,
        );

        test('has a main file', () {
          expect(
            File(
              path.join(tempPath, flutterDir, 'lib', 'main.dart'),
            ).existsSync(),
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

        test('has a pubspec file with serverpod_auth_idp_client dependency', () {
          final pubspec = File(
            path.join(tempPath, clientDir, 'pubspec.yaml'),
          );
          expect(
            pubspec.existsSync(),
            isTrue,
            reason: 'Client pubspec file does not exist.',
          );
          expect(
            pubspec.readAsStringSync(),
            contains('serverpod_auth_idp_client:'),
            reason:
                'Client pubspec file does not have serverpod_auth_idp_client dependency.',
          );
        });

        test('has a project_client file', () {
          expect(
            File(
              path.join(
                tempPath,
                clientDir,
                'lib',
                '${projectName}_client.dart',
              ),
            ).existsSync(),
            isTrue,
            reason: 'Client project_client file does not exist.',
          );
        });

        test('has a protocol client file', () {
          expect(
            File(
              path.join(
                tempPath,
                clientDir,
                'lib',
                'src',
                'protocol',
                'client.dart',
              ),
            ).existsSync(),
            isTrue,
            reason: 'Client protocol client file does not exist.',
          );
        });
      });

      group('then the .github directory', () {
        test('has tests workflow', () {
          expect(
            File(
              path.join(
                tempPath,
                projectName,
                '.github',
                'workflows',
                'tests.yml',
              ),
            ).existsSync(),
            isTrue,
            reason: 'tests.yml workflow does not exist.',
          );
        });

        test('has format workflow', () {
          expect(
            File(
              path.join(
                tempPath,
                projectName,
                '.github',
                'workflows',
                'format.yml',
              ),
            ).existsSync(),
            isTrue,
            reason: 'format.yml workflow does not exist.',
          );
        });

        test('has analyze workflow', () {
          expect(
            File(
              path.join(
                tempPath,
                projectName,
                '.github',
                'workflows',
                'analyze.yml',
              ),
            ).existsSync(),
            isTrue,
            reason: 'analyze.yml workflow does not exist.',
          );
        });
      });

      group('then the workspace', () {
        test('has a root pubspec.yaml file', () {
          expect(
            File(path.join(tempPath, projectName, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason: 'Root workspace pubspec file does not exist.',
          );
        });

        test('root pubspec.yaml has name: _', () {
          final content = File(
            path.join(tempPath, projectName, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('name: _'));
        });

        test('root pubspec.yaml has workspace section', () {
          final content = File(
            path.join(tempPath, projectName, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('workspace:'));
          expect(content, contains('${projectName}_client'));
          expect(content, contains('${projectName}_server'));
          expect(content, contains('${projectName}_flutter'));
        });

        test(
          'has a root .gitignore that ignores workspace .dart_tool and .scloud',
          () {
            final rootGitignore = File(
              path.join(tempPath, projectName, '.gitignore'),
            );
            expect(rootGitignore.existsSync(), isTrue);

            final content = rootGitignore.readAsStringSync();
            expect(content, contains('.dart_tool/'));
            expect(content, contains('.scloud/'));
          },
        );

        test('server pubspec.yaml has resolution: workspace', () {
          final content = File(
            path.join(tempPath, serverDir, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('resolution: workspace'));
        });

        test('client pubspec.yaml has resolution: workspace', () {
          final content = File(
            path.join(tempPath, clientDir, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('resolution: workspace'));
        });

        test('flutter pubspec.yaml has resolution: workspace', () {
          final content = File(
            path.join(tempPath, flutterDir, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('resolution: workspace'));
        });

        test('root has pubspec.lock file', () {
          expect(
            File(path.join(tempPath, projectName, 'pubspec.lock')).existsSync(),
            isTrue,
            reason: 'Root pubspec.lock file does not exist.',
          );
        });

        test('does not copy template pubspec lock files into packages', () {
          final packageDirs = [serverDir, clientDir, flutterDir];

          for (final packageDir in packageDirs) {
            expect(
              File(
                path.join(tempPath, packageDir, 'pubspec.lock'),
              ).existsSync(),
              isFalse,
              reason: 'Template pubspec.lock was copied into $packageDir.',
            );
          }
        });

        test('does not copy template pubspec override files', () {
          final packageDirs = [projectName, serverDir, clientDir, flutterDir];

          for (final packageDir in packageDirs) {
            expect(
              File(
                path.join(tempPath, packageDir, 'pubspec_overrides.yaml'),
              ).existsSync(),
              isFalse,
              reason:
                  'Template pubspec_overrides.yaml was copied into $packageDir.',
            );
          }
        });

        test('does not copy template melos project files', () {
          final packageDirs = [projectName, serverDir, clientDir, flutterDir];

          for (final packageDir in packageDirs) {
            final directory = Directory(path.join(tempPath, packageDir));
            final melosProjectFiles = directory
                .listSync()
                .whereType<File>()
                .where((file) {
                  final fileName = path.basename(file.path);
                  return fileName.startsWith('melos_') &&
                      fileName.endsWith('.iml');
                });

            expect(
              melosProjectFiles,
              isEmpty,
              reason:
                  'Template melos project file was copied into $packageDir.',
            );
          }
        });

        test(
          'then the flutter pubspec contains override for flutter secure storage',
          () {
            final pubspec = File(
              path.join(tempPath, flutterDir, 'pubspec.yaml'),
            );
            final content = pubspec.readAsStringSync();
            expect(content, contains('flutter_secure_storage'));
          },
        );

        test('has AGENTS.md', () {
          final agentsMd = File(path.join(tempPath, projectName, 'AGENTS.md'));
          expect(agentsMd.existsSync(), isTrue);
          expect(agentsMd.readAsStringSync(), isNotEmpty);
        });

        test('has CLAUDE.md', () {
          final claudeMd = File(path.join(tempPath, projectName, 'CLAUDE.md'));
          expect(claudeMd.existsSync(), isTrue);
          expect(claudeMd.readAsStringSync(), '@AGENTS.md\n');
        });

        test('has agent skills installed', () {
          expect(
            Directory(
              path.join(tempPath, projectName, '.agents', 'skills'),
            ).existsSync(),
            isTrue,
          );
          expect(
            Directory(
              path.join(tempPath, projectName, '.claude', 'skills'),
            ).existsSync(),
            isTrue,
          );
          expect(
            Directory(
              path.join(tempPath, projectName, '.cursor', 'skills'),
            ).existsSync(),
            isTrue,
          );
        });

        group('has Serverpod and Dart MCP servers configured', () {
          final serverDirRelative = '${projectName}_server';
          final genericConfig =
              '''
{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "$serverDirRelative"]
    },
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
''';

          test('for Claude', () {
            final claude = File(
              path.join(tempPath, projectName, '.mcp.json'),
            );
            expect(claude.existsSync(), isTrue);
            expect(claude.readAsStringSync(), genericConfig);
          });

          test('for Cursor', () {
            final cursor = File(
              path.join(tempPath, projectName, '.cursor/mcp.json'),
            );
            expect(cursor.existsSync(), isTrue);
            expect(cursor.readAsStringSync(), genericConfig);
          });

          test('for VS Code', () {
            final vscode = File(
              path.join(tempPath, projectName, '.vscode/mcp.json'),
            );
            expect(vscode.existsSync(), isTrue);
            expect(
              vscode.readAsStringSync(),
              genericConfig.replaceAll('mcpServers', 'servers'),
            );
          });
        });
      });

      group('then the .vscode directory', () {
        test('has launch.json', () {
          expect(
            File(
              path.join(
                tempPath,
                projectName,
                '.vscode',
                'launch.json',
              ),
            ).existsSync(),
            isTrue,
            reason: 'launch.json does not exist.',
          );
        });

        test('has flutter configuration as first entry', () {
          final launchJson = File(
            path.join(
              tempPath,
              projectName,
              '.vscode',
              'launch.json',
            ),
          ).readAsStringSync();

          expect(
            launchJson.contains('"${projectName}_flutter"'),
            isTrue,
            reason: 'launch.json does not contain flutter configuration.',
          );

          // Verify flutter config appears before server config
          final flutterIndex = launchJson.indexOf('"${projectName}_flutter"');
          final serverIndex = launchJson.indexOf('"${projectName}_server"');

          expect(
            flutterIndex,
            lessThan(serverIndex),
            reason:
                'Flutter configuration should appear before server configuration.',
          );
        });

        test('has compound configuration for full stack', () {
          final launchJson = File(
            path.join(
              tempPath,
              projectName,
              '.vscode',
              'launch.json',
            ),
          ).readAsStringSync();

          expect(
            launchJson.contains('"compounds"'),
            isTrue,
            reason: 'launch.json does not contain compounds section.',
          );

          expect(
            launchJson.contains('"${projectName} (full stack)"'),
            isTrue,
            reason:
                'launch.json does not contain full stack compound configuration.',
          );
        });
      });
    });
  });

  group('Given a clean state', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final (:serverDir, flutterDir: _, :clientDir) = createProjectFolderPaths(
      projectName,
    );

    late Process createProcess;

    tearDown(() async {
      createProcess.kill();
    });

    test(
      'when removing generated files from a new project and running generate then the files are recreated successfully',
      () async {
        createProcess = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
            '--no-interactive',
          ],
          rootPath: rootPath,
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
            path.join(tempPath, serverDir, 'lib', 'src', 'generated'),
          ),
        );
        generatedServerDir.deleteSync(recursive: true);

        var generatedClientDir = Directory(
          path.normalize(
            path.join(tempPath, clientDir, 'lib', 'src', 'protocol'),
          ),
        );
        generatedClientDir.deleteSync(recursive: true);

        var generateProcess = await runServerpodCli(
          [
            'generate',
          ],
          rootPath: rootPath,
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
          File(
            path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          ).existsSync(),
          isTrue,
          reason: 'Server generated endpoints file does not exist.',
        );

        expect(
          File(
            path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'generated',
              'greetings',
              'greeting.dart',
            ),
          ).existsSync(),
          isTrue,
          reason: 'Server generated example file does not exist.',
        );

        expect(
          File(
            path.join(
              tempPath,
              clientDir,
              'lib',
              'src',
              'protocol',
              'client.dart',
            ),
          ).existsSync(),
          isTrue,
          reason: 'Client protocol client file does not exist.',
        );

        expect(
          File(
            path.join(
              tempPath,
              serverDir,
              'lib',
              'src',
              'generated',
              'protocol.yaml',
            ),
          ).existsSync(),
          isTrue,
          reason: 'Client protocol client file does not exist.',
        );
      },
    );
  });

  group('Given a created project', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    late Process createProcess;

    setUp(() async {
      createProcess = await startServerpodCli(
        [
          'create',
          projectName,
          '--no-analytics',
          '--no-interactive',
        ],
        rootPath: rootPath,
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      assert((await createProcess.exitCode) == 0);
    });

    tearDown(() async {
      createProcess.kill();
    });

    test(
      'when building the server Dockerfile then the image is built successfully',
      () async {
        // Temporarily remove parameters from server.dart that have not been
        // published yet, because the Dockerfile won't have access to the local
        // override. Once published, we can remove these.
        final serverFile = File(path.join(commandRoot, 'lib', 'server.dart'));
        final serverSource = serverFile.readAsStringSync();
        const wasmHeaders = 'enableWasmHeaders: false,';
        // TODO: Remove once Session.alert is published.
        const sessionAlert = 'session.alert(';
        // TODO: Remove once ServerpodCloudEmailIdpConfig is published. The
        // published serverpod_auth_idp_server does not have it yet, so swap it
        // for the published-compatible EmailIdpConfigFromPasswords (its send
        // callbacks are optional, so the no-argument form compiles).
        final cloudEmailConfig = RegExp(
          r'ServerpodCloudEmailIdpConfig\([^)]*\)',
        );
        serverFile.writeAsStringSync(
          serverSource
              .replaceAll(wasmHeaders, '')
              .replaceAll(sessionAlert, 'session.log(')
              .replaceAll(cloudEmailConfig, 'EmailIdpConfigFromPasswords()'),
        );

        final dockerBuildProcess = await startProcess(
          'docker',
          [
            'build',
            '-f',
            path.join('${projectName}_server', 'Dockerfile'),
            '.',
          ],
          workingDirectory: path.join(tempPath, projectName),
        );

        addTearDown(() async {
          await dockerBuildProcess.kill();
        });

        expect(
          await dockerBuildProcess.exitCode,
          0,
          reason: 'Failed to build the generated server Docker image.',
        );
      },
      skip: Platform.isWindows
          ? 'Windows does not support Docker builds in GitHub Actions.'
          : null,
    );
  });

  group('Given a created project', () {
    final (:projectName, commandRoot: _) = createRandomProjectName(tempPath);

    late Process createProcess;

    setUp(() async {
      createProcess = await startServerpodCli(
        [
          'create',
          projectName,
          '-v',
          '--no-analytics',
          '--no-interactive',
        ],
        rootPath: rootPath,
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );
      assert((await createProcess.exitCode) == 0);
    });

    tearDown(() {
      createProcess.kill();
    });

    test(
      'when running tests then example unit and integration tests passes',
      () async {
        // The generated server's integration tests run on embedded PostgreSQL
        // (config/test.yaml sets `dataPath`), so no external database needs to
        // be provisioned here.
        var testProcess = await startProcess(
          'dart',
          ['test'],
          workingDirectory: path.join(
            tempPath,
            projectName,
            "${projectName}_server",
          ),
        );

        await expectLater(testProcess.exitCode, completion(0));
      },
      // The generated server now uses embedded PostgreSQL; drop this skip once
      // embedded PG is verified on Windows CI.
      skip: Platform.isWindows
          ? 'Pending: verify embedded PostgreSQL on Windows CI'
          : null,
    );
  });

  group(
    'Given a created project and a running pod',
    () {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      late Process createProcess;
      late Process startProjectProcess;

      setUpAll(() async {
        createProcess = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
            '--no-interactive',
          ],
          rootPath: rootPath,
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );
        assert((await createProcess.exitCode) == 0);

        startProjectProcess = await startProcessAndWaitForKeywords(
          'dart',
          ['bin/main.dart', '--apply-migrations'],
          workingDirectory: commandRoot,
          keywords: ['Webserver listening on'],
        );
      });

      tearDownAll(() async {
        createProcess.kill();
        startProjectProcess.kill();
      });

      test(
        'when requesting the Flutter web app under / before it is built, '
        'then the "Flutter web app not built" page is served',
        () async {
          final response = await http.get(Uri.parse('http://localhost:8082'));
          expect(response.statusCode, equals(200));
          expect(
            response.body,
            contains('<title>Flutter web app not built</title>'),
          );
          expect(
            response.body,
            isNot(
              contains(
                '<meta name="description" content="A new Flutter project.">',
              ),
            ),
          );
        },
      );

      group('Given the Flutter web app is built and the pod is restarted', () {
        setUp(() async {
          final flutterBuildProcess = await startServerpodCli(
            ['run', 'flutter_build'],
            rootPath: rootPath,
            workingDirectory: commandRoot,
            environment: {
              'SERVERPOD_HOME': rootPath,
            },
          );
          expect(await flutterBuildProcess.exitCode, 0);

          startProjectProcess.kill();
          startProjectProcess = await startProcessAndWaitForKeywords(
            'dart',
            ['bin/main.dart', '--apply-migrations'],
            workingDirectory: commandRoot,
            keywords: ['Webserver listening on'],
          );
        });

        test(
          'when requesting the Flutter web app under /, '
          'then the web app is served successfully',
          () async {
            final response = await http.get(Uri.parse('http://localhost:8082'));
            expect(response.statusCode, equals(200));
            expect(
              response.body,
              isNot(contains('<title>Flutter web app not built</title>')),
            );
            expect(
              response.body,
              contains(
                '<meta name="description" content="A new Flutter project.">',
              ),
            );
          },
        );
      });
    },
    skip: Platform.isWindows
        ? 'Windows does not support postgres in github actions'
        : null,
  );
}
