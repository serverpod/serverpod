/// Configuration options for the session module.
class AuthSessionConfig {
  /// Maximum session lifetime.
  ///
  /// Default to `null` (inifinite length), meaning sessions never expire implicitly.
  final Duration? maximumSessionLifetime;

  /// Create a new user session configuration.
  AuthSessionConfig({
    this.maximumSessionLifetime,
  });

  /// The current session module configuration.
  static AuthSessionConfig current = AuthSessionConfig();
}
