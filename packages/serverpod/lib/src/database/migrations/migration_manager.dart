import 'dart:io';

import 'package:collection/collection.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/analyze.dart';
import 'package:serverpod/src/database/migrations/migrations.dart';
import 'package:serverpod/src/database/migrations/repair_migrations.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../extensions.dart';

/// The migration manager handles migrations of the database.
class MigrationManager {
  final Directory _projectDirectory;

  /// List of installed migration versions. Available after [initialize] has
  /// been called.
  final List<DatabaseMigrationVersion> installedVersions = [];

  /// List of available migration versions as loaded from the migrations
  /// directory. Available after [initialize] has been called.
  final List<String> availableVersions = [];

  /// Creates a new migration manager.
  ///
  /// The [projectDirectory] is the directory where the project is located.
  MigrationManager(this._projectDirectory);

  /// Applies the repair migration to the database.
  Future<String?> applyRepairMigration(Session session) async {
    var repairMigration = RepairMigration.load(_projectDirectory);
    if (repairMigration == null) {
      return null;
    }

    String? appliedVersionName = repairMigration.versionName;
    await _withMigrationLock(session, () async {
      var appliedRepairMigration = await DatabaseMigrationVersion.db
          .findFirstRow(session,
              where: (t) => t.module
                  .equals(MigrationConstants.repairMigrationModuleName));

      if (appliedRepairMigration != null &&
          appliedRepairMigration.version == repairMigration.versionName) {
        appliedVersionName = null;
        return;
      }

      await session.db.unsafeSimpleExecute(
        repairMigration.sqlMigration,
      );

      await _updateState(session);
    });

    return appliedVersionName;
  }

  /// Migrates all modules to the latest version.
  ///
  /// Returns the migrations applied.
  /// Returns null if latest version was already installed.
  Future<List<String>?> migrateToLatest(Session session) async {
    List<String>? migrationsApplied = [];

    await _withMigrationLock(session, () async {
      await _updateState(session);
      var latestVersion = _getLatestVersion();

      var moduleName = session.serverpod.serializationManager.getModuleName();

      if (_isVersionInstalled(moduleName, latestVersion)) {
        migrationsApplied = null;
        return;
      }

      var installedVersion = _getInstalledVersion(moduleName);

      migrationsApplied = await _migrateToLatestModule(
        session,
        latestVersion: latestVersion,
        fromVersion: installedVersion,
      );
      await _updateState(session);
    });

    return migrationsApplied;
  }

  /// Returns the installed version of the given module, or null if no version
  /// is installed.
  String? _getInstalledVersion(String module) {
    var installed = installedVersions.firstWhereOrNull(
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
      throw Exception('Version $fromVersion not found in project.');
    }
    return availableVersions.sublist(index + 1);
  }

  /// Returns true if the latest version of a module is installed.
  bool _isVersionInstalled(String module, String version) {
    var installed = installedVersions.firstWhereOrNull(
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
      var definitionSqlFile = MigrationConstants.databaseDefinitionSQLPath(
        _projectDirectory,
        latestVersion,
      );
      var sqlDefinition = await definitionSqlFile.readAsString();

      sqlToExecute.add((version: latestVersion, sql: sqlDefinition));
    } else {
      var newerVersions = _getVersionsToApply(fromVersion);

      for (var version in newerVersions) {
        var migrationSqlFile = MigrationConstants.databaseMigrationSQLPath(
          _projectDirectory,
          version,
        );
        var sqlMigration = await migrationSqlFile.readAsString();

        sqlToExecute.add((version: version, sql: sqlMigration));
      }
    }

    return sqlToExecute;
  }

  /// Migration a single module to the latest version.
  ///
  /// Returns the migrations applied.
  Future<List<String>> _migrateToLatestModule(
    Session session, {
    required String latestVersion,
    String? fromVersion,
  }) async {
    var sqlToExecute = await _loadMigrationSQL(fromVersion, latestVersion);

    var migrationsApplied = <String>[];
    for (var code in sqlToExecute) {
      try {
        await session.db.unsafeSimpleExecute(code.sql);
        migrationsApplied.add(code.version);
      } catch (e) {
        stderr.writeln('Failed to apply migration ${code.version}.');
        stderr.writeln('$e');
        rethrow;
      }
    }

    return migrationsApplied;
  }

  /// Updates the state of the [MigrationManager] by loading the current version
  /// from the database and available migrations.
  Future<void> _updateState(Session session) async {
    installedVersions.clear();
    try {
      installedVersions.addAll(await DatabaseMigrationVersion.db.find(session));
    } catch (e) {
      // Table might not exist and we therefore ignore and assume no versions.
    }

    availableVersions.clear();
    var warnings = <String>[];
    try {
      availableVersions.addAll(MigrationVersions.listVersions(
        projectDirectory: _projectDirectory,
      ));
    } catch (e) {
      warnings.add(
          'Failed to determine migration versions for project: ${e.toString()}');
    }

    if (warnings.isNotEmpty) {
      stderr.writeln(
          'WARNING: The following module migration registries could not be '
          'loaded:');
      for (var warning in warnings) {
        stderr.writeln(' - $warning');
      }
    }
  }

  Future<void> _withMigrationLock(
    Session session,
    Future<void> Function() action,
  ) async {
    const String lockName = 'serverpod_migration_lock';

    /// Use a transaction to ensure that the advisory lock is retained
    /// until the transaction is completed.
    ///
    /// The transaction ensures that the session used for acquiring the
    /// lock is kept alive in the underlying connection pool, and that we
    /// can later use that exact same session for releasing the lock.
    /// The transaction is thus only used to get the desired behavior from
    /// the database driver, and does not have any effect on the Postgres level.
    ///
    /// This ensures that we are only running migrations one at a time.
    await session.db.transaction((transaction) async {
      await session.db.unsafeExecute(
        "SELECT pg_advisory_lock(hashtext('$lockName'));",
        transaction: transaction,
      );

      try {
        await action();
      } finally {
        await session.db.unsafeExecute(
          "SELECT pg_advisory_unlock(hashtext('$lockName'));",
          transaction: transaction,
        );
      }
    });
  }

  /// Returns true if the database structure is up to date. If not, it will
  /// print a warning to stderr.
  static Future<bool> verifyDatabaseIntegrity(Session session) async {
    var warnings = <String>[];

    var liveDatabase = await DatabaseAnalyzer.analyze(session.db);
    var targetTables =
        session.serverpod.serializationManager.getTargetTableDefinitions();

    for (var table in targetTables) {
      var liveTable = liveDatabase.findTableNamed(table.name);
      if (liveTable == null) {
        warnings.add('Table "${table.name}" is missing.');
        continue;
      }
      var mismatches = liveTable.like(table).asStringList();

      if (mismatches.isNotEmpty) {
        warnings.add(
            'Table "${table.name}" is not like the target database:\n - ${mismatches.join('\n - ')}');
        continue;
      }
    }
    if (warnings.isNotEmpty) {
      stderr.writeln(
        'WARNING: The database does not match the target database:',
      );
      for (var warning in warnings) {
        stderr.writeln(' - $warning');
      }
      stderr.writeln(
          'Hint: Did you forget to apply the migrations (--apply-migrations) or run a repair migration (--apply-repair-migration)?');
    }

    return warnings.isEmpty;
  }
}
