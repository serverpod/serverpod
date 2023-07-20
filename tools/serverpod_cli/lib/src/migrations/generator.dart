import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
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

  Directory get migrationsBaseDirectory =>
      Directory(path.join(directory.path, 'migrations'));

  Directory get migrationsProjectDirectory =>
      Directory(path.join(directory.path, 'migrations', projectName));

  List<String> getMigrationModules() {
    if (!migrationsBaseDirectory.existsSync()) {
      return [];
    }
    var names = <String>[];
    var fileEntities = migrationsBaseDirectory.listSync();
    for (var entity in fileEntities) {
      if (entity is Directory) {
        names.add(path.basename(entity.path));
      }
    }
    names.sort();
    return names;
  }

  List<String> getMigrationVersions({
    String? module,
  }) {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module ?? projectName,
      ),
    );
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

  Future<MigrationVersion> getMigrationVersion(
    String versionName, {
    String? module,
  }) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module ?? projectName,
      ),
    );
    return await MigrationVersion.load(
      versionName: versionName,
      migrationsDirectory: migrationsDirectory,
    );
  }

  Future<MigrationVersion?> getLatestMigrationVersion({
    String? module,
  }) async {
    var versions = getMigrationVersions(module: module);
    if (versions.isEmpty) {
      return null;
    }
    return await getMigrationVersion(
      versions.last,
      module: module,
    );
  }

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required int priority,
  }) async {
    var versionName = createVersionName(tag);

    var latest = await getLatestMigrationVersion();

    var srcDatabase = latest?.databaseDefinition ??
        DatabaseDefinition(
          tables: [],
          priority: priority,
        );
    var dstDatabase = await generateDatabaseDefinition(
      directory: directory,
      priority: priority,
    );

    var warnings = <DatabaseMigrationWarning>[];
    var migration = generateDatabaseMigration(
      srcDatabase: srcDatabase,
      dstDatabase: dstDatabase,
      warnings: warnings,
      priority: priority,
    );

    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    if (migration.isEmpty) {
      log.info('No changes detected.');
      return null;
    }

    var migrationVersion = MigrationVersion(
      migrationsDirectory: migrationsProjectDirectory,
      versionName: versionName,
      migration: migration,
      databaseDefinition: dstDatabase,
    );

    await migrationVersion.write(module: projectName);

    return migrationVersion;
  }

  Future<String?> repairMigration({
    String? tag,
    required bool force,
    required String runMode,
  }) async {
    var client = ConfigInfo(runMode).createServiceClient();
    var versions = <String, String>{};

    // Load the latest migration from all modules.
    var modules = getMigrationModules();
    var dstDefinitions = <DatabaseDefinition>[];
    for (var module in modules) {
      var version = await getLatestMigrationVersion(module: module);
      if (version == null) {
        continue;
      }
      versions[module] = version.versionName;
      dstDefinitions.add(version.databaseDefinition);
    }

    var dstDatabase = DatabaseDefinition(
      tables: dstDefinitions.expand((e) => e.tables).toList(),
    );

    // Get the live database definition from the server.
    var liveDatabase = await client.insights.getLiveDatabaseDefinition();

    // Print warnings, if any exists.
    var warnings = <DatabaseMigrationWarning>[];
    var migration = generateDatabaseMigration(
      srcDatabase: liveDatabase,
      dstDatabase: dstDatabase,
      warnings: warnings,
      priority: 0,
    );

    _printWarnings(warnings);
    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    // Check if there are any changes.
    var versionsChanged = false;
    if (liveDatabase.installedModules == null) {
      versionsChanged = true;
    } else {
      for (var module in liveDatabase.installedModules!.keys) {
        if (versions[module] != liveDatabase.installedModules![module]) {
          versionsChanged = true;
        }
      }
    }
    if (migration.isEmpty && !versionsChanged) {
      log.info('-- No changes detected.');
      return null;
    }

    // Output the migration.
    var sql = migration.toPgSql(versions: versions);
    log.info(sql);
    return sql;
  }

  void _printWarnings(List<DatabaseMigrationWarning> warnings) {
    if (warnings.isNotEmpty) {
      log.warning('Migration Warnings:');
      for (var warning in warnings) {
        log.warning(
          warning.message,
          style: const TextLog(type: TextLogType.bullet),
        );
      }
    }
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
  int get priority => migration.priority;

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
    );
    var migrationSql = migration.toPgSql(
      versions: {module: versionName},
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
