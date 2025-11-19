import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

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
        '"${AuthSession.t.lastUsedAt.columnName}" + ("${AuthSession.t.expireAfterUnusedFor.columnName}" * INTERVAL \'1 millisecond\') < \'${SerializationManager.encode(clock.now())}\'',
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
      where: (final t) {
        Expression<dynamic> expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= t.authUserId.equals(authUserId);
        }

        if (method != null) {
          expression &= t.method.equals(method);
        }

        return expression;
      },
      transaction: transaction,
    );

    final sessionInfos = <AuthSessionInfo>[
      for (final authSession in authSessions)
        AuthSessionInfo(
          id: authSession.id!,
          authUserId: authSession.authUserId,
          scopeNames: authSession.scopeNames,
          created: authSession.createdAt,
          lastUsed: authSession.lastUsedAt,
          expiresAt: authSession.expiresAt,
          expireAfterUnusedFor: authSession.expireAfterUnusedFor,
          method: authSession.method,
        ),
    ];

    return sessionInfos;
  }

  /// Deletes the sessions matching the given filters.
  ///
  /// If [authUserId] is provided, only sessions for that user will be deleted.
  /// If [method] is provided, only sessions created with that method will be deleted.
  /// If [authSessionId] is provided, only the session with that ID will be deleted.
  ///
  /// Returns a list with [DeletedSession]s.
  Future<List<DeletedSession>> deleteSessions(
    final Session session, {
    final UuidValue? authUserId,
    final UuidValue? authSessionId,
    final String? method,
    final Transaction? transaction,
  }) async {
    final authSessions = await AuthSession.db.deleteWhere(
      session,
      where: (final row) {
        Expression<dynamic> expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= row.authUserId.equals(authUserId);
        }

        if (authSessionId != null) {
          expression &= row.id.equals(authSessionId);
        }

        if (method != null) {
          expression &= row.method.equals(method);
        }

        return expression;
      },
      transaction: transaction,
    );

    return authSessions
        .map(
          (final session) => (
            authUserId: session.authUserId,
            sessionId: session.id!,
          ),
        )
        .toList();
  }
}

/// A tuple of (auth user ID, session ID) representing a deleted session.
typedef DeletedSession = ({UuidValue authUserId, UuidValue sessionId});
