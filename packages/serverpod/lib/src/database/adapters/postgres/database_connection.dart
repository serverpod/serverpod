import 'dart:async';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod/src/database/adapters/postgres/postgres_database_result.dart';
import 'package:serverpod/src/database/adapters/postgres/postgres_pool_manager.dart';
import 'package:serverpod/src/database/adapters/postgres/postgres_result_parser.dart';
import 'package:serverpod/src/database/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod/src/database/concepts/column_value.dart';
import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/interface/database_connection.dart';
import 'package:serverpod/src/database/concepts/exceptions.dart';
import 'package:serverpod/src/database/concepts/includes.dart';
import 'package:serverpod/src/database/concepts/order.dart';
import 'package:serverpod/src/database/concepts/row_lock.dart';
import 'package:serverpod/src/database/concepts/runtime_parameters.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';
import 'package:serverpod/src/database/concepts/transaction.dart';
import 'package:serverpod/src/database/postgres_error_codes.dart';
import 'package:serverpod/src/generated/database/enum_serialization.dart';
import 'package:uuid/uuid.dart';

import '../../interface/database_session.dart';
import '../../concepts/expressions.dart';
import '../../concepts/table.dart';
import '../../query_parameters.dart';

part 'postgres_exceptions.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [DatabaseSession] object should be used when connecting with the database.
@internal
class PostgresDatabaseConnection
    extends DatabaseConnection<PostgresPoolManager> {
  /// Access to the raw Postgresql connection pool.
  pg.Pool get _postgresConnection => poolManager.pool;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [DatabaseSession]
  /// to access the database.
  PostgresDatabaseConnection(super.poolManager);

  /// Tests the database connection.
  /// Throws an exception if the connection is not working.
  @override
  Future<bool> testConnection() async {
    return poolManager.testConnection();
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<List<T>> find<T extends TableRow>(
    DatabaseSession session, {
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    List<Order>? orderByList,
    Include? include,
    Transaction? transaction,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
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
        .withLockMode(lockMode, lockBehavior)
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
  @override
  Future<T?> findFirstRow<T extends TableRow>(
    DatabaseSession session, {
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
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
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );

    if (rows.isEmpty) return null;

    return rows.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<T?> findById<T extends TableRow>(
    DatabaseSession session,
    Object id, {
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'findById');
    return await findFirstRow<T>(
      session,
      where: table.id.equals(id),
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Acquires row-level locks without returning row data.
  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<void> lockRows<T extends TableRow>(
    DatabaseSession session, {
    required Expression where,
    required LockMode lockMode,
    required Transaction transaction,
    LockBehavior lockBehavior = LockBehavior.wait,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'lockRows');

    var query = SelectQueryBuilder(table: table)
        .withSelectFields([table.id])
        .withWhere(where)
        .withLockMode(lockMode, lockBehavior)
        .build();

    await _query(
      session,
      query,
      ignoreRows: true,
      context: _resolveQueryContext(transaction),
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<List<T>> insert<T extends TableRow>(
    DatabaseSession session,
    List<T> rows, {
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];

    var table = rows.first.table;

    var query = InsertQueryBuilder(
      table: table,
      rows: rows,
    ).build();

    return (await _mappedResultsQuery(
          session,
          query,
          transaction: transaction,
        ).then((_mergeResultsWithNonPersistedFields(rows))))
        .map(poolManager.serializationManager.deserialize<T>)
        .toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<T> insertRow<T extends TableRow>(
    DatabaseSession session,
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
  @override
  Future<List<T>> update<T extends TableRow>(
    DatabaseSession session,
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

    var columnNames = selectedColumnNames
        .map((columnName) => '"$columnName"')
        .join(', ');

    var values = _createQueryValueList(rows, selectedColumns);

    var setColumns = selectedColumnNames
        .map((columnName) => '"$columnName" = data."$columnName"')
        .join(', ');

    const tableAlias = 't';
    var returning = buildReturningClause(table, tableAlias: tableAlias);

    var query =
        'UPDATE "${table.tableName}" AS $tableAlias SET $setColumns FROM (VALUES $values) AS data($columnNames) WHERE data.id = $tableAlias.id RETURNING $returning';

    return (await _mappedResultsQuery(
          session,
          query,
          transaction: transaction,
        ).then((_mergeResultsWithNonPersistedFields(rows))))
        .map(poolManager.serializationManager.deserialize<T>)
        .toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<T> updateRow<T extends TableRow>(
    DatabaseSession session,
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

  /// Updates a single row by its ID with the specified column values.
  ///
  /// Returns the updated row or null if no row with the given ID exists.
  /// Throws [ArgumentError] if [columnValues] is empty.
  ///
  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<T> updateById<T extends TableRow>(
    DatabaseSession session,
    Object id, {
    required List<ColumnValue> columnValues,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'updateById');

    if (columnValues.isEmpty) {
      throw ArgumentError('columnValues cannot be empty');
    }

    var setClause = columnValues
        .map((cv) {
          var value = poolManager.encoder.convert(cv.value);
          return '"${cv.column.columnName}" = $value::${_convertToPostgresType(cv.column)}';
        })
        .join(', ');

    var query =
        'UPDATE "${table.tableName}" SET $setClause '
        'WHERE "${table.id.columnName}" = ${poolManager.encoder.convert(id)} '
        'RETURNING *';

    var result = await _mappedResultsQuery(
      session,
      query,
      transaction: transaction,
    );

    if (result.isEmpty) {
      throw _PgDatabaseUpdateRowException(
        'Failed to update row, no rows updated',
      );
    }

    return poolManager.serializationManager.deserialize<T>(
      result.first,
    );
  }

  /// Updates all rows matching the WHERE expression with the specified column values.
  ///
  /// Returns a list of all updated rows. Returns an empty list if no rows match.
  /// Throws [ArgumentError] if [columnValues] is empty.
  ///
  /// When [limit], [offset], [orderBy], [orderByList], or [orderDescending] are provided,
  /// only the rows selected by these parameters will be updated.
  ///
  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<List<T>> updateWhere<T extends TableRow>(
    DatabaseSession session, {
    required List<ColumnValue> columnValues,
    required Expression where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'updateWhere');

    if (columnValues.isEmpty) {
      throw ArgumentError('columnValues cannot be empty');
    }

    var setClause = columnValues
        .map((cv) {
          var value = poolManager.encoder.convert(cv.value);
          return '"${cv.column.columnName}" = $value::${_convertToPostgresType(cv.column)}';
        })
        .join(', ');

    String updateQuery;

    var requiresFilteredSubquery =
        limit != null ||
        offset != null ||
        orderBy != null ||
        orderByList != null;

    if (requiresFilteredSubquery) {
      var orders = _resolveOrderBy(orderByList, orderBy, orderDescending);
      var subquery = SelectQueryBuilder(table: table)
          .withSelectFields([table.id])
          .withWhere(where)
          .withOrderBy(orders)
          .withLimit(limit)
          .withOffset(offset)
          .build();

      var idAlias = '${table.tableName}.${table.id.columnName}';

      var orderByClause = switch (orders) {
        != null when orders.isNotEmpty =>
          ' ORDER BY '
              '${orders.map((o) => o.toString().replaceAll('"${table.tableName}".', '')).join(', ')}',
        _ => '',
      };

      updateQuery =
          'WITH rows_to_update AS ($subquery), '
          'updated AS ('
          'UPDATE "${table.tableName}" SET $setClause '
          'WHERE "${table.id.columnName}" IN (SELECT "$idAlias" FROM rows_to_update) '
          'RETURNING *'
          ') '
          'SELECT * FROM updated$orderByClause';
    } else {
      updateQuery =
          'UPDATE "${table.tableName}" SET $setClause'
          ' WHERE $where'
          ' RETURNING *';
    }

    var result = await _mappedResultsQuery(
      session,
      updateQuery,
      transaction: transaction,
    );

    return result.map(poolManager.serializationManager.deserialize<T>).toList();
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<List<T>> delete<T extends TableRow>(
    DatabaseSession session,
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
  @override
  Future<T> deleteRow<T extends TableRow>(
    DatabaseSession session,
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
  @override
  Future<List<T>> deleteWhere<T extends TableRow>(
    DatabaseSession session,
    Expression where, {
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteWhere');

    var query = DeleteQueryBuilder(
      table: table,
    ).withReturn(Returning.all).withWhere(where).build();

    return await _deserializedMappedQuery(
      session,
      query,
      table: table,
      transaction: transaction,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<int> count<T extends TableRow>(
    DatabaseSession session, {
    Expression? where,
    int? limit,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'count');

    var query = CountQueryBuilder(
      table: table,
    ).withCountAlias('c').withWhere(where).withLimit(limit).build();

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
  @override
  Future<PostgresDatabaseResult> simpleQuery(
    DatabaseSession session,
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
  @override
  Future<PostgresDatabaseResult> query(
    DatabaseSession session,
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

  Future<pg.Result> _query(
    DatabaseSession session,
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

    var timeout = timeoutInSeconds != null
        ? Duration(seconds: timeoutInSeconds)
        : null;

    var startTime = DateTime.now();
    try {
      var result = await context.execute(
        parameters is QueryParametersNamed ? pg.Sql.named(query) : query,
        timeout: timeout,
        ignoreRows: ignoreRows,
        queryMode: simpleQueryMode ? pg.QueryMode.simple : null,
        parameters: parameters?.parameters,
      );

      poolManager.lastDatabaseOperationTime = startTime;

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
  @override
  Future<int> execute(
    DatabaseSession session,
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
  @override
  Future<int> simpleExecute(
    DatabaseSession session,
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
    DatabaseSession session,
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
              : entry.value,
      };
    });
  }

  pg.Session _resolveQueryContext(Transaction? transaction) {
    var postgresTransaction = _castToPostgresTransaction(transaction);
    return postgresTransaction?.executionContext ?? _postgresConnection;
  }

  Future<List<T>> _deserializedMappedQuery<T extends TableRow>(
    DatabaseSession session,
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
        .map(
          (rawRow) => resolvePrefixedQueryRow(
            table,
            rawRow,
            resolvedListRelations,
            include: include,
          ),
        )
        .map(poolManager.serializationManager.deserialize<T>)
        .toList();
  }

  static void _logQuery(
    DatabaseSession session,
    String query,
    DateTime startTime, {
    int? numRowsAffected,
    dynamic exception,
    StackTrace? trace,
  }) {
    var duration = DateTime.now().difference(startTime);

    // Use the current stack trace if there is no exception.
    trace ??= StackTrace.current;

    session.logQuery?.call(
      query: query,
      duration: duration,
      numRowsAffected: numRowsAffected,
      error: exception?.toString(),
      stackTrace: trace,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  @override
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    required TransactionSettings settings,
    required DatabaseSession session,
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
          this,
        );
        return transactionFunction(transaction);
      },
      settings: pgTransactionSettings,
    );
  }

  /// Migrations on Postgres use a transaction to ensure that the advisory lock
  /// is retained until the transaction is completed.
  ///
  /// The transaction ensures that the session used for acquiring the lock is
  /// kept alive in the underlying connection pool, and that we can later use
  /// that exact same session for releasing the lock. The transaction is thus
  /// only used to get the desired behavior from the database driver, and does
  /// not have any effect on the Postgres level.
  ///
  /// This ensures that we are only running migrations one at a time.
  @override
  Future<void> runMigrations(
    DatabaseSession session,
    Future<void> Function(Transaction? transaction) action,
  ) async {
    const String lockName = 'serverpod_migration_lock';

    await session.db.transaction((transaction) async {
      await session.db.unsafeExecute(
        "SELECT pg_advisory_lock(hashtext('$lockName'));",
        transaction: transaction,
      );

      try {
        await action(null);
      } finally {
        await session.db.unsafeExecute(
          "SELECT pg_advisory_unlock(hashtext('$lockName'));",
          transaction: transaction,
        );
      }
    });
  }

  Future<Map<String, Map<Object, List<Map<String, dynamic>>>>>
  _queryIncludedLists(
    DatabaseSession session,
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
            .map(
              (rawRow) => resolvePrefixedQueryRow(
                relationTable,
                rawRow,
                resolvedLists,
                include: nestedInclude,
              ),
            )
            .whereType<Map<String, dynamic>>()
            .toList();

        resolvedListRelations.addAll(
          mapListToQueryById(
            resolvedList,
            relativeRelationTable,
            tableRelation.foreignFieldName,
          ),
        );
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

  List<Order>? _resolveOrderBy(
    List<Order>? orderByList,
    Column<dynamic>? orderBy,
    bool orderDescending,
  ) {
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
    return rows
        .map((row) => row.toJsonForDatabase() as Map<String, dynamic>)
        .map((row) {
          var values = column
              .map((column) {
                var unformattedValue = row[column.columnName];

                var formattedValue = poolManager.encoder.convert(
                  unformattedValue,
                );

                return '$formattedValue::${_convertToPostgresType(column)}';
              })
              .join(', ');

          return '($values)';
        })
        .join(', ');
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
    if (column is ColumnVector) return 'vector(${column.dimension})';
    if (column is ColumnHalfVector) return 'halfvec(${column.dimension})';
    if (column is ColumnSparseVector) return 'sparsevec(${column.dimension})';
    if (column is ColumnBit) return 'bit(${column.dimension})';
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

  Table _getTableOrAssert<T>(
    DatabaseSession session, {
    required String operation,
  }) {
    var table = poolManager.serializationManager.getTableForType(T);
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.$operation<MyTableClass>(where: ...);
Current type was $T''');
    return table!;
  }
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
  final DatabaseSession _session;
  final PostgresDatabaseConnection _databaseConnection;

  @override
  final Map<String, dynamic> runtimeParameters = {};

  _PostgresTransaction(
    this.executionContext,
    this._session,
    this._databaseConnection,
  );

  @override
  Future<void> cancel() async {
    await executionContext.rollback();
  }

  Future<void> _query(String query, {QueryParameters? parameters}) async {
    await _databaseConnection._query(
      _session,
      query,
      parameters: parameters,
      context: executionContext,
    );
  }

  @override
  Future<Savepoint> createSavepoint() async {
    var postgresCompatibleRandomString = const Uuid().v4().replaceAll(
      RegExp(r'-'),
      '_',
    );
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
