import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/authentication_tokens.dart';

/// Implementation of a token manager using JWT tokens.
class JwtTokenManager implements TokenManager {
  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    return AuthenticationTokens.createTokens(
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
    Expression? whereExpr;

    if (authUserId != null) {
      whereExpr = RefreshToken.t.authUserId.equals(authUserId);
    }

    if (method != null) {
      final methodExpr = RefreshToken.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;
    }

    final refreshTokens = await RefreshToken.db.find(
      session,
      where: whereExpr != null ? (final t) => whereExpr! : null,
      transaction: transaction,
    );

    return refreshTokens
        .map((final token) => TokenInfo(
              userId: token.authUserId.toString(),
              tokenProvider: AuthStrategy.jwt.name,
              tokenId: token.id.toString(),
              scopes: token.scopeNames.map((final name) => Scope(name)).toSet(),
              method: token.method,
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
        whereExpr = RefreshToken.t.authUserId.equals(authUserId);
      }

      final methodExpr = RefreshToken.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;

      await RefreshToken.db.deleteWhere(
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
      await AuthenticationTokens.destroyAllRefreshTokens(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );
    } else {
      await RefreshToken.db.deleteWhere(
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

    await AuthenticationTokens.destroyRefreshToken(
      session,
      refreshTokenId: tokenUuid,
      transaction: transaction,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return AuthenticationTokens.authenticationHandler(session, token);
  }
}
