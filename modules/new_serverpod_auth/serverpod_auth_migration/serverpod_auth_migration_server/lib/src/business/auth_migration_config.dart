import 'package:serverpod/serverpod.dart';

/// Configuration options for the account migration.
class AuthMigrationConfig {
  /// Whether to import the `serverpod_auth` `UserInfo` into a
  /// `serverpod_auth_profile` `UserProfile`.
  ///
  /// Defaults to `true`.
  final bool importProfile;

  /// Callback to be invoked if a user has been migrated.
  ///
  /// If one does any further migratations for this user in the database, one
  /// should ensure to use the passed `transaction`, such that a failure rolls
  /// back the entire, partial write.
  final UserMigrationHook? userMigrationHook;

  /// Create a new email account migration configuration.
  AuthMigrationConfig({
    this.importProfile = true,
    this.userMigrationHook,
  });
}

/// Callback to be invoked when a `serverpod_auth` `UserInfo` has been migrated
/// to a `serverpod_auth_user` `AuthUser`.
///
/// This is called only once, even if multiple authentications are migrated for
/// the user successively.
typedef UserMigrationHook = Future<void> Function(
  Session session, {
  required int oldUserId,
  required UuidValue newAuthUserId,
  Transaction? transaction,
});
