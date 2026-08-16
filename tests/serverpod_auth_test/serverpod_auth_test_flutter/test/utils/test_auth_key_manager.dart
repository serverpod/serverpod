import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';

class TestAuthKeyProvider implements ClientAuthKeyProvider {
  String? _key;

  @override
  Future<String?> get authHeaderValue async {
    if (_key == null) return null;
    return wrapAsBearerAuthHeaderValue(_key!);
  }

  Future<void> put(final String key) async {
    _key = key;
  }

  Future<void> remove() async {
    _key = null;
  }
}
