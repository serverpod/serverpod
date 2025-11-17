import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Collection of admin functions for managing sessions.
final class ServerSideSessionsAdmin {
  /// Creates a new admin helper class instance.
  @internal
  ServerSideSessionsAdmin();

  /// Deletes the session where [ServerSideSession.expiresAt] has elapsed, or where
  /// the session has not been used in since [ServerSideSession.expireAfterUnusedFor] expired it.
  Future<void> deleteExpiredSessions(
    final Session session, {

    /// Whether to delete sessions which [ServerSideSession.expiresAt] is in the past.
    final bool deleteExpired = true,

    /// Whether to delete sessions which have not been used for [ServerSideSession.expireAfterUnusedFor].
    final bool deleteInactive = true,
    final Transaction? transaction,
  }) async {
    if (deleteExpired) {
      await ServerSideSession.db.deleteWhere(
        session,
        where: (final t) => t.expiresAt < clock.now(),
        transaction: transaction,
      );
    }

    if (deleteInactive) {
      await session.db.unsafeQuery(
        'DELETE FROM ${ServerSideSession.t.tableName} WHERE '
        '"${ServerSideSession.t.expireAfterUnusedFor.columnName}" IS NOT NULL AND '
        '"${ServerSideSession.t.lastUsedAt.columnName}" + ("${ServerSideSession.t.expireAfterUnusedFor.columnName}" * INTERVAL \'1 millisecond\') < \'${SerializationManager.encode(clock.now())}\'',
        transaction: transaction,
      );
    }
  }

  /// List all sessions matching the given filters.
  Future<List<ServerSideSessionInfo>> findSessions(
    final Session session, {
    final UuidValue? authUserId,
    final String? method,
    final Transaction? transaction,
  }) async {
    final serverSideSessions = await ServerSideSession.db.find(
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

    final sessionInfos = <ServerSideSessionInfo>[
      for (final serverSideSession in serverSideSessions)
        ServerSideSessionInfo(
          id: serverSideSession.id!,
          authUserId: serverSideSession.authUserId,
          scopeNames: serverSideSession.scopeNames,
          created: serverSideSession.createdAt,
          lastUsed: serverSideSession.lastUsedAt,
          expiresAt: serverSideSession.expiresAt,
          expireAfterUnusedFor: serverSideSession.expireAfterUnusedFor,
          method: serverSideSession.method,
        ),
    ];

    return sessionInfos;
  }

  /// Deletes the sessions matching the given filters.
  ///
  /// If [authUserId] is provided, only sessions for that user will be deleted.
  /// If [method] is provided, only sessions created with that method will be deleted.
  /// If [serverSideSessionId] is provided, only the session with that ID will be deleted.
  ///
  /// Returns a list with [DeletedSession]s.
  Future<List<DeletedSession>> deleteSessions(
    final Session session, {
    final UuidValue? authUserId,
    final UuidValue? serverSideSessionId,
    final String? method,
    final Transaction? transaction,
  }) async {
    final serverSideSessions = await ServerSideSession.db.deleteWhere(
      session,
      where: (final row) {
        Expression<dynamic> expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= row.authUserId.equals(authUserId);
        }

        if (serverSideSessionId != null) {
          expression &= row.id.equals(serverSideSessionId);
        }

        if (method != null) {
          expression &= row.method.equals(method);
        }

        return expression;
      },
      transaction: transaction,
    );

    return serverSideSessions
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
