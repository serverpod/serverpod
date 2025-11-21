import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/legacy_authentication_handler.dart';
import 'package:serverpod_auth_bridge_server/src/generated/legacy_session.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Endpoint to convert legacy sessions.
class SessionMigrationEndpoint extends Endpoint {
  /// Gets the [TokenManager] from the [AuthServices] instance.
  ///
  /// If [TokenManager] should be fetched from a different source, override
  /// this method.
  TokenManager get tokenManager => AuthServices.instance.tokenManager;

  /// Converts a legacy session into a new token from the token manager.
  Future<AuthSuccess?> convertSession(
    final Session session, {
    required final String sessionKey,
  }) async {
    final legacySession = await resolveLegacySession(session, sessionKey);

    if (legacySession == null) {
      return null;
    }

    return DatabaseUtil.runInTransactionOrSavepoint(session.db, null, (
      final transaction,
    ) async {
      await LegacySession.db.deleteRow(
        session,
        legacySession,
        transaction: transaction,
      );

      return tokenManager.issueToken(
        session,
        authUserId: legacySession.authUserId,
        method: legacySession.method,
        scopes: {
          for (final scopeName in legacySession.scopeNames) Scope(scopeName),
        },
        transaction: transaction,
      );
    });
  }
}
