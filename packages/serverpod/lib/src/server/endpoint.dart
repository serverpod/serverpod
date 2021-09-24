import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'server.dart';
import 'serverpod.dart';
import 'session.dart';
import '../authentication/scope.dart';

/// The [Endpoint] is an entrypoint to the [Server]. To add a custom [Endpoint]
/// to a [Server], create a subclass and place it in the `endpoints` directory.
/// Code will generated that builds the corresponding client library. To add
/// methods that can be accessed from the client, make sure that the first
/// argument of the method is a [Session] parameter.
abstract class Endpoint {
  late String _name;
  /// The name of this [Endpoint]. It will be automatically generated from the
  /// name of the class (excluding any Endpoint suffix).
  String get name => _name;

  String? _moduleName;
  String? get moduleName => _moduleName;

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

  /// States if [Session]s should be logged for this endpoint. Defaults to true,
  /// override to change.
  bool get logSessions => true;

  /// If true, returned [ByteData] from methods will be sent sent to the client
  /// as raw data without any formatting. One use case is to return data through
  /// a non-api call. Defaults to false, override to change. If used, the
  /// endpoint method is responsible for correctly setting the contentType of
  /// the http response (defaults to `text/plain`).
  bool get sendByteDataAsRaw => false;

  final Map<Session, dynamic> _userObjects = {};

  /// Retrieves a custom object assiciated with this [Endpoint] and [Session].
  dynamic getUserObject(Session session) {
    return _userObjects[session];
  }

  /// Associate a custom object with this [Endpoint] and [Session].
  dynamic setUserObject(Session session, dynamic userObject) {
    _userObjects[session] = userObject;
  }

  /// Initializes the endpoint with the current [Server]. Typically, this is
  /// done from generated code.
  void initialize(Server server, String name, String? moduleName) {
    _server = server;
    _name = name;
    _moduleName = moduleName;
  }

  /// Override this method to setup a new stream when a client connects to the
  /// server.
  Future<void> setupStream(Session session) async {}

  /// Invoked when a message is sent to this endpoint from the client.
  /// Override this method to create your own custom [StreamingEndpoint].
  Future<void> handleStreamMessage(StreamingSession session, SerializableEntity message) async {}

  /// Sends an event to the client represented by the [Session] object.
  Future<void> sendStreamMessage(StreamingSession session, SerializableEntity message) async {
    var prefix = moduleName == null ? '' : '$moduleName.';

    var data = {
      'endpoint': '$prefix$name',
      'object': message.serialize(),
    };

    var payload = jsonEncode(data);
    session.webSocket.add(payload);
  }
}