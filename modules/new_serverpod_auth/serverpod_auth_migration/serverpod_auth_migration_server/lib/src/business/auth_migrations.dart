import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_migration_server/src/business/migrate_user.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as new_session;

/// Collection of helpers to migrate from `serverpod_auth` to the new packages.
abstract final class AuthMigrations {
  /// The configuration to be used for all migrations.
  static var config = AuthMigrationConfig();

  /// Returns whether a legacy `serverpod_auth` user has been migrated already.
  ///
  /// This is intended to be used to block access for migrated users on the
  /// legacy login/registration endpoints, and potentially even sessions.
  static Future<bool> isUserMigrated(
      final Session session, final int userId) async {
    return await getNewAuthUserId(session, userId) != null;
  }

  /// Returns the `AuthUser` id for a `UserInfo` which has already been migrated.
  static Future<UuidValue?> getNewAuthUserId(
    final Session session,
    final int userId,
  ) async {
    final migratedUser = await MigratedUser.db.findFirstRow(
      session,
      where: (final t) => t.oldUserId.equals(userId),
    );

    return migratedUser?.newAuthUserId;
  }

  /// Authentication helper which supports both the new and old authentication.
  ///
  /// Unlike the stock `serverpod_auth` `authenticationHandler`, this will set
  /// the new UUID `AuthUser` id for users which have been migrated. Thus they
  /// can keep using their session even if the backend has been fully migrated
  /// off of `int` user ID (but the table must not have been dropped of course).
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    final newAuthInfo =
        await new_session.AuthSessions.authenticationHandler(session, key);
    if (newAuthInfo != null) {
      return newAuthInfo;
    }

    final legacyAuthInfo = await legacy_auth.authenticationHandler(
      session,
      key,
    );

    if (legacyAuthInfo == null) {
      return null;
    }

    final newAuthUserId = await getNewAuthUserId(
      session,
      legacyAuthInfo.userId,
    );

    if (newAuthUserId == null) {
      return legacyAuthInfo;
    }

    return AuthenticationInfo(
      newAuthUserId,
      legacyAuthInfo.scopes,
      authId: legacyAuthInfo.authId,
    );
  }

  /// Migrates the next batch of users and their authentication methods.
  static Future<int> migrateNextUserBatch(
    final Session session, {
    final int maxUsers = 100,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final results = await session.db.unsafeQuery(
          'SELECT id FROM serverpod_user_info u '
          'WHERE NOT EXISTS ( '
          '  SELECT 1 FROM serverpod_auth_migration_migrated_user m WHERE u.id = m."oldUserId" '
          ') '
          'LIMIT $maxUsers',
          transaction: transaction,
        );

        final userIdsToMigrate = results.map(
          (final r) => r.toColumnMap()['id'] as int,
        );

        for (final userId in userIdsToMigrate) {
          final userInfo = (await legacy_auth.UserInfo.db.findById(
            session,
            userId,
            transaction: transaction,
          ))!;

          await migrateUserIfNeeded(
            session,
            userInfo,
            transaction: transaction,
          );
        }

        return userIdsToMigrate.length;
      },
    );
  }
}
