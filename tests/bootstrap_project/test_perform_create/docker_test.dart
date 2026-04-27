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
    'Given a TemplateContext with postgres and redis disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        final context = TemplateContext(redis: false, postgres: false);

        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          false,
          interactive: false,
          context: context,
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
        'then the server docker-compose file is not created',
        () async {
          final file = File(p.join(serverDir, 'docker-compose.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the server Dockerfile file is not created',
        () async {
          final file = File(p.join(serverDir, 'Dockerfile'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the vscode tasks.json file is not created',
        () async {
          final file = File(p.join(projectName, '.vscode', 'tasks.json'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the vscode launch.json file does not have prelaunch task',
        () async {
          final file = File(p.join(projectName, '.vscode', 'launch.json'));
          final content = await file.readAsString();
          expect(
            content,
            isNot(contains('"preLaunchTask": "docker_compose_up"')),
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with postgres and redis disabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        final context = TemplateContext(redis: false, postgres: false);

        await performCreate(
          projectName,
          ServerpodTemplateType.module,
          false,
          interactive: false,
          context: context,
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
        'then the server passwords config file is not created',
        () async {
          final file = File(p.join(serverDir, 'config', 'passwords.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the server docker-compose file is not created',
        () async {
          final file = File(p.join(serverDir, 'docker-compose.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );
    },
  );
}
