import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/session/business/auth_sessions.dart';

/// Implementation of a token issuer using session tokens.
class SasTokenIssuer implements TokenIssuer {
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
}

/// Implementation of a token provider using session tokens.
class SasTokenProvider implements TokenProvider {
  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    Expression? whereExpr;

    if (authUserId != null) {
      whereExpr = AuthSession.t.authUserId.equals(authUserId);
    }

    if (method != null) {
      final methodExpr = AuthSession.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;
    }

    final authSessions = await AuthSession.db.find(
      session,
      where: whereExpr != null ? (final t) => whereExpr! : null,
      transaction: transaction,
    );

    return authSessions
        .map((final authSession) => TokenInfo(
              userId: authSession.authUserId.toString(),
              tokenProvider: AuthStrategy.session.name,
              tokenId: authSession.id.toString(),
              scopes: authSession.scopeNames
                  .map((final name) => Scope(name))
                  .toSet(),
              method: authSession.method,
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
    Expression? whereExpr;

    if (authUserId != null) {
      whereExpr = AuthSession.t.authUserId.equals(authUserId);
    }

    if (method != null) {
      final methodExpr = AuthSession.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;
    }

    whereExpr ??= AuthSession.t.id.notEquals(null);

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
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    final tokenUuid = UuidValue.withValidation(tokenId);

    final deletedSessions = await AuthSession.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(tokenUuid),
      transaction: transaction,
    );

    if (deletedSessions.isNotEmpty) {
      final authSession = deletedSessions.first;
      await session.messages.authenticationRevoked(
        authSession.authUserId.uuid,
        RevokedAuthenticationAuthId(authId: tokenId),
      );
    }
  }
}
