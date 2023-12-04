import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class MigrationGenerator {
  MigrationGenerator({
    required this.directory,
    required this.projectName,
  });
  final Directory directory;
  final String projectName;

  static String createVersionName(String? tag) {
    var now = DateTime.now().toUtc();
    var fmt = DateFormat('yyyyMMddHHmmssSSS');
    var versionName = fmt.format(now);
    if (tag != null) {
      versionName += '-$tag';
    }
    return versionName;
  }

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required GeneratorConfig config,
    bool write = true,
  }) async {
    var migrationRegistry = MigrationRegistry.load(
      MigrationConstants.migrationsBaseDirectory(directory),
    );

    var databaseDefinitionLatest = await _getSourceDatabaseDefinition(
      projectName,
      migrationRegistry.getLatest(),
    );

    var protocols = await ProtocolHelper.loadProjectYamlProtocolsFromDisk(
      config,
    );
    var entityDefinitions = StatefulAnalyzer(protocols, (uri, collector) {
      collector.printErrors();

      if (collector.hasSeverErrors) {
        throw GenerateMigrationDatabaseDefinitionException();
      }
    }).validateAll();

    var databaseDefinitionProject = createDatabaseDefinitionFromEntities(
      entityDefinitions,
      config.name,
      config.modulesAll,
    );

    var databaseDefinitions = await _loadModuleDatabaseDefinitions(
      config.modulesAll,
      directory,
    );

    var versionName = createVersionName(tag);
    var nextMigrationVersion = DatabaseMigrationVersion(
      module: projectName,
      version: versionName,
    );

    var databaseDefinitionNext = _mergeDatabaseDefinitions(
      databaseDefinitionProject,
      databaseDefinitions,
      nextMigrationVersion,
    );

    var migration = generateDatabaseMigration(
      databaseSource: databaseDefinitionLatest,
      databaseTarget: databaseDefinitionNext,
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

    var migrationVersion = MigrationVersion(
      moduleName: projectName,
      projectDirectory: directory,
      versionName: versionName,
      migration: migration,
      databaseDefinitionProject: databaseDefinitionProject,
      databaseDefinitionFull: databaseDefinitionNext,
    );

    if (write) {
      var removedModules = _removedModulesDiff(
        databaseDefinitionLatest.installedModules,
        databaseDefinitionNext.installedModules,
      );

      await migrationVersion.write(
        installedModules: databaseDefinitionNext.installedModules,
        removedModules: removedModules,
      );
      migrationRegistry.add(versionName);
      await migrationRegistry.write();
    }

    return migrationVersion;
  }

  Future<Iterable<DatabaseDefinition>> _loadModuleDatabaseDefinitions(
    List<ModuleConfig> allModules,
    Directory projectFolder,
  ) async {
    var modules =
        allModules.where((module) => module.name != projectName).toList();

    var versions = await _loadMigrationVersionsFromModules(
      modules,
      directory: projectFolder,
    );
    return versions.map((e) => e.databaseDefinitionProject);
  }

  /// Creates a repair migration that will bring the database up to date with
  /// the targeted migration version.
  ///
  /// If [targetMigrationVersion] is not specified, the latest migration version
  /// will be used.
  ///
  /// Returns the repair migration file, or null if no migration was
  /// created.
  Future<File?> repairMigration({
    String? tag,
    required bool force,
    required String runMode,
    String? targetMigrationVersion,
  }) async {
    var migrationVersion =
        targetMigrationVersion ?? _getLatestMigrationVersion();

    _validateRepairMigrationVersion(migrationVersion);

    DatabaseDefinition dstDatabase = await _getSourceDatabaseDefinition(
      projectName,
      migrationVersion,
    );

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
      databaseSource: liveDatabase,
      databaseTarget: dstDatabase,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    bool versionsMismatch = _moduleVersionMismatch(liveDatabase, dstDatabase);

    if (migration.isEmpty && !versionsMismatch && !force) {
      log.info('No changes detected.');
      return null;
    }

    var repairMigrationName = createVersionName(tag);

    var installedModules = [
      ...dstDatabase.installedModules,
      DatabaseMigrationVersion(
        module: MigrationConstants.repairMigrationModuleName,
        version: repairMigrationName,
      )
    ];

    List<DatabaseMigrationVersion> removedModules = _removedModulesDiff(
      liveDatabase.installedModules,
      installedModules,
    );

    return _writeRepairMigration(
      repairMigrationName,
      migration,
      installedModules,
      removedModules,
    );
  }

  void _validateRepairMigrationVersion(String? migrationVersion) {
    var migrationRegistry = MigrationRegistry.load(
      MigrationConstants.migrationsBaseDirectory(directory),
    );

    if (migrationVersion == null ||
        !migrationRegistry.versions.contains(migrationVersion)) {
      throw MigrationRepairTargetNotFoundException(
        targetName: migrationVersion,
        versionsFound: migrationRegistry.versions,
      );
    }
  }

  List<DatabaseMigrationVersion> _removedModulesDiff(
    List<DatabaseMigrationVersion> preInstalledModules,
    List<DatabaseMigrationVersion> postInstalledModules,
  ) {
    var removedModules = preInstalledModules
        .where(
          (module) => !postInstalledModules.any(
            (installedModule) => installedModule.module == module.module,
          ),
        )
        .toList();
    return removedModules;
  }

  Future<DatabaseDefinition> _getSourceDatabaseDefinition(
    String moduleName,
    String? migrationVersionName,
  ) async {
    if (migrationVersionName == null) {
      return DatabaseDefinition(
        moduleName: moduleName,
        tables: [],
        installedModules: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );
    }

    var migrationVersion = await MigrationVersion.load(
      moduleName: projectName,
      versionName: migrationVersionName,
      projectDirectory: directory,
    );

    return migrationVersion.databaseDefinitionFull;
  }

  String? _getLatestMigrationVersion() {
    var migrationRegistry = MigrationRegistry.load(
      MigrationConstants.migrationsBaseDirectory(directory),
    );
    return migrationRegistry.getLatest();
  }

  bool _moduleVersionMismatch(
    DatabaseDefinition liveDatabase,
    DatabaseDefinition targetDatabase,
  ) {
    var installedModules = liveDatabase.installedModules.where(
      (module) => module.module != MigrationConstants.repairMigrationModuleName,
    );

    var targetModules = targetDatabase.installedModules.where(
      (module) => module.module != MigrationConstants.repairMigrationModuleName,
    );

    if (installedModules.length != targetModules.length) {
      return true;
    }

    for (var module in installedModules) {
      if (targetModules.any((version) =>
          version.module == module.module &&
          version.version != module.version)) {
        return true;
      }
    }

    return false;
  }

  Future<List<MigrationVersion>> _loadMigrationVersionsFromModules(
    List<ModuleConfig> modules, {
    required Directory directory,
  }) async {
    var modulePaths = await locateAllModulePaths(
      directory: directory,
    );

    var selectedModules = modules.where(
      (module) => module.migrationVersions.isNotEmpty,
    );

    var selectedPaths = modulePaths.where(
      (modulePath) {
        var moduleName = _extractModuleNameFromPath(modulePath);
        return selectedModules.any((module) => module.name == moduleName);
      },
    );

    var moduleMigrationVersions = <MigrationVersion>[];

    for (var modulePath in selectedPaths) {
      var moduleName = _extractModuleNameFromPath(modulePath);

      var versionName = selectedModules
          .firstWhere((e) => e.name == moduleName)
          .migrationVersions
          .last;

      var migrationVersion = await MigrationVersion.load(
        moduleName: moduleName,
        versionName: versionName,
        projectDirectory: Directory.fromUri(modulePath),
      );
      moduleMigrationVersions.add(migrationVersion);
    }

    return moduleMigrationVersions;
  }

  DatabaseDefinition _mergeDatabaseDefinitions(
    DatabaseDefinition databaseDefinitionProject,
    Iterable<DatabaseDefinition> databaseDefinitions,
    DatabaseMigrationVersion nextProjectMigrationVersion,
  ) {
    var tables = [
      ...databaseDefinitionProject.tables,
      ...databaseDefinitions.fold(
        <TableDefinition>[],
        (aggregate, item) => [...aggregate, ...item.tables],
      ),
    ];

    var installedModules = [
      nextProjectMigrationVersion,
      ...databaseDefinitionProject.installedModules.where(
        (module) => module.module != nextProjectMigrationVersion.module,
      ),
    ];

    return DatabaseDefinition(
      moduleName: databaseDefinitionProject.moduleName,
      tables: tables,
      installedModules: installedModules,
      migrationApiVersion: databaseDefinitionProject.migrationApiVersion,
    );
  }

  String _extractModuleNameFromPath(Uri path) {
    var packageName = path.pathSegments.last;
    return moduleNameFromServerPackageName(packageName);
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

  File _writeRepairMigration(
    String repairMigrationName,
    DatabaseMigration migration,
    List<DatabaseMigrationVersion> installedModules,
    List<DatabaseMigrationVersion> removedModules,
  ) {
    var repairMigrationSql = migration.toPgSql(
      installedModules: installedModules,
      removedModules: removedModules,
    );

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

    return repairMigrationFile;
  }
}

class MigrationVersion {
  MigrationVersion({
    required this.moduleName,
    required this.projectDirectory,
    required this.versionName,
    required this.migration,
    required this.databaseDefinitionProject,
    required this.databaseDefinitionFull,
  });

  final Directory projectDirectory;

  final String moduleName;
  final String versionName;
  final DatabaseMigration migration;
  final DatabaseDefinition databaseDefinitionProject;
  final DatabaseDefinition databaseDefinitionFull;

  static Future<MigrationVersion> load({
    required String moduleName,
    required String versionName,
    required Directory projectDirectory,
  }) async {
    try {
      // Get the serialization manager
      var serializationManager = Protocol();

      // Load the database definition
      var databaseDefinitionProjectPath =
          MigrationConstants.databaseDefinitionProjectJSONPath(
        projectDirectory,
        versionName,
      );

      var databaseDefinitionProject =
          await _readMigrationDataFile<DatabaseDefinition>(
        databaseDefinitionProjectPath,
        serializationManager,
      );

      var databaseDefinitionPath =
          MigrationConstants.databaseDefinitionJSONPath(
        projectDirectory,
        versionName,
      );
      var databaseDefinition = await _readMigrationDataFile<DatabaseDefinition>(
        databaseDefinitionPath,
        serializationManager,
      );

      // Load the migration definition
      var migrationPath = MigrationConstants.databaseMigrationJSONPath(
        projectDirectory,
        versionName,
      );
      var migrationDefinition = await _readMigrationDataFile<DatabaseMigration>(
        migrationPath,
        serializationManager,
      );

      return MigrationVersion(
        moduleName: moduleName,
        projectDirectory: projectDirectory,
        versionName: versionName,
        migration: migrationDefinition,
        databaseDefinitionProject: databaseDefinitionProject,
        databaseDefinitionFull: databaseDefinition,
      );
    } catch (e) {
      throw MigrationVersionLoadException(
        versionName: versionName,
        moduleName: moduleName,
        exception: e.toString(),
      );
    }
  }

  static Future<T> _readMigrationDataFile<T>(
    File definitionFile,
    Protocol serializationManager,
  ) async {
    var data = await definitionFile.readAsString();
    var content = serializationManager.decode<T>(
      data,
    );
    return content;
  }

  Future<void> write({
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
  }) async {
    var migrationDirectory = MigrationConstants.migrationVersionDirectory(
      projectDirectory,
      versionName,
    );

    if (migrationDirectory.existsSync()) {
      throw MigrationVersionAlreadyExistsException(
        directoryPath: migrationDirectory.path,
      );
    }
    await migrationDirectory.create(recursive: true);

    // Create sql for definition and migration
    var definitionSql = databaseDefinitionFull.toPgSql(
      installedModules: installedModules,
    );

    var migrationSql = migration.toPgSql(
      installedModules: installedModules,
      removedModules: removedModules,
    );

    // Write the database definition JSON file
    var definitionFile = MigrationConstants.databaseDefinitionProjectJSONPath(
      projectDirectory,
      versionName,
    );
    var definitionData = SerializationManager.encode(
      databaseDefinitionProject,
      formatted: true,
    );
    await definitionFile.writeAsString(definitionData);

    // Write the database full definition JSON file
    var definitionFullFile = MigrationConstants.databaseDefinitionJSONPath(
      projectDirectory,
      versionName,
    );
    var definitionFullData = SerializationManager.encode(
      databaseDefinitionFull,
      formatted: true,
    );
    await definitionFullFile.writeAsString(definitionFullData);

    // Write the database definition SQL file
    var definitionSqlFile = MigrationConstants.databaseDefinitionSQLPath(
      projectDirectory,
      versionName,
    );
    await definitionSqlFile.writeAsString(definitionSql);

    // Write the migration definition JSON file
    var migrationFile = MigrationConstants.databaseMigrationJSONPath(
      projectDirectory,
      versionName,
    );
    var migrationData = SerializationManager.encode(
      migration,
      formatted: true,
    );
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = MigrationConstants.databaseMigrationSQLPath(
      projectDirectory,
      versionName,
    );
    await migrationSqlFile.writeAsString(migrationSql);
  }
}
