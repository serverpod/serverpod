import 'package:serverpod_test_client/serverpod_test_client.dart';

// ignore: deprecated_member_use
class TestAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
  }

  @override
  Future<void> remove() async {
    _key = null;
  }

  @override
  Future<String?> toHeaderValue(String? key) async {
    if (key == null) return null;
    return wrapAsBearerAuthHeaderValue(key);
  }
}
