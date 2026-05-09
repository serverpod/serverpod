import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/client_side/client_migration_artifact_store.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDirectory;
  late ClientMigrationArtifactStore artifactStore;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'client_lib_migration_artifact_store_',
    );
    artifactStore = ClientMigrationArtifactStore(
      clientPackageRoot: tempDirectory,
    );
  });

  tearDown(() async {
    if (tempDirectory.existsSync()) {
      await tempDirectory.delete(recursive: true);
    }
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

      final registryContents = await File(
        path.join(
          tempDirectory.path,
          'lib',
          'migrations',
          'migration_registry.dart',
        ),
      ).readAsString();
      final migrationPartContents = await File(
        path.join(
          tempDirectory.path,
          'lib',
          'migrations',
          version,
          'migration.dart',
        ),
      ).readAsString();

      expect(registryContents, contains('library;'));
      expect(
        registryContents,
        contains("part '$version/migration.dart';"),
      );
      expect(
        registryContents,
        contains('_Migration$version()'),
      );

      expect(
        migrationPartContents,
        contains("part of '../migration_registry.dart';"),
      );
      expect(
        migrationPartContents,
        contains(
          'class _Migration$version implements MigrationVersionSql',
        ),
      );
      expect(
        migrationPartContents,
        contains("String get moduleName => 'example_project';"),
      );
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

      final registryContents = await File(
        path.join(
          tempDirectory.path,
          'lib',
          'migrations',
          'migration_registry.dart',
        ),
      ).readAsString();

      expect(
        RegExp(
          r"part '[^']+/migration\.dart';",
        ).allMatches(registryContents).length,
        2,
        reason: 'registry should declare one part per migration version',
      );
      expect(registryContents, contains("part '$v1/migration.dart';"));
      expect(registryContents, contains("part '$v2/migration.dart';"));
      expect(registryContents, contains('_Migration$v1()'));
      expect(registryContents, contains('_Migration$v2()'));
    },
  );
}
