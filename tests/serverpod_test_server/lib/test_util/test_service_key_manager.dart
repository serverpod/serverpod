import 'package:serverpod_test_client/serverpod_test_client.dart';

class TestServiceKeyManager implements ClientAuthKeyProvider {
  final String name;
  final String serviceSecret;

  TestServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String?> get authHeaderValue async {
    final key = await get();
    return wrapAsBearerAuthHeaderValue(key);
  }

  Future<String> get() async {
    return 'name:$serviceSecret';
  }

  Future<void> put(String key) async {}

  Future<void> remove() async {}
}
