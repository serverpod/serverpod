import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:postgres_pool/postgres_pool.dart';
import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/database_connection.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../server/session.dart';
import 'database_pool_manager.dart';
import 'expressions.dart';
import 'table.dart';

typedef _LogQuery = void Function(
  Session session,
  String query,
  DateTime startTime, {
  int? numRowsAffected,
  dynamic exception,
  StackTrace? trace,
});

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
class DatabaseConnectionLegacy {
  /// Database configuration.
  final DatabasePoolManager _poolManager;

  /// Access to the raw Postgresql connection pool.
  final PgPool _postgresConnection;

  final _LogQuery _logQuery;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnectionLegacy(
    this._poolManager,
    this._logQuery,
  ) : _postgresConnection = _poolManager.pool;

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
  Future<bool> update(
    TableRow row, {
    required Session session,
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

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

    var query = 'UPDATE ${row.table.tableName} SET $updates WHERE id = $id';

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : _postgresConnection;

      var affectedRows = await context.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
  Future<void> insert(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

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
        'INSERT INTO "${row.table.tableName}" ($columns) VALUES ($values) RETURNING id';

    int insertedId;
    try {
      List<List<dynamic>> result;

      var context = transaction != null
          ? transaction.postgresContext
          : _postgresConnection;

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

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
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
          : _postgresConnection;

      var result = await context.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: {},
      );
      for (var rawRow in result) {
        list.add(_poolManager.serializationManager
            .deserialize<T>(rawRow[tableName]));
      }
    } catch (e, trace) {
      _logQuery(session, query, startTime, exception: e, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: list.length);
    return list.cast<T>();
  }

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
  Future<bool> deleteRow(
    TableRow row, {
    required Session session,
    Transaction? transaction,
  }) async {
    var startTime = DateTime.now();

    var query = DeleteQueryBuilder(table: row.table.tableName)
        .withWhere(Expression('id = ${row.id}'))
        .build();

    try {
      var context = transaction != null
          ? transaction.postgresContext
          : _postgresConnection;

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

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
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
      await _postgresConnection.query(
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

  /// For most cases use the corresponding method in [DatabaseLegacy] instead.
  Future<ByteData?> retrieveFile(String storageId, String path,
      {required Session session}) async {
    var startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      query =
          'SELECT encode("byteData", \'base64\') AS "encoded" FROM serverpod_cloud_storage WHERE "storageId"=@storageId AND path=@path AND verified=@verified';

      var result = await _postgresConnection.query(
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
      var result = await _postgresConnection.query(
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
      await _postgresConnection.query(
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
}
