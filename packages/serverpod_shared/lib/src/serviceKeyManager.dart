import 'package:serverpod_client/src/auth_key_manager.dart';
import 'config.dart';


class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final ServerConfig config;

  ServiceKeyManager(this.name, this.config);

  Future<String> get() async {
    return 'name:${config.serviceSecret}';
  }
  Future<Null> put(String key) async {
  }
}