/// Configuration for the `servpod_auth` backwards compability module.
class AuthBackwardsCompatibilityConfig {
  /// True if the server should use the accounts email address as part of the
  /// salt when storing password hashes (strongly recommended). Default is true.
  final bool extraSaltyHash;

  /// Creates a new instance.
  AuthBackwardsCompatibilityConfig({
    this.extraSaltyHash = true,
  });
}
