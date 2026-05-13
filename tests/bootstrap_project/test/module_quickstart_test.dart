@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp';

void main() {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);
  final tempPath = path.join(rootPath, tempDirName);

  setUpAll(() async {
    await Directory(tempPath).create();
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  tearDownAll(() async {
    try {
      Directory(tempPath).deleteSync(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    var (commandRoot: _, :projectName) = createRandomProjectName(tempPath);
    final (:serverDir, flutterDir: _, :clientDir) = createProjectFolderPaths(
      projectName,
    );

    group('when creating a new module project with quickstart command', () {
      setUpAll(() async {
        var process = await startServerpodCli(
          [
            'quickstart',
            '--template',
            'module',
            projectName,
            '-v',
            '--no-analytics',
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
        expect(exitCode, 0);
      });

      group(
        'then the server project',
        () {
          test('folder is created', () {
            expect(
              Directory(path.join(tempPath, serverDir)).existsSync(),
              isTrue,
            );
          });

          test('has a pubspec file', () {
            expect(
              File(path.join(tempPath, serverDir, 'pubspec.yaml')).existsSync(),
              isTrue,
            );
          });

          test('has a .gitignore file', () {
            expect(
              File(path.join(tempPath, serverDir, '.gitignore')).existsSync(),
              isTrue,
            );
          });

          test('has a module_endpoint file', () {
            expect(
              File(
                path.join(
                  tempPath,
                  serverDir,
                  'lib',
                  'src',
                  'endpoints',
                  'module_endpoint.dart',
                ),
              ).existsSync(),
              isTrue,
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
            );
          });

          test('has a generated module_class file', () {
            expect(
              File(
                path.join(
                  tempPath,
                  serverDir,
                  'lib',
                  'src',
                  'generated',
                  'module_class.dart',
                ),
              ).existsSync(),
              isTrue,
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
            );
          });

          test('has a migrations folder', () {
            expect(
              Directory(
                path.join(
                  tempPath,
                  serverDir,
                  'migrations',
                ),
              ).existsSync(),
              isTrue,
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
            );
          });

          test('does not have docker compose file', () {
            final dockerComposeFile = File(
              path.join(tempPath, serverDir, 'docker-compose.yaml'),
            );
            expect(dockerComposeFile.existsSync(), isFalse);
          });

          test(
            'does not have passwords config file',
            () {
              final config = File(
                path.join(tempPath, serverDir, 'config', 'passwords.yaml'),
              );
              expect(config.existsSync(), isFalse);
            },
          );

          test(
            'has test configuration with sqlite',
            () {
              final testConfigFile = File(
                path.join(tempPath, serverDir, 'config', 'test.yaml'),
              );

              expect(
                testConfigFile.readAsStringSync(),
                contains('filePath: ${projectName}_test.db'),
              );
            },
          );

          test('has a generated protocol file', () {
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
            );
          });
        },
      );

      group(
        'then the client project folder',
        () {
          test('is created', () {
            expect(
              Directory(path.join(tempPath, clientDir)).existsSync(),
              isTrue,
            );
          });

          test('has a pubspec file', () {
            expect(
              File(path.join(tempPath, clientDir, 'pubspec.yaml')).existsSync(),
              isTrue,
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
            );
          });
        },
      );

      group('then the workspace', () {
        test('has a root pubspec.yaml file', () {
          expect(
            File(path.join(tempPath, projectName, 'pubspec.yaml')).existsSync(),
            isTrue,
          );
        });

        test('root pubspec.yaml has name: _', () {
          final content = File(
            path.join(tempPath, projectName, 'pubspec.yaml'),
          ).readAsStringSync();
          expect(content, contains('name: _'));
        });

        test(
          'root pubspec.yaml has workspace section with server and client',
          () {
            final content = File(
              path.join(tempPath, projectName, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(content, contains('workspace:'));
            expect(content, contains('${projectName}_client'));
            expect(content, contains('${projectName}_server'));
          },
        );

        test('has a root .gitignore that ignores workspace .dart_tool', () {
          final rootGitignore = File(
            path.join(tempPath, projectName, '.gitignore'),
          );
          expect(rootGitignore.existsSync(), isTrue);
          expect(rootGitignore.readAsStringSync(), contains('.dart_tool/'));
        });

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

        test('root has pubspec.lock file', () {
          expect(
            File(path.join(tempPath, projectName, 'pubspec.lock')).existsSync(),
            isTrue,
          );
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
        });

        group('has Serverpod and Dart MCP servers configured', () {
          final genericConfig = '''
{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp"]
    },
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
''';

          test('for Antigravity', () {
            final antigravity = File(
              path.join(
                tempPath,
                projectName,
                '.gemini/antigravity/mcp_config.json',
              ),
            );
            expect(antigravity.existsSync(), isTrue);
            expect(
              antigravity.readAsStringSync(),
              genericConfig.replaceAll('"dart":', '"dart-mcp-server":'),
            );
          });

          test('for Codex', () {
            final codex = File(
              path.join(tempPath, projectName, '.codex/config.toml'),
            );
            expect(codex.existsSync(), isTrue);
            expect(
              codex.readAsStringSync(),
              '''
[mcp_servers.serverpod]
command = "serverpod"
args = ["mcp"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''',
            );
          });

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

          test('for VSCode', () {
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
    });
  });
}
