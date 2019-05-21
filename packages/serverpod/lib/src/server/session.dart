import 'server.dart';
import 'package:serverpod/src/authentication/scope.dart';

class Session {
  final Uri uri;
  final Server server;
  
  DateTime _timeCreated;
  final List<QueryInfo> queries = <QueryInfo>[];

  String _authenticatedUser;
  List<Scope> _scopes;

  String _authenticationKey;
  String get authenticationKey => _authenticationKey;

  String _methodName;
  String get methodName => _methodName;

  Map<String, String> _queryParameters;
  Map<String, String> get queryParameters => _queryParameters;

  final String endpointName;

  Session({this.server, this.uri, this.endpointName}) {
    _timeCreated = DateTime.now();

    _queryParameters = uri.queryParameters;

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
}

class QueryInfo {
  final String query;
  final Duration time;
  final int numRows;
  final Exception exception;
  final StackTrace stackTrace;

  QueryInfo({this.query, this.time, this.numRows, this.exception, this.stackTrace});
}