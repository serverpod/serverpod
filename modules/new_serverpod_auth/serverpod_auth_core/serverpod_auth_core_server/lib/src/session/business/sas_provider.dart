import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/session/business/auth_sessions.dart';

/// Implementation of a token manager using SAS tokens.
class SasTokenManager implements TokenManager {
  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    return AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    final sessionInfos = await AuthSessions.admin.findSessions(
      session,
      authUserId: authUserId,
      method: method,
      transaction: transaction,
    );

    return sessionInfos
        .map((final sessionInfo) => TokenInfo(
              userId: sessionInfo.authUserId.toString(),
              tokenProvider: AuthStrategy.session.name,
              tokenId: sessionInfo.id.toString(),
              scopes: sessionInfo.scopeNames
                  .map((final name) => Scope(name))
                  .toSet(),
              method: sessionInfo.method,
            ))
        .toList();
  }

  @override
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    if (method != null) {
      Expression? whereExpr;

      if (authUserId != null) {
        whereExpr = AuthSession.t.authUserId.equals(authUserId);
      }

      final methodExpr = AuthSession.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;

      await AuthSession.db.deleteWhere(
        session,
        where: (final t) => whereExpr!,
        transaction: transaction,
      );

      if (authUserId != null) {
        await session.messages.authenticationRevoked(
          authUserId.uuid,
          RevokedAuthenticationUser(),
        );
      }
    } else if (authUserId != null) {
      await AuthSessions.destroyAllSessions(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );
    } else {
      await AuthSession.db.deleteWhere(
        session,
        where: (final t) => t.id.notEquals(null),
        transaction: transaction,
      );
    }
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    final tokenUuid = UuidValue.withValidation(tokenId);

    await AuthSessions.destroySession(
      session,
      authSessionId: tokenUuid,
      transaction: transaction,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return AuthSessions.authenticationHandler(session, token);
  }
}
