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
          'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          false,
          interactive: false,
          context: TemplateContext(
            template: ServerpodTemplateType.server,
            postgres: true,
          ),
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
    },
  );

  group(
    'Given a TemplateContext with postgres disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final projectName =
          'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          false,
          interactive: false,
          context: TemplateContext(
            template: ServerpodTemplateType.server,
            postgres: false,
          ),
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
          'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          false,
          interactive: false,
          context: TemplateContext(
            template: ServerpodTemplateType.module,
            postgres: true,
          ),
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
          'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        await performCreate(
          projectName,
          false,
          interactive: false,
          context: TemplateContext(
            template: ServerpodTemplateType.module,
            postgres: false,
          ),
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
