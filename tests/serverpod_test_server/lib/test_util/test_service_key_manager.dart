import 'package:serverpod_test_client/serverpod_test_client.dart';

// ignore: deprecated_member_use
class TestServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  TestServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String> get() async {
    return 'name:$serviceSecret';
  }

  @override
  Future<void> put(String key) async {}

  @override
  Future<void> remove() async {}

  @override
  Future<String?> toHeaderValue(String? key) async {
    if (key == null) return null;
    return wrapAsBearerAuthHeaderValue(key);
  }
}
