import 'package:serverpod_client/serverpod_client.dart';

import 'config.dart';

/// The key manager used for the service protocol.
class ServiceKeyManager extends AuthenticationKeyManager {
  /// Name of the client
  final String name;

  /// Server configuration.
  final ServerpodConfig config;

  /// Creates a new [ServiceKeyManager].
  ServiceKeyManager(this.name, this.config);

  @override
  Future<String> get() async {
    return '$name:${config.serviceSecret}';
  }

  @override
  Future<void> put(String key) async {}
  @override
  Future<void> remove() async {}
}
