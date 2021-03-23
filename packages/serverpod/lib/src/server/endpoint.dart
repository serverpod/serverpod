import 'server.dart';
import '../authentication/scope.dart';

class Endpoint {
  String _name;
  String get name => _name;

  Server _server;
  Server get server => _server;

  List<Scope> get requiredScopes => [];

  bool get requireLogin => false;

  bool get logSessions => true;

  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }
}