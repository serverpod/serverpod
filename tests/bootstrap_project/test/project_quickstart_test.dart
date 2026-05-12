@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp';

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
      var (commandRoot: _, :projectName) = createRandomProjectName(tempPath);
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      group(
        'when creating a new project with quickstart command',
        () {
          setUpAll(() async {
            var process = await startServerpodCli(
              [
                'quickstart',
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
                  File(
                    path.join(tempPath, serverDir, 'pubspec.yaml'),
                  ).existsSync(),
                  isTrue,
                );
              });

              test('has a .gitignore file', () {
                expect(
                  File(
                    path.join(tempPath, serverDir, '.gitignore'),
                  ).existsSync(),
                  isTrue,
                );
              });

              test('has a server.dart file', () {
                expect(
                  File(
                    path.join(tempPath, serverDir, 'lib', 'server.dart'),
                  ).existsSync(),
                  isTrue,
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
                );
              });

              test(
                'has a web/app directory containing the flutter web app',
                () {
                  expect(
                    Directory(
                      path.join(tempPath, serverDir, 'web', 'app'),
                    ).existsSync(),
                    isTrue,
                  );
                  expect(
                    File(
                      path.join(
                        tempPath,
                        serverDir,
                        'web',
                        'app',
                        'index.html',
                      ),
                    ).existsSync(),
                    isTrue,
                  );
                },
              );

              test(
                'has sqlite configurations',
                () {
                  final devConfigFile = File(
                    path.join(
                      tempPath,
                      serverDir,
                      'config',
                      'development.yaml',
                    ),
                  );

                  expect(
                    devConfigFile.readAsStringSync(),
                    contains('filePath:'),
                  );

                  final prodConfigFile = File(
                    path.join(tempPath, serverDir, 'config', 'production.yaml'),
                  );

                  expect(
                    prodConfigFile.readAsStringSync(),
                    contains('filePath:'),
                  );

                  final stagingConfigFile = File(
                    path.join(tempPath, serverDir, 'config', 'staging.yaml'),
                  );

                  expect(
                    stagingConfigFile.readAsStringSync(),
                    contains('filePath:'),
                  );

                  final testConfigFile = File(
                    path.join(tempPath, serverDir, 'config', 'test.yaml'),
                  );

                  expect(
                    testConfigFile.readAsStringSync(),
                    contains('filePath:'),
                  );
                },
              );
            },
          );

          group(
            'then the flutter project',
            () {
              test('folder is created', () {
                expect(
                  Directory(path.join(tempPath, flutterDir)).existsSync(),
                  isTrue,
                );
              });

              test('has a pubspec file', () {
                expect(
                  File(
                    path.join(tempPath, flutterDir, 'pubspec.yaml'),
                  ).existsSync(),
                  isTrue,
                );
              });

              test('has a main file', () {
                expect(
                  File(
                    path.join(tempPath, flutterDir, 'lib', 'main.dart'),
                  ).existsSync(),
                  isTrue,
                );
              });
            },
          );

          group('then the client project', () {
            test('folder is created', () {
              expect(
                Directory(path.join(tempPath, clientDir)).existsSync(),
                isTrue,
              );
            });

            test('has a pubspec file', () {
              expect(
                File(
                  path.join(tempPath, clientDir, 'pubspec.yaml'),
                ).existsSync(),
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
          });

          group('then the workspace', () {
            test('has a root pubspec.yaml file', () {
              expect(
                File(
                  path.join(tempPath, projectName, 'pubspec.yaml'),
                ).existsSync(),
                isTrue,
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

            test('flutter pubspec.yaml has resolution: workspace', () {
              final content = File(
                path.join(tempPath, flutterDir, 'pubspec.yaml'),
              ).readAsStringSync();
              expect(content, contains('resolution: workspace'));
            });

            test('root has pubspec.lock file', () {
              expect(
                File(
                  path.join(tempPath, projectName, 'pubspec.lock'),
                ).existsSync(),
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
              );
            });
          });

          group(
            'then the .vscode directory',
            () {
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
                );
              });

              group(
                'then launch.json',
                () {
                  late String launchJson;

                  setUp(() async {
                    final file = File(
                      path.join(
                        tempPath,
                        projectName,
                        '.vscode',
                        'launch.json',
                      ),
                    );

                    launchJson = await file.readAsString();
                  });

                  test('has flutter configuration as first entry', () {
                    expect(
                      launchJson.contains('"${projectName}_flutter"'),
                      isTrue,
                    );

                    final flutterIndex = launchJson.indexOf(
                      '"${projectName}_flutter"',
                    );
                    final serverIndex = launchJson.indexOf(
                      '"${projectName}_server"',
                    );

                    expect(flutterIndex, lessThan(serverIndex));
                  });

                  test('has compound configuration for full stack', () {
                    expect(launchJson, contains('"compounds"'));
                    expect(
                      launchJson,
                      contains('"${projectName} (full stack)"'),
                    );
                  });

                  test('does not have preLaunchTask', () {
                    expect(
                      launchJson,
                      isNot(contains('"preLaunchTask": "docker_compose_up"')),
                    );
                  });

                  test(
                    'does not have SERVERPOD_PASSWORD_database environment variable',
                    () {
                      expect(
                        launchJson,
                        isNot(contains('"SERVERPOD_PASSWORD_database":')),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
