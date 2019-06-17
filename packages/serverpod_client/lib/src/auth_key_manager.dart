abstract class AuthenticationKeyManager {
  Future<String> get();
  Future<Null> put(String key);
}
