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
            redis: false,
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

      test(
        'then the server docker-compose file is not created',
        () async {
          final file = File(p.join(serverDir, 'docker-compose.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with postgres and redis disabled, '
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
            redis: false,
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

  group(
    'Given a TemplateContext with postgres and redis enabled, '
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
            redis: true,
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
