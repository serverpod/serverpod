import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/business/legacy_authentication_handler.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/generated/legacy_session.dart';
import 'package:serverpod_auth_core_server/session.dart';

/// Endpoint to convert legacy sessions.
class SessionMigrationEndpoint extends Endpoint {
  /// Converts a legacy session into a `serverpod_auth_session` one.
  Future<AuthSuccess?> convertSession(
    final Session session, {
    required final String sessionKey,
  }) async {
    final legacySession = await resolveLegacySession(session, sessionKey);

    if (legacySession == null) {
      return null;
    }

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      null,
      (final transaction) async {
        await LegacySession.db.deleteRow(
          session,
          legacySession,
          transaction: transaction,
        );

        return AuthSessions.createSession(
          session,
          authUserId: legacySession.authUserId,
          method: legacySession.method,
          scopes: {
            for (final scopeName in legacySession.scopeNames) Scope(scopeName),
          },
          transaction: transaction,
        );
      },
    );
  }
}
