import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

class TestAuthKeyManager extends BearerAuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(final String key) async {
    _key = key;
  }

  @override
  Future<void> remove() async {
    _key = null;
  }
}
