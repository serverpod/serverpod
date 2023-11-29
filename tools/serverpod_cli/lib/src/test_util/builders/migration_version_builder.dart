import 'dart:io';

import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class MigrationVersionBuilder {
  String _moduleName = 'example_project';
  String _versionName = '00000000000000';
  DatabaseMigration _migration = DatabaseMigration(
    actions: [],
    warnings: [],
    priority: 0,
    migrationApiVersion: 0,
  );
  late DatabaseDefinition _databaseDefinition;
  late DatabaseDefinition _databaseDefinitionFull;
  Directory _projectDirectory = Directory.current;

  MigrationVersionBuilder() {
    _databaseDefinition = DatabaseDefinition(
      moduleName: _moduleName,
      installedModules: [
        DatabaseMigrationVersion(
          module: 'serverpod',
          version: '00000000000000',
        ),
        DatabaseMigrationVersion(module: _moduleName, version: _versionName)
      ],
      tables: [],
      migrationApiVersion: 0,
    );

    _databaseDefinitionFull = DatabaseDefinition(
      moduleName: _moduleName,
      installedModules: [
        DatabaseMigrationVersion(
          module: 'serverpod',
          version: '00000000000000',
        ),
        DatabaseMigrationVersion(module: _moduleName, version: _versionName)
      ],
      tables: [],
      migrationApiVersion: 0,
    );
  }

  MigrationVersionBuilder withModuleName(String moduleName) {
    _moduleName = moduleName;
    return this;
  }

  MigrationVersionBuilder withVersionName(String versionName) {
    _versionName = versionName;
    return this;
  }

  MigrationVersionBuilder withMigration(DatabaseMigration migration) {
    _migration = migration;
    return this;
  }

  /// The installed modules in the database definition is expected to include
  /// the main project and serverpod as a module
  MigrationVersionBuilder withDatabaseDefinition(
    DatabaseDefinition databaseDefinition,
  ) {
    _databaseDefinition = databaseDefinition;
    return this;
  }

  MigrationVersionBuilder withProjectDirectory(Directory projectDirectory) {
    _projectDirectory = projectDirectory;
    return this;
  }

  MigrationVersion build() {
    return MigrationVersion(
      moduleName: _moduleName,
      versionName: _versionName,
      migration: _migration,
      databaseDefinitionProject: _databaseDefinition,
      databaseDefinitionFull: _databaseDefinitionFull,
      projectDirectory: _projectDirectory,
    );
  }
}
