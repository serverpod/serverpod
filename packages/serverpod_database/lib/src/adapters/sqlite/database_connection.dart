import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
// We only use the `source_span` package to generated expected inputs for the
// `sqlparser` package, which depends on it for public interfaces.
// ignore: depend_on_referenced_packages
import 'package:sqlite3/common.dart' hide Session;
import 'package:sqlite_async/sqlite_async.dart';
import 'package:sqlparser/sqlparser.dart'
    show
        BaseSelectStatement,
        BeginTransactionStatement,
        CommitStatement,
        DeleteStatement,
        InsertStatement,
        ParserEntrypoint,
        SqlEngine,
        Statement,
        UpdateStatement;

import '../../../serverpod_database.dart';
import '../../concepts/table_relation.dart';
import '../../interface/database_connection.dart';
import '../../util/query_result_parser.dart';
import '../postgres/sql_query_builder.dart';
import 'sqlite_database_result.dart';
import 'sqlite_pool_manager.dart';
import 'sqlite_query_parameters.dart';

part 'sqlite_exceptions.dart';

/// A connection to the SQLite database.
@internal
class SqliteDatabaseConnection extends DatabaseConnection<SqlitePoolManager> {
  SqliteDatabaseConnection(super.poolManager);

  static final _sqlEngine = SqlEngine();

  Zone? _currentTransactionParentZone;

  SqliteDatabase get _db => poolManager.database;

  @override
  Future<bool> testConnection() async {
    return poolManager.testConnection();
  }

