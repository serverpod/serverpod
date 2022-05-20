import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:retry/retry.dart';
import 'package:serverpod_postgres_pool/postgres_pool.dart';
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
  Future<T?> findById<T>(
    int id, {
    required Session session,
    Transaction? transaction,
  }) async {
    var result = await find<T>(
      where: Expression('id = $id'),
      session: session,
      transaction: transaction,
    );
    if (result.isEmpty) return null;
    return result[0];
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> find<T>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
  }) async {
    assert(orderByList == null || orderBy == null);
    var table = session.serverpod.serializationManager.typeTableMapping[T];
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. myRows = await session.db.find<MyTableClass>(where: ...);
Current type was $T''');
    table = table!;

    var startTime = DateTime.now();
    where ??= Expression('TRUE');

    var tableName = table.tableName;
    var query = 'SELECT * FROM $tableName WHERE $where';
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
      if (orderDescending) query += ' DESC';
    } else if (orderByList != null) {
      assert(orderByList.isNotEmpty);

      var strList = <String>[];
      for (var order in orderByList) {
        strList.add(order.toString());
      }

      query += ' ORDER BY ${strList.join(',')}';
    }
    if (limit != null) query += ' LIMIT $limit';
    if (offset != null) query += ' OFFSET $offset';

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
        list.add(_formatTableRow(tableName, rawRow[tableName]));
      }
    } catch (e, trace) {
      _logQuery(session, query, startTime, exception: e, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: list.length);
    return list.cast<T>();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findSingleRow<T>({
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
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
    );

    if (result.isEmpty) {
      return null;
    } else {
      return result[0];
    }
  }

  TableRow? _formatTableRow(String tableName, Map<String, dynamic>? rawRow) {
    String? className = poolManager.tableClassMapping[tableName];
    if (className == null) return null;

    var data = <String, dynamic>{};

    for (var columnName in rawRow!.keys) {
      var value = rawRow[columnName];

      if (value is DateTime) {
        data[columnName] = value.toIso8601String();
      } else if (value is Uint8List) {
        throw (UnimplementedError('Binary storage is not yet supported.'));

        // TODO: It seems like the Postgres driver is returning incorrect data
        // var byteData = ByteData.view(value.buffer);
        // data[columnName] = byteData.base64encodedString();
      } else {
        data[columnName] = value;
      }
    }

    var serialization = <String, dynamic>{'data': data, 'class': className};

    return poolManager.serializationManager
        .createEntityFromSerialization(serialization) as TableRow?;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> count<T>({
    Expression? where,
    int? limit,
    bool useCache = true,
    required Session session,
    Transaction? transaction,
  }) async {
    var table = session.serverpod.serializationManager.typeTableMapping[T];
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. numRows = await session.db.count<MyTableClass>();
Current type was $T''');
    table = table!;

    var startTime = DateTime.now();

    where ??= Expression('TRUE');

    var tableName = table.tableName;
    var query = 'SELECT COUNT(*) as c FROM $tableName WHERE $where';
    if (limit != null) query += ' LIMIT $limit';

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
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    Map data = row.serializeForDatabase()['data'];

    int? id = data['id'];

    var updatesList = <String>[];

    for (var column in data.keys as Iterable<String>) {
      if (column == 'id') continue;

      if (data[column] is Map || data[column] is List) {
        data[column] = jsonEncode(data[column]);
      }

      var value = DatabasePoolManager.encoder.convert(data[column]);

      updatesList.add('"$column" = $value');
    }
    var updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';

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

    Map data = row.serializeForDatabase()['data'];

    var columnsList = <String>[];
    var valueList = <String>[];

    for (var column in data.keys as Iterable<String>) {
      if (column == 'id') continue;

      if (data[column] is Map || data[column] is List) {
        data[column] = jsonEncode(data[column]);
      }

      String value;
      var unformattedValue = data[column];
      // TODO: Support binary stores in the database
      // if (unformattedValue is String && unformattedValue.startsWith('decode(\'')/* && unformattedValue.endsWith('\', \'base64\')') */) {
      //   // TODO:
      //   // This is a bit of a hack since strings that starts with
      //   // `convert('` and ends with `', 'base64') will be incorrectly encoded
      //   // to base64. Best would be to find a better way to detect when we are
      //   // trying to store a ByteData.
      //   print('DETECTED BINARY');
      //   value = data[column];
      // }
      // else {
      //   value = DatabaseConfig.encoder.convert(unformattedValue);
      // }
      value = DatabasePoolManager.encoder.convert(unformattedValue);

      columnsList.add('"$column"');
      valueList.add(value);
    }
    var columns = columnsList.join(', ');
    var values = valueList.join(', ');

    var query =
        'INSERT INTO ${row.tableName} ($columns) VALUES ($values) RETURNING id';

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
  Future<int> delete<T>({
    required Expression where,
    required Session session,
    Transaction? transaction,
  }) async {
    var table = session.serverpod.serializationManager.typeTableMapping[T];
    assert(table is Table, '''
You need to specify a template type that is a subclass of TableRow.
E.g. numRows = await session.db.delete<MyTableClass>(where: ...);
Current type was $T''');
    table = table!;

    var startTime = DateTime.now();

    var tableName = table.tableName;

    var query = 'DELETE FROM $tableName WHERE $where';

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
  Future<bool> deleteRow(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    var query = 'DELETE FROM ${row.tableName} WHERE id = ${row.id}';

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
  Future<List<List<dynamic>>> query(
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

  void _logQuery(Session session, String query, DateTime startTime,
      {int? numRowsAffected, exception, StackTrace? trace}) {
    session.sessionLogs.queries.add(
      QueryLogEntry(
        sessionLogId: session.temporarySessionId,
        serverId: session.server.serverId,
        query: query,
        duration:
            DateTime.now().difference(startTime).inMicroseconds / 1000000.0,
        numRows: numRowsAffected,
        error: exception?.toString(),
        stackTrace: trace?.toString(),
      ),
    );
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
