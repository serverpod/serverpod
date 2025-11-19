import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The key manager used for the service protocol.
class ServiceKeyManager extends BearerAuthenticationKeyManager {
  /// Name of the client
  final String name;

  /// Server configuration.
  final String? serviceSecret;

  /// Creates a new [ServiceKeyManager].
  ServiceKeyManager(this.name, ServerpodConfig config)
    : serviceSecret = config.serviceSecret;

  /// Creates a new [ServiceKeyManager] with a service secret.
  ServiceKeyManager.withServiceSecret(
    this.name,
    this.serviceSecret,
  );

  @override
  Future<String> get() async {
    return '$name:$serviceSecret';
  }

  @override
  Future<void> put(String key) async {}
  @override
  Future<void> remove() async {}
}
