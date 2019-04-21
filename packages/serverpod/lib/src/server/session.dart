import 'server.dart';
import 'package:serverpod/src/authentication/scope.dart';

class Session {
  final Server server;
  final String authenticationKey;

  String _authenticatedUser;
  List<Scope> _scopes;

  Session({this.server, this.authenticationKey});

  bool _initialized = false;

  Future<Null> _initialize() async {
    if (server.authenticationHandler != null) {
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
}