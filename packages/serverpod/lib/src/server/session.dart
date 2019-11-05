import 'dart:convert';

import 'server.dart';
import 'package:serverpod/src/authentication/scope.dart';
import '../generated/protocol.dart';
import '../database/database.dart';
import '../database/database_connection.dart';
import '../database/table.dart';

class Session {
  final Uri uri;
  final String body;
  final Server server;
  final Duration maxLifeTime;
  
  DateTime _timeCreated;
  final List<QueryInfo> queries = <QueryInfo>[];
  final List<LogInfo> log = <LogInfo>[];

  String _authenticatedUser;
  Set<Scope> _scopes;

  String _authenticationKey;
  String get authenticationKey => _authenticationKey;

  String _methodName;
  String get methodName => _methodName;

  DatabaseConnection _databaseConnection;
  Future<DatabaseConnection> get databaseConnection async {
    if (_databaseConnection != null)
      return _databaseConnection;

    _databaseConnection = DatabaseConnection(server.database, maxLifeTime: maxLifeTime);
    bool success = await _databaseConnection.connect();

    if (success)
      return _databaseConnection;
    else
      return null;
  }

  Map<String, String> _queryParameters;
  Map<String, String> get queryParameters => _queryParameters;

  final String endpointName;

  Session({this.server, this.uri, this.body, this.endpointName, String authenticationKey, this.maxLifeTime=const Duration(minutes: 2)}) {
    _timeCreated = DateTime.now();

    if (body == null || body == '' || body == 'null') {
      _queryParameters = <String, String>{};
    }
    else {
      _queryParameters = jsonDecode(body).cast<String, String>();
    }

    if (authenticationKey != null)
      _authenticationKey = authenticationKey;
    else
      _authenticationKey = _queryParameters['auth'];

    _methodName = _queryParameters['method'];
  }

  bool _initialized = false;

  Future<Null> _initialize() async {
    if (server.authenticationHandler != null  && authenticationKey != null) {
      var authenticationInfo = await server.authenticationHandler(this, authenticationKey);
      _scopes = authenticationInfo?.scopes;
      _authenticatedUser = authenticationInfo?.authenticatedUser;
    }
    _initialized = true;
  }

  Future<String> get authenticatedUser async {
    if (!_initialized)
      await _initialize();
    return _authenticatedUser;
  }

  Future<Set<Scope>> get scopes async {
    if (!_initialized)
      await _initialize();
    return _scopes;
  }

  Future<bool> get isUserSignedIn async {
    return (await authenticatedUser) != null;
  }
  
  Duration get runningTime => DateTime.now().difference(_timeCreated);

  Future<Null> close() async {
    if (_databaseConnection != null) {
      await _databaseConnection.disconnect();
    }
  }

  logDebug(String message) {
    log.add(LogInfo(LogLevel.debug, message));
  }

  logInfo(String message) {
    log.add(LogInfo(LogLevel.info, message));
  }

  logWarning(String message, {StackTrace stackTrace}) {
    log.add(LogInfo(LogLevel.warning, message, stackTrace: stackTrace));
  }

  logError(String message, {StackTrace stackTrace}) {
    log.add(LogInfo(LogLevel.error, message, stackTrace: stackTrace));
  }

  logFatal(String message, {StackTrace stackTrace}) {
    log.add(LogInfo(LogLevel.fatal, message, stackTrace: stackTrace));
  }

  Future<TableRow> findById(Table table, int id) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;
    
    return await conn.findById(table, id, session: this);
  }

  Future<List<TableRow>> find(Table table, {Expression where, int limit, int offset, Column orderBy, bool orderDescending=false, bool useCache=true}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;
    
    return await conn.find(
      table,
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      session: this,
    );
  }

  Future<TableRow> findSingleRow(Table table, {Expression where, int offset, Column orderBy, bool orderDescending=false, bool useCache=true}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;
    
    return await conn.findSingleRow(
      table,
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      session: this,
    );
  }

  Future<int> count(Table table, {Expression where, int limit, bool useCache=true}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return await conn.count(
      table,
      where: where,
      limit: limit,
      useCache: useCache,
      session: this,
    );
  }

  Future<bool> update(TableRow row, {Transaction transaction}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return await conn.update(
      row,
      transaction: transaction,
      session: this,
    );
  }

  Future<bool> insert(TableRow row, {Transaction transaction}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return await conn.insert(
      row,
      transaction: transaction,
      session: this,
    );
  }

  Future<int> delete(Table table, {Expression where, Transaction transaction}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return await conn.delete(
      table,
      where: where,
      transaction: transaction,
      session: this,
    );
  }

  Future<bool> deleteRow(TableRow row, {Transaction transaction}) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return await conn.deleteRow(
      row,
      transaction: transaction,
      session: this,
    );
  }

  Future<List<List<dynamic>>> query(String query) async {
    var conn = await databaseConnection;
    if (conn == null)
      return null;

    return conn.query(
      query,
      session: this,
    );
  }
}

class QueryInfo {
  final String query;
  final Duration time;
  final int numRows;
  final dynamic exception;
  final StackTrace stackTrace;

  QueryInfo({this.query, this.time, this.numRows, this.exception, this.stackTrace});
}

class LogInfo {
  final LogLevel level;
  final String message;
  final StackTrace stackTrace;

  LogInfo(this.level, this.message, {this.stackTrace});
}