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
      // Creating database from scratch - inline pre/post database setup SQL
      var preDatabaseSetupFile = MigrationConstants.preDatabaseSetupSQLPath(
        _projectDirectory,
        latestVersion,
      );
      var postDatabaseSetupFile = MigrationConstants.postDatabaseSetupSQLPath(
        _projectDirectory,
        latestVersion,
      );
      var definitionSqlFile = MigrationConstants.databaseDefinitionSQLPath(
        _projectDirectory,
        latestVersion,
      );

      var preDatabaseSetupSql = preDatabaseSetupFile.existsSync()
          ? await preDatabaseSetupFile.readAsString()
          : '';
      var sqlDefinition = await definitionSqlFile.readAsString();
      var postDatabaseSetupSql = postDatabaseSetupFile.existsSync()
          ? await postDatabaseSetupFile.readAsString()
          : '';

      // Combine pre + definition + post into a single SQL string
      var combinedSql = _combineSQL([
        preDatabaseSetupSql,
        sqlDefinition,
        postDatabaseSetupSql,
      ]);

      sqlToExecute.add((version: latestVersion, sql: combinedSql));
    } else {
      // Rolling forward with migrations - inline pre/post migration SQL
      var newerVersions = _getVersionsToApply(fromVersion);

      for (var version in newerVersions) {
        var preMigrationFile = MigrationConstants.preMigrationSQLPath(
          _projectDirectory,
          version,
        );
        var migrationSqlFile = MigrationConstants.databaseMigrationSQLPath(
          _projectDirectory,
          version,
        );
        var postMigrationFile = MigrationConstants.postMigrationSQLPath(
          _projectDirectory,
          version,
        );

        var preMigrationSql = preMigrationFile.existsSync()
            ? await preMigrationFile.readAsString()
            : '';
        var sqlMigration = await migrationSqlFile.readAsString();
        var postMigrationSql = postMigrationFile.existsSync()
            ? await postMigrationFile.readAsString()
            : '';

        // Combine pre + migration + post into a single SQL string
        var combinedSql = _combineSQL([
          preMigrationSql,
          sqlMigration,
          postMigrationSql,
        ]);

        sqlToExecute.add((version: version, sql: combinedSql));
      }
    }

    return sqlToExecute;
  }

  /// Combines multiple SQL strings into one, removing empty strings
  /// and ensuring proper spacing between SQL blocks.
  String _combineSQL(List<String> sqlParts) {
    var nonEmptySql = sqlParts
        .map((sql) => sql.trim())
        .where((sql) => sql.isNotEmpty)
        .toList();

    if (nonEmptySql.isEmpty) return '';

    return nonEmptySql.join('\n\n');
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

  /// Checks if custom SQL files exist with meaningful content and extracts
  /// table names mentioned in the SQL for scoped leniency.
  ({bool hasCustomSQL, Set<String> affectedTables}) _analyzeCustomSQL() {
    try {
      var versions = MigrationVersions.listVersions(
        projectDirectory: _projectDirectory,
      );
      if (versions.isEmpty) {
        return (hasCustomSQL: false, affectedTables: <String>{});
      }

      var affectedTables = <String>{};
      var hasAnyCustomSQL = false;

      // Check all migrations for custom SQL
      for (var version in versions) {
        final customSqlFiles = [
          MigrationConstants.preDatabaseSetupSQLPath(
              _projectDirectory, version),
          MigrationConstants.postDatabaseSetupSQLPath(
              _projectDirectory, version),
          MigrationConstants.preMigrationSQLPath(_projectDirectory, version),
          MigrationConstants.postMigrationSQLPath(_projectDirectory, version),
        ];

        for (var file in customSqlFiles) {
          if (file.existsSync()) {
            var content = file.readAsStringSync().trim();

            // Check if file has meaningful content
            if (content.isEmpty) continue;

            // Remove SQL comments for analysis
            var contentWithoutComments = content
                .split('\n')
                .where((line) => !line.trim().startsWith('--'))
                .join('\n')
                .trim();

            if (contentWithoutComments.isEmpty) continue;

            hasAnyCustomSQL = true;

            // Extract table names using simple regex patterns
            // Matches: CREATE INDEX ... ON table_name
            final indexPattern = RegExp(
              r'CREATE\s+(?:UNIQUE\s+)?INDEX\s+\S+\s+ON\s+(\w+)',
              caseSensitive: false,
            );

            // Matches: ALTER TABLE table_name
            final alterPattern = RegExp(
              r'ALTER\s+TABLE\s+(\w+)',
              caseSensitive: false,
            );

            // Matches: CREATE TABLE table_name
            final createTablePattern = RegExp(
              r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)',
              caseSensitive: false,
            );

            for (var match in indexPattern.allMatches(contentWithoutComments)) {
              affectedTables.add(match.group(1)!);
            }
            for (var match in alterPattern.allMatches(contentWithoutComments)) {
              affectedTables.add(match.group(1)!);
            }
            for (var match
                in createTablePattern.allMatches(contentWithoutComments)) {
              affectedTables.add(match.group(1)!);
            }
          }
        }
      }

      return (hasCustomSQL: hasAnyCustomSQL, affectedTables: affectedTables);
    } catch (e) {
      // If we can't analyze, assume no custom SQL
      return (hasCustomSQL: false, affectedTables: <String>{});
    }
  }

  /// Categorizes comparison warnings into critical vs informational based on
  /// custom SQL presence and affected tables.
  static ({List<String> critical, List<String> informational})
      _categorizeWarnings(
    List<ComparisonWarning> warnings,
    String tableName,
    bool hasCustomSQL,
    Set<String> affectedTables,
  ) {
    var critical = <String>[];
    var informational = <String>[];

    // If no custom SQL, all warnings are critical
    if (!hasCustomSQL) {
      return (
        critical: warnings.map((w) => w.toString()).toList(),
        informational: <String>[]
      );
    }

    // Check if this table is affected by custom SQL
    var tableIsAffected =
        affectedTables.isEmpty || affectedTables.contains(tableName);

    for (var warning in warnings) {
      var warningText = warning.toString();

      // Always critical: Missing expected objects
      if (warning.isMissing && warning.type != 'Index') {
        critical.add(warningText);
        continue;
      }

      // Always critical: Column mismatches in managed tables
      if (warning.type == 'Column' && !warning.isMissing) {
        critical.add(warningText);
        continue;
      }

      // Always critical: Foreign key problems
      if (warning.type == 'Foreign key') {
        critical.add(warningText);
        continue;
      }

      // Informational: Missing indexes on affected tables (likely custom SQL)
      if (warning.type == 'Index' && warning.isMissing && tableIsAffected) {
        informational.add(warningText);
        continue;
      }

      // Default: treat as critical
      critical.add(warningText);
    }

    return (critical: critical, informational: informational);
  }

  /// Returns true if the database structure is up to date. If not, it will
  /// print warnings to stderr.
  ///
  /// When custom SQL is detected, warnings are categorized as critical
  /// (must fix) vs informational (expected from custom SQL).
  Future<bool> verifyDatabaseIntegrity(Session session) async {
    var allCriticalWarnings = <String>[];
    var allInfoWarnings = <String>[];

    var liveDatabase = await DatabaseAnalyzer.analyze(session.db);
    var targetTables =
        session.serverpod.serializationManager.getTargetTableDefinitions();

    // Analyze custom SQL using the instance's project directory
    var customSqlAnalysis = _analyzeCustomSQL();

    for (var table in targetTables) {
      var liveTable = liveDatabase.findTableNamed(table.name);
      if (liveTable == null) {
        allCriticalWarnings.add('Table "${table.name}" is missing.');
        continue;
      }

      var mismatches = liveTable.like(table);

      if (mismatches.isNotEmpty) {
        var categorized = _categorizeWarnings(
          mismatches,
          table.name,
          customSqlAnalysis.hasCustomSQL,
          customSqlAnalysis.affectedTables,
        );

        if (categorized.critical.isNotEmpty) {
          allCriticalWarnings.add(
            'Table "${table.name}" is not like the target database:\n - ${categorized.critical.join('\n - ')}',
          );
        }

        if (categorized.informational.isNotEmpty) {
          allInfoWarnings.add(
            'Table "${table.name}" has additional objects (likely from custom SQL):\n - ${categorized.informational.join('\n - ')}',
          );
        }
      }
    }

    // Print critical warnings
    if (allCriticalWarnings.isNotEmpty) {
      stderr.writeln(
        'WARNING: The database does not match the target database:',
      );
      for (var warning in allCriticalWarnings) {
        stderr.writeln(' - $warning');
      }
      stderr.writeln(
          'Hint: Did you forget to apply the migrations (--apply-migrations) or run a repair migration (--apply-repair-migration)?');
    }

    // Print informational warnings
    if (allInfoWarnings.isNotEmpty) {
      stderr.writeln(
        '\nINFO: Database has additional objects from custom SQL:',
      );
      for (var warning in allInfoWarnings) {
        stderr.writeln(' - $warning');
      }
      stderr.writeln(
          'Note: These are expected when using custom SQL hooks and do not indicate a problem.');
    }

    // Only fail if there are critical warnings
    return allCriticalWarnings.isEmpty;
  }
}
