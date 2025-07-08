import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart';
import 'package:serverpod_auth_migration_server/src/business/migrate_user.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;

/// Collection of helpers to migrate from `serverpod_auth` to the new packages.
abstract final class AuthMigrations {
  /// The configuration to be used for all migrations.
  static var config = AuthMigrationConfig();

  /// Returns whether a legacy `serverpod_auth` user has been migrated already.
  ///
  /// This is intended to be used to block access for migrated users on the
  /// legacy login/registration endpoints, and potentially even sessions.
  static Future<bool> isUserMigrated(
    final Session session,
    final int userId, {
    final Transaction? transaction,
  }) async {
    final authUserId = await getNewAuthUserId(
      session,
      userId,
      transaction: transaction,
    );

    return authUserId != null;
  }

  /// Returns the `AuthUser` id for a `UserInfo` if it has been migrated.
  static Future<UuidValue?> getNewAuthUserId(
    final Session session,
    final int userId, {
    final Transaction? transaction,
  }) async {
    final migratedUser = await MigratedUser.db.findFirstRow(
      session,
      where: (final t) => t.oldUserId.equals(userId),
      transaction: transaction,
    );

    return migratedUser?.newAuthUserId;
  }

  /// Migrates the next batch of users and their authentication methods.
  static Future<int> migrateUsers(
    final Session session, {
    required final UserMigrationFunction? userMigration,
    final int? maxUsers,
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
          '${maxUsers != null ? 'LIMIT $maxUsers' : ''}',
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

          final (migratedUser, didCreate) = await migrateUserIfNeeded(
            session,
            userInfo,
            transaction: transaction,
          );

          if (didCreate && userMigration != null) {
            await userMigration(
              session,
              oldUserId: migratedUser.oldUserId,
              newAuthUserId: migratedUser.newAuthUserId,
              transaction: transaction,
            );
          }
        }

        return userIdsToMigrate.length;
      },
    );
  }
}
