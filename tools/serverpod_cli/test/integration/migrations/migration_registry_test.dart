import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = path.join(
    'test',
    'integration',
    'migrations',
    'test_assets',
  );

  group(
    'Given a migration folder with multiple migrations when loading migration registry',
    () {
      var projectDirectory = Directory(
        path.join(testAssetsPath, 'multiple_migrations'),
      );
      var moduleMigrationsDirectory = Directory(
        path.join(
          MigrationConstants.migrationsBaseDirectory(projectDirectory).path,
        ),
      );
      test(
        'when loading migration registry then migrations are listed in alphabetical sorting order',
        () {
          var migrationRegistry = MigrationRegistry.load(
            moduleMigrationsDirectory,
          );

          expect(migrationRegistry.versions, [
            '00000000000000',
            '00000000000001',
            '00000000000002',
            '00000000000002-1',
            '00000000000002-2',
            '00000000000002-a',
            '00000000000002-b',
          ]);
        },
      );
    },
  );

  group(
    'Given a migration folder with an empty migration directory',
    () {
      var projectDirectory = Directory(
        path.join(testAssetsPath, 'empty_migration'),
      );
      var moduleMigrationsDirectory = Directory(
        path.join(
          MigrationConstants.migrationsBaseDirectory(projectDirectory).path,
        ),
      );

      test(
        'when loading migration registry then empty folders are ignored.',
        () {
          var migrationRegistry = MigrationRegistry.load(
            moduleMigrationsDirectory,
          );

          expect(migrationRegistry.versions, isEmpty);
        },
      );

      test(
        'when getting latest migration then null is returned.',
        () {
          var migrationRegistry = MigrationRegistry.load(
            moduleMigrationsDirectory,
          );

          expect(migrationRegistry.getLatest(), isNull);
        },
      );
    },
  );

  group(
    'Given a migration folder with both valid and empty migration directories',
    () {
      var projectDirectory = Directory(
        path.join(testAssetsPath, 'mixed_migrations'),
      );
      var moduleMigrationsDirectory = Directory(
        path.join(
          MigrationConstants.migrationsBaseDirectory(projectDirectory).path,
        ),
      );

      test(
        'when loading migration registry then only valid migrations are listed.',
        () {
          var migrationRegistry = MigrationRegistry.load(
            moduleMigrationsDirectory,
          );

          expect(migrationRegistry.versions, ['00000000000002']);
        },
      );

      test(
        'when getting latest migration then the latest valid migration is returned.',
        () {
          var migrationRegistry = MigrationRegistry.load(
            moduleMigrationsDirectory,
          );

          expect(migrationRegistry.getLatest(), '00000000000002');
        },
      );
    },
  );
}
