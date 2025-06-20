/// Configuration options for the email account migration.
class AuthMigrationEmailConfig {
  /// Whether to import the `serverpod_auth` `UserInfo` into a
  /// `serverpod_auth_profile` `UserProfile`.
  ///
  /// Defaults to `true`.
  final bool importProfile;

  /// Create a new email account migration configuration.
  AuthMigrationEmailConfig({
    this.importProfile = true,
  });
}
