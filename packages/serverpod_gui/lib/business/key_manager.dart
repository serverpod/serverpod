import 'package:serverpod_client/src/auth_key_manager.dart';

class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  ServiceKeyManager(this.name, this.serviceSecret);

  Future<String> get() async {
    return 'name:$serviceSecret';
  }
  Future<Null> put(String key) async {
  }
}