import 'dart:io';

import 'package:serverpod_cli/src/migrations/client_side/client_migration_artifact_store.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  late ClientMigrationArtifactStore artifactStore;

  setUp(() {
    artifactStore = ClientMigrationArtifactStore(
      clientPackageRoot: Directory(d.sandbox),
    );
  });

  test(
    'Given client migration artifacts, '
    'when writing the migration version and registry, '
    'then Dart migration files are generated for runtime use.',
    () async {
      const version = '20240101000000000';
      final emptyDefinition = DatabaseDefinition(
        moduleName: 'example_project',
        tables: [],
        installedModules: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );

      await artifactStore.writeVersion(
        MigrationVersionArtifacts(
          version: version,
          definitionSql: 'CREATE TABLE example (id INTEGER PRIMARY KEY);',
          migrationSql: 'ALTER TABLE example ADD COLUMN name TEXT;',
          definition: emptyDefinition,
          projectDefinition: emptyDefinition,
          migration: DatabaseMigration(
            actions: [],
            warnings: [],
            migrationApiVersion: DatabaseConstants.migrationApiVersion,
          ),
        ),
      );
      await artifactStore.writeVersionRegistry([version]);

      await d.dir('lib', [
        d.dir('migrations', [
          d.file(
            'migration_registry.dart',
            allOf(
              contains('library;'),
              contains("part '$version/migration.dart';"),
              contains('_Migration$version()'),
            ),
          ),
          d.dir(version, [
            d.file(
              'migration.dart',
              allOf(
                contains("part of '../migration_registry.dart';"),
                contains(
                  'class _Migration$version implements MigrationVersionSql',
                ),
                contains("String get moduleName => 'example_project';"),
              ),
            ),
          ]),
        ]),
      ]).validate();
    },
  );

  test(
    'Given a first client migration is written, '
    'when a second migration is written and the registry is updated, '
    'then migration_registry.dart contains both versions.',
    () async {
      const v1 = '20240101000000000';
      const v2 = '20240201000000000';
      final emptyDefinition = DatabaseDefinition(
        moduleName: 'example_project',
        tables: [],
        installedModules: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );
      final emptyMigration = DatabaseMigration(
        actions: [],
        warnings: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );

      Future<void> writeClientMigration(String version) async {
        await artifactStore.writeVersion(
          MigrationVersionArtifacts(
            version: version,
            definitionSql: 'CREATE TABLE example (id INTEGER PRIMARY KEY);',
            migrationSql: 'ALTER TABLE example ADD COLUMN name TEXT;',
            definition: emptyDefinition,
            projectDefinition: emptyDefinition,
            migration: emptyMigration,
          ),
        );
      }

      await writeClientMigration(v1);
      await artifactStore.writeVersionRegistry([v1]);

      await writeClientMigration(v2);
      await artifactStore.writeVersionRegistry([v1, v2]);

      await d.dir('lib', [
        d.dir('migrations', [
          d.file(
            'migration_registry.dart',
            allOf(
              contains("part '$v1/migration.dart';"),
              contains("part '$v2/migration.dart';"),
              contains('_Migration$v1()'),
              contains('_Migration$v2()'),
              predicate<String>(
                (contents) =>
                    RegExp(
                      r"part '[^']+/migration\.dart';",
                    ).allMatches(contents).length ==
                    2,
                'declares one part per migration version',
              ),
            ),
          ),
        ]),
      ]).validate();
    },
  );

  group(
    'Given a client migration artifact store without a migration registry and '
    'where the last migration version directory is empty,',
    () {
      setUp(() async {
        await d.dir('lib', [
          d.dir('migrations', [
            d.dir('10000000000000', [d.file('migration.dart', '')]),
            d.dir('20000000000000'),
          ]),
        ]).create();
      });

      group('when listing migration versions,', () {
        late List<String> versions;

        setUp(() async {
          versions = await artifactStore.listVersions();
        });

        test('then the empty trailing migration version is not listed.', () {
          expect(versions, ['10000000000000']);
        });

        test(
          'then the empty trailing migration version directory is deleted.',
          () async {
            await d.dir('lib', [
              d.dir('migrations', [d.nothing('20000000000000')]),
            ]).validate();
          },
        );

        test('then no migration registry is created.', () async {
          await d.dir('lib', [
            d.dir('migrations', [d.nothing('migration_registry.dart')]),
          ]).validate();
        });
      });
    },
  );

  group(
    'Given a client migration artifact store where the last migration version '
    'directory is empty,',
    () {
      setUp(() async {
        await d.dir('lib', [
          d.dir('migrations', [
            d.dir('10000000000000', [d.file('migration.dart', '')]),
            d.dir('20000000000000'),
          ]),
        ]).create();

        await artifactStore.writeVersionRegistry([
          '10000000000000',
          '20000000000000',
        ]);
      });

      group('when listing migration versions,', () {
        late List<String> versions;

        setUp(() async {
          versions = await artifactStore.listVersions();
        });

        test('then the empty trailing migration version is not listed.', () {
          expect(versions, ['10000000000000']);
        });

        test(
          'then the empty trailing migration version directory is deleted.',
          () async {
            await d.dir('lib', [
              d.dir('migrations', [d.nothing('20000000000000')]),
            ]).validate();
          },
        );

        test(
          'then the migration registry no longer references the empty '
          'trailing migration version.',
          () async {
            await d.dir('lib', [
              d.dir('migrations', [
                d.file(
                  'migration_registry.dart',
                  allOf(
                    contains("part '10000000000000/migration.dart';"),
                    isNot(contains('20000000000000')),
                  ),
                ),
              ]),
            ]).validate();
          },
        );
      });
    },
  );
}
