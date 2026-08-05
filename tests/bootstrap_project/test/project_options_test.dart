@Timeout(Duration(minutes: 15))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group(
    'Given an empty temporary workspace,',
    () {
      Directory? tempDirectory;
      late final String tempPath;

      setUpAll(() {
        tempDirectory = Directory.systemTemp.createTempSync('spb_');
        tempPath = tempDirectory!.path;
      });

      tearDownAll(() async {
        try {
          await tempDirectory?.delete(recursive: true);
        } catch (e) {}
      });

      group(
        'when creating a new project with database enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--database'],
            );
          });

          test('then the project contains database configurations', () {
            final developmentConfig = File(
              path.join(
                project.commandRoot,
                'config',
                'development.yaml',
              ),
            ).readAsStringSync();
            expect(developmentConfig, contains('database:'));
          });
        },
      );

      group(
        'when creating a new project with database disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--no-database'],
            );
          });

          test('then the project does not contain database configurations', () {
            final developmentConfig = File(
              path.join(
                project.commandRoot,
                'config',
                'development.yaml',
              ),
            ).readAsStringSync();
            expect(developmentConfig, isNot(contains('database:')));
          });
        },
      );

      group(
        'when creating a new project with database disabled and authentication enabled',
        () {
          late ({String projectName, String commandRoot}) project;
          late ProcessResult createResult;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            createResult = await runServerpodCli(
              [
                'create',
                project.projectName,
                '--no-database',
                '--auth',
                '--no-analytics',
                '--no-interactive',
              ],
              rootPath: rootPath,
              workingDirectory: tempPath,
              environment: {'SERVERPOD_HOME': rootPath},
            );
          });

          test('then an error is thrown', () {
            expect(createResult.exitCode, isNot(0));
            final output = '${createResult.stdout}\n${createResult.stderr}'
                .replaceAll(RegExp(r'\s+'), ' ');
            expect(
              output,
              contains(
                'ERROR: Authentication requires a database. '
                'Enable --database or remove --auth.',
              ),
            );
          });

          test('then the project is not created', () {
            expect(
              Directory(
                path.join(tempPath, project.projectName),
              ).existsSync(),
              isFalse,
            );
          });
        },
      );

      group(
        'when creating a new project with Redis enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--redis'],
            );
          });

          test('then the project contains Redis configurations', () {
            final developmentConfig = File(
              path.join(
                project.commandRoot,
                'config',
                'development.yaml',
              ),
            ).readAsStringSync();
            expect(developmentConfig, contains('redis:'));
          });
        },
      );

      group(
        'when creating a new project with Redis disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--no-redis'],
            );
          });

          test('then the project does not contain Redis configurations', () {
            final developmentConfig = File(
              path.join(
                project.commandRoot,
                'config',
                'development.yaml',
              ),
            ).readAsStringSync();
            expect(developmentConfig, isNot(contains('redis:')));
          });
        },
      );

      group(
        'when creating a new project with database and auth enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--database', '--auth'],
            );
          });

          test('then the project contains auth configurations', () {
            final pubspec = File(
              path.join(project.commandRoot, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(pubspec, contains('serverpod_auth_idp_server:'));
          });
        },
      );

      group(
        'when creating a new project with auth disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--no-auth'],
            );
          });

          test('then the project does not contain auth configurations', () {
            final pubspec = File(
              path.join(project.commandRoot, 'pubspec.yaml'),
            ).readAsStringSync();
            expect(pubspec, isNot(contains('serverpod_auth_idp_server:')));
          });
        },
      );

      group(
        'when creating a new project with website enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--website'],
            );
          });

          test('then the project contains website configurations', () {
            final server = File(
              path.join(
                project.commandRoot,
                'lib',
                'server.dart',
              ),
            ).readAsStringSync();
            expect(server, contains('pod.webServer.addRoute(RootRoute()'));
          });
        },
      );

      group(
        'when creating a new project with website disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--no-website'],
            );
          });

          test('then the project does not contain website configurations', () {
            final server = File(
              path.join(
                project.commandRoot,
                'lib',
                'server.dart',
              ),
            ).readAsStringSync();
            expect(server, isNot(contains('RootRoute')));
          });
        },
      );

      group(
        'when creating a new project with webapp enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--webapp'],
            );
          });

          test('then the project contains webapp configurations', () {
            final server = File(
              path.join(
                project.commandRoot,
                'lib',
                'server.dart',
              ),
            ).readAsStringSync();
            expect(server, contains('AppConfigRoute'));
          });
        },
      );

      group(
        'when creating a new project with webapp disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--no-webapp'],
            );
          });

          test('then the project does not contain webapp configurations', () {
            final server = File(
              path.join(
                project.commandRoot,
                'lib',
                'server.dart',
              ),
            ).readAsStringSync();
            expect(server, isNot(contains('AppConfigRoute')));
          });
        },
      );

      group(
        'when creating a new project without specifying IDEs',
        () {
          late String projectRoot;

          setUpAll(() async {
            final project = createRandomProjectName(tempPath);
            projectRoot = path.join(tempPath, project.projectName);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: [],
            );
          });

          test(
            'then the project is configured for Claude, Cursor, and VS Code by default.',
            () {
              expect(
                File(path.join(projectRoot, '.mcp.json')).existsSync(),
                isTrue,
              );
              expect(
                File(
                  path.join(projectRoot, '.cursor', 'mcp.json'),
                ).existsSync(),
                isTrue,
              );
              expect(
                File(
                  path.join(projectRoot, '.vscode', 'mcp.json'),
                ).existsSync(),
                isTrue,
              );
              expect(
                File(
                  path.join(projectRoot, '.codex', 'config.toml'),
                ).existsSync(),
                isFalse,
              );
            },
          );
        },
      );

      group(
        'when creating a new project with IDE configuration disabled',
        () {
          late String projectRoot;

          setUpAll(() async {
            final project = createRandomProjectName(tempPath);
            projectRoot = path.join(tempPath, project.projectName);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              options: ['--ide', 'none'],
            );
          });

          test(
            'then the project contains no installed agent skills or IDE-specific MCP configuration.',
            () {
              expect(
                Directory(
                  path.join(projectRoot, '.agents', 'skills'),
                ).existsSync(),
                isFalse,
              );
              expect(
                File(
                  path.join(projectRoot, '.codex', 'config.toml'),
                ).existsSync(),
                isFalse,
              );
              expect(
                File(path.join(projectRoot, '.mcp.json')).existsSync(),
                isFalse,
              );
              expect(
                File(
                  path.join(projectRoot, '.cursor', 'mcp.json'),
                ).existsSync(),
                isFalse,
              );
              expect(
                File(
                  path.join(projectRoot, '.vscode', 'mcp.json'),
                ).existsSync(),
                isFalse,
              );
            },
          );
        },
      );

      group(
        'when creating a new project with IDE configuration disabled and an IDE selected',
        () {
          late ({String projectName, String commandRoot}) project;
          late ProcessResult createResult;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            createResult = await runServerpodCli(
              [
                'create',
                project.projectName,
                '--ide',
                'none,codex',
                '--no-analytics',
                '--no-interactive',
              ],
              rootPath: rootPath,
              workingDirectory: tempPath,
              environment: {'SERVERPOD_HOME': rootPath},
            );
          });

          test('then an error is thrown', () {
            expect(createResult.exitCode, isNot(0));
            final output = '${createResult.stdout}\n${createResult.stderr}'
                .replaceAll(RegExp(r'\s+'), ' ');
            expect(
              output,
              contains(
                'ERROR: Invalid value for option `ide`: '
                '"none" cannot be combined with other IDE options.',
              ),
            );
          });

          test('then the project is not created', () {
            expect(
              Directory(
                path.join(tempPath, project.projectName),
              ).existsSync(),
              isFalse,
            );
          });
        },
      );
    },
  );
}
