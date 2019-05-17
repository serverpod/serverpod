import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'server.dart';

abstract class FutureCall {
  String _name;
  String get name => _name;

  Server _server;
  Server get server => _server;

  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }

  Future<Null> invoke(SerializableEntity object);
}
