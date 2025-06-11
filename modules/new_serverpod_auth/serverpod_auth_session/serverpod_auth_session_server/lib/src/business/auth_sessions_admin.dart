import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/src/generated/auth_session.dart';

/// Collection of admin functions for managing sessions.
final class AuthSessionsAdmin {
  /// Creates a new admin helper class instance.
  @internal
  AuthSessionsAdmin();

  /// Deletes the session where [AuthSession.expiresAt] has elapsed, or where
  /// the session has not been used in since [AuthSession.expireAfterUnusedFor] expired it.
  Future<void> deleteExpiredSessions(
    final Session session, {
    /// Whether to delete sessions which [AuthSession.expiresAt] is in the past.
    final bool deleteExpired = true,

    /// Whether to delete sessions which have not been used for [AuthSession.expireAfterUnusedFor].
    final bool deleteInactive = true,
    final Transaction? transaction,
  }) async {
    if (deleteExpired) {
      await AuthSession.db.deleteWhere(
        session,
        where: (final t) => t.expiresAt < clock.now(),
        transaction: transaction,
      );
    }

    if (deleteInactive) {
      await session.db.unsafeQuery(
        'DELETE FROM ${AuthSession.t.tableName} WHERE '
        '"${AuthSession.t.expireAfterUnusedFor.columnName}" IS NOT NULL AND '
        '"${AuthSession.t.lastUsed.columnName}" + ("${AuthSession.t.expireAfterUnusedFor.columnName}" * INTERVAL \'1 millisecond\') < \'${SerializationManager.encode(clock.now())}\'',
        transaction: transaction,
      );
    }
  }
}
