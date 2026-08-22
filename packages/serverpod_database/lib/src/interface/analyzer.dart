import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../serverpod_database.dart' hide Protocol;

/// The current schema version of the database definition.
const currentSchemaVersion = 2;

/// Analyzes the structure of [Database]s.
abstract class DatabaseAnalyzer {
  /// The [Database] to analyze.
  final Database database;

  /// Creates a new [DatabaseAnalyzer] for the given [database].
  DatabaseAnalyzer({required this.database});

  /// Analyze the structure of the [database].
  Future<DatabaseDefinition> analyze() async {
    return DatabaseDefinition(
      schemaVersion: currentSchemaVersion,
      name: await getCurrentDatabaseName(),
      moduleName: 'analyzer',
      tables: await getTableDefinitions(),
      migrationApiVersion: DatabaseConstants.migrationApiVersion,
      installedModules: await _getInstalledMigrationVersions(),
    );
  }

  /// Retrieves the current database from the [database].
  Future<String> getCurrentDatabaseName();

  /// Retrieves the definitions of the tables in the [database].
  Future<List<TableDefinition>> getTableDefinitions();

  /// Retrieves the definitions of the columns in the [database].
  Future<List<ColumnDefinition>> getColumnDefinitions({
    required String schemaName,
    required String tableName,
  });

  /// Retrieves the definitions of the indexes in the [database].
  Future<List<IndexDefinition>> getIndexDefinitions({
    required String schemaName,
    required String tableName,
  });

  /// Retrieves the definitions of the foreign keys in the [database].
  Future<List<ForeignKeyDefinition>> getForeignKeyDefinitions({
    required String schemaName,
    required String tableName,
  });

  /// Retrieves a list of installed database migrations.
  Future<List<DatabaseMigrationVersionModel>>
  _getInstalledMigrationVersions() async {
    try {
      // NOTE: This extraction must be done manually because the table does not
      // exist as a shared model, but only in the server/client packages. Once
      // tables in shared models are supported, this can be replaced by a
      // simple `find` call.
      final result = await database.unsafeQuery(
        'SELECT * FROM serverpod_migrations;',
      );
      return [
        for (final row in result)
          DatabaseMigrationVersionModel.fromJson(
            row.toColumnMap(),
          ),
      ];
    } catch (e) {
      if (isUndefinedTableError(e, tableName: 'serverpod_migrations')) {
        log.warning(
          'The serverpod_migrations table is missing. '
          'Have you applied the database migrations?',
        );
        return [];
      }
      log.error('Failed to get installed migrations', error: e);
      // SQLite e2e shares one file between the insights server and CLI
      // apply/create steps. Lock/busy is not "undefined table"; rethrowing
      // hangs Insights until the 5-minute test timeout. Postgres still
      // rethrows so connection loss is not reported as every table missing.
      if (database.dialect == DatabaseDialect.sqlite) {
        return [];
      }
      rethrow;
    }
  }
}

/// Extensions on [DatabaseAnalyzer] to add functionality not overridden by
/// the concrete analyzer implementations.
extension DatabaseAnalyzerExtensions on DatabaseAnalyzer {
  /// Gets the target database definition for the current dialect.
  ///
  /// This is used to compare the live database to the target database. The
  /// definitions returned by this method do not contain elements that are
  /// ignored on the current dialect (e.g. unsupported index types).
  List<TableDefinition> getTargetTableDefinitions() {
    var tables = database.serializationManager.getTargetTableDefinitions();
    return tables.forDialect(database.dialect);
  }
}
