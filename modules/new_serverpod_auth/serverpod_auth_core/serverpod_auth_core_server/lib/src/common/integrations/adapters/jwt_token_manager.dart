import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/common/models/auth_success.dart';

import '../../../../auth_user.dart';
import '../../../generated/common/models/auth_strategy.dart';
import '../../../jwt/business/jwt.dart';
import '../../../jwt/business/jwt_config.dart';
import '../token_manager.dart';

/// Token manager adapter for [Jwt].
///
/// This class is used to bridge the gap between the [Jwt]
/// and the [TokenManager] interface. It delegates all operations to the
/// [Jwt] instance.
class JwtTokenManager implements TokenManager {
  /// The name of the token issuer.
  static String get tokenIssuerName => AuthStrategy.jwt.name;

  /// The [Jwt] instance.
  final Jwt jwt;

  /// Creates a new [JwtTokenManager] instance.
  JwtTokenManager({
    required final JwtConfig config,
    final AuthUsers authUsers = const AuthUsers(),
  }) : jwt = Jwt(
         config: config,
         authUsers: authUsers,
       );

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) async {
    return jwt.createTokens(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
  }) async {
    if (_isNotTargetedTokenIssuer(tokenIssuer)) {
      return [];
    }

    return (await jwt.admin.listJwtTokens(
          session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
        ))
        .map(
          (final element) => TokenInfo(
            userId: element.authUserId.toString(),
            tokenId: element.id.toString(),
            tokenIssuer: tokenIssuerName,
            scopes: element.scopeNames.map(Scope.new).toSet(),
            method: element.method,
          ),
        )
        .toList();
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {
    if (_isNotTargetedTokenIssuer(tokenIssuer)) {
      return;
    }

    final deletedRefreshTokens = await jwt.admin.deleteRefreshTokens(
      session,
      authUserId: authUserId,
      method: method,
      transaction: transaction,
    );

    for (final (:authUserId, :refreshTokenId) in deletedRefreshTokens) {
      await session.messages.authenticationRevoked(
        authUserId.uuid,
        RevokedAuthenticationAuthId(authId: refreshTokenId.uuid),
      );
    }
  }

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {
    if (_isNotTargetedTokenIssuer(tokenIssuer)) {
      return;
    }

    final UuidValue refreshTokenId;
    try {
      refreshTokenId = UuidValue.withValidation(tokenId);
    } catch (e) {
      // Silence if the tokenId is not a valid UUID which can happen when
      // interacting with multiple token managers.
      return;
    }

    final deletedRefreshToken = await jwt.admin.deleteRefreshTokens(
      session,
      refreshTokenId: refreshTokenId,
      transaction: transaction,
    );

    if (deletedRefreshToken.isEmpty) return;

    if (deletedRefreshToken.length != 1) {
      throw StateError(
        'Expected 1 refresh token to be deleted, but got ${deletedRefreshToken.length}',
      );
    }

    final (:authUserId, refreshTokenId: _) = deletedRefreshToken.first;

    await session.messages.authenticationRevoked(
      authUserId.uuid,
      RevokedAuthenticationAuthId(authId: refreshTokenId.uuid),
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return jwt.authenticationHandler(session, token);
  }

  bool _isNotTargetedTokenIssuer(final String? tokenIssuer) {
    return tokenIssuer != null && tokenIssuer != tokenIssuerName;
  }
}
