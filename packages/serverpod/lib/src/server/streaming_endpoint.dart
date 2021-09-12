import 'package:serverpod/serverpod.dart';

import 'server.dart';
import 'session.dart';

abstract class StreamingEndpoint {
  late Server _server;
  /// The [Server] this [Endpoint] is running on.
  Server get server => _server;

  /// The [ServerPod] this [Endpoint] is running on.
  Serverpod get pod => server.serverpod;

  /// List of [Scope]s that are required to access this [Endpoint]. Override
  /// this getter to setup custom requirements.
  List<Scope> get requiredScopes => [];

  /// States if the [Endpoint] only should accept users that are authenticated.
  /// Default value is false, override to change.
  bool get requireLogin => false;

  late String _name;
  /// The name of this [Endpoint]. It will be automatically generated from the
  /// name of the class (excluding any Endpoint suffix).
  String get name => _name;

  /// Initializes the endpoint with the current [Server]. Typically, this is
  /// done from generated code.
  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }

  /// Override this method to setup a new stream when a client connects to the
  /// server.
  Future<void> setupStream(Session session) async {}

  /// Invoked when a message is sent to this endpoint from the client.
  /// Override this method to create your own custom [StreamingEndpoint].
  Future<void> handleMessage(Session session, SerializableEntity message);

  /// Sends an event to the client represented by the [Session] object.
  Future<void> sendMessage(Session session, SerializableEntity message) async {

  }
}