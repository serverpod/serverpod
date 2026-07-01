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
    'Given a TemplateContext with redis disabled and no database option enabled, '
    'when performCreate is called with the context and a fullstack template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          postgres: false,
          redis: false,
          sqlite: false,
        ),
      );

      test(
        'then the server docker-compose file is not created',
        () async {
          final file = File(p.join(project.serverDir, 'docker-compose.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the server config for development does not contain database configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('database:')));
        },
      );

      test(
        'then the server config for staging does not contain database configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('database:')));
        },
      );

      test(
        'then the server config for production does not contain database configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('database:')));
        },
      );

      test(
        'then the server config for test does not contain database configurations',
        () async {
          final config = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await config.readAsString();
          expect(content, isNot(contains('database:')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with redis disabled and no database option enabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          postgres: false,
          redis: false,
          sqlite: false,
        ),
      );

      test(
        'then the server docker-compose file is not created',
        () async {
          final file = File(p.join(project.serverDir, 'docker-compose.yaml'));
          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the server passwords config file is not created',
        () async {
          final file = File(
            p.join(
              project.serverDir,
              'config'
              'passwords.yaml',
            ),
          );
          await expectLater(file.exists(), completion(false));
        },
      );

      group(
        'then the server config for test',
        () {
          late File config;

          setUp(() {
            config = File(p.join(project.serverDir, 'config', 'test.yaml'));
          });

          test(
            'does not contain database configurations',
            () async {
              final content = await config.readAsString();
              expect(content, isNot(contains('database:')));
            },
          );
        },
      );
    },
  );
}
