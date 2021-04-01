import 'dart:convert';
import 'dart:io';

import 'server.dart';
import 'package:serverpod/src/authentication/scope.dart';
import '../generated/protocol.dart';
import '../database/database.dart';

enum SessionType {
  methodCall,
  futureCall,
}

class Session {
  final SessionType type;

  final Server server;
  final Duration maxLifeTime;

  late DateTime _timeCreated;
  final List<QueryInfo> queries = <QueryInfo>[];
  final List<LogInfo> log = <LogInfo>[];

  int? _authenticatedUser;
  Set<Scope>? _scopes;

  late final Database db;

  MethodCallInfo? _methodCall;
  MethodCallInfo? get methodCall => _methodCall;

  FutureCallInfo? _futureCall;
  FutureCallInfo? get futureCall => _futureCall;

  String? _authenticationKey;
  String? get authenticationKey => _authenticationKey;

  Session({
    this.type = SessionType.methodCall,
    required this.server,
    Uri? uri,
    String? body,
    String? endpointName,
    String? authenticationKey,
    this.maxLifeTime=const Duration(minutes: 1),
    HttpRequest? httpRequest,
    String? futureCallName,
  }){
    _timeCreated = DateTime.now();

    if (type == SessionType.methodCall) {
      // Method call session

      // Read query parameters
      Map<String, String> queryParameters = {};
      if (body != null && body != '' && body != 'null') {
        queryParameters = jsonDecode(body).cast<String, String>();
      }

      // Get the the authentication key, if any
      if (authenticationKey == null)
        authenticationKey = queryParameters['auth'];
      _authenticationKey = authenticationKey;

      String? methodName = queryParameters['method'];

      db = Database(session: this);

      _methodCall = MethodCallInfo(
        uri: uri!,
        body: body!,
        queryParameters: queryParameters,
        endpointName: endpointName!,
        methodName: methodName!,
        httpRequest: httpRequest!,
      );
    }
    else if (type == SessionType.futureCall){
      // Future call session

      _futureCall = FutureCallInfo(
        callName: futureCallName!,
      );
    }
  }

  bool _initialized = false;

  Future<Null> _initialize() async {
    if (server.authenticationHandler != null  && _authenticationKey != null) {
      var authenticationInfo = await server.authenticationHandler!(this, _authenticationKey!);
      _scopes = authenticationInfo?.scopes;
      _authenticatedUser = authenticationInfo?.authenticatedUserId;
    }
    _initialized = true;
  }

  Future<int?> get authenticatedUserId async {
    if (!_initialized)
      await _initialize();
    return _authenticatedUser;
  }

  Future<Set<Scope>?> get scopes async {
    if (!_initialized)
      await _initialize();
    return _scopes;
  }

  Future<bool> get isUserSignedIn async {
    return (await authenticatedUserId) != null;
  }
  
  Duration get runningTime => DateTime.now().difference(_timeCreated);

  Future<Null> close() async {
  }

  logDebug(String message) {
    log.add(LogInfo(LogLevel.debug, message));
  }

  logInfo(String message) {
    log.add(LogInfo(LogLevel.info, message));
  }

  logWarning(String message, {StackTrace? stackTrace}) {
    log.add(LogInfo(LogLevel.warning, message, stackTrace: stackTrace));
  }

  logError(String message, {StackTrace? stackTrace}) {
    log.add(LogInfo(LogLevel.error, message, stackTrace: stackTrace));
  }

  logFatal(String message, {StackTrace? stackTrace}) {
    log.add(LogInfo(LogLevel.fatal, message, stackTrace: stackTrace));
  }
}

class MethodCallInfo {
  final Uri uri;
  final String body;
  final Map<String, String> queryParameters;
  final String endpointName;
  final String methodName;
  final HttpRequest httpRequest;
  final String? authenticationKey;

  MethodCallInfo({
    required this.uri,
    required this.body,
    required this.queryParameters,
    required this.endpointName,
    required this.methodName,
    required this.httpRequest,
    this.authenticationKey,
  });
}

class FutureCallInfo {
  final String callName;
  FutureCallInfo({
    required this.callName,
  });
}

class QueryInfo {
  final String query;
  final Duration time;
  final int? numRows;
  final dynamic exception;
  final StackTrace? stackTrace;

  QueryInfo({required this.query, required this.time, this.numRows, this.exception, this.stackTrace});
}

class LogInfo {
  final LogLevel level;
  final String message;
  final StackTrace? stackTrace;

  LogInfo(this.level, this.message, {this.stackTrace});
}