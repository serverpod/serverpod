import 'dart:async';

import 'package:postgres_pool/postgres_pool.dart';
import 'package:retry/retry.dart';
import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/database_query_helper.dart';
import 'package:serverpod/src/database/database_result.dart';
import 'package:serverpod/src/database/includes.dart';
import 'package:serverpod/src/database/order.dart';
import 'package:serverpod/src/database/transaction.dart';

import '../generated/protocol.dart';
import '../server/session.dart';
import 'database_pool_manager.dart';
import 'expressions.dart';
import 'table.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
class DatabaseConnection {
  /// Database configuration.
  final DatabasePoolManager _poolManager;

  /// Access to the raw Postgresql connection pool.
  final PgPool _postgresConnection;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this._poolManager)
      : _postgresConnection = _poolManager.pool;

  /// Tests the database connection.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection() async {
    await _postgresConnection.query('SELECT 1;', timeoutInSeconds: 2);
    return true;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> find<T extends TableRow>(
    Session session, {
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    List<Order>? orderByList,
    Include? include,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'find');
    orderByList = _resolveOrderBy(orderByList, orderBy, orderDescending);

    var query = SelectQueryBuilder(table: table)
        .withSelectFields(table.columns)
        .withWhere(where)
        .withOrderBy(orderByList)
        .withLimit(limit)
        .withOffset(offset)
        .withInclude(include)
        .build();

    return _deserializedMappedQuery<T>(
      session,
      query,
      table: table,
      timeoutInSeconds: 60,
      transaction: transaction,
      include: include,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findFirstRow<T extends TableRow>(
    Session session, {
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) async {
    _getTableOrAssert<T>(session, operation: 'findRow');
    var rows = await find<T>(
      session,
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      limit: 1,
      transaction: transaction,
      include: include,
    );

    if (rows.isEmpty) return null;

    return rows.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findById<T extends TableRow>(
    Session session,
    int id, {
    Transaction? transaction,
    Include? include,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'findById');
    return await findFirstRow<T>(
      session,
      where: table.id.equals(id),
      transaction: transaction,
      include: include,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> insert<T extends TableRow>(
    Session session,
    List<T> rows, {
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];

    var table = rows.first.table;

    var selectedColumns =
        table.columns.where((column) => column.columnName != 'id');

    var columnNames =
        selectedColumns.map((e) => '"${e.columnName}"').join(', ');

    var values = rows.map((row) => row.allToJson()).map((row) {
      var values = selectedColumns.map((column) {
        var unformattedValue = row[column.columnName];
        return DatabasePoolManager.encoder.convert(unformattedValue);
      }).join(', ');
      return '($values)';
    }).join(', ');

    var query =
        'INSERT INTO "${table.tableName}" ($columnNames) VALUES $values RETURNING *';

    var result =
        await mappedResultsQuery(session, query, transaction: transaction);

    return result
        .map((t) => t[table.tableName])
        .map((row) => _poolManager.serializationManager.deserialize<T>(row))
        .toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> insertRow<T extends TableRow>(
    Session session,
    T row, {
    Transaction? transaction,
  }) async {
    var result = await insert<T>(session, [row], transaction: transaction);

    if (result.length != 1) {
      throw PostgreSQLException(
          'Failed to insert row, updated number of rows is ${result.length} != 1');
    }

    return result.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> update<T extends TableRow>(
    Session session,
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];
    if (rows.any((column) => column.id == null)) {
      throw ArgumentError.notNull('row.id');
    }

    var table = rows.first.table;

    var selectedColumns = columns ?? table.columns;

    if (columns != null) {
      _validateColumnsExists(columns, table);
      selectedColumns = [table.id, ...columns];
    }

    var selectedColumnNames = selectedColumns.map((e) => e.columnName);

    var columnNames =
        selectedColumnNames.map((columnName) => '"$columnName"').join(', ');

    var values = _createQueryValueList(rows, selectedColumns);

    var setColumns = selectedColumnNames
        .where((columnName) => columnName != 'id')
        .map((columnName) => '"$columnName" = data."$columnName"')
        .join(', ');

    var query =
        'UPDATE "${table.tableName}" AS t SET $setColumns FROM (VALUES $values) AS data($columnNames) WHERE data.id = t.id RETURNING *';

    var result =
        await mappedResultsQuery(session, query, transaction: transaction);

    return result
        .map((t) => t[table.tableName])
        .map((row) => _poolManager.serializationManager.deserialize<T>(row))
        .toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> updateRow<T extends TableRow>(
    Session session,
    T row, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    var updated = await update<T>(
      session,
      [row],
      columns: columns,
      transaction: transaction,
    );

    if (updated.isEmpty) {
      throw PostgreSQLException('Failed to update row, no rows updated');
    }

    return updated.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<int>> delete<T extends TableRow>(
    Session session,
    List<T> rows, {
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];
    if (rows.any((column) => column.id == null)) {
      throw ArgumentError.notNull('row.id');
    }

    var table = rows.first.table;

    return deleteWhere<T>(
      session,
      table.id.inSet(rows.map((row) => row.id!).toSet()),
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> deleteRow<T extends TableRow>(
    Session session,
    T row, {
    Transaction? transaction,
  }) async {
    var result = await delete<T>(
      session,
      [row],
      transaction: transaction,
    );

    if (result.isEmpty) {
      throw PostgreSQLException('Failed to delete row, no rows deleted.');
    }

    return result.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<int>> deleteWhere<T extends TableRow>(
    Session session,
    Expression where, {
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteWhere');

    var query = DeleteQueryBuilder(table: table)
        .withReturn(Returning.id)
        .withWhere(where)
        .build();

    var result = await this.query(session, query, transaction: transaction);

    return result.toList().map((r) => r.first as int).toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> count<T extends TableRow>(
    Session session, {
    Expression? where,
    int? limit,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'count');

    var query = CountQueryBuilder(table: table)
        .withCountAlias('c')
        .withWhere(where)
        .withLimit(limit)
        .build();

    var result = await this.query(session, query, transaction: transaction);

    if (result.length != 1) return 0;

    List rows = result.first;
    if (rows.length != 1) return 0;

    return rows.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<PostgreSQLResult> query(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    Map<String, dynamic>? substitutionValues = const {},
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction?.postgresContext ?? _postgresConnection;

      var result = await context.query(
        query,
        allowReuse: false,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: substitutionValues,
      );

      _logQuery(
        session,
        query,
        startTime,
        numRowsAffected: result.affectedRowCount,
      );
      return result;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> execute(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction?.postgresContext ?? _postgresConnection;

      var result = await context.execute(
        query,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: {},
      );
      _logQuery(session, query, startTime);
      return result;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<Map<String, Map<String, dynamic>>>> mappedResultsQuery(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction?.postgresContext ?? _postgresConnection;

      var result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: {},
      );

      _logQuery(
        session,
        query,
        startTime,
        numRowsAffected: result.length,
      );
      return result;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  Future<List<T>> _deserializedMappedQuery<T extends TableRow>(
    Session session,
    String query, {
    required Table table,
    int? timeoutInSeconds,
    Transaction? transaction,
    Include? include,
  }) async {
    var result = await mappedResultsQuery(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );

    var resolvedListRelations = await _queryIncludedLists(
      session,
      table,
      include,
      result,
    );

    return result
        .map((rawRow) => resolvePrefixedQueryRow(
              table,
              rawRow,
              resolvedListRelations,
              include: include,
            ))
        .map((row) => _poolManager.serializationManager.deserialize<T>(row))
        .toList();
  }

  void _logQuery(
    Session session,
    String query,
    DateTime startTime, {
    int? numRowsAffected,
    exception,
    StackTrace? trace,
  }) {
    // Check if this query should be logged.
    var logSettings = session.serverpod.logManager.getLogSettingsForSession(
      session,
    );
    var duration =
        DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
    var slow = duration >= logSettings.slowQueryDuration;
    var shouldLog = session.serverpod.logManager.shouldLogQuery(
      session: session,
      slow: slow,
      failed: exception != null,
    );

    if (!shouldLog) {
      return;
    }

    // Use the current stack trace if there is no exception.
    trace ??= StackTrace.current;

    // Log the query.
    var entry = QueryLogEntry(
      sessionLogId: session.sessionLogs.temporarySessionId,
      serverId: session.server.serverId,
      query: query,
      duration: duration,
      numRows: numRowsAffected,
      error: exception?.toString(),
      stackTrace: trace.toString(),
      slow: slow,
      order: session.sessionLogs.currentLogOrderId,
    );
    session.serverpod.logManager.logQuery(session, entry);
    session.sessionLogs.currentLogOrderId += 1;
    session.sessionLogs.numQueries += 1;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    RetryOptions? retryOptions,
    FutureOr<R> Function()? orElse,
    FutureOr<bool> Function(Exception exception)? retryIf,
  }) {
    return _postgresConnection.runTx<R>(
      (ctx) {
        var transaction = _PostgresTransaction(ctx);
        return transactionFunction(transaction);
      },
      retryOptions: retryOptions,
      orElse: orElse,
      retryIf: retryIf,
    );
  }

  Future<Map<String, Map<int, List<Map<String, dynamic>>>>> _queryIncludedLists(
    Session session,
    Table table,
    Include? include,
    List<Map<String, Map<String, dynamic>>> previousResultSet,
  ) async {
    if (include == null) return {};

    Map<String, Map<int, List<Map<String, dynamic>>>> resolvedListRelations =
        {};

    for (var entry in include.includes.entries) {
      var nestedInclude = entry.value;
      var relationFieldName = entry.key;

      var relativeRelationTable = table.getRelationTable(relationFieldName);
      var tableRelation = relativeRelationTable?.tableRelation;
      if (relativeRelationTable == null || tableRelation == null) {
        throw StateError('Relation table is null.');
      }

      if (nestedInclude is IncludeList) {
        var ids = extractPrimaryKeyForRelation<int>(
          previousResultSet,
          tableRelation,
        );

        if (ids.isEmpty) continue;

        var relationTable = nestedInclude.table;

        var orderBy = _resolveOrderBy(
          nestedInclude.orderByList,
          nestedInclude.orderBy,
          nestedInclude.orderDescending,
        );

        var query = SelectQueryBuilder(table: relationTable)
            .withSelectFields(relationTable.columns)
            .withWhere(nestedInclude.where)
            .withOrderBy(orderBy)
            .withLimit(nestedInclude.limit)
            .withOffset(nestedInclude.offset)
            .withWhereRelationInResultSet(ids, relativeRelationTable)
            .withInclude(nestedInclude.include)
            .build();

        var includeListResult = await mappedResultsQuery(session, query);

        var resolvedLists = await _queryIncludedLists(
          session,
          nestedInclude.table,
          nestedInclude,
          includeListResult,
        );

        var resolvedList = includeListResult
            .map((rawRow) => resolvePrefixedQueryRow(
                  relationTable,
                  rawRow,
                  resolvedLists,
                  include: nestedInclude,
                ))
            .whereType<Map<String, dynamic>>()
            .toList();

        resolvedListRelations.addAll(mapListToQueryById(
          resolvedList,
          relativeRelationTable,
          tableRelation.foreignFieldName,
        ));
      } else {
        var resolvedNestedListRelations = await _queryIncludedLists(
          session,
          relativeRelationTable,
          nestedInclude,
          previousResultSet,
        );

        resolvedListRelations.addAll(resolvedNestedListRelations);
      }
    }

    return resolvedListRelations;
  }

  void _validateColumnsExists(List<Column> columns, Table table) {
    for (var column in columns) {
      if (!table.columns.any((c) => c.columnName == column.columnName)) {
        throw ArgumentError.value(
          column,
          column.columnName,
          'does not exist in row',
        );
      }
    }
  }

  List<Order>? _resolveOrderBy(List<Order>? orderByList,
      Column<dynamic>? orderBy, bool orderDescending) {
    assert(orderByList == null || orderBy == null);
    if (orderBy != null) {
      // If order by is set then order by list is overriden.
      return [Order(column: orderBy, orderDescending: orderDescending)];
    }
    return orderByList;
  }

  String _createQueryValueList(
    Iterable<TableRow> rows,
    Iterable<Column> column,
  ) {
    return rows
        .map((row) => row.allToJson() as Map<String, dynamic>)
        .map((row) {
      var values = column.map((column) {
        var unformattedValue = row[column.columnName];

        var formattedValue =
            DatabasePoolManager.encoder.convert(unformattedValue);

        return '$formattedValue::${_convertToPostgresType(column)}';
      }).join(', ');

      return '($values)';
    }).join(', ');
  }

  String _convertToPostgresType(Column column) {
    if (column is ColumnString) return 'text';
    if (column is ColumnBool) return 'boolean';
    if (column is ColumnInt) return 'integer';
    if (column is ColumnDouble) return 'double precision';
    if (column is ColumnDateTime) return 'timestamp without time zone';
    if (column is ColumnByteData) return 'bytea';
    if (column is ColumnDuration) return 'bigint';
    if (column is ColumnUuid) return 'uuid';
    if (column is ColumnSerializable) return 'json';
    if (column is ColumnEnumExtended) {
      switch (column.serialized) {
        case EnumSerialization.byIndex:
          return 'integer';
        case EnumSerialization.byName:
          return 'text';
      }
    }

    return 'json';
  }
}

Table _getTableOrAssert<T>(Session session, {required String operation}) {
  var table = session.serverpod.serializationManager.getTableForType(T);
  assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.$operation<MyTableClass>(where: ...);
Current type was $T''');
  return table!;
}

/// Postgres specific implementation of transactions.
class _PostgresTransaction extends Transaction {
  _PostgresTransaction(super.postgresContext);
}
