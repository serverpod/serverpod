/// Centralized access to authentication services.
class AuthServices {
  static AuthServices _instance = AuthServices();

  /// Singleton instance of [AuthServices].
  static AuthServices get instance => _instance;

  /// Initialize the [AuthServices] singleton.
  static void initialize() {
    _instance = AuthServices();
  }

  /// Create an [AuthServices] instance.
  AuthServices();
}
