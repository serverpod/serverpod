import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// The key manager used for the service protocol.
class ServiceAuthKeyProvider implements ClientAuthKeyProvider {
  /// Name of the client
  final String name;

  /// Server configuration.
  final String? serviceSecret;

  /// Creates a new [ServiceAuthKeyProvider].
  ServiceAuthKeyProvider(this.name, ServerpodConfig config)
    : serviceSecret = config.serviceSecret;

  /// Creates a new [ServiceAuthKeyProvider] with a service secret.
  ServiceAuthKeyProvider.withServiceSecret(
    this.name,
    this.serviceSecret,
  );

  @override
  Future<String?> get authHeaderValue async {
    final key = '$name:$serviceSecret';
    return wrapAsBearerAuthHeaderValue(key);
  }
}
