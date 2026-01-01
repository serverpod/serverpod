@Timeout(Duration(minutes: 10))
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';

void main() {
  late String projectName;
  late String serverDir;
  late Directory migrationsDir;

  Future<void> createProject() async {
    projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var result = await runServerpod(
      ['create', projectName],
      workingDirectory: d.sandbox,
    );
    expect(
      result.exitCode,
      0,
      reason: 'Failed to create project: ${result.stderr}',
    );
    serverDir = path.join(d.sandbox, projectName, '${projectName}_server');
    migrationsDir = Directory(path.join(serverDir, 'migrations'));
  }

  Future<void> writeModel(String name, List<String> fields) async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var className = name
        .split('_')
        .map((e) => e.isEmpty ? '' : e[0].toUpperCase() + e.substring(1))
        .join('');
    var tableName = '${name}_$timestamp';

    var content =
        '''
class: $className
table: $tableName
fields:
''';
    for (var field in fields) {
      content += '  $field\n';
    }

    final modelFile = File(
      path.join(serverDir, 'lib', 'src', 'protocol', '$name.yaml'),
    );
    modelFile.parent.createSync(recursive: true);
    modelFile.writeAsStringSync(content);
  }

  Future<ProcessResult> createMigration([List<String> args = const []]) async {
    // Pause to ensure migrations are created in the correct order
    await Future.delayed(const Duration(milliseconds: 2));

    return await runServerpod([
      'create-migration',
      ...args,
    ], workingDirectory: serverDir);
  }

  Future<ProcessResult> rebaseMigration([List<String> args = const []]) async {
    return await runServerpod([
      'rebase-migration',
      ...args,
    ], workingDirectory: serverDir);
  }

  List<String> getMigrationNames() {
    if (!migrationsDir.existsSync()) return [];
    return migrationsDir
        .listSync()
        .whereType<Directory>()
        .map((d) => path.basename(d.path))
        .where((name) => !name.startsWith('.'))
        .toList()
      ..sort();
  }

  /// Copies the incoming migration to the migrations directory.
  Future<String?> copyIncomingMigration(int version) async {
    final incomingDir = Directory(
      path.join(
        Directory.current.path,
        'test',
        'test_migrations',
        'incoming_$version',
      ),
    );
    if (!incomingDir.existsSync()) return null;
    if (!migrationsDir.existsSync()) return null;

    final migrationVersion = MigrationGenerator.createVersionName(null);
    final migrationDir = Directory(
      path.join(migrationsDir.path, migrationVersion),
    );
    migrationDir.createSync(recursive: true);
    incomingDir.listSync().forEach((file) {
      if (file is! File) return;
      File(path.join(migrationDir.path, path.basename(file.path)))
        ..writeAsBytesSync(file.readAsBytesSync());
    });
    return migrationVersion;
  }

  setUp(() async {
    await createProject();
  });

  group('Rebase Migration', () {
    group('Given --onto specified', () {
      test(
        'when there are local migrations then migrations are collapsed into one',
        () async {
          final previousMigrations = getMigrationNames();

          // 1. First migration (v1) - our base
          await writeModel(
            'example',
            ['name: String'],
          );
          await createMigration();
          final v1 = getMigrationNames().last;

          // 2. Second migration (v2)
          await writeModel(
            'other',
            ['name: String', 'age: int'],
          );
          await createMigration();
          final v2 = getMigrationNames().last;

          // 3. Third migration (v3)
          await writeModel(
            'third',
            ['name: String'],
          );
          await createMigration();
          final v3 = getMigrationNames().last;

          expect(getMigrationNames().length, previousMigrations.length + 3);

          // 4. Rebase onto v1 (should collapse v2 and v3 into one)
          final result = await rebaseMigration([
            '--onto',
            v1,
          ]);
          expect(result.exitCode, 0, reason: 'Rebase migration should succeed');

          // 5. Verify state
          final postRebaseMigrations = getMigrationNames();

          // Should have the previous migrations, v1, and exactly one new migration
          expect(postRebaseMigrations.length, previousMigrations.length + 2);
          final testMigrations = postRebaseMigrations.whereNot(
            previousMigrations.contains,
          );
          expect(testMigrations.length, 2);
          expect(testMigrations.first, v1);
          expect(testMigrations.last, isNot(v2));
          expect(testMigrations.last, isNot(v3));

          // Verify registry
          final registryFile = File(
            path.join(serverDir, 'migrations', 'migration_registry.txt'),
          );
          final registryContent = registryFile.readAsStringSync();
          expect(registryContent, contains(v1));
          expect(registryContent, contains(testMigrations.last));
          expect(registryContent, isNot(contains(v2)));
          expect(registryContent, isNot(contains(v3)));
        },
      );

      test(
        'when a tag is specified then the new migration has the specified tag',
        () async {
          final previousMigrations = getMigrationNames();

          // 1. First migration (v1)
          await writeModel(
            'example',
            ['name: String'],
          );
          await createMigration();
          final v1 = getMigrationNames().last;

          // 2. Second migration (v2)
          await writeModel(
            'other',
            ['name: String'],
          );
          await createMigration();

          // 3. Rebase onto v1 with tag
          const tag = 'my-custom-tag';
          final result = await rebaseMigration(['--onto', v1, '--tag', tag]);
          expect(result.exitCode, 0);

          // 4. Verify tag
          final postRebaseMigrations = getMigrationNames();
          final testMigrations = postRebaseMigrations.whereNot(
            previousMigrations.contains,
          );
          expect(testMigrations.last, contains('-$tag'));
        },
      );

      test(
        'when rebasing onto a specific intermediate migration then migrations after it are collapsed',
        () async {
          final previousMigrations = getMigrationNames();

          // 1. v1
          await writeModel(
            'example',
            ['name: String'],
          );
          await createMigration();
          final v1 = getMigrationNames().last;

          // 2. v2 (intermediate)
          await writeModel(
            'other',
            ['name: String'],
          );
          await createMigration();
          final v2 = getMigrationNames().last;

          // 3. v3 (to be collapsed)
          await writeModel(
            'third',
            ['name: String'],
          );
          await createMigration();
          final v3 = getMigrationNames().last;

          // 4. v4 (to be collapsed)
          await writeModel(
            'fourth',
            ['name: String'],
          );
          await createMigration();
          final v4 = getMigrationNames().last;

          expect(getMigrationNames().length, previousMigrations.length + 4);

          // Rebase onto v2
          final result = await rebaseMigration(['--onto', v2]);
          expect(result.exitCode, 0);

          final postRebaseMigrations = getMigrationNames();
          expect(postRebaseMigrations, contains(v1));
          expect(postRebaseMigrations, contains(v2));
          expect(postRebaseMigrations, isNot(contains(v3)));
          expect(postRebaseMigrations, isNot(contains(v4)));
          // Should have previous, v1, v2, and one new one.
          expect(postRebaseMigrations.length, previousMigrations.length + 3);
        },
      );

      group('and --check flag', () {
        test(
          'when there is exactly one migration since base then exit code is 0',
          () async {
            // 1. First migration (v1)
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // 2. Second migration (v2)
            await writeModel(
              'other',
              ['name: String'],
            );
            await createMigration();

            // 3. Run rebase-migration --check --onto v1
            final result = await rebaseMigration([
              '--check',
              '--onto',
              v1,
            ]);
            expect(result.exitCode, 0);
            expect(
              result.stdout,
              contains(
                'There is only one migration after the base migration',
              ),
            );
          },
        );

        test(
          'when there are multiple migrations since base then exit code is 1',
          () async {
            // 1. First migration (v1)
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // Pause to ensure v1 is created before v2
            await Future.delayed(const Duration(milliseconds: 2));

            // 2. Second migration (v2)
            await writeModel(
              'other',
              ['name: String'],
            );
            await createMigration();

            // Pause to ensure v1 is created before v2
            await Future.delayed(const Duration(milliseconds: 2));

            // 3. Third migration (v3)
            await writeModel(
              'third',
              ['name: String'],
            );
            await createMigration();

            // Pause to ensure v2 is created before v3
            await Future.delayed(const Duration(milliseconds: 2));

            // 4. Run rebase-migration --check --onto v1
            final result = await rebaseMigration([
              '--check',
              '--onto',
              v1,
            ]);
            expect(result.exitCode, 1);
            expect(
              result.stdout,
              contains(
                'There is more than one migration after the base migration',
              ),
            );
          },
        );
      });
    });

    group(
      'Given a conflict in registry',
      () {
        test(
          'when rebasing then rebase onto the incoming migration',
          () async {
            final previousMigrations = getMigrationNames();

            // v1
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // v2 (local)
            await writeModel(
              'other',
              ['name: String'],
            );
            await createMigration();
            final v2 = getMigrationNames().last;

            // v3 (simulated incoming)
            const incomingVersion = 1;
            final v3 = await copyIncomingMigration(incomingVersion);
            expect(
              v3,
              isNotNull,
              reason: 'Failed to copy incoming migration: $incomingVersion',
            );

            // Create conflict in registry
            final registryFile = File(
              path.join(serverDir, 'migrations', 'migration_registry.txt'),
            );
            registryFile.writeAsStringSync('''
${previousMigrations.join('\n')}
$v1
${MigrationRegistryFile.startMarker}
$v2
${MigrationRegistryFile.middleMarker}
$v3
${MigrationRegistryFile.endMarker} replace
''');

            // Rebase. Should pick v3 as base.
            final result = await rebaseMigration([]);
            expect(result.exitCode, 0);

            final postRebase = getMigrationNames();
            expect(postRebase, contains(v1));
            expect(postRebase, contains(v3));
            expect(postRebase, isNot(contains(v2))); // v2 is rebased
            // v1, v3, new
            expect(postRebase.length, previousMigrations.length + 3);

            // Verify registry is resolved
            final content = registryFile.readAsStringSync();
            expect(content, isNot(contains(MigrationRegistryFile.startMarker)));
            expect(content, contains(v1));
            expect(content, contains(v3));
            expect(content, isNot(contains(v2)));
          },
        );

        test(
          'when rebasing with multiple incoming migrations then rebase onto the latest incoming migration',
          () async {
            final previousMigrations = getMigrationNames();

            // v1
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // v2 (local)
            await writeModel(
              'local',
              ['name: String'],
            );
            await createMigration();
            final v2 = getMigrationNames().last;

            // v3 (incoming 1)
            await writeModel(
              'incoming1',
              ['name: String'],
            );
            await createMigration();
            final v3 = getMigrationNames().last;

            // v4 (incoming 2)
            await writeModel(
              'incoming2',
              ['name: String'],
            );
            await createMigration();
            final v4 = getMigrationNames().last;

            // Create conflict in registry
            final registryFile = File(
              path.join(serverDir, 'migrations', 'migration_registry.txt'),
            );
            registryFile.writeAsStringSync('''
$v1
${MigrationRegistryFile.startMarker}
$v2
${MigrationRegistryFile.middleMarker}
$v3
$v4
${MigrationRegistryFile.endMarker} replace
''');

            // Rebase. Should pick v4 as base.
            final result = await rebaseMigration([]);
            expect(result.exitCode, 0);

            final postRebase = getMigrationNames();
            expect(postRebase, contains(v1));
            expect(postRebase, contains(v3));
            expect(postRebase, contains(v4));
            expect(postRebase, isNot(contains(v2))); // v2 is rebased
            // v1, v3, v4, new
            expect(postRebase.length, previousMigrations.length + 4);

            final content = registryFile.readAsStringSync();
            expect(content, isNot(contains(MigrationRegistryFile.startMarker)));
            expect(content, contains(v1));
            expect(content, contains(v3));
            expect(content, contains(v4));
          },
        );
      },

      // TODO: Ensure test is working as expected
      skip: true,
    );

    group(
      'Given destructive changes',
      () {
        test(
          'when rebasing without force then it fails and rolls back',
          () async {
            final previousMigrations = getMigrationNames();

            // v1
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // v2 (destructive: remove name column)
            await writeModel(
              'example',
              [],
            ); // Removed name
            await createMigration([
              '--force',
            ]); // Create the destructive migration locally first
            final v2 = getMigrationNames().last;

            // Rebase onto v1 without force.
            final result = await rebaseMigration(['--onto', v1]);
            expect(result.exitCode, isNot(0));

            // Verify rollback
            final current = getMigrationNames();
            expect(current, contains(v2));
            expect(current.last, v2);
            expect(current.length, previousMigrations.length + 2);
          },
        );

        test(
          'when rebasing with --force then it succeeds',
          () async {
            final previousMigrations = getMigrationNames();

            // v1
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // v2 (destructive: remove name column)
            await writeModel(
              'example',
              [],
            ); // Removed name
            await createMigration([
              '--force',
            ]); // Create the destructive migration locally first
            final v2 = getMigrationNames().last;

            // Rebase onto v1 WITH force.
            final result = await rebaseMigration(['--onto', v1, '--force']);
            expect(result.exitCode, 0);

            final finalMigrations = getMigrationNames();
            expect(finalMigrations, contains(v1));
            expect(finalMigrations, isNot(contains(v2)));
            // v1 + new migration
            expect(finalMigrations.length, previousMigrations.length + 2);
          },
        );

        test(
          'when rebasing without --force then it fails and rolls back, but succeeds with force',
          () async {
            final previousMigrations = getMigrationNames();

            // v1
            await writeModel(
              'example',
              ['name: String'],
            );
            await createMigration();
            final v1 = getMigrationNames().last;

            // v2 (destructive: remove name column)
            await writeModel(
              'example',
              [],
            ); // Removed name
            await createMigration([
              '--force',
            ]); // Create the destructive migration locally first
            final v2 = getMigrationNames().last;

            // Rebase onto v1 without force.
            // The new migration will try to apply v2's changes (dropping column).
            // create-migration will see this as destructive and warn.
            // rebase should fail.
            final result = await rebaseMigration(['--onto', v1]);
            expect(result.exitCode, isNot(0));

            // Verify rollback
            final current = getMigrationNames();
            expect(current, contains(v2));
            expect(current.last, v2);
            expect(current.length, previousMigrations.length + 2);

            // Now rebase with force
            final resultForce = await rebaseMigration([
              '--onto',
              v1,
              '--force',
            ]);
            expect(resultForce.exitCode, 0);

            final finalMigrations = getMigrationNames();
            expect(finalMigrations, contains(v1));
            expect(finalMigrations, isNot(contains(v2)));
            // v1 + new migration
            expect(finalMigrations.length, previousMigrations.length + 2);
          },
        );
      },

      // TODO: Ensure test is working as expected
      skip: true,
    );
  });
}
