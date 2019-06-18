import 'dart:convert';

import 'server.dart';
import 'package:serverpod/src/authentication/scope.dart';
import '../generated/protocol.dart';

class Session {
  final Uri uri;
  final String body;
  final Server server;
  
  DateTime _timeCreated;
  final List<QueryInfo> queries = <QueryInfo>[];
  final List<LogInfo> log = <LogInfo>[];

  String _authenticatedUser;
  List<Scope> _scopes;

  String _authenticationKey;
  String get authenticationKey => _authenticationKey;

  String _methodName;
  String get methodName => _methodName;

  Map<String, String> _queryParameters;
  Map<String, String> get queryParameters => _queryParameters;

  final String endpointName;

  Session({this.server, this.uri, this.body, this.endpointName}) {
    _timeCreated = DateTime.now();

    if (body == null || body == '' || body == 'null') {
      _queryParameters = <String, String>{};
    }
    else {
      _queryParameters = jsonDecode(body).cast<String, String>();
    }

    _authenticationKey = _queryParameters['auth'];
    _methodName = _queryParameters['method'];
  }

  bool _initialized = false;

  Future<Null> _initialize() async {
    if (server.authenticationHandler != null  && authenticationKey != null) {
      var authenticationInfo = await server.authenticationHandler(server, authenticationKey);
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

  Future<List<Scope>> get scopes async {
    if (!_initialized)
      await _initialize();
    return _scopes;
  }

  Future<bool> get isUserSignedIn async {
    return (await authenticatedUser) != null;
  }
  
  Duration get runningTime => DateTime.now().difference(_timeCreated);

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
}

class QueryInfo {
  final String query;
  final Duration time;
  final int numRows;
  final Exception exception;
  final StackTrace stackTrace;

  QueryInfo({this.query, this.time, this.numRows, this.exception, this.stackTrace});
}

class LogInfo {
  final LogLevel level;
  final String message;
  final StackTrace stackTrace;

  LogInfo(this.level, this.message, {this.stackTrace});
}