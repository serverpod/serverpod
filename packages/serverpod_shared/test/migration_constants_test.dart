import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('MigrationConstants', () {
    late Directory testDir;

    setUp(() {
      testDir = Directory.systemTemp.createTempSync('test_migrations_');
    });

    tearDown(() {
      testDir.deleteSync(recursive: true);
    });

    group('defaultMigrationsDirectoryName', () {
      test(
        'returns "migrations".',
        () {
          expect(
            MigrationConstants.defaultMigrationsDirectoryName,
            equals('migrations'),
          );
        },
      );
    });

    group('migrationsBaseDirectory', () {
      test(
        'Given no custom path '
        'when getting migrations base directory '
        'then returns default migrations directory.',
        () {
          var result = MigrationConstants.migrationsBaseDirectory(testDir);

          expect(
            result.path,
            equals(path.join(testDir.path, 'migrations')),
          );
        },
      );

      test(
        'Given custom path "custom/migrations" '
        'when getting migrations base directory '
        'then returns custom migrations directory.',
        () {
          var result = MigrationConstants.migrationsBaseDirectory(
            testDir,
            customMigrationsPath: 'custom/migrations',
          );

          expect(
            result.path,
            equals(path.join(testDir.path, 'custom/migrations')),
          );
        },
      );

      test(
        'Given custom path "db-migrations" '
        'when getting migrations base directory '
        'then returns custom single directory.',
        () {
          var result = MigrationConstants.migrationsBaseDirectory(
            testDir,
            customMigrationsPath: 'db-migrations',
          );

          expect(
            result.path,
            equals(path.join(testDir.path, 'db-migrations')),
          );
        },
      );
    });

    group('migrationVersionDirectory', () {
      test(
        'Given no custom path '
        'when getting migration version directory '
        'then returns path under default migrations directory.',
        () {
          var result = MigrationConstants.migrationVersionDirectory(
            testDir,
            '20240101000000000',
          );

          expect(
            result.path,
            equals(path.join(testDir.path, 'migrations', '20240101000000000')),
          );
        },
      );

      test(
        'Given custom path '
        'when getting migration version directory '
        'then returns path under custom migrations directory.',
        () {
          var result = MigrationConstants.migrationVersionDirectory(
            testDir,
            '20240101000000000',
            customMigrationsPath: 'custom/migrations',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'custom/migrations',
                '20240101000000000',
              ),
            ),
          );
        },
      );
    });

    group('databaseDefinitionSQLPath', () {
      test(
        'Given no custom path '
        'when getting database definition SQL path '
        'then returns path under default migrations directory.',
        () {
          var result = MigrationConstants.databaseDefinitionSQLPath(
            testDir,
            '20240101000000000',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'migrations',
                '20240101000000000',
                'definition.sql',
              ),
            ),
          );
        },
      );

      test(
        'Given custom path '
        'when getting database definition SQL path '
        'then returns path under custom migrations directory.',
        () {
          var result = MigrationConstants.databaseDefinitionSQLPath(
            testDir,
            '20240101000000000',
            customMigrationsPath: 'custom/migrations',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'custom/migrations',
                '20240101000000000',
                'definition.sql',
              ),
            ),
          );
        },
      );
    });

    group('databaseDefinitionJSONPath', () {
      test(
        'Given no custom path '
        'when getting database definition JSON path '
        'then returns path under default migrations directory.',
        () {
          var result = MigrationConstants.databaseDefinitionJSONPath(
            testDir,
            '20240101000000000',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'migrations',
                '20240101000000000',
                'definition.json',
              ),
            ),
          );
        },
      );

      test(
        'Given custom path '
        'when getting database definition JSON path '
        'then returns path under custom migrations directory.',
        () {
          var result = MigrationConstants.databaseDefinitionJSONPath(
            testDir,
            '20240101000000000',
            customMigrationsPath: 'custom/migrations',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'custom/migrations',
                '20240101000000000',
                'definition.json',
              ),
            ),
          );
        },
      );
    });

    group('databaseMigrationSQLPath', () {
      test(
        'Given no custom path '
        'when getting database migration SQL path '
        'then returns path under default migrations directory.',
        () {
          var result = MigrationConstants.databaseMigrationSQLPath(
            testDir,
            '20240101000000000',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'migrations',
                '20240101000000000',
                'migration.sql',
              ),
            ),
          );
        },
      );

      test(
        'Given custom path '
        'when getting database migration SQL path '
        'then returns path under custom migrations directory.',
        () {
          var result = MigrationConstants.databaseMigrationSQLPath(
            testDir,
            '20240101000000000',
            customMigrationsPath: 'custom/migrations',
          );

          expect(
            result.path,
            equals(
              path.join(
                testDir.path,
                'custom/migrations',
                '20240101000000000',
                'migration.sql',
              ),
            ),
          );
        },
      );
    });
  });
}
