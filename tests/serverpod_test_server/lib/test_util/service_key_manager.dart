import 'package:serverpod_test_client/serverpod_test_client.dart';

class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  ServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String> get() async {
    return 'name:$serviceSecret';
  }

  @override
  Future<void> put(String key) async {}

  @override
  Future<void> remove() async {}
}
