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
        'when creating a new server project with database enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with database disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
              options: ['--no-database'],
            );
          });

          test('then the project contains no database configurations', () {
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
        'when creating a new server project with database disabled and authentication enabled',
        () {
          late ({String projectName, String commandRoot}) project;
          late ProcessResult createResult;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            createResult = await runServerpodCli(
              [
                'create',
                project.projectName,
                '--template',
                'server',
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
                path.join(
                  tempPath,
                  project.projectName,
                ),
              ).existsSync(),
              isFalse,
            );
          });
        },
      );

      group(
        'when creating a new server project with Redis enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with Redis disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with database and auth enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with auth disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with website enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with website disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with webapp enabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project with webapp disabled',
        () {
          late ({String projectName, String commandRoot}) project;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
        'when creating a new server project without specifying IDEs',
        () {
          late ({String projectName, String commandRoot}) project;
          late String projectRoot;

          setUpAll(() async {
            project = createRandomProjectName(tempPath);
            projectRoot = path.join(tempPath, project.projectName);
            await createProject(
              rootPath: rootPath,
              tempPath: tempPath,
              projectName: project.projectName,
              template: 'server',
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
    },
  );
}
