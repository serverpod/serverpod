@Timeout(Duration(minutes: 15))
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp_project_server';

void main() async {
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
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group(
    'Given a clean state',
    () {
      final (:projectName, commandRoot: _) = createRandomProjectName(tempPath);
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      group(
        'when creating a new project with the server template',
        () {
          setUpAll(() async {
            var createProcess = await startServerpodCli(
              [
                'create',
                '--template',
                'server',
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

            var exitCode = await createProcess.exitCode;
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

          test('then a flutter project folder is not created', () {
            expect(
              Directory(path.join(tempPath, flutterDir)).existsSync(),
              isFalse,
            );
          });

          test('then the workspace has a root pubspec.yaml file', () {
            expect(
              File(
                path.join(tempPath, projectName, 'pubspec.yaml'),
              ).existsSync(),
              isTrue,
              reason: 'Root workspace pubspec file does not exist.',
            );
          });

          test('then the workspace root pubspec.yaml has name: _', () {
            final content = File(
              path.join(tempPath, projectName, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(content, contains('name: _'));
          });

          test(
            'then the workspace root pubspec.yaml has workspace section',
            () {
              final content = File(
                path.join(tempPath, projectName, 'pubspec.yaml'),
              ).readAsStringSync();
              expect(content, contains('workspace:'));
              expect(content, contains('${projectName}_client'));
              expect(content, contains('${projectName}_server'));
            },
          );

          test(
            'then the workspace has a root .gitignore that ignores workspace .dart_tool and .scloud',
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

          test('then the server pubspec.yaml has resolution: workspace', () {
            final content = File(
              path.join(tempPath, serverDir, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(content, contains('resolution: workspace'));
          });

          test('then the client pubspec.yaml has resolution: workspace', () {
            final content = File(
              path.join(tempPath, clientDir, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(content, contains('resolution: workspace'));
          });

          test('then the workspace root has pubspec.lock file', () {
            expect(
              File(
                path.join(tempPath, projectName, 'pubspec.lock'),
              ).existsSync(),
              isTrue,
              reason: 'Root pubspec.lock file does not exist.',
            );
          });

          test(
            'then the workspace does not copy template pubspec lock files into packages',
            () {
              final packageDirs = [serverDir, clientDir];

              for (final packageDir in packageDirs) {
                expect(
                  File(
                    path.join(tempPath, packageDir, 'pubspec.lock'),
                  ).existsSync(),
                  isFalse,
                  reason: 'Template pubspec.lock was copied into $packageDir.',
                );
              }
            },
          );

          test(
            'then the workspace does not copy template pubspec override files',
            () {
              final packageDirs = [projectName, serverDir, clientDir];

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
            },
          );

          test(
            'then the workspace does not copy template melos project files',
            () {
              final packageDirs = [projectName, serverDir, clientDir];

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
            },
          );

          test('then the workspace has AGENTS.md file', () {
            final agentsMd = File(
              path.join(tempPath, projectName, 'AGENTS.md'),
            );
            expect(agentsMd.existsSync(), isTrue);
            expect(agentsMd.readAsStringSync(), isNotEmpty);
          });

          test('then the workspace has CLAUDE.md file', () {
            final claudeMd = File(
              path.join(tempPath, projectName, 'CLAUDE.md'),
            );
            expect(claudeMd.existsSync(), isTrue);
            expect(claudeMd.readAsStringSync(), '@AGENTS.md\n');
          });

          test('then the workspace has agent skills installed', () {
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

          group(
            'then the workspace has Serverpod and Dart MCP servers configured',
            () {
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
            },
          );

          test('then the server project folder is created', () {
            expect(
              Directory(path.join(tempPath, serverDir)).existsSync(),
              isTrue,
              reason: 'Server folder does not exist.',
            );
          });

          test('then the server project has a pubspec file', () {
            expect(
              File(
                path.join(tempPath, serverDir, 'pubspec.yaml'),
              ).existsSync(),
              isTrue,
              reason: 'Server pubspec file does not exist.',
            );
          });

          test(
            'then the server pubspec does not contain the serverpod scripts section',
            () {
              final content = File(
                path.join(tempPath, serverDir, 'pubspec.yaml'),
              ).readAsStringSync();
              expect(content, isNot(contains('scripts:')));
              expect(content, isNot(contains('flutter_build:')));
            },
          );

          test(
            'then the server pubspec does not contain the flutter_apps section',
            () {
              final content = File(
                path.join(tempPath, serverDir, 'pubspec.yaml'),
              ).readAsStringSync();
              expect(content, isNot(contains('flutter_apps:')));
            },
          );

          test('then the server project has a .gitignore file', () {
            expect(
              File(path.join(tempPath, serverDir, '.gitignore')).existsSync(),
              isTrue,
              reason: 'Server .gitignore file does not exist.',
            );
          });

          test('then the server project has a src/cache_busting.dart file', () {
            expect(
              File(
                path.join(
                  tempPath,
                  serverDir,
                  'lib',
                  'src',
                  'cache_busting.dart',
                ),
              ).existsSync(),
              isTrue,
              reason: 'Server cache_busting.dart file does not exist.',
            );
          });

          test('then the server project has a server.dart file', () {
            expect(
              File(
                path.join(tempPath, serverDir, 'lib', 'server.dart'),
              ).existsSync(),
              isTrue,
              reason: 'Server server.dart file does not exist.',
            );
          });

          test(
            'then the server.dart contains website configurations',
            () {
              final file = File(
                path.join(tempPath, serverDir, 'lib', 'server.dart'),
              );

              final content = file.readAsStringSync();

              expect(
                content,
                contains("import 'src/web/routes/root.dart';"),
                reason: 'server.dart does not contain website configurations.',
              );

              expect(
                content,
                contains("pod.webServer.addRoute(RootRoute(), '/')"),
                reason: 'server.dart does not contain website configurations.',
              );

              expect(
                content,
                contains("pod.webServer.addRoute(RootRoute(), '/index.html')"),
                reason: 'server.dart does not contain website configurations.',
              );

              expect(
                content,
                contains(
                  "final root = Directory(Uri(path: 'web/static').toFilePath())",
                ),
                reason: 'server.dart does not contain website configurations.',
              );

              expect(
                content,
                contains(
                  "StaticRoute.withCacheBusting(root, mountPrefix: '/web')",
                ),
                reason: 'server.dart does not contain website configurations.',
              );
            },
          );

          test(
            'then the server.dart does not contain Flutter web app configurations',
            () {
              final file = File(
                path.join(tempPath, serverDir, 'lib', 'server.dart'),
              );

              final content = file.readAsStringSync();

              expect(
                content,
                isNot(
                  contains("import 'src/web/routes/app_config_route.dart';"),
                ),
                reason: 'server.dart contains Flutter web app configurations.',
              );

              expect(
                content,
                isNot(
                  contains('AppConfigRoute(apiConfig: pod.config.apiServer)'),
                ),
                reason: 'server.dart contains Flutter web app configurations.',
              );

              expect(
                content,
                isNot(
                  contains(
                    "final appDir = Directory(Uri(path: 'web/app').toFilePath())",
                  ),
                ),
                reason: 'server.dart contains Flutter web app configurations.',
              );

              expect(
                content,
                isNot(
                  contains(
                    "Uri(path: 'web/pages/build_flutter_app.html').toFilePath()",
                  ),
                ),
                reason: 'server.dart contains Flutter web app configurations.',
              );
            },
          );

          test('then the server project has a Dockerfile', () {
            expect(
              File(path.join(tempPath, serverDir, 'Dockerfile')).existsSync(),
              isTrue,
              reason: 'Server Dockerfile does not exist.',
            );
          });

          test('then the server project has an example_endpoint file', () {
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

          test('then the server project has a generated endpoints file', () {
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

          test('then the server project has a generated test tools file', () {
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

          test('then the server project has a generated example file', () {
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

          test(
            'then the server project has a generated protocol.yaml file',
            () {
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
            },
          );

          test('then the client project folder is created', () {
            expect(
              Directory(path.join(tempPath, clientDir)).existsSync(),
              isTrue,
              reason: 'Client folder does not exist.',
            );
          });

          test(
            'then the client project has a pubspec file with serverpod_auth_idp_client dependency',
            () {
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
            },
          );

          test('then the client project has a project_client file', () {
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

          test('then the client project has a protocol client file', () {
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

          test('then the .github directory has tests workflow', () {
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

          test('then the .github directory has format workflow', () {
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

          test('then the .github directory has analyze workflow', () {
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

          test('then the .vscode directory has launch.json', () {
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

          test(
            'then the .vscode launch.json does not have flutter configuration',
            () {
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
                isFalse,
                reason: 'launch.json contains flutter configuration.',
              );
            },
          );

          test(
            'then the .vscode launch.json has server configuration',
            () {
              final launchJson = File(
                path.join(
                  tempPath,
                  projectName,
                  '.vscode',
                  'launch.json',
                ),
              ).readAsStringSync();

              expect(
                launchJson.contains('"${projectName}_server"'),
                isTrue,
                reason: 'launch.json does not contain server configuration.',
              );
            },
          );

          test(
            'then the .vscode launch.json does not have compound configuration for full stack',
            () {
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
                isFalse,
                reason: 'launch.json contains compounds section.',
              );

              expect(
                launchJson.contains('"${projectName} (full stack)"'),
                isFalse,
                reason:
                    'launch.json contains full stack compound configuration.',
              );
            },
          );
        },
      );
    },
  );

  group(
    'Given a created project with the server template and a running pod',
    () {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      late Process createProcess;
      late Process startProjectProcess;

      setUpAll(() async {
        createProcess = await startServerpodCli(
          [
            'create',
            projectName,
            '--template',
            'server',
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
        'when requesting the static website under / then it is is served',
        () async {
          final response = await http.get(Uri.parse('http://localhost:8082'));
          expect(response.statusCode, equals(200));
          expect(
            response.body,
            contains('<title>Built with Serverpod</title>'),
          );
          expect(response.body, isNot(contains('Open Flutter app')));
        },
      );
    },
    skip: Platform.isWindows
        ? 'Windows does not support postgres in github actions'
        : null,
  );
}
