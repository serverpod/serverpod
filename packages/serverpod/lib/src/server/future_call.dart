import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'server.dart';
import 'session.dart';

abstract class FutureCall {
  late String _name;
  String get name => _name;

  late Server _server;
  Server get server => _server;

  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }

  Future<void> invoke(Session session, SerializableEntity? object);
}
