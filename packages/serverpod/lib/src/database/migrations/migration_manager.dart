import 'dart:io';
import 'package:collection/collection.dart';
import 'package:serverpod/protocol.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/analyze.dart';
import 'package:serverpod/src/database/migrations/migrations.dart';
import 'package:serverpod/src/database/migrations/repair_migrations.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../extensions.dart';

/// The migration manager handles migrations of the database.
class MigrationManager {
  /// List of installed migration versions. Available after [initialize] has
  /// been called.
  final List<DatabaseMigrationVersion> installedVersions = [];

  /// List of available migration versions as loaded from the migrations
  /// directory. Available after [initialize] has been called.
  final List<String> availableVersions = [];

  /// Initializing the [MigrationManager] by loading the current version
  /// from the database and available migrations.
  Future<void> initialize(Session session) async {
    // Get installed versions
    installedVersions.clear();
    try {
      installedVersions.addAll(await DatabaseMigrationVersion.db.find(session));
    } catch (e) {
      // Table might not exist and we therefore ignore and assume no versions.
    }

    // Get available migrations

    var warnings = <String>[];
    try {
      availableVersions.addAll(MigrationVersions.listVersions());
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

  /// Returns true if the database structure is up to date. If not, it will
  /// print a warning to stderr.
  Future<bool> verifyDatabaseIntegrity(Session session) async {
    var warnings = <String>[];

    var liveDatabase = await DatabaseAnalyzer.analyze(session.dbNext);
    var targetDatabase =
        session.serverpod.serializationManager.getTargetDatabaseDefinition();

    for (var table in targetDatabase.tables) {
      var liveTable = liveDatabase.findTableNamed(table.name);
      if (liveTable == null) {
        warnings.add('Table "${table.name}" is missing.');
        continue;
      }
      if (!liveTable.like(table)) {
        warnings.add('Table "${table.name}" is not like the target database.');
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
    }

    return warnings.isEmpty;
  }

  /// Returns the latest version of the given module from available migrations.
  String getLatestVersion() {
    if (availableVersions.isEmpty) {
      throw Exception('No migrations found in project.');
    }
    return availableVersions.last;
  }

  /// Returns true if the latest version of a module is installed.
  bool isVersionInstalled(String module, String version) {
    var installed = installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return false;
    }
    return version == installed.version;
  }

  /// Returns true if any version of the given module is installed.
  bool isAnyInstalled(String module) {
    return getInstalledVersion(module) != null;
  }

  /// Returns the installed version of the given module, or null if no version
  /// is installed.
  String? getInstalledVersion(String module) {
    var installed = installedVersions.firstWhereOrNull(
      (element) => element.module == module,
    );
    if (installed == null) {
      return null;
    }
    return installed.version;
  }

  /// Lists all versions newer than the given version for the given module.
  List<String> getVersionsToApply(String fromVersion) {
    if (availableVersions.isEmpty) return [];

    var index = availableVersions.indexOf(fromVersion);
    if (index == -1) {
      throw Exception('Version $fromVersion not found in project.');
    }
    return availableVersions.sublist(index + 1);
  }

  /// Applies the repair migration to the database.
  Future<void> applyRepairMigration(Session session) async {
    var repairMigration = RepairMigration.load(Directory.current);
    if (repairMigration == null) {
      return;
    }

    var appliedRepairMigration = await DatabaseMigrationVersion.db.findFirstRow(
        session,
        where: (t) =>
            t.module.equals(MigrationConstants.repairMigrationModuleName));

    if (appliedRepairMigration != null &&
        appliedRepairMigration.version == repairMigration.versionName) {
      return;
    }

    await session.dbNext.unsafeExecute(repairMigration.sqlMigration);
  }

  /// Migrates all modules to the latest version.
  Future<void> migrateToLatest(Session session) async {
    var latestVersion = getLatestVersion();

    var targetDefinition =
        session.serverpod.serializationManager.getTargetDatabaseDefinition();

    if (!isVersionInstalled(targetDefinition.moduleName, latestVersion)) {
      var installedVersion = getInstalledVersion(targetDefinition.moduleName);

      await _migrateToLatestModule(
        session,
        toVersion: latestVersion,
        fromVersion: installedVersion,
      );
    }
  }

  /// Migration a single module to the latest version.
  Future<void> _migrateToLatestModule(
    Session session, {
    required String toVersion,
    String? fromVersion,
  }) async {
    var sqlToExecute = await _loadMigrationSQL(fromVersion, toVersion);

    for (var sql in sqlToExecute) {
      try {
        await session.dbNext.unsafeExecute(sql);
      } catch (e) {
        stderr.writeln('Failed to apply migration $toVersion.');
        stderr.writeln('$e');
        rethrow;
      }
    }
  }

  Future<List<String>> _loadMigrationSQL(
    String? fromVersion,
    String toVersion,
  ) async {
    var sqlToExecute = <String>[];

    if (fromVersion == null) {
      var definitionSqlFile = MigrationConstants.databaseDefinitionSQLPath(
        Directory.current,
        toVersion,
      );
      var sqlDefinition = await definitionSqlFile.readAsString();

      sqlToExecute.add(sqlDefinition);
    } else {
      var newerVersions = getVersionsToApply(toVersion);

      for (var version in newerVersions) {
        var migrationSqlFile = MigrationConstants.databaseMigrationSQLPath(
          Directory.current,
          version,
        );
        var sqlMigration = await migrationSqlFile.readAsString();

        sqlToExecute.add(sqlMigration);
      }
    }

    return sqlToExecute;
  }
}
