abstract class AuthorizationKeyManager {
  Future<String> get();
  Future<Null> put(String key);
}
