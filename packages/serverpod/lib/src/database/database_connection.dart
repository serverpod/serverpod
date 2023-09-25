import 'dart:async';
import 'package:retry/retry.dart';
import 'package:postgres_pool/postgres_pool.dart';
import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/database_connection_legacy.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/database_result.dart';

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

  /// Access to legacy database methods.
  late final DatabaseConnectionLegacy legacy;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this._poolManager)
      : _postgresConnection = _poolManager.pool {
    legacy = DatabaseConnectionLegacy(_poolManager, _logQuery);
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
    assert(orderByList == null || orderBy == null);
    var table = _getTableOrAssert<T>(session, operation: 'find');

    if (orderBy != null) {
      // If order by is set then order by list is overriden.
      // TODO: Only expose order by list in interface.
      orderByList = [Order(column: orderBy, orderDescending: orderDescending)];
    }

    var tableName = table.tableName;
    var query = SelectQueryBuilder(table: tableName)
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
      timeoutInSeconds: 60,
      transaction: transaction,
      include: include,
      table: table,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findRow<T extends TableRow>(
    Session session, {
    Expression? where,
    Transaction? transaction,
    Include? include,
  }) async {
    _getTableOrAssert<T>(session, operation: 'findRow');
    var rows = await find<T>(
      session,
      where: where,
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
    return await findRow<T>(
      session,
      where: table.id.equals(id),
      transaction: transaction,
      include: include,
    );
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> insertRow<T extends TableRow>(
    Session session,
    TableRow row, {
    Transaction? transaction,
  }) async {
    Map data = row.allToJson();

    for (var column in row.table.columns) {
      if (!data.containsKey(column.columnName)) {
        throw ArgumentError.value(
          column,
          column.columnName,
          'does not exist in row',
        );
      }
    }

    var selectedColumns = row.table.columns.where((column) {
      return column.columnName != 'id';
    });

    var columns =
        selectedColumns.map((column) => '"${column.columnName}"').join(', ');

    var values = selectedColumns.map((column) {
      var unformattedValue = data[column.columnName];
      return DatabasePoolManager.encoder.convert(unformattedValue);
    }).join(', ');

    var query =
        'INSERT INTO "${row.table.tableName}" ($columns) VALUES ($values) RETURNING *';

    var result = await _deserializedQuery<T>(
      session,
      query,
      transaction: transaction,
    );

    if (result.length != 1) {
      throw PostgreSQLException(
          'Failed to insert row, updated number of rows is ${result.length} != 1');
    }

    return result.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> updateRow<T extends TableRow>(
    Session session,
    TableRow row, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    var selectedColumns = columns ?? row.table.columns;
    Map data = row.allToJson();

    int? id = data['id'];
    if (id == null) {
      throw ArgumentError.notNull('row.id');
    }

    for (var column in selectedColumns) {
      if (!data.containsKey(column.columnName)) {
        throw ArgumentError.value(
          column,
          column.columnName,
          'does not exist in row',
        );
      }
    }

    var updates = selectedColumns
        .where((column) => column.columnName != 'id')
        .map((column) {
      var value = DatabasePoolManager.encoder.convert(data[column.columnName]);
      return '"${column.columnName}" = $value';
    }).join(', ');

    var query =
        'UPDATE ${row.table.tableName} SET $updates WHERE id = $id RETURNING *';

    var updated = await _deserializedQuery<T>(
      session,
      query,
      transaction: transaction,
    );

    if (updated.isEmpty) {
      throw PostgreSQLException('Failed to update row, no rows updated');
    }

    return updated.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> deleteRow(
    Session session,
    TableRow row, {
    Transaction? transaction,
  }) async {
    int? id = row.id;
    if (id == null) {
      throw ArgumentError.notNull('row.id');
    }

    var query = DeleteQueryBuilder(table: row.table.tableName)
        .withWhere(Expression('id = $id'))
        .withReturnId()
        .build();

    var result = await this.query(session, query, transaction: transaction);

    if (result.isEmpty) {
      throw PostgreSQLException('Failed to delete row, no rows deleted.');
    }
    return result.first.first;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<int>> deleteWhere<T extends TableRow>(
    Session session,
    Expression where, {
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteWhere');

    var query = DeleteQueryBuilder(table: table.tableName)
        .withReturnId()
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

    var query = CountQueryBuilder(table: table.tableName)
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
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction?.postgresContext ?? _postgresConnection;

      var result = await context.query(
        query,
        allowReuse: false,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: {},
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

  Future<List<Map<String, Map<String, dynamic>>>> _mappedResultsQuery(
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

  Future<List<T>> _deserializedQuery<T extends TableRow>(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var result = await this.query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );

    return result
        .map((row) => row.toColumnMap())
        .map((row) => _poolManager.serializationManager.deserialize<T>(row))
        .toList();
  }

  Future<List<T>> _deserializedMappedQuery<T extends TableRow>(
    Session session,
    String query, {
    required Table table,
    int? timeoutInSeconds,
    Transaction? transaction,
    Include? include,
  }) async {
    var result = await _mappedResultsQuery(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );

    return result
        .map((rawRow) => resolvePrefixedQueryRow(
              table,
              rawRow,
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
        var transaction = Transaction._(ctx);
        return transactionFunction(transaction);
      },
      retryOptions: retryOptions,
      orElse: orElse,
      retryIf: retryIf,
    );
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

/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// Defines how to order a database [column].
class Order {
  /// The columns to order by.
  final Column column;

  /// Whether the column should be ordered ascending or descending.
  final bool orderDescending;

  /// Creates a new [Order] definition for a specific [column] and whether it
  /// should be ordered descending or ascending.
  Order({required this.column, this.orderDescending = false});

  @override
  String toString() {
    var str = '$column';
    if (orderDescending) str += ' DESC';
    return str;
  }
}

/// Holds the state of a running database transaction.
class Transaction {
  /// The Postgresql execution context associated with a running transaction.
  final PostgreSQLExecutionContext postgresContext;
  Transaction._(this.postgresContext);
}

/// Defines what tables to join when querying a table.
abstract class Include {
  /// Map containing the relation field name as key and the [Include] object
  /// for the foreign table as value.
  Map<String, Include?> get includes;

  /// Accessor for the [Table] this include is for.
  Table get table;
}
