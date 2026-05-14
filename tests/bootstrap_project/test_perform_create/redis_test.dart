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
    'Given a TemplateContext with redis enabled, '
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
          context: TemplateContext(redis: true),
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
            'contains redis configurations',
            () async {
              final content = await dockerComposeFile.readAsString();
              expect(content, contains('redis:'));
              expect(content, contains('redis_test:'));
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
            'contains redis configurations',
            () async {
              final content = await config.readAsString();
              expect(content, contains('redis:'));
            },
          );
        },
      );

      test(
        'then the vscode tasks.json file is created',
        () async {
          final file = File(p.join(projectName, '.vscode', 'tasks.json'));
          await expectLater(file.exists(), completion(true));
        },
      );

      test(
        'then the vscode launch.json file has prelaunch task',
        () async {
          final file = File(p.join(projectName, '.vscode', 'launch.json'));
          final content = await file.readAsString();
          expect(content, contains('"preLaunchTask": "docker_compose_up"'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with redis disabled, '
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
          context: TemplateContext(redis: false),
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
        'then the server passwords config file does not contain redis configurations',
        () async {
          final config = File(p.join(serverDir, 'config', 'passwords.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('redis:')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with redis enabled, '
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
          context: TemplateContext(redis: true),
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

          test('contains redis configurations', () async {
            final content = await config.readAsString();
            expect(content, contains('redis:'));
          });
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

          test('contains redis configurations', () async {
            final content = await dockerComposeFile.readAsString();
            expect(content, contains('redis_test:'));
          });
        },
      );
    },
  );

  group(
    'Given a TemplateContext with redis disabled, '
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
          context: TemplateContext(redis: false),
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
        'then the server config for test does not contain redis configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('redis:')));
        },
      );
    },
  );
}
