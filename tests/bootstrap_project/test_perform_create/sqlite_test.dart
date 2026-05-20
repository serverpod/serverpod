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
    'Given a TemplateContext with sqlite enabled, '
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
            sqlite: true,
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
        'then the server test config file contains sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${projectName}_test.db'));
        },
      );

      test(
        'then the server development config file contains sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'development.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${projectName}_dev.db'));
        },
      );

      test(
        'then the server staging config file contains sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'staging.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${projectName}_staging.db'));
        },
      );

      test(
        'then the server production config file contains sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'production.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${projectName}_prod.db'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with sqlite disabled, '
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
            sqlite: false,
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
        'then the server test config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server development config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'development.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server staging config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'staging.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server production config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'production.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with sqlite enabled, '
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
            sqlite: true,
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
        'then the server test config file contains sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${projectName}_test.db'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with sqlite disabled, '
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
            sqlite: false,
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
        'then the server test config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );
    },
  );
}
