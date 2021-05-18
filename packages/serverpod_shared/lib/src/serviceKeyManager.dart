import 'package:serverpod_client/src/auth_key_manager.dart';
import 'config.dart';


class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final ServerConfig config;

  ServiceKeyManager(this.name, this.config);

  @override
  Future<String> get() async {
    return 'name:${config.serviceSecret}';
  }
  @override
  Future<Null> put(String key) async {
  }
}