import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/authentication_tokens.dart';

/// Implementation of a token issuer using JWT tokens.
class JwtTokenIssuer implements TokenIssuer {
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
}

/// Implementation of a token provider using JWT tokens.
class JwtTokenProvider implements TokenProvider {
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
    Expression? whereExpr;

    if (authUserId != null) {
      whereExpr = RefreshToken.t.authUserId.equals(authUserId);
    }

    if (method != null) {
      final methodExpr = RefreshToken.t.method.equals(method);
      whereExpr = whereExpr != null ? whereExpr & methodExpr : methodExpr;
    }

    whereExpr ??= RefreshToken.t.id.notEquals(null);

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
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    final Transaction? transaction,
  }) async {
    final tokenUuid = UuidValue.withValidation(tokenId);

    final deletedTokens = await RefreshToken.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(tokenUuid),
      transaction: transaction,
    );

    if (deletedTokens.isNotEmpty) {
      final token = deletedTokens.first;
      await session.messages.authenticationRevoked(
        token.authUserId.uuid,
        RevokedAuthenticationAuthId(authId: tokenId),
      );
    }
  }
}