  @override
  Future<List<T>> find<T extends TableRow>(
    DatabaseSession session, {
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    Include? include,
    Transaction? transaction,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'find');
    var orderByCols = _resolveOrderBy(orderByList, orderBy, orderDescending);

    await _warnIfSqliteIgnoresLockBehavior(
      session,
      operation: 'finding rows',
      lockBehavior: lockBehavior,
    );

    var query = SelectQueryBuilder(table: table)
        .withSelectFields(table.columns)
        .withWhere(where)
        .withOrderBy(orderByCols)
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

  @override
  Future<T?> findFirstRow<T extends TableRow>(
    DatabaseSession session, {
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
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
      // ignore: deprecated_member_use_from_same_package
      orderDescending: orderDescending,
      limit: 1,
      transaction: transaction,
      include: include,
      lockBehavior: lockBehavior,
      lockMode: lockMode,
    );

    if (rows.isEmpty) return null;
    return rows.first;
  }

  @override
  Future<T?> findById<T extends TableRow>(
    DatabaseSession session,
    Object id, {
    Transaction? transaction,
    Include? include,
    LockBehavior? lockBehavior,
    LockMode? lockMode,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'findById');
    return await findFirstRow<T>(
      session,
      where: table.id.equals(id),
      transaction: transaction,
      include: include,
      lockBehavior: lockBehavior,
      lockMode: lockMode,
    );
  }

  /// No-op for SQLite.
  ///
  /// Since SQLite allow only one write transaction at a time, locking specific
  /// rows is not necessary - nor supported by the SQLite engine. Given that
  /// [lockRows] require a transaction, the lock will be acquired implicitly.
  ///
  /// This method is no-op to maintain compatibility with code that can also
  /// be run against other databases.
  @override
  Future<void> lockRows<T extends TableRow>(
    DatabaseSession session, {
    required Expression where,
    required LockMode lockMode,
    required Transaction transaction,
    LockBehavior lockBehavior = LockBehavior.wait,
  }) async {
    await _warnIfSqliteIgnoresLockBehavior(
      session,
      operation: 'locking rows',
      lockBehavior: lockBehavior,
    );
  }

  Future<void> _warnIfSqliteIgnoresLockBehavior(
    DatabaseSession session, {
    required String operation,
    LockBehavior? lockBehavior,
  }) async {
    if (lockBehavior == null || lockBehavior == LockBehavior.wait) return;
    await session.logWarning?.call(
      'The lock behavior "$lockBehavior" has no effect when $operation '
      'on SQLite because SQLite does not support concurrent writes and the '
      'transaction will acquire a lock implicitly. To suppress this warning, '
      'either skip locking or use "LockBehavior.wait".',
    );
  }

  @override
  Future<List<T>> insert<T extends TableRow>(
    DatabaseSession session,
    List<T> rows, {
    Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    if (rows.isEmpty) return [];
    if (rows.length > 1) {
      return DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (tx) async => [
          for (var row in rows)
            await insert<T>(
              session,
              [row],
              transaction: tx,
              ignoreConflicts: ignoreConflicts,
            ).then((results) => results.firstOrNull),
        ].whereType<T>().toList(),
      );
    }

    final allMaps = [
      for (final withIdNull in [true, false])
        ...await _runInsert(
          session,
          rows,
          ignoreConflicts,
          withIdNull,
          transaction,
        ),
    ];

    var merged = _mergeResultsWithNonPersistedFields(rows)(allMaps);
    return merged.map(poolManager.serializationManager.deserialize<T>).toList();
  }

  Future<List<Map<String, dynamic>>> _runInsert<T extends TableRow>(
    DatabaseSession session,
    List<T> rows,
    bool ignoreConflicts,
    bool withIdNull,
    Transaction? transaction,
  ) async {
    var filteredRows = rows
        .where((r) => withIdNull ? r.id == null : r.id != null)
        .toList();

    if (filteredRows.isEmpty) return [];
    if (filteredRows.length > 1 && transaction == null) {
      throw StateError('Transaction is required for batch inserts');
    }

    var table = rows.first.table;
    var columns = withIdNull
        ? table.columns.where((c) => c.columnName != 'id').toList()
        : table.columns;

    // SQLite does not support DEFAULT in VALUES; omit columns that are null
    // and have a default so SQLite applies the column default.
    var rowPayloads = <_RowPayload>[];
    for (var row in filteredRows) {
      var rowJson = row.toJsonForDatabase() as Map<String, dynamic>;
      var includedColumns = <Column>[];
      var encodedValues = <String>[];
      for (var column in columns) {
        final rawValue = rowJson[column.columnName];
        final useDefault = rawValue == null && column.hasDefault;
        if (!useDefault) {
          includedColumns.add(column);
          encodedValues.add(
            poolManager.encoder.encodeColumnValue(
              column,
              rawValue,
              hasDefaults: false,
            ),
          );
        }
      }
      rowPayloads.add(_RowPayload(includedColumns, encodedValues));
    }

    // No need to run in transaction or savepoint here, since we are already
    // ensure that any batch with more than 1 row has a transaction or
    // savepoint at the caller's site.
    return [
      for (var p in rowPayloads)
        ...await _mappedResultsQuery(
          session,
          _buildSqlSingleRowInsert(
            table: table,
            columns: p.columns,
            encodedValues: p.values,
            ignoreConflicts: ignoreConflicts,
          ),
          transaction: transaction,
          table: table,
        ),
    ];
  }

  @override
  Future<T> insertRow<T extends TableRow>(
    DatabaseSession session,
    T row, {
    Transaction? transaction,
  }) async {
    var result = await insert<T>(session, [row], transaction: transaction);

    if (result.length != 1) {
      throw _SqliteDatabaseInsertRowException(
        'Failed to insert row, updated number of rows is ${result.length} != 1',
      );
    }

    return result.first;
  }

  @override
  Future<List<T>> update<T extends TableRow>(
    DatabaseSession session,
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];
    if (rows.any((r) => r.id == null)) {
      throw ArgumentError.notNull('row.id');
    }

    if (rows.length > 1) {
      return DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (tx) async => [
          for (var row in rows)
            await update<T>(
              session,
              [row],
              columns: columns,
              transaction: tx,
            ).then((r) => r.firstOrNull),
        ].whereType<T>().toList(),
      );
    }

    var table = rows.first.table;
    var selectedColumns = (columns ?? table.managedColumns).toSet();
    if (columns != null) {
      _validateColumnsExists(selectedColumns, table.columns.toSet());
      selectedColumns.add(table.id);
    }

    var encoder = poolManager.encoder;
    var results = <Map<String, dynamic>>[];

    for (var row in rows) {
      var rowJson = row.toJsonForDatabase() as Map<String, dynamic>;
      var setParts = <String>[];
      var idValue = encoder.convert(row.id);

      for (var col in selectedColumns) {
        if (col.columnName == 'id') continue;
        final rawValue = rowJson[col.columnName];
        setParts.add(_buildSetExpression(col, rawValue));
      }
      if (setParts.isEmpty) {
        // No columns to update (e.g. columns: (t) => [t.id]); keep SQL valid.
        setParts.add('"${table.id.columnName}" = $idValue');
      }

      // No need to run in transaction or savepoint here, since we are already
      // ensure that any batch with more than 1 row has a transaction or
      // savepoint at the top level.
      results.addAll(
        await _mappedResultsQuery(
          session,
          _buildSqlUpdateWhereId(
            table: table,
            setClause: setParts.join(', '),
            idSqlValue: idValue,
          ),
          transaction: transaction,
          table: table,
        ),
      );
    }

