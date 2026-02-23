import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart';

import '../../generated/protocol.dart';
import '../database.dart';

/// Analyzes the structure of [Database]s.
abstract class DatabaseAnalyzer {
  /// The [Database] to analyze.
  final Database database;

  /// Creates a new [DatabaseAnalyzer] for the given [database].
  DatabaseAnalyzer({required this.database});

  /// Analyze the structure of the [database].
  Future<DatabaseDefinition> analyze() async {
    return DatabaseDefinition(
      name: await getCurrentDatabaseName(),
      moduleName: Protocol().getModuleName(),
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
  Future<List<DatabaseMigrationVersion>>
  _getInstalledMigrationVersions() async {
    try {
      return await database.find<DatabaseMigrationVersion>();
    } catch (e) {
      // Ignore if the table does not exist.
      stderr.writeln('Failed to get installed migrations: $e');
      return [];
    }
  }
}
