import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/common.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/refresh_token_exceptions.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../generated/protocol.dart';
import 'jwt_util.dart';
import 'refresh_token_string.dart';

/// Collection of admin functions for managing authentication tokens.
final class JwtAdmin {
  final Duration _refreshTokenLifetime;
  final JwtUtil _jwtUtil;
  final Argon2HashUtil _refreshTokenSecretHash;
  final int _refreshTokenRotatingSecretLength;

  /// Creates a new admin helper class instance.
  @internal
  JwtAdmin({
    required final Duration refreshTokenLifetime,
    required final JwtUtil jwtUtil,
    required final Argon2HashUtil refreshTokenSecretHash,
    required final int refreshTokenRotatingSecretLength,
  }) : _refreshTokenLifetime = refreshTokenLifetime,
       _jwtUtil = jwtUtil,
       _refreshTokenSecretHash = refreshTokenSecretHash,
       _refreshTokenRotatingSecretLength = refreshTokenRotatingSecretLength;

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

  /// {@template authentication_tokens_admin.rotate_refresh_token}
  /// Returns a new refresh / access token pair.
  ///
  /// This invalidates the previous refresh token.
  /// Previously created access tokens for this refresh token will continue to work until they expire.
  /// {@endtemplate}
  Future<TokenPair> rotateRefreshToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    final RefreshTokenStringData refreshTokenData;

    try {
      refreshTokenData = RefreshTokenString.parseRefreshTokenString(
        refreshToken,
      );
    } catch (e, stackTrace) {
      session.log(
        'Received malformed refresh token',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.debug,
      );

      throw RefreshTokenMalformedServerException();
    }

    var refreshTokenRow = await RefreshToken.db.findById(
      session,
      refreshTokenData.id,
      transaction: transaction,
    );

    if (refreshTokenRow == null ||
        !uint8ListAreEqual(
          Uint8List.sublistView(refreshTokenRow.fixedSecret),
          refreshTokenData.fixedSecret,
        )) {
      throw RefreshTokenNotFoundServerException();
    }

    if (refreshTokenRow.isExpired(_refreshTokenLifetime)) {
      await RefreshToken.db.deleteRow(
        session,
        refreshTokenRow,
        transaction: transaction,
      );

      throw RefreshTokenExpiredServerException(
        refreshTokenId: refreshTokenRow.id!,
        authUserId: refreshTokenRow.authUserId,
      );
    }

    if (!await _refreshTokenSecretHash.validateHashFromBytes(
      secret: refreshTokenData.rotatingSecret,
      hash: Uint8List.sublistView(refreshTokenRow.rotatingSecretHash),
      salt: Uint8List.sublistView(refreshTokenRow.rotatingSecretSalt),
    )) {
      await RefreshToken.db.deleteRow(
        session,
        refreshTokenRow,
        transaction: transaction,
      );

      throw RefreshTokenInvalidSecretServerException(
        refreshTokenId: refreshTokenRow.id!,
        authUserId: refreshTokenRow.authUserId,
      );
    }

    final newSecret = _generateRefreshTokenRotatingSecret();
    final newHash = await _refreshTokenSecretHash.createHashFromBytes(
      secret: newSecret,
    );

    refreshTokenRow = await RefreshToken.db.updateRow(
      session,
      refreshTokenRow.copyWith(
        rotatingSecretHash: ByteData.sublistView(newHash.hash),
        rotatingSecretSalt: ByteData.sublistView(newHash.salt),
        lastUpdatedAt: clock.now(),
      ),
      transaction: transaction,
    );

    return TokenPair(
      refreshToken: RefreshTokenString.buildRefreshTokenString(
        refreshToken: refreshTokenRow,
        rotatingSecret: newSecret,
      ),
      accessToken: _jwtUtil.createJwt(refreshTokenRow),
    );
  }

  Uint8List _generateRefreshTokenRotatingSecret() {
    return generateRandomBytes(_refreshTokenRotatingSecretLength);
  }
}

extension on RefreshToken {
  bool isExpired(final Duration refreshTokenLifetime) {
    final oldestAcceptedRefreshTokenDate = clock.now().subtract(
      refreshTokenLifetime,
    );

    return lastUpdatedAt.isBefore(oldestAcceptedRefreshTokenDate);
  }
}

/// A tuple of (refresh token ID) representing a deleted refresh token.
typedef DeletedRefreshToken = ({
  UuidValue authUserId,
  UuidValue refreshTokenId,
});
