import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Collection of admin functions for managing authentication tokens.
final class AuthenticationTokensAdmin {
  final Duration _refreshTokenLifetime;

  /// Creates a new admin helper class instance.
  @internal
  AuthenticationTokensAdmin({
    required final Duration refreshTokenLifetime,
  }) : _refreshTokenLifetime = refreshTokenLifetime;

  /// Removes all expired refresh tokens from the database.
  Future<void> deleteExpiredRefreshTokens(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final oldestValidRefreshTokenDate = clock.now().subtract(
      _refreshTokenLifetime,
    );

    await RefreshToken.db.deleteWhere(
      session,
      where: (final t) => t.lastUpdatedAt < oldestValidRefreshTokenDate,
      transaction: transaction,
    );
  }

  /// List all authentication tokens matching the given filters.
  Future<List<AuthenticationTokenInfo>> listAuthenticationTokens(
    final Session session, {
    final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,

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
          createdAt: refreshToken.createdAt,
          lastUpdatedAt: refreshToken.lastUpdatedAt,
          extraClaimsJSON: refreshToken.extraClaims,
          method: refreshToken.method,
        ),
    ];

    return authenticationTokenInfos;
  }

  /// Deletes the refresh tokens matching the given filters.
  ///
  /// If [refreshTokenId] is provided, only the refresh token with that ID will be deleted.
  /// If [authUserId] is provided, only the refresh tokens for that user will be deleted.
  /// If [method] is provided, only the refresh tokens created with that method will be deleted.
  ///
  /// Returns a list with [DeletedRefreshToken]s.
  Future<List<DeletedRefreshToken>> deleteRefreshTokens(
    final Session session, {
    final UuidValue? refreshTokenId,
    final UuidValue? authUserId,
    final String? method,
    final Transaction? transaction,
  }) async {
    final refreshTokens = await RefreshToken.db.deleteWhere(
      session,
      where: (final row) {
        Expression<dynamic> expression = Constant.bool(true);

        if (authUserId != null) {
          expression &= row.authUserId.equals(authUserId);
        }

        if (refreshTokenId != null) {
          expression &= row.id.equals(refreshTokenId);
        }

        if (method != null) {
          expression &= row.method.equals(method);
        }

        return expression;
      },
      transaction: transaction,
    );

    return refreshTokens
        .map(
          (final refreshToken) => (
            authUserId: refreshToken.authUserId,
            refreshTokenId: refreshToken.id!,
          ),
        )
        .toList();
  }
}

/// A tuple of (refresh token ID) representing a deleted refresh token.
typedef DeletedRefreshToken = ({
  UuidValue authUserId,
  UuidValue refreshTokenId,
});
