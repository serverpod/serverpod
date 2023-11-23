import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
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
      MigrationConstants.migrationsBaseDirectory(directory);

  Directory get migrationsProjectDirectory =>
      Directory(path.join(migrationsBaseDirectory.path, projectName));

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

  Future<MigrationVersion> getMigrationVersion(
    String versionName,
    String module,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module,
      ),
    );
    try {
      return await MigrationVersion.load(
        versionName: versionName,
        migrationsDirectory: migrationsDirectory,
      );
    } catch (e) {
      throw MigrationVersionLoadException(
        versionName: versionName,
        moduleName: module,
        exception: e.toString(),
      );
    }
  }

  Future<MigrationVersion?> getLatestMigrationVersion(
    String module,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        module,
      ),
    );

    var migrationRegistry = MigrationRegistry.load(migrationsDirectory);

    var latestVersion = migrationRegistry.getLatest();
    if (latestVersion == null) {
      return null;
    }

    return await getMigrationVersion(
      latestVersion,
      module,
    );
  }

  Future<DatabaseDefinition> _getSourceDatabaseDefinition(
    String? latestVersion,
    int priority,
  ) async {
    if (latestVersion == null) {
      return DatabaseDefinition(
        tables: [],
        priority: priority,
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );
    }

    var latest = await getMigrationVersion(latestVersion, projectName);
    return latest.databaseDefinition;
  }

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required int priority,
    bool write = true,
  }) async {
    var migrationRegistry = MigrationRegistry.load(
      migrationsProjectDirectory,
    );

    var srcDatabase = await _getSourceDatabaseDefinition(
      migrationRegistry.getLatest(),
      priority,
    );

    var dstDatabase = await generateDatabaseDefinition(
      directory: directory,
      priority: priority,
    );

    var migration = generateDatabaseMigration(
      srcDatabase: srcDatabase,
      dstDatabase: dstDatabase,
      priority: priority,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    if (migration.isEmpty && !force) {
      log.info('No changes detected.');
      return null;
    }

    var versionName = createVersionName(tag);
    var migrationVersion = MigrationVersion(
      migrationsDirectory: migrationsProjectDirectory,
      versionName: versionName,
      migration: migration,
      databaseDefinition: dstDatabase,
    );

    if (write) {
      await migrationVersion.write(module: projectName);
      migrationRegistry.add(versionName);
      await migrationRegistry.write();
    }

    return migrationVersion;
  }

  Future<bool> repairMigration({
    String? tag,
    required bool force,
    required String runMode,
    RepairTargetMigration? targetMigration,
  }) async {
    Map<String, MigrationVersion> versions =
        await loadMigrationVersionsFromAllModules(
      targetMigration: targetMigration,
    );

    DatabaseDefinition dstDatabase =
        createDatabaseDefinitionFromTables(versions);

    var client = ConfigInfo(runMode).createServiceClient();
    DatabaseDefinition liveDatabase;
    try {
      liveDatabase = await client.insights.getLiveDatabaseDefinition();
    } catch (e) {
      throw MigrationLiveDatabaseDefinitionException(
        exception: e.toString(),
      );
    } finally {
      client.close();
    }

    var migration = generateDatabaseMigration(
      srcDatabase: liveDatabase,
      dstDatabase: dstDatabase,
      priority: 0,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return false;
    }

    bool versionsMismatch = moduleVersionMismatch(liveDatabase, versions);

    if (migration.isEmpty && !versionsMismatch && !force) {
      log.info('No changes detected.');
      return false;
    }

    var repairMigrationName = createVersionName(tag);

    var moduleVersions = versions
        .map((key, value) => MapEntry<String, String>(key, value.versionName));
    moduleVersions[MigrationConstants.repairMigrationModuleName] =
        repairMigrationName;

    _writeRepairMigration(
      repairMigrationName,
      migration,
      moduleVersions,
    );

    return true;
  }

  bool moduleVersionMismatch(
    DatabaseDefinition liveDatabase,
    Map<String, MigrationVersion> versions,
  ) {
    var installedModules = liveDatabase.installedModules;
    if (installedModules == null) {
      return versions.isNotEmpty;
    }

    installedModules.removeWhere((module) =>
        module.module == MigrationConstants.repairMigrationModuleName);

    if (installedModules.length != versions.length) {
      return true;
    }

    for (var module in installedModules) {
      if (versions[module.module]?.versionName != module.version) {
        return true;
      }
    }

    return false;
  }

  DatabaseDefinition createDatabaseDefinitionFromTables(
      Map<String, MigrationVersion> versions) {
    var migrationDefinitions =
        versions.values.map((e) => e.databaseDefinition).toList();
    var dstDatabase = DatabaseDefinition(
      tables: migrationDefinitions.expand((e) => e.tables).toList(),
      migrationApiVersion: DatabaseConstants.migrationApiVersion,
    );
    return dstDatabase;
  }

  Future<Map<String, MigrationVersion>> loadMigrationVersionsFromAllModules({
    RepairTargetMigration? targetMigration,
  }) async {
    var versions = <String, MigrationVersion>{};
    if (targetMigration != null) {
      versions[targetMigration.moduleName] =
          await _loadTargetRepairMigrationVersion(targetMigration);
    }

    var modules = getMigrationModules();
    modules.removeWhere((moduleName) => versions.containsKey(moduleName));

    for (var module in modules) {
      var version = await getLatestMigrationVersion(module);

      if (version == null) {
        continue;
      }

      versions[module] = version;
    }
    return versions;
  }

  Future<MigrationVersion> _loadTargetRepairMigrationVersion(
    RepairTargetMigration targetMigration,
  ) async {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
        targetMigration.moduleName,
      ),
    );

    var registry = MigrationRegistry.load(migrationsDirectory);

    if (!registry.versions.contains(targetMigration.version)) {
      throw MigrationRepairTargetNotFoundException(
        versionsFound: registry.versions,
        targetName: targetMigration.version,
      );
    }

    return await getMigrationVersion(
      targetMigration.version,
      targetMigration.moduleName,
    );
  }

  void _printWarnings(List<DatabaseMigrationWarning> warnings) {
    if (warnings.isNotEmpty) {
      log.warning('Migration Warnings:');
      for (var warning in warnings) {
        log.warning(
          warning.message,
          type: TextLogType.bullet,
        );
      }
    }
  }

  void _writeRepairMigration(
    String repairMigrationName,
    DatabaseMigration migration,
    Map<String, String> moduleVersions,
  ) {
    var repairMigrationSql = migration.toPgSql(versions: moduleVersions);

    var repairMigrationFile = File(path.join(
      MigrationConstants.repairMigrationDirectory(directory).path,
      '$repairMigrationName.sql',
    ));

    var targetDirectory =
        MigrationConstants.repairMigrationDirectory(directory);

    if (targetDirectory.existsSync()) {
      targetDirectory.deleteSync(recursive: true);
    }

    targetDirectory.createSync(recursive: true);

    try {
      repairMigrationFile.writeAsStringSync(repairMigrationSql);
    } catch (e) {
      throw MigrationRepairWriteException(exception: e.toString());
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
    var databaseDefinition = serializationManager.decode<DatabaseDefinition>(
      definitionData,
    );

    // Load the migration definition
    var migrationFile = File(path.join(
      versionDir.path,
      _fileNameMigrationJson,
    ));
    var migrationData = await migrationFile.readAsString();
    var migrationDefinition = serializationManager.decode<DatabaseMigration>(
      migrationData,
    );

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
    var versionDir = Directory(
      path.join(migrationsDirectory.path, versionName),
    );

    if (versionDir.existsSync()) {
      throw MigrationVersionAlreadyExistsException(
        directoryPath: versionDir.path,
      );
    }
    await versionDir.create(recursive: true);

    // Create sql for definition and migration
    var definitionSql = databaseDefinition.toPgSql(
      module: module,
      version: versionName,
    );

    var migrationSql = migration.toPgSql(
      versions: {module: versionName},
    );

    // Write the database definition JSON file
    var definitionFile = File(path.join(
      versionDir.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = SerializationManager.encode(
      databaseDefinition,
      formatted: true,
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
    var migrationData = SerializationManager.encode(
      migration,
      formatted: true,
    );
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = File(path.join(
      versionDir.path,
      _fileNameMigrationSql,
    ));
    await migrationSqlFile.writeAsString(migrationSql);
  }
}

class RepairTargetMigration {
  RepairTargetMigration({
    required this.moduleName,
    required this.version,
  });

  final String moduleName;
  final String version;
}
