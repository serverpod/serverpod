import 'package:serverpod_test_client/serverpod_test_client.dart';

class TestAuthKeyManager implements ClientAuthKeyProvider {
  String? _key;

  @override
  Future<String?> get authHeaderValue async {
    final key = await get();
    if (key == null) return null;
    return wrapAsBearerAuthHeaderValue(key);
  }

  Future<String?> get() async => _key;

  Future<void> put(String key) async {
    _key = key;
  }

  Future<void> remove() async {
    _key = null;
  }
}
