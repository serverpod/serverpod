import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/common/models/auth_success.dart';

import '../../../auth_user/auth_user.dart';
import '../../../generated/common/models/auth_strategy.dart';
import '../../../jwt/business/jwt.dart';
import '../../../jwt/business/jwt_config.dart';
import '../../../jwt/util/jwt_refresh_cookie_path.dart';
import '../token_manager.dart';

/// Token manager adapter for [Jwt].
///
/// This class is used to bridge the gap between the [Jwt]
/// and the [TokenManager] interface. It delegates all operations to the
/// [Jwt] instance.
class JwtTokenManager extends TokenManager {
  /// The name of the token issuer.
  static String get tokenIssuerName => AuthStrategy.jwt.name;

  /// The [Jwt] instance.
  final Jwt jwt;

  /// Creates a new [JwtTokenManager] instance.
  JwtTokenManager({
    required JwtConfig config,
    AuthUsers authUsers = const AuthUsers(),
  }) : jwt = Jwt(
         config: config,
         authUsers: authUsers,
       );

  @override
  Future<AuthSuccess> createToken(
    Session session, {
    required UuidValue authUserId,
    required String method,
    Set<Scope>? scopes,
    Transaction? transaction,
  }) {
    return jwt.createTokens(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }

  @override
  DateTime? refreshTokenExpiresAt() {
    // Slack for the delay between minting and the cookie write, so the
    // cookie does not outlive the token.
    return clock.now().toUtc().add(
      jwt.config.refreshTokenLifetime - const Duration(seconds: 10),
    );
  }

  @override
  String? refreshCookiePath(Session session) => jwtRefreshCookiePath(session);

  @override
  Future<List<TokenInfo>> listTokens(
    Session session, {
    required UuidValue? authUserId,
    String? method,
    String? tokenIssuer,
    Transaction? transaction,
  }) async {
    if (_isNotTargetedTokenIssuer(tokenIssuer)) {
      return [];
    }

    return (await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
          method: method,
          transaction: transaction,
        ))
        .map(
          (element) => TokenInfo(
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
    Session session, {
    required UuidValue? authUserId,
    Transaction? transaction,
    String? method,
    String? tokenIssuer,
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
    Session session, {
    required String tokenId,
    Transaction? transaction,
    String? tokenIssuer,
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
    Session session,
    String token,
  ) async {
    return jwt.authenticationHandler(session, token);
  }

  bool _isNotTargetedTokenIssuer(String? tokenIssuer) {
    return tokenIssuer != null && tokenIssuer != tokenIssuerName;
  }
}
