import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:retry/retry.dart';
import 'package:postgres_pool/postgres_pool.dart';
import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/database_result.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../generated/protocol.dart';
import '../server/session.dart';
import 'database_pool_manager.dart';
import 'expressions.dart';
import 'table.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
class DatabaseConnection {
  /// Database configuration.
  final DatabasePoolManager poolManager;

  /// Access to the raw Postgresql connection pool.
  late PgPool postgresConnection;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this.poolManager) {
    postgresConnection = poolManager.pool;
  }

  /// Returns a list of names of all tables in the current database.
  Future<List<String>> getTableNames() async {
    List<String> tableNames = <String>[];

    var query = 'SELECT * FROM pg_catalog.pg_tables';
    var result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: {},
    );

    for (Map row in result) {
      row = row.values.first;
      if (row['schemaname'] == 'public') tableNames.add(row['tablename']);
    }

    return tableNames;
  }

  /// Returns a description for a table in the database.
  Future<Table?> getTableDescription(String tableName) async {
    var query =
        'select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name =\'$tableName\'';
    var result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: {},
    );
    var columns = <Column>[];

    var hasID = false;
    for (Map row in result) {
      row = row.values.first;
      String? columnName = row['column_name'];
      String? sqlType = row['data_type'];
      int? varcharLength = row['character_maximum_length'];
      var type = _sqlTypeToDartType(sqlType);

      if (columnName == 'id' && type == int) hasID = true;

      if (type == null) {
        return null;
      }

      if (type == String) {
        columns.add(ColumnString(columnName!, varcharLength: varcharLength));
      } else if (type == int) {
        columns.add(ColumnInt(columnName!));
      } else if (type == double) {
        columns.add(ColumnDouble(columnName!));
      } else if (type == DateTime) {
        columns.add(ColumnDateTime(columnName!));
      }
    }

    if (!hasID) {
      return null;
    }

    return Table(
      tableName: tableName,
      columns: columns,
    );
  }

  Type? _sqlTypeToDartType(String? type) {
    if (type == 'character varying' || type == 'text') return String;
    if (type == 'integer') return int;
    if (type == 'boolean') return bool;
    if (type == 'double precision') return double;
    if (type == 'timestamp without time zone' || type == 'date') {
      return DateTime;
    }
    return null;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findById<T extends TableRow>(
    int id, {
    required Session session,
    Transaction? transaction,
    Include? include,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'findById');
    var result = await find<T>(
      where: table.id.equals(id),
      session: session,
      transaction: transaction,
      include: include,
    );
    if (result.isEmpty) return null;
    return result[0];
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> find<T extends TableRow>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
    Include? include,
  }) async {
    assert(orderByList == null || orderBy == null);
    var table = _getTableOrAssert<T>(session, operation: 'find');

    var startTime = DateTime.now();

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

    List<TableRow?> list = <TableRow>[];
    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: {},
      );
      for (var rawRow in result) {
        var rawTableRow = resolvePrefixedQueryRow(
          table,
          rawRow,
          include: include,
        );

        list.add(_formatTableRow<T>(tableName, rawTableRow));
      }
    } catch (e, trace) {
      _logQuery(session, query, startTime, exception: e, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: list.length);
    return list.cast<T>();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findSingleRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
    Include? include,
  }) async {
    var result = await find<T>(
      where: where,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      limit: 1,
      offset: offset,
      session: session,
      transaction: transaction,
      include: include,
    );

    if (result.isEmpty) {
      return null;
    } else {
      return result[0];
    }
  }

  //TODO: is this still needed?
  T? _formatTableRow<T extends TableRow>(
      String tableName, Map<String, dynamic>? rawRow) {
    var data = <String, dynamic>{};

    for (var columnName in rawRow!.keys) {
      var value = rawRow[columnName];

      if (value is DateTime) {
        data[columnName] = value.toIso8601String();
      } else if (value is Uint8List) {
        var byteData = ByteData.view(
          value.buffer,
          value.offsetInBytes,
          value.length,
        );
        data[columnName] = byteData.base64encodedString();
      } else {
        data[columnName] = value;
      }
    }

    return poolManager.serializationManager.deserialize<T>(data);
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'count');

    var startTime = DateTime.now();

    var tableName = table.tableName;
    var query = CountQueryBuilder(table: tableName)
        .withCountAlias('c')
        .withWhere(where)
        .withLimit(limit)
        .build();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var result =
          await context.query(query, allowReuse: false, substitutionValues: {});

      if (result.length != 1) return 0;

      List returnedRow = result[0];
      if (returnedRow.length != 1) return 0;

      _logQuery(session, query, startTime, numRowsAffected: 1);
      return returnedRow[0];
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> update(
    TableRow row, {
    required Session session,
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    var data = row.toJsonForDatabase();

    columns?.forEach((column) {
      if (!data.containsKey(column.columnName)) {
        throw Exception(
          'Column ${column.columnName} does not exist in table row provided.',
        );
      }
    });

    int? id = data['id'];

    Iterable<String> cols = columns?.map((c) => c.toString()) ?? data.keys;

    String updates = cols.where((column) => column != 'id').map((column) {
      var value = DatabasePoolManager.encoder.convert(data[column]);
      return '"$column" = $value';
    }).join(', ');

    var query = 'UPDATE "${row.tableName}" SET $updates WHERE id = $id';

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var affectedRows = await context.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> insert(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    Map data = row.toJsonForDatabase();

    var columnsList = <String>[];
    var valueList = <String>[];

    for (var column in data.keys as Iterable<String>) {
      if (column == 'id') continue;

      dynamic unformattedValue = data[column];

      String value = DatabasePoolManager.encoder.convert(unformattedValue);

      columnsList.add('"$column"');
      valueList.add(value);
    }
    var columns = columnsList.join(', ');
    var values = valueList.join(', ');

    var query =
        'INSERT INTO "${row.tableName}" ($columns) VALUES ($values) RETURNING id';

    int insertedId;
    try {
      List<List<dynamic>> result;

      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      result =
          await context.query(query, allowReuse: false, substitutionValues: {});
      if (result.length != 1) {
        throw PostgreSQLException(
            'Failed to insert row, updated number of rows is ${result.length} != 1');
      }

      var returnedRow = result[0];
      if (returnedRow.length != 1) {
        throw PostgreSQLException(
            'Failed to insert row, updated number of columns is ${returnedRow.length} != 1');
      }

      insertedId = returnedRow[0];
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: 1);

    row.setColumn('id', insertedId);
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> delete<T extends TableRow>({
    required Expression where,
    required Session session,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'delete');

    var startTime = DateTime.now();

    var tableName = table.tableName;

    var query = DeleteQueryBuilder(table: tableName).withWhere(where).build();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var affectedRows = await context.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> deleteAndReturn<T extends TableRow>({
    required Expression where,
    required Session session,
    Transaction? transaction,
  }) async {
    var table = _getTableOrAssert<T>(session, operation: 'deleteAndReturn');

    var startTime = DateTime.now();

    var tableName = table.tableName;
    var query = DeleteQueryBuilder(table: tableName)
        .withWhere(where)
        .withReturnAll()
        .build();

    List<TableRow?> list = <TableRow>[];
    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: {},
      );
      for (var rawRow in result) {
        list.add(_formatTableRow<T>(tableName, rawRow[tableName]));
      }
    } catch (e, trace) {
      _logQuery(session, query, startTime, exception: e, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: list.length);
    return list.cast<T>();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> deleteRow(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    var query = DeleteQueryBuilder(table: row.tableName)
        .withWhere(Expression('id = ${row.id}'))
        .build();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var affectedRows = await context.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
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

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> storeFile(String storageId, String path, ByteData byteData,
      DateTime? expiration, bool verified,
      {required Session session}) async {
    var startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      var encoded = byteData.base64encodedString();
      query =
          'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "verified", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @verified, $encoded) ON CONFLICT("storageId", "path") DO UPDATE SET "byteData"=$encoded, "addedTime"=@addedTime, "expiration"=@expiration, "verified"=@verified';
      await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
          'addedTime': DateTime.now().toUtc(),
          'expiration': expiration?.toUtc(),
          'verified': verified,
          // TODO: Use substitution value for the data for efficiency (seems not to work with the driver currently).
          // 'byteData': byteData.buffer.asUint8List(),
        },
      );
      _logQuery(session, query, startTime);
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<ByteData?> retrieveFile(String storageId, String path,
      {required Session session}) async {
    var startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      query =
          'SELECT encode("byteData", \'base64\') AS "encoded" FROM serverpod_cloud_storage WHERE "storageId"=@storageId AND path=@path AND verified=@verified';

      var result = await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
          'verified': true,
        },
      );
      _logQuery(session, query, startTime);
      if (result.isNotEmpty) {
        var encoded = (result.first.first as String).replaceAll('\n', '');
        return ByteData.view(base64Decode(encoded).buffer);
      }
      return null;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// Returns true if the specified file has been successfully uploaded to the
  /// database cloud storage.
  Future<bool> verifyFile(String storageId, String path,
      {required Session session}) async {
    // Check so that the file is saved, but not
    var startTime = DateTime.now();
    var query =
        'SELECT verified FROM serverpod_cloud_storage WHERE "storageId"=@storageId AND "path"=@path';
    try {
      var result = await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
        },
      );
      _logQuery(session, query, startTime);

      if (result.isEmpty) return false;

      var verified = result.first.first as bool;
      if (verified) return false;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }

    startTime = DateTime.now();
    try {
      var query =
          'UPDATE serverpod_cloud_storage SET "verified"=@verified WHERE "storageId"=@storageId AND "path"=@path';
      await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
          'verified': true,
        },
      );
      _logQuery(session, query, startTime);

      return true;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<PostgreSQLResult> query(
    String query, {
    required Session session,
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      var result = await context.query(query,
          allowReuse: false,
          timeoutInSeconds: timeoutInSeconds,
          substitutionValues: {});
      _logQuery(session, query, startTime);
      return result;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> execute(
    String query, {
    required Session session,
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

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
    return postgresConnection.runTx<R>(
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
