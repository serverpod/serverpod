import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/database/sql_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_database/serverpod_database.dart';
// This is a temporary internal import since the normalize functions are not
// meant to be exported from the database package. It will be removed once the
// [MigrationGenerator] gets moved to the database package.
// ignore: implementation_imports
import 'package:serverpod_database/src/definition/definition_normalizer.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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

  /// Creates a new migration version.
  /// If [tag] is specified, the migration will be tagged with the given name.
  /// If [force] is true, the migration will be created even if there are
  /// warnings.
  /// If [write] is false, the migration will not be written to disk.
  ///
  /// Returns the migration version, or null if no migration was created.
  ///
  /// Throws [MigrationVersionLoadException] if the a migration version
  /// could not be loaded.
  /// Throws [GenerateMigrationDatabaseDefinitionException] if the database
  /// definition could not be created from project models.
  /// Throws [MigrationVersionAlreadyExistsException] if the migration version
  /// already exists.
  MigrationArtifactStore get _artifactStore =>
      FileSystemMigrationArtifactStore(projectDirectory: directory);

  Future<MigrationVersionArtifacts?> createMigration({
    String? tag,
    required bool force,
    required GeneratorConfig config,
    bool write = true,
  }) async {
    var versions = await _artifactStore.listVersions();
    var latestVersion = versions.lastOrNull;

    var databaseDefinitionLatest = await _getSourceDatabaseDefinition(
      projectName,
      latestVersion,
    );

    var models = await ModelHelper.loadProjectYamlModelsFromDisk(
      config,
    );
    var modelDefinitions = StatefulAnalyzer(config, models, (uri, collector) {
      collector.printErrors();

      if (collector.hasSevereErrors) {
        throw GenerateMigrationDatabaseDefinitionException();
      }
    }).validateAll();

    var databaseDefinitionProject = createDatabaseDefinitionFromModels(
      modelDefinitions,
      config.name,
      config.modulesAll,
    );

    var databaseDefinitions = await _loadModuleDatabaseDefinitions(
      config.modulesDependent,
      directory,
    );

    var versionName = createVersionName(tag);
    var nextMigrationVersion = DatabaseMigrationVersionModel(
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
      throw const MigrationAbortedException();
    }

    if (migration.isEmpty) {
      log.info(
        'No changes detected.',
      );
      return null;
    }

    var sqlGenerator = SqlGenerator.forDialect(config.databaseDialect);

    // Filter the elements here to keep the definition files complete. Only
    // the migration and definition SQL will be filtered by the dialect.
    var databaseDefinitionNextForDialect = databaseDefinitionNext.forDialect(
      config.databaseDialect,
      logWarnings: log.warning,
    );

    var artifacts = MigrationVersionArtifacts(
      version: versionName,
      definitionSql: sqlGenerator.generateDatabaseDefinitionSql(
        databaseDefinitionNextForDialect,
        installedModules: databaseDefinitionNext.installedModules,
      ),
      migrationSql: sqlGenerator.generateDatabaseMigrationSql(
        migration,
        databaseDefinitionNextForDialect,
        installedModules: databaseDefinitionNext.installedModules,
        removedModules: _removedModulesDiff(
          databaseDefinitionLatest.installedModules,
          databaseDefinitionNext.installedModules,
        ),
      ),
      definition: databaseDefinitionNext,
      projectDefinition: databaseDefinitionProject,
      migration: migration,
    );

    if (write) {
      await _artifactStore.writeVersion(artifacts);
      versions.add(versionName);
      await _artifactStore.writeVersionRegistry(versions);
    }

    return artifacts;
  }

  Future<Iterable<DatabaseDefinition>> _loadModuleDatabaseDefinitions(
    List<ModuleConfig> modules,
    Directory projectFolder,
  ) async {
    var versions = await _loadMigrationVersionsFromModules(
      modules,
      directory: projectFolder,
    );
    return versions.map((e) => e.projectDefinition);
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
    required DatabaseDialect dialect,
    String? targetMigrationVersion,
  }) async {
    var migrationVersion =
        targetMigrationVersion ??
        (await _artifactStore.listVersions()).lastOrNull;

    await _validateRepairMigrationVersion(migrationVersion);

    DatabaseDefinition dstDatabase = await _getSourceDatabaseDefinition(
      projectName,
      migrationVersion,
    );

    // Stored artifacts use the full merged definition (same as create-migration
    // before SQL is generated). The live database only contains objects that
    // exist for this dialect, so we must compare against the dialect-filtered
    // target—otherwise unsupported indexes (etc.) appear as spurious drift.
    var dstDatabaseForDialect = dstDatabase.forDialect(
      dialect,
      logWarnings: log.warning,
    );

    var client = ConfigInfo(runMode).createServiceClient();
    DatabaseDefinition liveDatabase;
    try {
      liveDatabase = normalizeDefinitionToV2(
        await client.insights.getLiveDatabaseDefinition(),
      );
    } catch (e) {
      throw MigrationLiveDatabaseDefinitionException(
        exception: e.toString(),
      );
    } finally {
      client.close();
    }

    var migration = generateDatabaseMigration(
      databaseSource: liveDatabase,
      databaseTarget: dstDatabaseForDialect,
    );

    var warnings = migration.warnings;
    _printWarnings(warnings);

    if (warnings.isNotEmpty && !force) {
      log.info('Migration aborted. Use --force to ignore warnings.');
      return null;
    }

    bool versionsMismatch = _moduleVersionMismatch(liveDatabase, dstDatabase);

    if (migration.isEmpty && !versionsMismatch && !force) {
      log.info(
        'No changes detected. Use --force to create an empty repair migration.',
      );
      return null;
    }

    var repairMigrationName = createVersionName(tag);

    var installedModules = [
      ...dstDatabase.installedModules,
      DatabaseMigrationVersionModel(
        module: MigrationConstants.repairMigrationModuleName,
        version: repairMigrationName,
      ),
    ];

    List<DatabaseMigrationVersionModel> removedModules = _removedModulesDiff(
      liveDatabase.installedModules,
      installedModules,
    );

    return await _writeRepairMigration(
      repairMigrationName,
      migration,
      dstDatabaseForDialect,
      installedModules,
      removedModules,
      dialect,
    );
  }

  Future<void> _validateRepairMigrationVersion(String? migrationVersion) async {
    var versions = await _artifactStore.listVersions();

    if (migrationVersion == null || !versions.contains(migrationVersion)) {
      throw MigrationRepairTargetNotFoundException(
        targetName: migrationVersion,
        versionsFound: versions,
      );
    }
  }

  List<DatabaseMigrationVersionModel> _removedModulesDiff(
    List<DatabaseMigrationVersionModel> preInstalledModules,
    List<DatabaseMigrationVersionModel> postInstalledModules,
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

    try {
      var artifacts = await _artifactStore.readVersion(migrationVersionName);
      if (artifacts == null) {
        throw MigrationVersionLoadException(
          versionName: migrationVersionName,
          moduleName: projectName,
          exception: 'Migration version not found.',
        );
      }
      return artifacts.definition;
    } catch (e) {
      if (e is MigrationVersionLoadException) rethrow;
      throw MigrationVersionLoadException(
        versionName: migrationVersionName,
        moduleName: moduleName,
        exception: e.toString(),
      );
    }
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
      if (targetModules.any(
        (version) =>
            version.module == module.module &&
            version.version != module.version,
      )) {
        return true;
      }
    }

    return false;
  }

  Future<List<MigrationVersionArtifacts>> _loadMigrationVersionsFromModules(
    List<ModuleConfig> modules, {
    required Directory directory,
  }) async {
    var selectedModules = modules.where(
      (module) => module.migrationVersions.isNotEmpty,
    );

    var moduleMigrationArtifacts = <MigrationVersionArtifacts>[];

    for (var module in selectedModules) {
      var versionName = module.migrationVersions.last;
      var uri = Uri(
        scheme: 'file', // assuming the module is local
        pathSegments: module.serverPackageDirectoryPathParts,
      );
      var moduleArtifactStore = FileSystemMigrationArtifactStore(
        projectDirectory: Directory.fromUri(uri),
      );

      var artifacts = await moduleArtifactStore.readVersion(versionName);
      if (artifacts == null) {
        throw MigrationVersionLoadException(
          versionName: versionName,
          moduleName: module.name,
          exception: 'Migration version not found.',
        );
      }

      moduleMigrationArtifacts.add(artifacts);
    }

    return moduleMigrationArtifacts;
  }

  DatabaseDefinition _mergeDatabaseDefinitions(
    DatabaseDefinition databaseDefinitionProject,
    Iterable<DatabaseDefinition> databaseDefinitions,
    DatabaseMigrationVersionModel nextProjectMigrationVersion,
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
      schemaVersion: currentSchemaVersion,
      moduleName: databaseDefinitionProject.moduleName,
      tables: tables,
      installedModules: installedModules,
      migrationApiVersion: databaseDefinitionProject.migrationApiVersion,
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

  Future<File> _writeRepairMigration(
    String repairMigrationName,
    DatabaseMigration migration,
    DatabaseDefinition databaseDefinition,
    List<DatabaseMigrationVersionModel> installedModules,
    List<DatabaseMigrationVersionModel> removedModules,
    DatabaseDialect dialect,
  ) async {
    var sqlGenerator = SqlGenerator.forDialect(dialect);

    var repairMigrationSql = sqlGenerator.generateDatabaseMigrationSql(
      migration,
      databaseDefinition,
      installedModules: installedModules,
      removedModules: removedModules,
    );

    await _artifactStore.writeRepairMigration(
      RepairMigration(
        version: repairMigrationName,
        migrationSql: repairMigrationSql,
      ),
    );

    return File(
      path.join(
        MigrationConstants.repairMigrationDirectory(directory).path,
        '$repairMigrationName.sql',
      ),
    );
  }
}
