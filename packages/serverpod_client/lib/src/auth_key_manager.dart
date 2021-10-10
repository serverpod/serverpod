/// Manages keys for authentication with the server.
abstract class AuthenticationKeyManager {
  /// Retrieves an authentication key.
  Future<String?> get();

  /// Saves an authentication key retrieved by the server.
  Future<void> put(String key);

  /// Removes the authentication key.
  Future<void> remove();
}
