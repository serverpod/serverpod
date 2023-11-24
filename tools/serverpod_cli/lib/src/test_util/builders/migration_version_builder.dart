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
  Directory _migrationsDirectory = Directory.current;

  MigrationVersionBuilder() {
    _databaseDefinition = DatabaseDefinition(
      installedModules: [
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

  /// Should include your self in the installedModules.
  MigrationVersionBuilder withDatabaseDefinition(
    DatabaseDefinition databaseDefinition,
  ) {
    _databaseDefinition = databaseDefinition;
    return this;
  }

  MigrationVersionBuilder withMigrationsDirectory(
    Directory migrationsDirectory,
  ) {
    _migrationsDirectory = migrationsDirectory;
    return this;
  }

  MigrationVersion build() {
    return MigrationVersion(
      moduleName: _moduleName,
      versionName: _versionName,
      migration: _migration,
      databaseDefinition: _databaseDefinition,
      migrationsDirectory: _migrationsDirectory,
    );
  }
}
