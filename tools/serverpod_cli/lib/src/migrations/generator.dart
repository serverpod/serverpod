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
const _fileNameDefinitionJson = 'definition.json';
const _fileNameDefinitionFullJson = 'definition_full.json';
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

  Directory get migrationsBaseDirectory =>
      MigrationConstants.migrationsBaseDirectory(directory);

  Directory get migrationsProjectDirectory => Directory(path.join(
        migrationsBaseDirectory.path,
        projectName,
      ));

  Future<MigrationVersion?> createMigration({
    String? tag,
    required bool force,
    required int priority,
    required GeneratorConfig config,
    bool write = true,
  }) async {
    var migrationRegistry = MigrationRegistry.load(
      migrationsProjectDirectory,
    );

    var databaseDefinitionLatest = await _getSourceDatabaseDefinition(
      migrationRegistry.getLatest(),
      priority,
      getFull: false,
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
      databaseTarget: databaseDefinitionProject,
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
      versionDirectory: Directory(
        path.join(migrationsProjectDirectory.path, versionName),
      ),
      versionName: versionName,
      migration: migration,
      databaseDefinitionProject: databaseDefinitionProject,
      databaseDefinitionFull: databaseDefinitionNext,
    );

    if (write) {
      await migrationVersion.write(module: projectName);
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
    String? migrationVersionName,
    int priority, {
    bool getFull = true,
  }) async {
    if (migrationVersionName == null) {
      return DatabaseDefinition(
        tables: [],
        priority: priority,
        installedModules: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );
    }

    var migrationVersion = await MigrationVersion.load(
      moduleName: projectName,
      versionName: migrationVersionName,
      migrationDirectory: migrationsBaseDirectory,
    );

    return getFull
        ? migrationVersion.databaseDefinitionFull
        : migrationVersion.databaseDefinitionProject;
  }

  String? _getLatestMigrationVersion(String projectName) {
    var migrationsDirectory = Directory(
      path.join(
        migrationsBaseDirectory.path,
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
    String? targetMigrationVersion,
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
        versionName: targetMigrationVersion ?? versionName,
        migrationDirectory: MigrationConstants.migrationsBaseDirectory(
          Directory.fromUri(modulePath),
        ),
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
    required Directory versionDirectory,
    required this.versionName,
    required this.migration,
    required this.databaseDefinitionProject,
    required this.databaseDefinitionFull,
  }) : _versionDirectory = versionDirectory;

  final Directory _versionDirectory;

  final String moduleName;
  final String versionName;
  final DatabaseMigration migration;
  final DatabaseDefinition databaseDefinitionProject;
  final DatabaseDefinition databaseDefinitionFull;
  int get priority => migration.priority;

  static Future<MigrationVersion> load({
    required String moduleName,
    required String versionName,
    required Directory migrationDirectory,
  }) async {
    try {
      var versionDir = Directory(
        path.join(migrationDirectory.path, moduleName, versionName),
      );

      // Get the serialization manager
      var serializationManager = Protocol();

      // Load the database definition
      var databaseDefinitionPath = path.join(
        versionDir.path,
        _fileNameDefinitionJson,
      );
      var databaseDefinition = await _readMigrationDataFile<DatabaseDefinition>(
        databaseDefinitionPath,
        serializationManager,
      );

      var databaseDefinitionFullPath = path.join(
        versionDir.path,
        _fileNameDefinitionFullJson,
      );
      var databaseDefinitionFull =
          await _readMigrationDataFile<DatabaseDefinition>(
        databaseDefinitionFullPath,
        serializationManager,
      );

      // Load the migration definition
      var migrationPath = path.join(
        versionDir.path,
        _fileNameMigrationJson,
      );
      var migrationDefinition = await _readMigrationDataFile<DatabaseMigration>(
        migrationPath,
        serializationManager,
      );

      return MigrationVersion(
        moduleName: moduleName,
        versionDirectory: versionDir,
        versionName: versionName,
        migration: migrationDefinition,
        databaseDefinitionProject: databaseDefinition,
        databaseDefinitionFull: databaseDefinitionFull,
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
    String definitionPath,
    Protocol serializationManager,
  ) async {
    var definitionFile = File(definitionPath);
    var data = await definitionFile.readAsString();
    var content = serializationManager.decode<T>(
      data,
    );
    return content;
  }

  Future<void> write({
    required String module,
  }) async {
    if (_versionDirectory.existsSync()) {
      throw MigrationVersionAlreadyExistsException(
        directoryPath: _versionDirectory.path,
      );
    }
    await _versionDirectory.create(recursive: true);

    // Create sql for definition and migration
    var definitionSql = databaseDefinitionProject.toPgSql(
      module: module,
      version: versionName,
    );

    var migrationSql = migration.toPgSql(
      versions: {module: versionName},
    );

    // Write the database definition JSON file
    var definitionFile = File(path.join(
      _versionDirectory.path,
      _fileNameDefinitionJson,
    ));
    var definitionData = SerializationManager.encode(
      databaseDefinitionProject,
      formatted: true,
    );
    await definitionFile.writeAsString(definitionData);

    // Write the database full definition JSON file
    var definitionFullFile = File(path.join(
      _versionDirectory.path,
      _fileNameDefinitionFullJson,
    ));
    var definitionFullData = SerializationManager.encode(
      databaseDefinitionFull,
      formatted: true,
    );
    await definitionFullFile.writeAsString(definitionFullData);

    // Write the database definition SQL file
    var definitionSqlFile = File(path.join(
      _versionDirectory.path,
      _fileNameDefinitionSql,
    ));
    await definitionSqlFile.writeAsString(definitionSql);

    // Write the migration definition JSON file
    var migrationFile = File(path.join(
      _versionDirectory.path,
      _fileNameMigrationJson,
    ));
    var migrationData = SerializationManager.encode(
      migration,
      formatted: true,
    );
    await migrationFile.writeAsString(migrationData);

    // Write the migration definition SQL file
    var migrationSqlFile = File(path.join(
      _versionDirectory.path,
      _fileNameMigrationSql,
    ));
    await migrationSqlFile.writeAsString(migrationSql);
  }
}
