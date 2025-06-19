import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
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

  /// List all sessions matching the given filters.
  Future<List<AuthSessionInfo>> findSessions(
    final Session session, {
    final UuidValue? authUserId,
    final String? method,
    final Transaction? transaction,
  }) async {
    final authSessions = await AuthSession.db.find(
      session,
      where: (final t) =>
          (authUserId != null
              ? t.authUserId.equals(authUserId)
              : Constant.bool(true)) &
          (method != null ? t.method.equals(method) : Constant.bool(true)),
      transaction: transaction,
    );

    final sessionInfos = <AuthSessionInfo>[
      for (final authSession in authSessions)
        AuthSessionInfo(
          id: authSession.id!,
          authUserId: authSession.authUserId,
          scopeNames: authSession.scopeNames,
          created: authSession.created,
          lastUsed: authSession.lastUsed,
          expiresAt: authSession.expiresAt,
          expireAfterUnusedFor: authSession.expireAfterUnusedFor,
          method: authSession.method,
        ),
    ];

    return sessionInfos;
  }
}
