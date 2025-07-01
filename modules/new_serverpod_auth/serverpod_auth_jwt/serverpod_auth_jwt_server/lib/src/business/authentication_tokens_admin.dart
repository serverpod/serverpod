import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

/// Collection of admin functions for managing authentication tokens.
final class AuthenticationTokensAdmin {
  /// Creates a new admin helper class instance.
  @internal
  AuthenticationTokensAdmin();

  /// Removes all expired refresh tokens from the database.
  Future<void> deleteExpiredRefreshTokens(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final oldestValidRefreshTokenDate =
        clock.now().subtract(AuthenticationTokens.config.refreshTokenLifetime);

    await RefreshToken.db.deleteWhere(
      session,
      where: (final t) => t.lastUpdated < oldestValidRefreshTokenDate,
      transaction: transaction,
    );
  }

  /// List all authentication tokens matching the given filters.
  Future<List<AuthenticationTokenInfo>> listAuthenticationTokens(
    final Session session, {
    final UuidValue? authUserId,
    final Transaction? transaction,

    /// How many items to return at maximum. Must be <= 1000.
    final int limit = 100,
    final int offset = 0,
  }) async {
    if (limit <= 0 || limit > 1000) {
      throw ArgumentError.value(limit, 'limit', 'Must be between 1 and 1000');
    }
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Must be >= 0');
    }

    final refreshTokens = await RefreshToken.db.find(
      session,
      where: (final t) => (authUserId != null
          ? t.authUserId.equals(authUserId)
          : Constant.bool(true)),
      limit: limit,
      offset: offset,
      orderBy: (final t) => t.id,
      transaction: transaction,
    );

    final authenticationTokenInfos = [
      for (final refreshToken in refreshTokens)
        AuthenticationTokenInfo(
          id: refreshToken.id!,
          authUserId: refreshToken.authUserId,
          scopeNames: refreshToken.scopeNames,
          created: refreshToken.created,
          lastUpdated: refreshToken.lastUpdated,
          extraClaimsJSON: refreshToken.extraClaims,
        ),
    ];

    return authenticationTokenInfos;
  }
}
