import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart';

import '../../serverpod_database.dart';
import '../migrations/table_comparison_warning.dart';

/// The migration manager handles migrations of the database.
abstract class MigrationManager {
  final MigrationArtifactStoreReader _artifactStore;

  /// The run mode of the server.
  ///
  /// This is used to determine if additional database integrity checks should
  /// be run, since they can be expensive and not matter in production.
  ///
  /// If the run mode is not set, the migration manager will not run any
  /// additional database integrity checks. This config only matters if using
  /// the [MigrationManager] to run migrations. For other use cases, the run
  /// mode is not relevant.
  final String? runMode;

  /// List of installed migration versions. Available after starting a migration
  /// or repair migration.
  final List<DatabaseMigrationVersionModel> _installedVersions = [];

  /// List of available migration versions as loaded from the migrations
  /// directory. Available after starting a migration or repair migration.
  @visibleForTesting
  final List<String> availableVersions = [];

  /// Creates a new migration manager.
  MigrationManager(this._artifactStore, {this.runMode});

  /// Loads the installed versions of the migrations from the database.
  ///
  /// This method depends on the table model that will be available only in the
  /// server/client package.
  Future<List<DatabaseMigrationVersionModel>> loadInstalledVersions(
    DatabaseSession session, {
    Transaction? transaction,
  });

  /// Loads the installed repair migration from the database.
  ///
  /// This method depends on the table model that will be available only in the
  /// server/client package.
  Future<DatabaseMigrationVersionModel?> loadInstalledRepairMigration(
    DatabaseSession session, {
    Transaction? transaction,
  });

  /// Lists all available migration versions.
  Future<List<String>> listAvailableVersions() async {
    return await _artifactStore.listVersions();
  }

  /// Applies the repair migration to the database.
  Future<String?> applyRepairMigration(DatabaseSession session) async {
    var repairMigration = await _artifactStore.readRepairMigration();
    if (repairMigration == null) {
      return null;
    }

    String? appliedVersion = repairMigration.version;
    await _withMigrationLock(session, (transaction) async {
      var appliedRepairMigration = await loadInstalledRepairMigration(
        session,
        transaction: transaction,
      );

      if (appliedRepairMigration != null &&
          appliedRepairMigration.version == repairMigration.version) {
        appliedVersion = null;
        return;
      }

      await session.db.unsafeSimpleExecute(
        repairMigration.migrationSql,
        transaction: transaction,
      );

      await _updateState(session, transaction);
    });

    return appliedVersion;
  }

  /// Loads the module name from the latest available migration definition.
  ///
  /// Returns the module name from the `definition.json` of the last available
  /// migration version, or null if not found or if parsing fails.
  Future<String?> _loadLatestDefinitionModuleName() async {
    if (availableVersions.isEmpty) return null;

    var latestVersion = availableVersions.last;
    return await _artifactStore.loadDefinitionModuleName(latestVersion);
  }

  /// Migrates all modules to the latest version.
  ///
  /// Returns the migrations applied.
  /// Returns null if latest version was already installed.
  Future<List<String>?> migrateToLatest(DatabaseSession session) async {
    List<String>? migrationsApplied = [];

    await _withMigrationLock(session, (transaction) async {
      await _updateState(session, transaction);
      var latestVersion = _getLatestVersion();

      var moduleName = session.db.serializationManager.getModuleName();

      var definitionModuleName = await _loadLatestDefinitionModuleName();
      if (definitionModuleName != null && definitionModuleName != moduleName) {
        log.warning(
          'The module name in the migration definition '
          '("$definitionModuleName") does not match the module name of the '
          'serialization manager ("$moduleName"). This may indicate that the '
          'wrong Protocol class is being used in "server.dart". Make sure you '
          'are using the Protocol class generated under '
          '"src/generated/protocol.dart" and not one from an external package.',
        );
      }

      if (_isVersionInstalled(moduleName, latestVersion)) {
        migrationsApplied = null;
        return;
      }

      var installedVersion = _getInstalledVersion(moduleName);

      migrationsApplied = await _migrateToLatestModule(
        session,
        latestVersion: latestVersion,
        fromVersion: installedVersion,
        transaction: transaction,
      );
      await _updateState(session, transaction);
    });

    return migrationsApplied;
  }

