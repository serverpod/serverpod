import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/analyze.dart';
import 'package:serverpod/src/database/database.dart';
import 'package:serverpod/src/database/extensions.dart';

/// Provides a way to export raw data from the database. The data is serialized
/// using JSON. Primarily used for Serverpod Insights.
class DatabaseBulkData {
  /// Exports data from the provided [table].
  static Future<BulkData> exportTableData({
    required Database database,
    required String table,
    int lastId = 0,
    int limit = 100,
    Filter? filter,
  }) async {
    var liveTableDefinition = await _getLiveTableDefinition(database, table);
    if (liveTableDefinition == null) {
      throw BulkDataException(
        message: 'The "$table" table was not found in the live database.',
      );
    }
    var targetTableDefinition =
        await _getTargetTableDefinition(database, table);
    if (targetTableDefinition == null) {
      throw BulkDataException(
        message: 'The "$table" table was not found in the database definition.',
      );
    }

    if (!liveTableDefinition.like(targetTableDefinition)) {
      throw BulkDataException(
        message: 'The "$table" table definition does not match the live '
            'database.',
      );
    }

    var columns = liveTableDefinition.columns;
    var columnSelects = <String>[];

    for (var column in columns) {
      if (column.columnType.name == 'bytea') {
        columnSelects.add('octet_length("${column.name}")');
      } else {
        columnSelects.add('"${column.name}"');
      }
    }

    var filterQuery = '';
    try {
      if (filter != null) {
        filterQuery = filter.toQuery(targetTableDefinition);
        filterQuery = ' AND $filterQuery';
      }
    } catch (e) {
      throw BulkDataException(
        message: 'Failed to create filter query ($e).',
      );
    }

    List<List<dynamic>> data;
    var query = 'SELECT ${columnSelects.join(', ')} FROM "$table" '
        'WHERE id > $lastId$filterQuery ORDER BY "id" LIMIT $limit';
    try {
      data = await database.unsafeQuery(query);
    } catch (e) {
      throw BulkDataException(
        message: 'Failed to query database ($e).',
        query: query,
      );
    }

    return BulkData(
      tableDefinition: targetTableDefinition,
      data: SerializationManager.encode(data),
    );
  }

  /// Returns the approximate number of rows in the provided [table].
  static Future<int> approximateRowCount({
    required Database database,
    required String table,
  }) async {
    var tableDefinition = await _getLiveTableDefinition(database, table);
    if (tableDefinition == null) {
      throw BulkDataException(
        message: 'The "$table" table was not found in the live database.',
      );
    }

    var query = 'SELECT reltuples::bigint AS estimate FROM pg_class '
        'JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace '
        'WHERE relname = \'$table\' AND nspname = \'public\'';

    var result = await database.unsafeQuery(query);

    if (result.isEmpty) {
      return 0;
    }
    var count = result.first.first as int;
    return max(count, 0);
  }

  /// Executes a series of queries and returns the last result as a
  /// [BulkQueryResult].
  static Future<BulkQueryResult> executeQueries({
    required Database database,
    required List<String> queries,
  }) async {
    var result =
        await database.transaction<BulkQueryResult>((transaction) async {
      var startTime = DateTime.now();
      DatabaseResult? result;
      int numAffectedRows = 0;

      for (var query in queries) {
        result = await database.unsafeQuery(query, transaction: transaction);
        numAffectedRows += result.affectedRowCount;
      }
      result!;

      var duration = DateTime.now().difference(startTime);

      return BulkQueryResult(
        headers: result.schema.columns
            .map((e) => BulkQueryColumnDescription(
                  name: e.columnName ?? '',
                ))
            .toList(),
        data: SerializationManager.encode(result),
        numAffectedRows: numAffectedRows,
        duration: duration,
      );
    });

    return result;
  }

  static Future<TableDefinition?> _getTargetTableDefinition(
    Database database,
    String table,
  ) async {
    var tableDefinitions =
        Serverpod.instance.serializationManager.getTargetTableDefinitions();

    var tableDefinition =
        tableDefinitions.firstWhereOrNull((e) => e.name == table);

    return tableDefinition;
  }

  static Future<TableDefinition?> _getLiveTableDefinition(
    Database database,
    String table,
  ) async {
    var databaseDefinition = await _getLiveDatabaseDefinition(database);

    var tableDefinition =
        databaseDefinition.tables.firstWhereOrNull((e) => e.name == table);

    return tableDefinition;
  }

  static DatabaseDefinition? _cachedDatabaseDefinition;

  static Future<DatabaseDefinition> _getLiveDatabaseDefinition(
    Database database,
  ) async {
    if (_cachedDatabaseDefinition == null) {
      _cachedDatabaseDefinition = await DatabaseAnalyzer.analyze(database);

      // Invalidate the cache after 1 minute.
      Timer(const Duration(minutes: 1), () {
        _cachedDatabaseDefinition = null;
      });
    }
    return _cachedDatabaseDefinition!;
  }
}
