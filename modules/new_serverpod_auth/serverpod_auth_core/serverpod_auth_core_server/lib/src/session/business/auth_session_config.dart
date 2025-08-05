/// Configuration options for the session module.
class AuthSessionConfig {
  /// Length of the session key secret (which is only stored on the client).
  ///
  /// Defaults to 32 bytes.
  final int sessionKeySecretLength;

  /// Length of the salt used for the session key hash.
  ///
  /// Defaults to 16 bytes.
  final int sessionKeyHashSaltLength;

  /// Create a new user session configuration.
  AuthSessionConfig({
    this.sessionKeySecretLength = 32,
    this.sessionKeyHashSaltLength = 16,
  });
}
