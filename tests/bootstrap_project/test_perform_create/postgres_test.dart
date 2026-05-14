import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'util.dart';

void main() {
  final rootPath = p.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group(
    'Given a TemplateContext with postgres enabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          false,
          interactive: false,
          context: TemplateContext(postgres: true),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      test(
        'then the server Dockerfile file is created',
        () async {
          final file = File(p.join(serverDir, 'Dockerfile'));
          await expectLater(file.exists(), completion(true));
        },
      );

      group(
        'then the server docker-compose file',
        () {
          late File dockerComposeFile;

          setUp(() {
            dockerComposeFile = File(p.join(serverDir, 'docker-compose.yaml'));
          });

          test('is created', () async {
            await expectLater(dockerComposeFile.exists(), completion(true));
          });

          test(
            'contains postgres configurations',
            () async {
              final content = await dockerComposeFile.readAsString();
              expect(content, contains('postgres:'));
              expect(content, contains('postgres_test:'));
              expect(content, contains('volumes:'));
            },
          );
        },
      );

      group(
        'then the server passwords config file',
        () {
          late File config;

          setUp(() {
            config = File(p.join(serverDir, 'config', 'passwords.yaml'));
          });

          test('is created', () async {
            await expectLater(config.exists(), completion(true));
          });

          test(
            'contains postgres configurations',
            () async {
              final content = await config.readAsString();
              expect(content, contains('database:'));
            },
          );
        },
      );

      test(
        'then the server config for development contains postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'development.yaml'));
          final content = await config.readAsString();
          expect(content, contains('user: postgres'));
        },
      );

      test(
        'then the server config for staging contains postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'staging.yaml'));
          final content = await config.readAsString();
          expect(content, contains('user: postgres'));
        },
      );

      test(
        'then the server config for production contains postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'production.yaml'));
          final content = await config.readAsString();
          expect(content, contains('user: postgres'));
        },
      );

      test(
        'then the server config for test contains postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await config.readAsString();
          expect(content, contains('user: postgres'));
        },
      );

      test(
        'then the vscode tasks.json file is created',
        () async {
          final file = File(p.join(projectName, '.vscode', 'tasks.json'));
          await expectLater(file.exists(), completion(true));
        },
      );

      group(
        'then the vscode launch.json file',
        () {
          late String launchJson;

          setUp(() async {
            final file = File(p.join(projectName, '.vscode', 'launch.json'));
            launchJson = await file.readAsString();
          });

          test(
            'has prelaunch task',
            () async {
              expect(
                launchJson,
                contains('"preLaunchTask": "docker_compose_up"'),
              );
            },
          );

          test(
            'has database password environment variable',
            () async {
              expect(launchJson, contains('"SERVERPOD_PASSWORD_database":'));
            },
          );

          test(
            'has apply migration command',
            () async {
              expect(launchJson, contains('"--apply-migrations"'));
            },
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with postgres disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          false,
          interactive: false,
          context: TemplateContext(postgres: false),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      group(
        'then the server passwords config file',
        () {
          late File config;

          setUp(() {
            config = File(p.join(serverDir, 'config', 'passwords.yaml'));
          });

          test('is created', () async {
            await expectLater(config.exists(), completion(true));
          });

          test(
            'does not contain postgres configurations',
            () async {
              final content = await config.readAsString();
              expect(content, isNot(contains('database:')));
            },
          );
        },
      );

      test(
        'then the server config for development does not contain postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'development.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('user: postgres')));
        },
      );

      test(
        'then the server config for staging does not contain postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'staging.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('user: postgres')));
        },
      );

      test(
        'then the server config for production does not contain postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'production.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('user: postgres')));
        },
      );

      test(
        'then the server config for test does not contain postgres configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('user: postgres')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with postgres enabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          ServerpodTemplateType.module,
          false,
          interactive: false,
          context: TemplateContext(postgres: true),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      group(
        'then the server docker-compose file',
        () {
          late File dockerComposeFile;

          setUp(() {
            dockerComposeFile = File(
              p.join(serverDir, 'docker-compose.yaml'),
            );
          });

          test('is created', () async {
            await expectLater(dockerComposeFile.exists(), completion(true));
          });

          test(
            'contains postgres configurations',
            () async {
              final content = await dockerComposeFile.readAsString();
              expect(content, contains('postgres_test:'));
              expect(content, contains('volumes:'));
            },
          );
        },
      );

      group(
        'then the server passwords config file',
        () {
          late File config;

          setUp(() {
            config = File(p.join(serverDir, 'config', 'passwords.yaml'));
          });

          test('is created', () async {
            await expectLater(config.exists(), completion(true));
          });

          test(
            'contains postgres configurations',
            () async {
              final content = await config.readAsString();
              expect(content, contains('database:'));
            },
          );
        },
      );
      group(
        'then the server config for test',
        () {
          late String content;

          setUp(() async {
            final config = File(p.join(serverDir, 'config', 'test.yaml'));
            content = await config.readAsString();
          });

          test(
            'contains postgres configurations',
            () async {
              expect(content, contains('user: postgres'));
            },
          );

          test(
            'contains persistent session logging configuration',
            () async {
              expect(content, contains('persistentEnabled: true'));
            },
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with postgres disabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          ServerpodTemplateType.module,
          false,
          interactive: false,
          context: TemplateContext(postgres: false),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      group(
        'then the server config for test',
        () {
          late String content;

          setUp(() async {
            final config = File(p.join(serverDir, 'config', 'test.yaml'));
            content = await config.readAsString();
          });

          test(
            'does not contain postgres configurations',
            () async {
              expect(content, isNot(contains('user: postgres')));
            },
          );

          test(
            'does not contain persistent session logging configuration',
            () async {
              expect(content, isNot(contains('persistentEnabled: true')));
            },
          );
        },
      );
    },
  );
}