    var merged = _mergeResultsWithNonPersistedFields(rows)(results);
    return merged.map(poolManager.serializationManager.deserialize<T>).toList();
  }

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
      throw _SqliteDatabaseUpdateRowException(
        'Failed to update row, no rows updated',
      );
    }

    return updated.first;
  }

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

    var encoder = poolManager.encoder;
    var setClause = _buildSetClause(columnValues);

    var result = await _mappedResultsQuery(
      session,
      _buildSqlUpdateWhereId(
        table: table,
        setClause: setClause,
        idSqlValue: encoder.convert(id),
      ),
      transaction: transaction,
      table: table,
    );

    if (result.isEmpty) {
      throw _SqliteDatabaseUpdateRowException(
        'Failed to update row, no rows updated',
      );
    }

    return poolManager.serializationManager.deserialize<T>(result.first);
  }

  @override
  Future<List<T>> updateWhere<T extends TableRow>(
    DatabaseSession session, {
    required List<ColumnValue> columnValues,
    required Expression where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'updateWhere');

    if (columnValues.isEmpty) {
      throw ArgumentError('columnValues cannot be empty');
    }

    var requiresFilteredSubquery =
        limit != null ||
        offset != null ||
        orderBy != null ||
        orderByList != null;

    String selectQuery;
    if (requiresFilteredSubquery) {
      var orders = _resolveOrderBy(orderByList, orderBy, orderDescending);
      // SQLite requires LIMIT if using OFFSET. In this case, use a large limit.
      var effectiveLimit = limit ?? (offset != null ? 0x7fffffff : null);
      selectQuery = SelectQueryBuilder(table: table)
          .withSelectFields([table.id])
          .withWhere(where)
          .withOrderBy(orders)
          .withLimit(effectiveLimit)
          .withOffset(offset)
          .build();
    } else {
      selectQuery = SelectQueryBuilder(
        table: table,
      ).withSelectFields([table.id]).withWhere(where).build();
    }

    // Get ids to update, then UPDATE ... WHERE id IN (...)
    var idResult = await _mappedResultsQuery(
      session,
      selectQuery,
      transaction: transaction,
      table: table,
      prefixedColumns: true,
    );
    if (idResult.isEmpty) return [];

    // Select result may use column or field name depending on query/engine.
    var idQueryKey = truncateIdentifier(
      table.id.fieldQueryAlias,
      DatabaseConstants.pgsqlMaxNameLimitation,
    );

    var idKey = table.id.columnName;
    var idKeyAlt = table.id.fieldName;
    var ids = idResult
        .map((r) => r[idQueryKey] ?? r[idKey] ?? r[idKeyAlt])
        .whereType<Object>()
        .toList();

    var idList = ids.map(poolManager.encoder.convert).join(', ');

    var result = await _mappedResultsQuery(
      session,
      _buildSqlUpdateWhereIdIn(
        table: table,
        setClause: _buildSetClause(columnValues),
        idListSql: idList,
      ),
      transaction: transaction,
      table: table,
    );
    if (requiresFilteredSubquery) {
      result = _restoreOperationWhereSelectionOrder(result, table, ids);
    }

    return result.map(poolManager.serializationManager.deserialize<T>).toList();
  }

  @override
  Future<List<T>> delete<T extends TableRow>(
    DatabaseSession session,
    List<T> rows, {
    Column? orderBy,
    List<Column>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    Transaction? transaction,
  }) async {
    if (rows.isEmpty) return [];
    if (rows.any((r) => r.id == null)) {
      throw ArgumentError.notNull('row.id');
    }

    var table = rows.first.table;
    return deleteWhere<T>(
      session,
      table.id.inSet(rows.map((row) => row.id!).castToIdType().toSet()),
      orderBy: orderBy,
      orderByList: orderByList,
      // ignore: deprecated_member_use_from_same_package
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  @override
  Future<T> deleteRow<T extends TableRow>(
    DatabaseSession session,
    T row, {
    Transaction? transaction,
  }) async {
    var result = await delete<T>(session, [row], transaction: transaction);

    if (result.isEmpty) {
      throw _SqliteDatabaseDeleteRowException(
        'Failed to delete row, no rows deleted.',
      );
    }

    return result.first;
  }

  @override
  Future<List<T>> deleteWhere<T extends TableRow>(
    DatabaseSession session,
    Expression where, {
    Column? orderBy,
    List<Column>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteWhere');
    var orderByCols = _resolveOrderBy(orderByList, orderBy, orderDescending);

    // SQLite does not support DELETE ... USING. Use subquery to get ids first.
    var selectIdsQuery = SelectQueryBuilder(table: table)
        .withSelectFields([table.id])
        .withWhere(where)
        .withOrderBy(orderByCols)
        .build();

    // It is not possible to use data-modifying CTEs with delete on SQLite to
    // order the deleted rows, so we need to first select the ids and then
    // delete the rows. For the operation to be atomic, it runs inside a
    // transaction or savepoint.
    if (orderByCols != null) {
      return await DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (tx) async {
          final orderedIds = (await _mappedResultsQuery(
            session,
            selectIdsQuery,
            transaction: tx,
          )).map((row) => row.values.first as Object).toList();

          return await _deleteWhereOrdered<T>(
            session,
            table,
            selectIdsQuery,
            where,
            orderedIds: orderedIds,
            transaction: tx,
          );
        },
      );
    }

    return await _deleteWhereOrdered<T>(
      session,
      table,
      selectIdsQuery,
      where,
      transaction: transaction,
    );
  }

  Future<List<T>> _deleteWhereOrdered<T extends TableRow>(
    DatabaseSession session,
    Table table,
    String selectIdsQuery,
    Expression where, {
    List<Object>? orderedIds,
    Transaction? transaction,
  }) async {
    var deleteQuery =
        'DELETE FROM "${table.tableName}" '
        'WHERE "${table.id.columnName}" IN ($selectIdsQuery) '
        'RETURNING *';

    var result = await _mappedResultsQuery(
      session,
      deleteQuery,
      transaction: transaction,
      table: table,
    );

    if (orderedIds != null) {
      result = _restoreOperationWhereSelectionOrder(result, table, orderedIds);
    }

    return result.map(poolManager.serializationManager.deserialize<T>).toList();
  }

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

    var result = await _runQuery(session, query, transaction: transaction);

    if (result.isEmpty) return 0;
    if (result.length != 1) return 0;

    var firstRow = result.first;
    var val = firstRow.columnAt(0);
    if (val is int) return val;
    return 0;
  }

  @override
  Future<SqliteDatabaseResult> simpleQuery(
    DatabaseSession session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return this.query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: null,
    );
  }

  @override
  Future<SqliteDatabaseResult> query(
    DatabaseSession session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async {
    var (sql, params) = convertQueryParametersForSqlite(query, parameters);
    var result = await _runQuery(
      session,
      sql,
      parameters: params,
      transaction: transaction,
    );
    return SqliteDatabaseResult(result);
  }

  @override
  Future<int> execute(
    DatabaseSession session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async {
    var (sql, params) = convertQueryParametersForSqlite(query, parameters);

    final script = _parseSqlScriptForBatch(sql);
    if (script.length > 1 && params.isNotEmpty) {
      throw UnsupportedError(
        'Parameters are not supported for multiple statements in SQLite. To '
        'run the statements atomically, use a transaction and pass the '
        'parameters for each statement individually.',
      );
    }

    // For INSERT/UPDATE/DELETE, sqlite_async's execute() returns ResultSet with
    // 0 rows, so we need to read the affected row count via SELECT changes().
    if (script.any((s) => s.isWriteStatement) && transaction == null) {
      return _db.computeWithDatabase((db) async {
        var updatedRows = 0;
        for (final statement in script) {
          db.execute(statement.text, params);
          updatedRows += db.updatedRows;
        }
        return updatedRows;
      });
    }

    var result = await _runQueryWithScript(
      session,
      script,
      parameters: params,
      transaction: transaction,
    );

    // For INSERT/UPDATE/DELETE, sqlite_async's execute() returns ResultSet with
    // 0 rows, so we need to read the affected row count via SELECT changes().
    if (result.isEmpty && transaction != null) {
      return _sqliteChangesFromTransaction(transaction);
    }

    // This is required to match Postgres execute() behavior, which returns the
    // number of rows affected by the last statement, even if it is a SELECT
    // statement.
    return result.length;
  }

  @override
  Future<int> simpleExecute(
    DatabaseSession session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return execute(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: null,
    );
  }

  @override
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    required TransactionSettings settings,
    required DatabaseSession session,
  }) async {
    try {
      // Set a reference to the parent zone (outside the transaction) to allow
      // for concurrent reads to operate while a write lock is held. Will skip
      // assigning if already set to preserve the highest parent zone.
      _currentTransactionParentZone ??= Zone.current;
      return await _db.writeTransaction<R>((tx) async {
        var transaction = _SqliteTransaction(tx, session);
        final result = await transactionFunction(transaction);
        if (transaction._isCancelled) {
          throw _TransactionCancelledException(result);
        }
        return result;
      });
    } on _TransactionCancelledException catch (e) {
      return e.result;
    } finally {
      _currentTransactionParentZone = null;
    }
  }

  List<_ParsedSqlStatement> _parseSqlScriptForBatch(String sql) =>
      _parseSqlScript(sql)
          .where((statement) => !statement.isEmpty)
          .where((statement) => !statement.shouldSkipInBatchQuery)
          .toList();

  Future<ResultSet> _runQuery(
    DatabaseSession session,
    String query, {
    List<Object?>? parameters,
    Transaction? transaction,
  }) {
    return _runQueryWithScript(
      session,
      _parseSqlScriptForBatch(query),
      parameters: parameters,
      transaction: transaction,
    );
  }

  Future<ResultSet> _runQueryWithScript(
    DatabaseSession session,
    List<_ParsedSqlStatement> script, {
    List<Object?>? parameters,
    Transaction? transaction,
  }) async {
    // If the query contain multiple statements and at least one of them is a
    // write statement, we must wrap it in a transaction or savepoint to ensure
    // it is executed atomically.
    if (script.length > 1 &&
        script.any((statement) => statement.isWriteStatement)) {
      return DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (tx) => _runParsedSqlScript(
          session,
          script,
          parameters ?? const [],
          _castToSqliteTransaction(tx),
        ),
      );
    }

    return _runParsedSqlScript(
      session,
      script,
      parameters ?? const [],
      _castToSqliteTransaction(transaction),
    );
  }

  Future<ResultSet> _runParsedSqlScript(
    DatabaseSession session,
    List<_ParsedSqlStatement> script,
    List<Object?> parameters,
    _SqliteTransaction? sqliteTx,
  ) async {
    ResultSet? result;
    for (final statement in script) {
      result = await _runSingleStatementQuery(
        session,
        statement,
        parameters: parameters,
        sqliteTx: sqliteTx,
      );
    }

    return result ?? ResultSet([], null, []);
  }

  Future<ResultSet> _runSingleStatementQuery(
    DatabaseSession session,
    _ParsedSqlStatement parsed, {
    List<Object?>? parameters,
    _SqliteTransaction? sqliteTx,
  }) async {
    var startTime = DateTime.now();
    var stopwatch = Stopwatch()..start();
    parameters ??= const [];
    final statement = parsed.text.trim();
    if (statement.isEmpty) {
      return ResultSet([], null, []);
    }

    try {
      late ResultSet result;

      poolManager.lastDatabaseOperationTime = startTime;

      if (sqliteTx != null) {
        result = parsed.isSelectStatement
            ? await sqliteTx.getAll(statement, parameters)
            : await sqliteTx.execute(statement, parameters);
      } else {
        Future<ResultSet> runQuery() async {
          return parsed.isSelectStatement
              ? await _db.getAll(statement, parameters ?? const [])
              : await _db.execute(statement, parameters ?? const []);
        }

        final transactionParentZone = _currentTransactionParentZone;
        result = (parsed.isSelectStatement && transactionParentZone != null)
            ? await transactionParentZone.fork().run(runQuery)
            : await runQuery();
      }

      _logQuery(session, statement, stopwatch, numRowsAffected: result.length);
      return result;
    } catch (exception, trace) {
      final serverpodException = exception is _SqliteDatabaseQueryException
          ? exception
          : _SqliteDatabaseQueryException.fromSqliteException(exception);
      _logQuery(
        session,
        statement,
        stopwatch,
        exception: serverpodException,
        trace: trace,
      );
      Error.throwWithStackTrace(serverpodException, trace);
    }
  }

  /// Maps a row from database column names to protocol field names when the
  /// table has explicit column names. Required so RETURNING * deserialization
  /// matches what Protocol expects (field names).
  static Map<String, dynamic> _rowDbColumnNamesToFieldNames(
    Table table,
    Map<String, dynamic> row,
  ) {
    if (!table.hasColumnMapping) return row;
    var result = <String, dynamic>{};
    for (var col in table.columns) {
      if (row.containsKey(col.columnName)) {
        result[col.fieldName] = row[col.columnName];
      }
    }
    return result;
  }

  Map<String, dynamic> _normalizeQueryResultRow(
    Map<String, dynamic> row,
    Table table, {
    Include? include,
    bool prefixedColumns = false,
  }) {
    if (!prefixedColumns) {
      final fieldNamedRow = table.hasColumnMapping
          ? _rowDbColumnNamesToFieldNames(table, row)
          : row;

      return {
        for (final column in table.columns)
          if (fieldNamedRow.containsKey(column.fieldName))
            column.fieldName: poolManager.encoder.coerceColumnValue(
              column,
              fieldNamedRow[column.fieldName],
            ),
      };
    }

    final normalized = Map<String, dynamic>.from(row);
    _normalizePrefixedColumns(normalized, table, include: include);
    return normalized;
  }

  void _normalizePrefixedColumns(
    Map<String, dynamic> row,
    Table table, {
    Include? include,
  }) {
    for (final column in table.columns) {
      final key = truncateIdentifier(
        column.fieldQueryAlias,
        DatabaseConstants.pgsqlMaxNameLimitation,
      );
      if (row.containsKey(key)) {
        row[key] = poolManager.encoder.coerceColumnValue(
          column,
          row[key],
        );
      }
    }

    include?.includes.forEach((relationField, relationInclude) {
      if (relationInclude == null || relationInclude is IncludeList) return;
      final relationTable = table.getRelationTable(relationField);
      if (relationTable == null) return;
      _normalizePrefixedColumns(
        row,
        relationTable,
        include: relationInclude,
      );
    });
  }

  String _buildSetClause(List<ColumnValue> columnValues) {
    return columnValues
        .map((columnValue) {
          return _buildSetExpression(
            columnValue.column,
            columnValue.value,
          );
        })
        .join(', ');
  }

  String _buildSetExpression(Column column, dynamic value) {
    final encodedValue = poolManager.encoder.encodeColumnValue(column, value);
    return '"${column.columnName}" = $encodedValue';
  }

  /// SQLite applies `ORDER BY`, `LIMIT`, and `OFFSET` in the preliminary
  /// `SELECT id ...` used by `updateWhere`, but the subsequent
  /// `UPDATE ... WHERE id IN (...) RETURNING *` does not preserve that row
  /// order. Re-apply the selected id order so `updateWhere` returns rows in the
  /// same order implied by the caller's query options. The same applies to
  /// delete operations, in which the result order is arbitrary. A pre-selected
  /// list of ids is then provided to restore the order.
  static Iterable<Map<String, dynamic>> _restoreOperationWhereSelectionOrder(
    Iterable<Map<String, dynamic>> rows,
    Table table,
    List<Object> ids,
  ) {
    final orderById = <Object, int>{
      for (var index = 0; index < ids.length; index++) ids[index]: index,
    };
    final sortedRows = rows.toList();
    sortedRows.sort((a, b) {
      final aIndex = orderById[a[table.id.fieldName]] ?? ids.length;
      final bIndex = orderById[b[table.id.fieldName]] ?? ids.length;
      return aIndex.compareTo(bIndex);
    });
    return sortedRows;
  }

  Future<Iterable<Map<String, dynamic>>> _mappedResultsQuery(
    DatabaseSession session,
    String query, {
    List<Object?>? parameters,
    Transaction? transaction,
    Table? table,
    Include? include,
    bool prefixedColumns = false,
  }) async {
    var result = await _runQuery(
      session,
      query,
      parameters: parameters,
      transaction: transaction,
    );

    var rows = result.map((row) => Map<String, dynamic>.from(row));
    if (table != null) {
      rows = rows.map(
        (row) => _normalizeQueryResultRow(
          row,
          table,
          include: include,
          prefixedColumns: prefixedColumns,
        ),
      );
    }
    return rows;
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
      transaction: transaction,
      table: table,
      include: include,
      prefixedColumns: true,
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
        .whereType<Map<String, dynamic>>()
        .map(poolManager.serializationManager.deserialize<T>)
        .toList();
  }

  static void _logQuery(
    DatabaseSession session,
    String query,
    Stopwatch stopwatch, {
    int? numRowsAffected,
    dynamic exception,
    StackTrace? trace,
  }) {
    stopwatch.stop();
    trace ??= StackTrace.current;
    session.logQuery?.call(
      query: query,
      duration: stopwatch.elapsed,
      numRowsAffected: numRowsAffected,
      error: exception?.toString(),
      stackTrace: trace,
    );
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
          // ignore: deprecated_member_use_from_same_package
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
          table: relationTable,
          include: nestedInclude,
          prefixedColumns: true,
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
    List<Column>? orderByList,
    Column<dynamic>? orderBy,
    bool orderDescending,
  ) {
    assert(orderByList == null || orderBy == null);
    if (orderBy != null) {
      if (orderBy is Order) return [orderBy];
      return [orderDescending ? orderBy.desc() : orderBy.asc()];
    }
    if (orderByList == null || orderByList.isEmpty) return null;
    return orderByList.asOrderBy();
  }

  List<Map<String, dynamic>> Function(Iterable<Map<String, dynamic>>)
  _mergeResultsWithNonPersistedFields<T extends TableRow>(List<T> rows) {
    return (Iterable<Map<String, dynamic>> dbResults) =>
        List<Map<String, dynamic>>.generate(dbResults.length, (i) {
          return {
            ...rows[i].toJson(),
            ...dbResults.elementAt(i),
          };
        });
  }

  /// Parses [sql] into statements using [SqlEngine.parse] (tokenizer
  /// aware of comments and strings). If that does not yield statements, runs
  /// the whole script as a single statement so SQLite still executes it (no
  /// character-level splitting).
  static List<_ParsedSqlStatement> _parseSqlScript(String sql) {
    final trimmed = sql.trim();
    if (trimmed.isEmpty) return [];
    if (!trimmed.contains(';')) {
      return [_parseOneStatement(trimmed)];
    }
    final result = _sqlEngine.parse(ParserEntrypoint.multiple, trimmed);

    final out = <_ParsedSqlStatement>[];
    for (final stmt in result.rootNode.statements) {
      final text = _stripTrailingSemicolon(result.lexemeOfNode(stmt));
      if (text.isEmpty) continue;
      out.add(_ParsedSqlStatement(text: text, ast: stmt));
    }
    if (out.isNotEmpty) return out;
    return [_parseOneStatement(trimmed)];
  }

  static _ParsedSqlStatement _parseOneStatement(String sql) {
    final result = _sqlEngine.parse(ParserEntrypoint.statement, sql);
    final root = result.rootNode;
    return _ParsedSqlStatement(text: sql, ast: root);
  }

  static String _stripTrailingSemicolon(String sql) {
    return sql.trim().replaceFirst(RegExp(r'(?:;|\s)+$'), '');
  }
}

