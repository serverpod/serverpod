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
  final List<QueryLogEntry> queries = [];
  final List<LogEntry> logs = [];

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

  Future<void> _initialize() async {
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

  Future<void> close() async {
  }

  void log(String message, {LogLevel? level, dynamic? exception, StackTrace? stackTrace}) {
    logs.add(
      LogEntry(
        serverId: server.serverId,
        logLevel: (level ?? LogLevel.info).index,
        message: message,
        time: DateTime.now(),
        exception: '$exception',
        stackTrace: '$stackTrace',
      ),
    );
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