  /// Returns the installed version of the given module, or null if no version
  /// is installed.
  String? _getInstalledVersion(String module) {
    var installed = _installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return null;
    }
    return installed.version;
  }

  /// Returns the latest version of the given module from available migrations.
  String _getLatestVersion() {
    if (availableVersions.isEmpty) {
      throw Exception('No migrations found in project.');
    }
    return availableVersions.last;
  }

  /// Lists all versions newer than the given version for the given module.
  List<String> _getVersionsToApply(String fromVersion) {
    if (availableVersions.isEmpty) return [];

    var index = availableVersions.indexOf(fromVersion);
    if (index == -1) {
      throw Exception(
        'DB has migration version $fromVersion registered but it is not found in the project files.',
      );
    }
    return availableVersions.sublist(index + 1);
  }

  /// Returns true if the latest version of a module is installed.
  bool _isVersionInstalled(String module, String version) {
    var installed = _installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return false;
    }
    return version == installed.version;
  }

  Future<List<({String version, String sql})>> _loadMigrationSQL(
    String? fromVersion,
    String latestVersion,
  ) async {
    var sqlToExecute = <({String version, String sql})>[];

    if (fromVersion == null) {
      var latestArtifacts = await _artifactStore.readVersionSql(
        latestVersion,
      );
      var sqlDefinition = latestArtifacts?.definitionSql;
      if (sqlDefinition == null) {
        throw Exception(
          'Definition for migration version $latestVersion could not be loaded.',
        );
      }

      sqlToExecute.add((version: latestVersion, sql: sqlDefinition));
    } else {
      var newerVersions = _getVersionsToApply(fromVersion);

      for (var version in newerVersions) {
        var versionArtifacts = await _artifactStore.readVersionSql(
          version,
        );
        var sqlMigration = versionArtifacts?.migrationSql;
        if (sqlMigration == null) {
          throw Exception(
            'Migration for version $version could not be loaded.',
          );
        }

        sqlToExecute.add((version: version, sql: sqlMigration));
      }
    }

    return sqlToExecute;
  }

  /// Migration a single module to the latest version.
  ///
  /// Returns the migrations applied.
  Future<List<String>> _migrateToLatestModule(
    DatabaseSession session, {
    required String latestVersion,
    String? fromVersion,
    Transaction? transaction,
  }) async {
    var sqlToExecute = await _loadMigrationSQL(fromVersion, latestVersion);

    var migrationsApplied = <String>[];
    for (var code in sqlToExecute) {
      try {
        await session.db.unsafeSimpleExecute(
          code.sql,
          transaction: transaction,
        );
        migrationsApplied.add(code.version);
      } catch (e) {
        log.error('Failed to apply migration ${code.version}.', error: e);
        rethrow;
      }
    }

    return migrationsApplied;
  }

  /// Updates the state of the [MigrationManager] by loading the current version
  /// from the database and available migrations.
  Future<void> _updateState(
    DatabaseSession session,
    Transaction? transaction,
  ) async {
    _installedVersions.clear();
    try {
      _installedVersions.addAll(
        await loadInstalledVersions(session, transaction: transaction),
      );
    } catch (e) {
      // Table might not exist and we therefore ignore and assume no versions.
    }

    availableVersions.clear();
    var warnings = <String>[];
    try {
      availableVersions.addAll(
        await _artifactStore.listVersions(),
      );
    } catch (e) {
      warnings.add(
        'Failed to determine migration versions for project: ${e.toString()}',
      );
    }

    if (warnings.isNotEmpty) {
      log.warning(
        'The following module migration registries could not be loaded:\n'
        '${warnings.map((w) => ' - $w').join('\n')}',
      );
    }
  }

  Future<void> _withMigrationLock(
    DatabaseSession session,
    Future<void> Function(Transaction? transaction) action,
  ) async {
    final provider = DatabaseProvider.forDialect(session.db.dialect);
    final migrationRunner = provider.createMigrationRunner(runMode: runMode);
    await migrationRunner.runMigrations(session, action);
  }

  /// Returns true if the database structure is up to date. If not, it
  /// logs a warning via the global [log].
  static Future<bool> verifyDatabaseIntegrity(DatabaseSession session) async {
    var warnings = <String>[];

    var liveDatabase = await session.db.analyzer.analyze();
    var targetTables = session.db.analyzer.getTargetTableDefinitions();

    for (var table in targetTables) {
      var liveTable = liveDatabase.findTableNamed(table.name);
      if (liveTable == null) {
        warnings.add('Table "${table.name}" is missing.');
        continue;
      }
      var mismatches = liveTable.like(table).asStringList();

      if (mismatches.isNotEmpty) {
        warnings.add(
          'Table "${table.name}" is not like the target database:\n'
          ' - ${mismatches.join('\n - ')}',
        );
        continue;
      }
    }
    if (warnings.isNotEmpty) {
      log.warning(
        'The database does not match the target database:\n'
        '${warnings.map((w) => ' - $w').join('\n')}\n'
        'Hint: Did you forget to run `serverpod generate`, apply the migrations '
        '(--apply-migrations), or run a repair migration (--apply-repair-migration)?',
      );
    }

    return warnings.isEmpty;
  }
}

/// Handles migrations for client-side databases.
class ClientMigrationManager extends MigrationManager {
  /// Creates a manager for the given in-memory [migrations] and [moduleName].
  ClientMigrationManager({
    required super.runMode,
    required List<MigrationVersionSql> migrations,
    required String moduleName,
  }) : super(
         RuntimeListMigrationArtifactStore(
           migrations,
           moduleName: moduleName,
         ),
       );

  @override
  Future<List<DatabaseMigrationVersionModel>> loadInstalledVersions(
    DatabaseSession session, {
    Transaction? transaction,
  }) async {
    // NOTE: This should be replaced by a proper find on the model once tables
    // are available for shared package models. Currently, only the server and
    // client packages have access to the [DatabaseMigrationVersion] model.
    final result = await session.db.unsafeQuery(
      'SELECT * FROM "serverpod_migrations";',
      transaction: transaction,
    );

    return [
      for (final row in result)
        DatabaseMigrationVersionModel.fromJson(
          row.toColumnMap(),
        ),
    ];
  }

  @override
  Future<DatabaseMigrationVersionModel?> loadInstalledRepairMigration(
    DatabaseSession session, {
    Transaction? transaction,
  }) async {
    return null;
  }
}
