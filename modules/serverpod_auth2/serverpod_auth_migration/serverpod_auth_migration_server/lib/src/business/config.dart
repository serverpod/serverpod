import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_server/serverpod_auth2_server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

typedef PostMigrationCallback = FutureOr<void> Function(
  Session session,

  /// The newly created auth user, with it's ID field set
  AuthUser,

  /// The old `auth` module [UserInfo] from which the new user was created
  UserInfo,
);

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

  final PostMigrationCallback? afterAuthUserMigration;

  AuthMigrationConfig({
    this.beforeAuthUserMigration,
    this.afterAuthUserMigration,
  });

  static void update({
    PostMigrationCallback? afterAuthUserMigration,
  }) {
    _config = _config.copyWith(
      afterAuthUserMigration: afterAuthUserMigration,
    );
  }

  AuthMigrationConfig copyWith({
    PostMigrationCallback? afterAuthUserMigration,
  }) {
    return AuthMigrationConfig(
      beforeAuthUserMigration: beforeAuthUserMigration,
      afterAuthUserMigration: afterAuthUserMigration,
    );
  }
}
