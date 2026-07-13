import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/runner.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
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
    'Given a project without a database, '
    'when creating CreateConfigState in the upgrade path for the TUI',
    () {
      late CreateConfigStateResult result;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.mini,
          auth: true,
          redis: true,
          postgres: true,
          webapp: true,
          ides: [TemplateIde.claude, TemplateIde.cursor, TemplateIde.vscode],
        ),
      );

      setUpAll(() async {
        result = await getCreateConfigState(
          name: '.',
          force: false,
          template: ServerpodTemplateType.fullstack,
          interactive: false,
          configs: ServerpodCreateConfig.values,
          workingDirectory: Directory(project.projectRoot),
        );
      });

      test(
        'then CreateConfigState contains all configs except template config',
        () {
          final configs = [...ServerpodCreateConfig.values];
          configs.removeWhere(
            (config) => config == ServerpodCreateConfig.template,
          );

          expect(
            result.state.configs,
            isNot(contains(ServerpodCreateConfig.template)),
          );

          expect(result.state.configs, containsAll(configs));
        },
      );

      test('then the result indicates upgrade is true', () {
        expect(result.isUpgrade, isTrue);
      });

      test('then default migration can be created', () {
        expect(result.createDefaultMigrationForUpgrade, isTrue);
      });
    },
  );

  group(
    'Given a server project without IDE configurations, '
    'when creating CreateConfigState in the upgrade path for the TUI',
    () {
      late CreateConfigStateResult result;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          auth: true,
          redis: true,
          postgres: true,
          webapp: true,
          ides: [],
        ),
      );

      setUpAll(() async {
        result = await getCreateConfigState(
          name: '.',
          force: false,
          template: ServerpodTemplateType.fullstack,
          interactive: false,
          configs: ServerpodCreateConfig.values,
          workingDirectory: Directory(project.projectRoot),
        );
      });

      test(
        'then CreateConfigState contains only IDE config',
        () {
          expect(result.state.configs, [ServerpodCreateConfig.ide]);
        },
      );

      test(
        'then CreateConfigState requires IDE selection',
        () {
          expect(result.state.requireIde, isTrue);
        },
      );

      test('then the result indicates upgrade is true', () {
        expect(result.isUpgrade, isTrue);
      });

      test(
        'then default migration can not be created',
        () {
          expect(result.createDefaultMigrationForUpgrade, isFalse);
        },
      );
    },
  );
}
