import 'dart:async';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod/src/database/adapters/postgres/postgres_database_result.dart';
import 'package:serverpod/src/database/adapters/postgres/postgres_result_parser.dart';
import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/exceptions.dart';
import 'package:serverpod/src/database/concepts/includes.dart';
import 'package:serverpod/src/database/concepts/order.dart';
import 'package:serverpod/src/database/concepts/runtime_parameters.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';
import 'package:serverpod/src/database/concepts/transaction.dart';
import 'package:serverpod/src/database/postgres_error_codes.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../generated/protocol.dart';
import '../../../server/session.dart';
import '../../concepts/expressions.dart';
import '../../concepts/table.dart';
import '../../database_pool_manager.dart';
import '../../query_parameters.dart';

part 'postgres_exceptions.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
@internal
class DatabaseConnection {
  /// Database configuration.
  final DatabasePoolManager _poolManager;

  /// Access to the raw Postgresql connection pool.
  pg.Pool get _postgresConnection => _poolManager.pool;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this._poolManager);

  /// Tests the database connection.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection() async {
    await _postgresConnection.execute(
      'SELECT 1;',
      timeout: const Duration(seconds: 2),
    );
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
    Object id, {
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

    var query = InsertQueryBuilder(
      table: table,
      rows: rows,
    ).build();

    return (await _mappedResultsQuery(session, query, transaction: transaction)
            .then((_mergeResultsWithNonPersistedFields(rows))))
        .map(_poolManager.serializationManager.deserialize<T>)
        .toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> insertRow<T extends TableRow>(
    Session session,
    T row, {
    Transaction? transaction,
  }) async {
    var result = await insert<T>(
      session,
      [row],
      transaction: transaction,
    );

    if (result.length != 1) {
      throw _PgDatabaseInsertRowException(
        'Failed to insert row, updated number of rows is ${result.length} != 1',
      );
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

    var selectedColumns = (columns ?? table.managedColumns).toSet();

    if (columns != null) {
      _validateColumnsExists(selectedColumns, table.columns.toSet());
      selectedColumns.add(table.id);
    }

    var selectedColumnNames = selectedColumns.map((e) => e.columnName);

    var columnNames =
        selectedColumnNames.map((columnName) => '"$columnName"').join(', ');

    var values = _createQueryValueList(rows, selectedColumns);

    var setColumns = selectedColumnNames
        .map((columnName) => '"$columnName" = data."$columnName"')
        .join(', ');

    var query =
        'UPDATE "${table.tableName}" AS t SET $setColumns FROM (VALUES $values) AS data($columnNames) WHERE data.id = t.id RETURNING *';

    return (await _mappedResultsQuery(session, query, transaction: transaction)
            .then((_mergeResultsWithNonPersistedFields(rows))))
        .map(_poolManager.serializationManager.deserialize<T>)
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
      throw _PgDatabaseUpdateRowException(
        'Failed to update row, no rows updated',
      );
    }

    return updated.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> delete<T extends TableRow>(
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
      table.id.inSet(rows.map((row) => row.id!).castToIdType().toSet()),
      transaction: transaction,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> deleteRow<T extends TableRow>(
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
      throw _PgDatabaseDeleteRowException(
        'Failed to delete row, no rows deleted.',
      );
    }

    return result.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> deleteWhere<T extends TableRow>(
    Session session,
    Expression where, {
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteWhere');

    var query = DeleteQueryBuilder(table: table)
        .withReturn(Returning.all)
        .withWhere(where)
        .build();

    return await _deserializedMappedQuery(
      session,
      query,
      table: table,
      transaction: transaction,
    );
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

    var result = await _query(
      session,
      query,
      context: _resolveQueryContext(transaction),
    );

    if (result.length != 1) return 0;

    List rows = result.first;
    if (rows.length != 1) return 0;

    return rows.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<PostgresDatabaseResult> simpleQuery(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var result = await _query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      simpleQueryMode: true,
      context: _resolveQueryContext(transaction),
    );

    return PostgresDatabaseResult(result);
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<PostgresDatabaseResult> query(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async {
    var result = await _query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      parameters: parameters,
      context: _resolveQueryContext(transaction),
    );

    return PostgresDatabaseResult(result);
  }

  static Future<pg.Result> _query(
    Session session,
    String query, {
    int? timeoutInSeconds,
    bool ignoreRows = false,
    bool simpleQueryMode = false,
    QueryParameters? parameters,
    required pg.Session context,
  }) async {
    assert(
      simpleQueryMode == false ||
          (simpleQueryMode == true && parameters == null),
      'simpleQueryMode does not support parameters',
    );

    var timeout =
        timeoutInSeconds != null ? Duration(seconds: timeoutInSeconds) : null;

    var startTime = DateTime.now();
    try {
      var result = await context.execute(
        parameters is QueryParametersNamed ? pg.Sql.named(query) : query,
        timeout: timeout,
        ignoreRows: ignoreRows,
        queryMode: simpleQueryMode ? pg.QueryMode.simple : null,
        parameters: parameters?.parameters,
      );

      _logQuery(
        session,
        query,
        startTime,
        numRowsAffected: result.affectedRows,
      );
      return result;
    } on pg.ServerException catch (exception, trace) {
      var message = switch (exception.code) {
        (PgErrorCode.undefinedTable) =>
          'Table not found, have you applied the database migration? (${exception.message})',
        (_) => exception.message,
      };

      var serverpodException = _PgDatabaseQueryException.fromServerException(
        exception,
        messageOverride: message,
      );

      _logQuery(
        session,
        query,
        startTime,
        exception: serverpodException,
        trace: trace,
      );
      Error.throwWithStackTrace(serverpodException, trace);
    } on pg.PgException catch (exception, trace) {
      var serverpodException = _PgDatabaseQueryException(exception.message);
      _logQuery(
        session,
        query,
        startTime,
        exception: serverpodException,
        trace: trace,
      );
      Error.throwWithStackTrace(serverpodException, trace);
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
    QueryParameters? parameters,
  }) async {
    var result = await _query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      ignoreRows: true,
      parameters: parameters,
      context: _resolveQueryContext(transaction),
    );

    return result.affectedRows;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> simpleExecute(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var result = await _query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      ignoreRows: true,
      simpleQueryMode: true,
      context: _resolveQueryContext(transaction),
    );

    return result.affectedRows;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<Iterable<Map<String, dynamic>>> _mappedResultsQuery(
    Session session,
    String query, {
    int? timeoutInSeconds,
    required Transaction? transaction,
  }) async {
    var result = await _query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      context: _resolveQueryContext(transaction),
    );

    return result.map((row) {
      return {
        for (final entry in row.toColumnMap().entries)
          // Serverpod serialization already knows the type of the target
          // class, so we can remove `UndecodedBytes` here to avoid the
          // dependency of serverpod_serialization on the `postgres` package.
          entry.key: entry.value is pg.UndecodedBytes
              ? (entry.value as pg.UndecodedBytes).bytes
              : entry.value
      };
    });
  }

  pg.Session _resolveQueryContext(Transaction? transaction) {
    var postgresTransaction = _castToPostgresTransaction(transaction);
    return postgresTransaction?.executionContext ?? _postgresConnection;
  }

  Future<List<T>> _deserializedMappedQuery<T extends TableRow>(
    Session session,
    String query, {
    required Table table,
    int? timeoutInSeconds,
    required Transaction? transaction,
    Include? include,
  }) async {
    var result = await _mappedResultsQuery(
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
      transaction,
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

  static void _logQuery(
    Session session,
    String query,
    DateTime startTime, {
    int? numRowsAffected,
    dynamic exception,
    StackTrace? trace,
  }) {
    var duration = DateTime.now().difference(startTime);

    // Use the current stack trace if there is no exception.
    trace ??= StackTrace.current;

    session.logManager?.logQuery(
      query: query,
      duration: duration,
      numRowsAffected: numRowsAffected,
      error: exception?.toString(),
      stackTrace: trace,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    required TransactionSettings settings,
    required Session session,
  }) {
    var pgTransactionSettings = pg.TransactionSettings(
      isolationLevel: switch (settings.isolationLevel) {
        IsolationLevel.readCommitted => pg.IsolationLevel.readCommitted,
        IsolationLevel.readUncommitted => pg.IsolationLevel.readUncommitted,
        IsolationLevel.repeatableRead => pg.IsolationLevel.repeatableRead,
        IsolationLevel.serializable => pg.IsolationLevel.serializable,
        null => null,
      },
    );

    return _postgresConnection.runTx<R>(
      (ctx) {
        var transaction = _PostgresTransaction(
          ctx,
          session,
        );
        return transactionFunction(transaction);
      },
      settings: pgTransactionSettings,
    );
  }

  Future<Map<String, Map<Object, List<Map<String, dynamic>>>>>
      _queryIncludedLists(
    Session session,
    Table table,
    Include? include,
    Iterable<Map<String, dynamic>> previousResultSet,
    Transaction? transaction,
  ) async {
    if (include == null) return {};

    Map<String, Map<Object, List<Map<String, dynamic>>>> resolvedListRelations =
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
        var ids = _extractPrimaryKeyForRelation<Object>(
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

        var includeListResult = await _mappedResultsQuery(
          session,
          query,
          transaction: transaction,
        );

        var resolvedLists = await _queryIncludedLists(
          session,
          nestedInclude.table,
          nestedInclude,
          includeListResult,
          transaction,
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
          transaction,
        );

        resolvedListRelations.addAll(resolvedNestedListRelations);
      }
    }

    return resolvedListRelations;
  }

  void _validateColumnsExists(Set<Column> columns, Set<Column> tableColumns) {
    var additionalColumns = columns.difference(tableColumns);

    if (additionalColumns.isNotEmpty) {
      throw ArgumentError.value(
        additionalColumns.toList().toString(),
        'columns',
        'Columns do not exist in table',
      );
    }
  }

  List<Order>? _resolveOrderBy(List<Order>? orderByList,
      Column<dynamic>? orderBy, bool orderDescending) {
    assert(orderByList == null || orderBy == null);
    if (orderBy != null) {
      // If order by is set then order by list is overridden.
      return [Order(column: orderBy, orderDescending: orderDescending)];
    }
    return orderByList;
  }

  String _createQueryValueList(
    Iterable<TableRow> rows,
    Iterable<Column> column,
  ) {
    return rows.map((row) => row.toJson() as Map<String, dynamic>).map((row) {
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
    if (column is ColumnInt) return 'bigint';
    if (column is ColumnDouble) return 'double precision';
    if (column is ColumnDateTime) return 'timestamp without time zone';
    if (column is ColumnByteData) return 'bytea';
    if (column is ColumnDuration) return 'bigint';
    if (column is ColumnUuid) return 'uuid';
    if (column is ColumnUri) return 'text';
    if (column is ColumnBigInt) return 'text';
    if (column is ColumnVector) return 'vector';
    if (column is ColumnHalfVector) return 'halfvec';
    if (column is ColumnSparseVector) return 'sparsevec';
    if (column is ColumnBit) return 'bit';
    if (column is ColumnSerializable) return 'json';
    if (column is ColumnEnumExtended) {
      switch (column.serialized) {
        case EnumSerialization.byIndex:
          return 'bigint';
        case EnumSerialization.byName:
          return 'text';
      }
    }

    return 'json';
  }

  /// Merges the database result with the original non-persisted fields.
  /// Database fields take precedence for common fields, while non-persisted fields are retained.
  List<Map<String, dynamic>> Function(Iterable<Map<String, dynamic>>)
      _mergeResultsWithNonPersistedFields<T extends TableRow>(
    List<T> rows,
  ) {
    return (Iterable<Map<String, dynamic>> dbResults) =>
        List<Map<String, dynamic>>.generate(dbResults.length, (i) {
          return {
            // Add non-persisted fields from the original object
            ...rows[i].toJson(),
            // Override with database fields (common fields)
            ...dbResults.elementAt(i),
          };
        });
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

/// Throws an exception if the given [transaction] is not a Postgres transaction.
_PostgresTransaction? _castToPostgresTransaction(
  Transaction? transaction,
) {
  if (transaction == null) return null;
  if (transaction is! _PostgresTransaction) {
    throw ArgumentError.value(
      transaction,
      'transaction',
      'Transaction type does not match the required database transaction type, $_PostgresTransaction. '
          'You need to create the transaction from the database by calling '
          'session.db.transaction();',
    );
  }
  return transaction;
}

class _PostgresSavepoint implements Savepoint {
  @override
  final String id;
  final _PostgresTransaction _transaction;

  _PostgresSavepoint(this.id, this._transaction);

  @override
  Future<void> release() async {
    await _transaction._query('RELEASE SAVEPOINT $id;');
  }

  @override
  Future<void> rollback() async {
    await _transaction._query('ROLLBACK TO SAVEPOINT $id;');
  }
}

/// Postgres specific implementation of transactions.
class _PostgresTransaction implements Transaction {
  final pg.TxSession executionContext;
  final Session _session;

  @override
  final Map<String, dynamic> runtimeParameters = {};

  _PostgresTransaction(
    this.executionContext,
    this._session,
  );

  @override
  Future<void> cancel() async {
    await executionContext.rollback();
  }

  Future<void> _query(String query, {QueryParameters? parameters}) async {
    await DatabaseConnection._query(
      _session,
      query,
      parameters: parameters,
      context: executionContext,
    );
  }

  @override
  Future<Savepoint> createSavepoint() async {
    var postgresCompatibleRandomString =
        const Uuid().v4().replaceAll(RegExp(r'-'), '_');
    var savepointId = 'savepoint_$postgresCompatibleRandomString';
    await _query('SAVEPOINT $savepointId;');
    return _PostgresSavepoint(savepointId, this);
  }

  @override
  Future<void> setRuntimeParameters(
    RuntimeParametersListBuilder builder,
  ) async {
    final parameters = builder(RuntimeParametersBuilder());
    for (var group in parameters) {
      for (var statement in group.buildStatements(isLocal: true)) {
        await _query(statement);
      }
      runtimeParameters.addAll(group.options);
    }
  }
}

/// Extracts all the primary keys from the result set that are referenced by
/// the given [relationTable].
Set<T> _extractPrimaryKeyForRelation<T>(
  Iterable<Map<String, dynamic>> resultSet,
  TableRelation tableRelation,
) {
  var idFieldName = tableRelation.fieldQueryAliasWithJoins;

  var ids = resultSet.map((e) => e[idFieldName] as T?).whereType<T>().toSet();
  return ids;
}
