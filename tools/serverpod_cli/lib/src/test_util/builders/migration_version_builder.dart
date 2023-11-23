import 'dart:io';

import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class MigrationVersionBuilder {
  String _versionName = '00000000000000';
  DatabaseMigration _migration = DatabaseMigration(
    actions: [],
    warnings: [],
    priority: 0,
    migrationApiVersion: 0,
  );
  DatabaseDefinition _databaseDefinition = DatabaseDefinition(
    tables: [],
    migrationApiVersion: 0,
  );
  Directory _migrationsDirectory = Directory.current;

  MigrationVersionBuilder withVersionName(String versionName) {
    _versionName = versionName;
    return this;
  }

  MigrationVersionBuilder withMigration(DatabaseMigration migration) {
    _migration = migration;
    return this;
  }

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
      versionName: _versionName,
      migration: _migration,
      databaseDefinition: _databaseDefinition,
      migrationsDirectory: _migrationsDirectory,
    );
  }
}
