import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:postgres_pool/postgres_pool.dart';
import 'package:retry/retry.dart';
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
    final tableNames = <String>[];

    const query = 'SELECT * FROM pg_catalog.pg_tables';
    final result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: <String, dynamic>{},
    );

    for (final rowRaw in result) {
      final row = rowRaw.values.first;
      if (row['schemaname'] == 'public') {
        final tableName = row['tablename'] as String;
        tableNames.add(tableName);
      }
    }

    return tableNames;
  }

  /// Returns a description for a table in the database.
  Future<Table?> getTableDescription(String tableName) async {
    final query =
        "select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name ='$tableName'";
    final result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: <String, dynamic>{},
    );

    final columns = <Column>[];

    var hasID = false;
    for (final rows in result) {
      final row = rows.values.first;
      final columnName = row['column_name'] as String?;
      final sqlType = row['data_type'] as String?;
      final varcharLength = row['character_maximum_length'] as int?;
      final type = _sqlTypeToDartType(sqlType);

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
  }) async {
    final result = await find<T>(
      where: Expression('id = $id'),
      session: session,
      transaction: transaction,
    );
    if (result.isEmpty) return null;
    return result[0];
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> find<T extends TableRow>({
    required Session session,
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    assert(orderByList == null || orderBy == null);
    var table = session.serverpod.serializationManager.getTableForType(T);
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.find<MyTableClass>(where: ...);
Current type was $T''');
    table = table!;

    final startTime = DateTime.now();
    where ??= Expression('TRUE');

    final tableName = table.tableName;
    var query = 'SELECT * FROM $tableName WHERE $where';
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
      if (orderDescending) query += ' DESC';
    } else if (orderByList != null) {
      assert(orderByList.isNotEmpty);

      final strList = <String>[];
      for (final order in orderByList) {
        strList.add(order.toString());
      }

      query += ' ORDER BY ${strList.join(',')}';
    }
    if (limit != null) query += ' LIMIT $limit';
    if (offset != null) query += ' OFFSET $offset';

    final list = <TableRow?>[];
    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: <String, dynamic>{},
      );
      for (final rawRow in result) {
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
  Future<T?> findSingleRow<T extends TableRow>({
    required Session session,
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    final result = await find<T>(
      where: where,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      limit: 1,
      offset: offset,
      session: session,
      transaction: transaction,
    );

    if (result.isEmpty) {
      return null;
    } else {
      return result[0];
    }
  }

  //TODO: is this still needed?
  T? _formatTableRow<T extends TableRow>(
    String tableName,
    Map<String, dynamic>? rawRow,
  ) {
    final data = <String, dynamic>{};

    for (final columnName in rawRow!.keys) {
      final dynamic value = rawRow[columnName];

      if (value is DateTime) {
        data[columnName] = value.toIso8601String();
      } else if (value is Uint8List) {
        final byteData = ByteData.view(
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
    required Session session,
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    var table = session.serverpod.serializationManager.getTableForType(T);
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. numRows = await session.db.count<MyTableClass>();
Current type was $T''');
    table = table!;

    final startTime = DateTime.now();

    where ??= Expression('TRUE');

    final tableName = table.tableName;
    var query = 'SELECT COUNT(*) as c FROM $tableName WHERE $where';
    if (limit != null) query += ' LIMIT $limit';

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final result = await context.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{},
      );

      if (result.length != 1) return 0;

      final returnedRow = result[0];
      if (returnedRow.length != 1) return 0;

      _logQuery(session, query, startTime, numRowsAffected: 1);
      return returnedRow[0] as int;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> update(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    final startTime = DateTime.now();

    final data = row.toJsonForDatabase();

    final id = data['id'] as int?;

    final updatesList = <String>[];

    for (final column in data.keys) {
      if (column == 'id') continue;

      final value = DatabasePoolManager.encoder.convert(data[column]);

      updatesList.add('"$column" = $value');
    }
    final updates = updatesList.join(', ');

    final query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final affectedRows = await context.execute(
        query,
        substitutionValues: <String, dynamic>{},
      );

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
    final startTime = DateTime.now();

    final Map data = row.toJsonForDatabase();

    final columnsList = <String>[];
    final valueList = <String>[];

    for (final column in data.keys as Iterable<String>) {
      if (column == 'id') continue;

      final dynamic unformattedValue = data[column];

      final value = DatabasePoolManager.encoder.convert(unformattedValue);

      columnsList.add('"$column"');
      valueList.add(value);
    }
    final columns = columnsList.join(', ');
    final values = valueList.join(', ');

    final query =
        'INSERT INTO ${row.tableName} ($columns) VALUES ($values) RETURNING id';

    int insertedId;
    try {
      List<List<dynamic>> result;

      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      result = await context.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{},
      );

      if (result.length != 1) {
        throw PostgreSQLException(
          'Failed to insert row, '
          'updated number of rows is ${result.length} != 1',
        );
      }

      final returnedRow = result[0];
      if (returnedRow.length != 1) {
        throw PostgreSQLException(
          'Failed to insert row, '
          'updated number of columns is ${returnedRow.length} != 1',
        );
      }

      insertedId = returnedRow[0] as int;
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
    var table = session.serverpod.serializationManager.getTableForType(T);
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. numRows = await session.db.delete<MyTableClass>(where: ...);
Current type was $T''');
    table = table!;

    final startTime = DateTime.now();

    final tableName = table.tableName;

    final query = 'DELETE FROM $tableName WHERE $where';

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final affectedRows = await context.execute(
        query,
        substitutionValues: <String, dynamic>{},
      );
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
    var table = session.serverpod.serializationManager.getTableForType(T);
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.deleteAndReturn<MyTableClass>(where: ...);
Current type was $T''');
    table = table!;

    final startTime = DateTime.now();

    final tableName = table.tableName;
    final query = 'DELETE FROM $tableName WHERE $where RETURNING *';

    final list = <TableRow?>[];
    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: <String, dynamic>{},
      );

      for (final rawRow in result) {
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
    final startTime = DateTime.now();

    final query = 'DELETE FROM ${row.tableName} WHERE id = ${row.id}';

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final affectedRows = await context.execute(
        query,
        substitutionValues: <String, dynamic>{},
      );

      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> storeFile(
    String storageId,
    String path,
    ByteData byteData,
    DateTime? expiration,
    bool verified, {
    required Session session,
  }) async {
    final startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      final encoded = byteData.base64encodedString();
      query =
          'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "verified", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @verified, $encoded) ON CONFLICT("storageId", "path") DO UPDATE SET "byteData"=$encoded, "addedTime"=@addedTime, "expiration"=@expiration, "verified"=@verified';
      await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{
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
  Future<ByteData?> retrieveFile(
    String storageId,
    String path, {
    required Session session,
  }) async {
    final startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      query = 'SELECT encode("byteData", \'base64\') '
          'AS "encoded" FROM serverpod_cloud_storage '
          'WHERE "storageId"=@storageId AND path=@path AND verified=@verified';
      final result = await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{
          'storageId': storageId,
          'path': path,
          'verified': true,
        },
      );
      _logQuery(session, query, startTime);
      if (result.isNotEmpty) {
        final encoded = (result.first.first as String).replaceAll('\n', '');
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
  Future<bool> verifyFile(
    String storageId,
    String path, {
    required Session session,
  }) async {
    // Check so that the file is saved, but not
    var startTime = DateTime.now();
    const query = 'SELECT verified FROM serverpod_cloud_storage '
        'WHERE "storageId"=@storageId AND "path"=@path';
    try {
      final result = await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{
          'storageId': storageId,
          'path': path,
        },
      );
      _logQuery(session, query, startTime);

      if (result.isEmpty) return false;

      final verified = result.first.first as bool;
      if (verified) return false;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }

    startTime = DateTime.now();
    try {
      const query =
          'UPDATE serverpod_cloud_storage '
          'SET "verified"=@verified '
          'WHERE "storageId"=@storageId AND "path"=@path';
      await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: <String, dynamic>{
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
  Future<List<List<dynamic>>> query(
    String query, {
    required Session session,
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    final startTime = DateTime.now();

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final result = await context.query(
        query,
        allowReuse: false,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: <String, dynamic>{},
      );
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
    final startTime = DateTime.now();

    try {
      final context = transaction != null
          ? transaction.postgresContext
          : postgresConnection;

      final result = await context.execute(
        query,
        timeoutInSeconds: timeoutInSeconds,
        substitutionValues: <String, dynamic>{},
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
    Object? exception,
    StackTrace? trace,
  }) {
    // Check if this query should be logged.
    final logSettings = session.serverpod.logManager.getLogSettingsForSession(
      session,
    );
    final duration =
        DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
    final slow = duration >= logSettings.slowQueryDuration;
    final shouldLog = session.serverpod.logManager.shouldLogQuery(
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
    final entry = QueryLogEntry(
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
        final transaction = Transaction._(ctx);
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
