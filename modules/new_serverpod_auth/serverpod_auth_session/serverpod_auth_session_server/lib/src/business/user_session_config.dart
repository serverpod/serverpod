/// Configuration options for the user session module.
class UserSessionConfig {
  /// Maximum session lifetime.
  ///
  /// Default to `null` (inifinite length), meaning sessions never expire implicitly.
  final Duration? maximumSessionLifetime;

  /// Create a new user session configuration.
  UserSessionConfig({
    this.maximumSessionLifetime,
  });

  /// The current user session module configuration.
  static UserSessionConfig current = UserSessionConfig();
}
