import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

const _fileNameMigrationJson = 'migration.json';
const _fileNameDefinitionJson = 'definition.json';
const _fileNameMigrationSql = 'migration.sql';
const _fileNameDefinitionSql = 'definition.sql';

class MigrationGenerator {
  MigrationGenerator({
    required this.directory,
    required this.projectName,
  });
  final Directory directory;
  final String projectName;

  static String createVersionName(String? tag) {
    var now = DateTime.now().toUtc();
    var fmt = DateFormat('yyyyMMddHHmmss');
    var versionName = fmt.format(now);
    if (tag != null) {
      versionName += '-$tag';
    }
    return versionName;
  }

  Directory get migrationsDirectory =>
      Directory(path.join(directory.path, 'migrations', projectName));

  List<String> getMigrationVersions() {
    if (!migrationsDirectory.existsSync()) {
      return [];
    }
    var versions = <String>[];
    var fileEntities = migrationsDirectory.listSync();
    for (var entity in fileEntities) {
      if (entity is Directory) {
        versions.add(path.basename(entity.path));
      }
    }
    versions.sort();
    return versions;
  }

  Future<MigrationVersion> getMigrationVersion(String versionName) async {
    return await MigrationVersion.load(
      versionName: versionName,
      migrationsDirectory: migrationsDirectory,
    );
  }

  Future<MigrationVersion?> getLatestMigrationVersion() async {
    var versions = getMigrationVersions();
    if (versions.isEmpty) {
      return null;
    }
    return await getMigrationVersion(versions.last);
  }

  Future<void> createMigration({
    String? tag,
    required bool force,
    bool verbose = false,
  }) async {
    var versionName = createVersionName(tag);

    var latest = await getLatestMigrationVersion();

    var srcDatabase =
        latest?.databaseDefinition ?? DatabaseDefinition(tables: []);
    var dstDatabase = await generateDatabaseDefinition(directory: directory);

    var warnings = <DatabaseMigrationWarning>[];
    var migration = generateDatabaseMigration(
      srcDatabase,
      dstDatabase,
      warnings,
    );

    if (warnings.isNotEmpty) {
      print('Migration Warnings:');
      for (var warning in warnings) {
        print(' - ${warning.message}');
      }

      if (!force) {
        print('Migration aborted. Use --force to ignore warnings.');
        return;
      }
    }

    if (migration.isEmpty) {
      print('No changes detected.');
      return;
    }

    var migrationVersion = MigrationVersion(
      migrationsDirectory: migrationsDirectory,
      versionName: versionName,
      migration: migration,
      databaseDefinition: dstDatabase,
    );

    await migrationVersion.write(module: projectName);
  }
}

class MigrationVersion {
  MigrationVersion({
    required this.migrationsDirectory,
    required this.versionName,
    required this.migration,
    required this.databaseDefinition,
  });

  final Directory migrationsDirectory;
  final String versionName;
  final DatabaseMigration migration;
  final DatabaseDefinition databaseDefinition;

  static Future<MigrationVersion> load({
    required String versionName,
    required Directory migrationsDirectory,
  }) async {
    var versionDir = Directory(
      path.join(migrationsDirectory.path, versionName),
    );

    // Get the serialization manager
    var serializationManager = Protocol();

    // Load the database definition
    var definitionFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = await definitionFile.readAsString();
    var databaseDefinition = serializationManager.decodeWithType(
      definitionData,
    ) as DatabaseDefinition;

    // Load the migration definition
    var migrationFile = File(path.join(
      versionDir.path,
      _fileNameMigrationJson,
    ));
    var migrationData = await migrationFile.readAsString();
    var migrationDefinition = serializationManager.decodeWithType(
      migrationData,
    ) as DatabaseMigration;

    return MigrationVersion(
      migrationsDirectory: migrationsDirectory,
      versionName: versionName,
      migration: migrationDefinition,
      databaseDefinition: databaseDefinition,
    );
  }

  Future<void> write({
    required String module,
  }) async {
    // Create sql for definition and migration
    var definitionSql = databaseDefinition.toPgSql(
      module: module,
      version: versionName,
      priority: 1,
    );
    var migrationSql = migration.toPgSql(
      module: module,
      version: versionName,
      priority: 1,
    );

    var versionDir = Directory(
      path.join(migrationsDirectory.path, versionName),
    );
    await versionDir.create(recursive: true);

    // Get the serialization manager
    var serializationManager = Protocol();

    // Write the database definition JSON file
    var definitionFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = serializationManager.encodeWithType(
      databaseDefinition,
    );
    await definitionFile.writeAsString(definitionData);

    // Write the database definition SQL file
    var definitionSqlFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionSql,
    ));
    await definitionSqlFile.writeAsString(definitionSql);

    // Write the migration definition JSON file
    var migrationFile = File(path.join(
      versionDir.path,
      _fileNameMigrationJson,
    ));
    var migrationData = serializationManager.encodeWithType(migration);
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = File(path.join(
      versionDir.path,
      _fileNameMigrationSql,
    ));
    await migrationSqlFile.writeAsString(migrationSql);
  }
}
