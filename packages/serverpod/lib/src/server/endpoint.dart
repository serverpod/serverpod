import 'server.dart';
import 'serverpod.dart';
import '../authentication/scope.dart';

/// The [Endpoint] is an entrypoint to the [Server]. To add a custom [Endpoint]
/// to a [Server], create a subclass and place it in the `endpoints` directory.
/// Code will generated that builds the corresponding client library. To add
/// methods that can be accessed from the client, make sure that the first
/// argument of the method is a [Session] parameter.
class Endpoint {
  late String _name;
  /// The name of this [Endpoint]. It will be automatically generated from the
  /// name of the class (excluding any Endpoint suffix).
  String get name => _name;

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

  /// Initializes the endpoint with the current [Server]. Typically, this is
  /// done from generated code.
  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }
}