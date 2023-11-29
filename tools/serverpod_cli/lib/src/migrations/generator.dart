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

const _fileNameMigrationJson = 'migration.json';
const _fileNameDefinitionProjectJson = 'definition_project.json';
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
    var fmt = DateFormat('yyyyMMddHHmmssSSS');
    var versionName = fmt.format(now);
    if (tag != null) {
      versionName += '-$tag';
    }
    return versionName;
  }

  Directory get _migrationsBaseDirectory =>
      MigrationConstants.migrationsBaseDirectory(directory);

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required int priority,
    required GeneratorConfig config,
    bool write = true,
  }) async {
    var migrationRegistry = MigrationRegistry.load(
      _migrationsBaseDirectory,
    );

    var databaseDefinitionLatest = await _getSourceDatabaseDefinition(
      projectName,
      migrationRegistry.getLatest(),
      priority,
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
      priority,
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

    var migrationVersion = MigrationVersion(
      moduleName: projectName,
      projectDirectory: Directory(
        path.join(_migrationsBaseDirectory.path, versionName),
      ),
      versionName: versionName,
      migration: migration,
      databaseDefinitionProject: databaseDefinitionProject,
      databaseDefinitionFull: databaseDefinitionNext,
    );

    if (write) {
      await migrationVersion.write();
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

  Future<bool> repairMigration({
    String? tag,
    required bool force,
    required String runMode,
    String? targetMigrationVersion,
  }) async {
    var migrationVersion =
        targetMigrationVersion ?? _getLatestMigrationVersion(projectName);

    DatabaseDefinition dstDatabase = await _getSourceDatabaseDefinition(
      projectName,
      migrationVersion,
      0,
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
      priority: 0,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return false;
    }

    bool versionsMismatch = _moduleVersionMismatch(liveDatabase, dstDatabase);

    if (migration.isEmpty && !versionsMismatch && !force) {
      log.info('No changes detected.');
      return false;
    }

    var repairMigrationName = createVersionName(tag);

    var moduleVersions = dstDatabase.installedModules.fold(
      <String, String>{},
      (moduleVersions, element) {
        moduleVersions.addAll({element.module: element.version});
        return moduleVersions;
      },
    );
    moduleVersions[MigrationConstants.repairMigrationModuleName] =
        repairMigrationName;

    _writeRepairMigration(
      repairMigrationName,
      migration,
      moduleVersions,
    );

    return true;
  }

  Future<DatabaseDefinition> _getSourceDatabaseDefinition(
    String moduleName,
    String? migrationVersionName,
    int priority,
  ) async {
    if (migrationVersionName == null) {
      return DatabaseDefinition(
        moduleName: moduleName,
        tables: [],
        priority: priority,
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

  String? _getLatestMigrationVersion(String projectName) {
    var migrationsDirectory = Directory(
      path.join(
        _migrationsBaseDirectory.path,
        projectName,
      ),
    );

    var migrationRegistry = MigrationRegistry.load(migrationsDirectory);

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
      priority: databaseDefinitionProject.priority,
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
    required this.moduleName,
    required Directory projectDirectory,
    required this.versionName,
    required this.migration,
    required this.databaseDefinitionProject,
    required this.databaseDefinitionFull,
  }) : _projectDirectory = projectDirectory;

  final Directory _projectDirectory;

  final String moduleName;
  final String versionName;
  final DatabaseMigration migration;
  final DatabaseDefinition databaseDefinitionProject;
  final DatabaseDefinition databaseDefinitionFull;
  int get priority => migration.priority;

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

  Future<void> write() async {
    if (_projectDirectory.existsSync()) {
      throw MigrationVersionAlreadyExistsException(
        directoryPath: _projectDirectory.path,
      );
    }
    await _projectDirectory.create(recursive: true);

    // Create sql for definition and migration
    var definitionSql = databaseDefinitionFull.toPgSql(
      module: moduleName,
      version: versionName,
    );

    var migrationSql = migration.toPgSql(
      versions: {moduleName: versionName},
    );

    // Write the database definition JSON file
    var definitionFile = MigrationConstants.databaseDefinitionProjectJSONPath(
      _projectDirectory,
      versionName,
    );
    var definitionData = SerializationManager.encode(
      databaseDefinitionProject,
      formatted: true,
    );
    await definitionFile.writeAsString(definitionData);

    // Write the database full definition JSON file
    var definitionFullFile = MigrationConstants.databaseDefinitionJSONPath(
      _projectDirectory,
      versionName,
    );
    var definitionFullData = SerializationManager.encode(
      databaseDefinitionFull,
      formatted: true,
    );
    await definitionFullFile.writeAsString(definitionFullData);

    // Write the database definition SQL file
    var definitionSqlFile = MigrationConstants.databaseDefinitionSQLPath(
      _projectDirectory,
      versionName,
    );
    await definitionSqlFile.writeAsString(definitionSql);

    // Write the migration definition JSON file
    var migrationFile = MigrationConstants.databaseMigrationJSONPath(
      _projectDirectory,
      versionName,
    );
    var migrationData = SerializationManager.encode(
      migration,
      formatted: true,
    );
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = MigrationConstants.databaseMigrationSQLPath(
      _projectDirectory,
      versionName,
    );
    await migrationSqlFile.writeAsString(migrationSql);
  }
}
