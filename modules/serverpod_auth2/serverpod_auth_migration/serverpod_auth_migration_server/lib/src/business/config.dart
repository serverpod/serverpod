import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

class AuthMigrationConfig {
  static AuthMigrationConfig _config = AuthMigrationConfig();

  /// Updates the configuration used by authentication migration.
  static void set(AuthMigrationConfig config) {
    _config = config;
  }

  /// Gets the current email account module configuration.
  static AuthMigrationConfig get current => _config;

  final FutureOr<AuthUser> Function(
    Session session,

    /// The auth user to be created, this will not have it's `id` field set yet
    AuthUser,
    UserInfo,
  )? beforeAuthUserMigration;

  final FutureOr<void> Function(
    Session session,

    /// The newly created auth user, with it's ID field set
    AuthUser,

    /// The old `auth` module [UserInfo] from which the new user was created
    UserInfo,
  )? afterAuthUserMigration;

  AuthMigrationConfig({
    this.beforeAuthUserMigration,
    this.afterAuthUserMigration,
  });
}
