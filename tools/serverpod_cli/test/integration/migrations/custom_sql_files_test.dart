import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

MigrationVersion _createMigrationVersion(
  Directory projectDirectory,
  String versionName,
) {
  var databaseDefinition = DatabaseDefinition(
    moduleName: 'example_project',
    tables: [],
    installedModules: [
      DatabaseMigrationVersion(
        module: 'serverpod',
        version: '00000000000000',
      ),
      DatabaseMigrationVersion(
        module: 'example_project',
        version: versionName,
      ),
    ],
    migrationApiVersion: DatabaseConstants.migrationApiVersion,
  );

  return MigrationVersion(
    moduleName: 'example_project',
    projectDirectory: projectDirectory,
    versionName: versionName,
    migration: DatabaseMigration(
      actions: [],
      warnings: [],
      migrationApiVersion: DatabaseConstants.migrationApiVersion,
    ),
    databaseDefinitionProject: databaseDefinition,
    databaseDefinitionFull: databaseDefinition,
  );
}

void main() {
  var testAssetsPath =
      path.join('test', 'integration', 'migrations', 'test_assets');
  var tempDirectory = Directory(path.join(testAssetsPath, 'temp'));

  setUp(() {
    tempDirectory.createSync();
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  group('Custom SQL file generation', () {
    test(
        'Given create-migration command when executed then creates 4 empty custom SQL files.',
        () async {
      const versionName = '20240101000000';
      var migrationVersion =
          _createMigrationVersion(tempDirectory, versionName);

      await migrationVersion.write(
        installedModules:
            migrationVersion.databaseDefinitionFull.installedModules,
        removedModules: const [],
        previousVersion: null,
      );

      var preDatabaseSetup = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        versionName,
      );
      var postDatabaseSetup = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        versionName,
      );
      var preMigration = MigrationConstants.preMigrationSQLPath(
        tempDirectory,
        versionName,
      );
      var postMigration = MigrationConstants.postMigrationSQLPath(
        tempDirectory,
        versionName,
      );

      expect(preDatabaseSetup.existsSync(), isTrue,
          reason: 'pre_database_setup.sql should be created');
      expect(postDatabaseSetup.existsSync(), isTrue,
          reason: 'post_database_setup.sql should be created');
      expect(preMigration.existsSync(), isTrue,
          reason: 'pre_migration.sql should be created');
      expect(postMigration.existsSync(), isTrue,
          reason: 'post_migration.sql should be created');

      expect(preDatabaseSetup.readAsStringSync(), isEmpty,
          reason: 'pre_database_setup.sql should be empty initially');
      expect(postDatabaseSetup.readAsStringSync(), isEmpty,
          reason: 'post_database_setup.sql should be empty initially');
      expect(preMigration.readAsStringSync(), isEmpty,
          reason: 'pre_migration.sql should be empty initially');
      expect(postMigration.readAsStringSync(), isEmpty,
          reason: 'post_migration.sql should be empty initially');
    });

    test(
        'Given custom database setup SQL in previous migration when writing new migration then files are copied.',
        () async {
      const previousVersion = '20240101000000';
      const currentVersion = '20240102000000';

      var previousDirectory = MigrationConstants.migrationVersionDirectory(
        tempDirectory,
        previousVersion,
      );
      previousDirectory.createSync(recursive: true);

      var previousPreFile = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        previousVersion,
      );
      var previousPostFile = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        previousVersion,
      );
      previousPreFile.writeAsStringSync('PRE-CUSTOM-SQL;');
      previousPostFile.writeAsStringSync('POST-CUSTOM-SQL;');

      var migrationVersion =
          _createMigrationVersion(tempDirectory, currentVersion);

      await migrationVersion.write(
        installedModules:
            migrationVersion.databaseDefinitionFull.installedModules,
        removedModules: const [],
        previousVersion: previousVersion,
      );

      var newPreFile = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );
      var newPostFile = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );

      expect(newPreFile.readAsStringSync(), 'PRE-CUSTOM-SQL;',
          reason:
              'pre_database_setup.sql should be copied from previous version');
      expect(newPostFile.readAsStringSync(), 'POST-CUSTOM-SQL;',
          reason:
              'post_database_setup.sql should be copied from previous version');
    });

    test(
        'Given no previous migration when writing migration version then database setup SQL files are empty.',
        () async {
      const currentVersion = '20240103000000';
      var migrationVersion =
          _createMigrationVersion(tempDirectory, currentVersion);

      await migrationVersion.write(
        installedModules:
            migrationVersion.databaseDefinitionFull.installedModules,
        removedModules: const [],
        previousVersion: null,
      );

      var preFile = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );
      var postFile = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );

      expect(preFile.existsSync(), isTrue,
          reason: 'pre_database_setup.sql should exist');
      expect(postFile.existsSync(), isTrue,
          reason: 'post_database_setup.sql should exist');
      expect(preFile.readAsStringSync(), isEmpty,
          reason:
              'pre_database_setup.sql should be empty with no previous migration');
      expect(postFile.readAsStringSync(), isEmpty,
          reason:
              'post_database_setup.sql should be empty with no previous migration');
    });

    test(
        'Given custom migration SQL in previous version when writing new migration then migration SQL is accumulated to database setup.',
        () async {
      const previousVersion = '20240104000000';
      const currentVersion = '20240105000000';

      var previousDirectory = MigrationConstants.migrationVersionDirectory(
        tempDirectory,
        previousVersion,
      );
      previousDirectory.createSync(recursive: true);

      // Add custom SQL to previous migration files
      var previousPreMigration = MigrationConstants.preMigrationSQLPath(
        tempDirectory,
        previousVersion,
      );
      var previousPostMigration = MigrationConstants.postMigrationSQLPath(
        tempDirectory,
        previousVersion,
      );
      previousPreMigration
          .writeAsStringSync('CREATE INDEX idx_pre ON test_table(field);');
      previousPostMigration
          .writeAsStringSync('CREATE INDEX idx_post ON test_table(field2);');

      var migrationVersion =
          _createMigrationVersion(tempDirectory, currentVersion);

      await migrationVersion.write(
        installedModules:
            migrationVersion.databaseDefinitionFull.installedModules,
        removedModules: const [],
        previousVersion: previousVersion,
      );

      var newPreDatabaseSetup = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );
      var newPostDatabaseSetup = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );

      var preContent = newPreDatabaseSetup.readAsStringSync();
      var postContent = newPostDatabaseSetup.readAsStringSync();

      expect(preContent, contains('CREATE INDEX idx_pre ON test_table(field)'),
          reason:
              'pre_database_setup.sql should accumulate pre_migration.sql from previous version');
      expect(
          postContent, contains('CREATE INDEX idx_post ON test_table(field2)'),
          reason:
              'post_database_setup.sql should accumulate post_migration.sql from previous version');
    });

    test(
        'Given both previous database_setup and migration SQL when writing new migration then both are accumulated.',
        () async {
      const previousVersion = '20240106000000';
      const currentVersion = '20240107000000';

      var previousDirectory = MigrationConstants.migrationVersionDirectory(
        tempDirectory,
        previousVersion,
      );
      previousDirectory.createSync(recursive: true);

      // Add SQL to previous database_setup files
      var previousPreSetup = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        previousVersion,
      );
      var previousPostSetup = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        previousVersion,
      );
      previousPreSetup.writeAsStringSync(
          '-- From previous setup\nCREATE TABLE setup_table (id INT);');
      previousPostSetup.writeAsStringSync(
          '-- From previous setup\nCREATE INDEX idx_setup ON setup_table(id);');

      // Add SQL to previous migration files
      var previousPreMigration = MigrationConstants.preMigrationSQLPath(
        tempDirectory,
        previousVersion,
      );
      var previousPostMigration = MigrationConstants.postMigrationSQLPath(
        tempDirectory,
        previousVersion,
      );
      previousPreMigration.writeAsStringSync(
          '-- From previous migration\nCREATE TABLE migration_table (id INT);');
      previousPostMigration.writeAsStringSync(
          '-- From previous migration\nCREATE INDEX idx_migration ON migration_table(id);');

      var migrationVersion =
          _createMigrationVersion(tempDirectory, currentVersion);

      await migrationVersion.write(
        installedModules:
            migrationVersion.databaseDefinitionFull.installedModules,
        removedModules: const [],
        previousVersion: previousVersion,
      );

      var newPreSetup = MigrationConstants.preDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );
      var newPostSetup = MigrationConstants.postDatabaseSetupSQLPath(
        tempDirectory,
        currentVersion,
      );

      var preContent = newPreSetup.readAsStringSync();
      var postContent = newPostSetup.readAsStringSync();

      expect(preContent, contains('From previous setup'),
          reason: 'Should contain SQL from previous database_setup');
      expect(preContent, contains('From previous migration'),
          reason: 'Should accumulate SQL from previous migration');
      expect(preContent, contains('CREATE TABLE setup_table'),
          reason: 'Should preserve setup table creation');
      expect(preContent, contains('CREATE TABLE migration_table'),
          reason: 'Should accumulate migration table creation');

      expect(postContent, contains('From previous setup'),
          reason: 'Should contain SQL from previous database_setup');
      expect(postContent, contains('From previous migration'),
          reason: 'Should accumulate SQL from previous migration');
      expect(postContent, contains('idx_setup'),
          reason: 'Should preserve setup index');
      expect(postContent, contains('idx_migration'),
          reason: 'Should accumulate migration index');
    });
  });
}
