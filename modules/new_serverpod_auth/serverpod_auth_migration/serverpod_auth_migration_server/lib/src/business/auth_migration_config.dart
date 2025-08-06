/// Configuration options for the account migration.
class AuthMigrationConfig {
  /// Whether to import the `serverpod_auth` `UserInfo` into a
  /// `serverpod_auth_profile` `UserProfile`.
  ///
  /// Defaults to `true`.
  final bool importProfile;

  /// Whether to import the `serverpod_auth` `AuthKey` into a
  /// `serverpod_auth_bridge` `LegacySession`.
  ///
  /// Defaults to `true`.
  final bool importSessions;

  /// Create a new email account migration configuration.
  AuthMigrationConfig({this.importProfile = true, this.importSessions = true});
}
