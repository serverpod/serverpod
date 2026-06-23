import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

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
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          sqlite: true,
        ),
      );

      test(
        'then the server test config file contains sqlite configurations',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${project.name}_test.db'));
        },
      );

      test(
        'then the server development config file contains sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await file.readAsString();
          expect(content, contains('filePath: ${project.name}_dev.db'));
        },
      );

      test(
        'then the server staging config file contains sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await file.readAsString();
          expect(content, contains('filePath: ${project.name}_staging.db'));
        },
      );

      test(
        'then the server production config file contains sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
          final content = await file.readAsString();
          expect(content, contains('filePath: ${project.name}_prod.db'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with sqlite disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          sqlite: false,
        ),
      );

      test(
        'then the server test config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server development config file does not contain sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server staging config file does not contain sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );

      test(
        'then the server production config file does not contain sqlite configurations',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
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
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          sqlite: true,
        ),
      );

      test(
        'then the server test config file contains sqlite configurations',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, contains('filePath: ${project.name}_test.db'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with sqlite disabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          sqlite: false,
        ),
      );

      test(
        'then the server test config file does not contain sqlite configurations',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('filePath:')));
        },
      );
    },
  );
}