/// Single SQL statement with optional [ast] for [SqliteDatabaseConnection].
class _ParsedSqlStatement {
  _ParsedSqlStatement({required String text, required this.ast})
    : text = text.trim();

  final String text;
  final Statement ast;

  /// Whether the statement is empty.
  bool get isEmpty => text.isEmpty;

  /// Whether the statement is a form of SELECT statement.
  bool get isSelectStatement => ast is BaseSelectStatement;

  /// Whether the statement produces row changes.
  bool get isWriteStatement =>
      ast is InsertStatement ||
      ast is UpdateStatement ||
      ast is DeleteStatement;

  /// Skipped inside transactions to avoid recursive locks.
  bool get shouldSkipInBatchQuery =>
      ast is BeginTransactionStatement || ast is CommitStatement;
}

/// Single-row INSERT with pre-encoded SQL literals.
///
/// Used when each row may list a different set of columns (for example omitting
/// columns so the database applies column defaults).
String _buildSqlSingleRowInsert({
  required Table table,
  required List<Column> columns,
  required List<String> encodedValues,
  bool ignoreConflicts = false,
}) {
  final onConflict = ignoreConflicts ? ' ON CONFLICT DO NOTHING' : '';
  if (columns.isEmpty) {
    return 'INSERT INTO "${table.tableName}" DEFAULT VALUES'
        '$onConflict RETURNING *';
  }
  final columnNames = columns.map((c) => '"${c.columnName}"').join(', ');
  final values = encodedValues.join(', ');
  return 'INSERT INTO "${table.tableName}" ($columnNames) VALUES ($values)'
      '$onConflict RETURNING *';
}

