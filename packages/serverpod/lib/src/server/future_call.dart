import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'server.dart';
import 'session.dart';

/// Superclass of a [FutureCall], override the [invoke] method to create a
/// custom [FutureCall]. The call also needs to be registered with the top
/// [ServerPod] object before starting the [Server].
abstract class FutureCall<T extends SerializableEntity?> {
  late String _name;

  /// The name of the call.
  String get name => _name;

  /// The type of the data provided by when calling [invoke].
  Type get dataType => T;

  late Server _server;

  /// The [Server] where the call is registered.
  Server get server => _server;

  /// Initializes the [FutureCall]. This is typically called from the [Server]
  /// when the call is being registered and should not be called directly.
  void initialize(Server server, String name) {
    _server = server;
    _name = name;
  }

  /// Override this method to do any custom work in a [FutureCall].
  Future<void> invoke(Session session, T object);
}