String _buildSqlUpdateWhereId({
  required Table table,
  required String setClause,
  required String idSqlValue,
}) {
  return 'UPDATE "${table.tableName}" SET $setClause '
      'WHERE "${table.id.columnName}" = $idSqlValue '
      'RETURNING *';
}

String _buildSqlUpdateWhereIdIn({
  required Table table,
  required String setClause,
  required String idListSql,
}) {
  return 'UPDATE "${table.tableName}" SET $setClause '
      'WHERE "${table.id.columnName}" IN ($idListSql) '
      'RETURNING *';
}

Table _getTableOrAssert<T>(
  DatabaseSession session, {
  required String operation,
}) {
  var table = session.db.serializationManager.getTableForType(T);
  assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.$operation<MyTableClass>(where: ...);
Current type was $T''');
  return table!;
}

_SqliteTransaction? _castToSqliteTransaction(Transaction? transaction) {
  if (transaction == null) return null;
  if (transaction is! _SqliteTransaction) {
    throw ArgumentError.value(
      transaction,
      'transaction',
      'Transaction type does not match the required database transaction type, '
          '_SqliteTransaction. You need to create the transaction from the '
          'database by calling session.db.transaction();',
    );
  }
  return transaction;
}

/// Returns the number of rows changed by the last statement, using SQLite's
/// `changes()` function.
///
/// After INSERT/UPDATE/DELETE inside a transaction, the async driver will
/// return a [ResultSet] with 0 rows if no RETURNING is used. `SELECT changes()`
/// matches the native SQLite count for that connection.
Future<int> _sqliteChangesFromTransaction(Transaction transaction) async {
  final sqliteTx = _castToSqliteTransaction(transaction)!;
  final changesResult = await sqliteTx.execute('SELECT changes()', []);
  if (changesResult.isEmpty) return 0;
  final n = changesResult.first.columnAt(0);
  return n is int ? n : int.tryParse(n.toString()) ?? 0;
}

class _RowPayload {
  final List<Column> columns;
  final List<String> values;
  _RowPayload(this.columns, this.values);
}

class _SqliteSavepoint implements Savepoint {
  @override
  final String id;
  final _SqliteTransaction _transaction;

  _SqliteSavepoint(this.id, this._transaction);

  @override
  Future<void> release() async {
    await _transaction._execute('RELEASE SAVEPOINT $id');
  }

  @override
  Future<void> rollback() async {
    await _transaction._execute('ROLLBACK TO SAVEPOINT $id');
  }
}

class _SqliteTransaction implements Transaction {
  final SqliteWriteContext _ctx;
  bool _isCancelled = false;

  @override
  final Map<String, dynamic> runtimeParameters = {};

  _SqliteTransaction(this._ctx, DatabaseSession session);

  @override
  Future<void> cancel() async {
    if (_isCancelled) return;
    _isCancelled = true;
    await _ctx.execute('ROLLBACK');
  }

  Future<ResultSet> getAll(
    String query, [
    List<Object?> parameters = const [],
  ]) {
    return _ctx.getAll(query, parameters);
  }

  Future<ResultSet> execute(
    String query, [
    List<Object?> parameters = const [],
  ]) {
    if (_isCancelled) {
      return Future.value(ResultSet([], null, []));
    }
    return _ctx.execute(query, parameters);
  }

  Future<void> _execute(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
    try {
      await _ctx.execute(sql, parameters);
    } catch (exception, trace) {
      final serverpodException = exception is _SqliteDatabaseQueryException
          ? exception
          : _SqliteDatabaseQueryException.fromSqliteException(exception);
      Error.throwWithStackTrace(serverpodException, trace);
    }
  }

  @override
  Future<Savepoint> createSavepoint() async {
    var id = 'savepoint_${const Uuid().v4().replaceAll(RegExp(r'-'), '_')}';
    await _execute('SAVEPOINT $id');
    return _SqliteSavepoint(id, this);
  }

  @override
  Future<void> setRuntimeParameters(
    RuntimeParametersListBuilder builder,
  ) async {
    // SQLite has no SET LOCAL or current_setting; only store options so
    // transaction.runtimeParameters is still populated for callers that read it.
    final parameters = builder(RuntimeParametersBuilder());
    for (var group in parameters) {
      runtimeParameters.addAll(group.options);
    }
  }
}

Set<T> _extractPrimaryKeyForRelation<T>(
  Iterable<Map<String, dynamic>> resultSet,
  TableRelation tableRelation,
) {
  var idFieldName = tableRelation.fieldQueryAliasWithJoins;
  return resultSet.map((e) => e[idFieldName] as T?).whereType<T>().toSet();
}

class _TransactionCancelledException<R> implements Exception {
  _TransactionCancelledException(this.result);

  /// The result of the transaction.
  final R result;
}
