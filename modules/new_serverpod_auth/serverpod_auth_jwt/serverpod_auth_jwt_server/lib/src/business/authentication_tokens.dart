import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/jwt_token_util.dart';
import 'package:serverpod_auth_jwt_server/src/business/refresh_token_secret_hash.dart';
import 'package:serverpod_auth_jwt_server/src/business/refresh_token_string.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Business logic for handling JWT-based access and refresh tokens.
abstract class AuthenticationTokens {
  /// Looks up the `AuthenticationInfo` belonging to the [jwtAccessToken].
  ///
  /// In case the session token looks like a JWT, but is not valid a debug-level
  /// log entry is written.
  ///
  /// Returns `null` in any case where not valid authentication could be derived from the input.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String jwtAccessToken,
  ) async {
    try {
      final result = JwtUtil.verifyJwt(jwtAccessToken);

      return AuthenticationInfo(
        result.authUserId,
        result.scopes,
        authId: result.refreshTokenId.toString(),
      );
    } on JWTException catch (e, stackTrace) {
      if (e is! JWTUndefinedException) {
        // Only log errors with the JWT if it was understood as a JWT and not any other format.
        session.log(
          'Invalid JWT access token',
          level: LogLevel.debug,
          exception: e,
          stackTrace: stackTrace,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Creates a new token pair for a given auth user.
  ///
  /// This is akin to creating a new session, and should be used after a successful login or registration.
  static Future<TokenPair> createTokens(
    final Session session, {
    required final UuidValue authUserId,
    required final Set<Scope> scopes,
    final Transaction? transaction,
  }) async {
    final secret = _generateRefreshTokenSecret();
    final newHash = RefreshTokenSecretHash.createHash(secret: secret);

    final refreshToken = await RefreshToken.db.insertRow(
      session,
      RefreshToken(
        authUserId: authUserId,
        fixedSecret: _generateRefreshTokenFixedSecret(),
        variableSecret: (newHash.hash, newHash.salt),
        scopeNames: scopes.names,
      ),
      transaction: transaction,
    );

    return TokenPair(
      refreshToken: RefreshTokenString.buildRefreshTokenString(
        refreshToken: refreshToken,
        secret: secret,
      ),
      accessToken: JwtUtil.createJwt(refreshToken),
    );
  }

  /// Returns a new refresh & access token pair.
  ///
  /// This invalidates the previous refresh token.
  static Future<TokenPair> rotateRefreshToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    final UuidValue id;
    final String fixedSecret;
    final String variableSecret;

    try {
      (:id, :fixedSecret, :variableSecret) =
          RefreshTokenString.parseRefreshTokenString(refreshToken);
    } catch (e, _) {
      throw RefreshTokenMalformedException();
    }

    var refreshTokenRow = await RefreshToken.db.findById(
      session,
      id,
      transaction: transaction,
    );

    if (refreshTokenRow == null || refreshTokenRow.fixedSecret != fixedSecret) {
      throw RefreshTokenNotFoundException();
    }

    if (refreshTokenRow.isExpired) {
      await RefreshToken.db.deleteRow(
        session,
        refreshTokenRow,
        transaction: transaction,
      );

      throw RefreshTokenExpiredException();
    }

    if (!RefreshTokenSecretHash.validateHash(
      secret: variableSecret,
      hash: refreshTokenRow.variableSecret.$1,
      salt: refreshTokenRow.variableSecret.$2,
    )) {
      await RefreshToken.db
          .deleteRow(session, refreshTokenRow, transaction: transaction);

      throw RefreshTokenInvalidSecretException();
    }

    final newSecret = _generateRefreshTokenSecret();
    final newHash = RefreshTokenSecretHash.createHash(secret: newSecret);

    refreshTokenRow = await RefreshToken.db.updateRow(
      session,
      refreshTokenRow.copyWith(
        variableSecret: (newHash.hash, newHash.salt),
        lastUpdated: DateTime.now(),
      ),
      transaction: transaction,
    );

    return TokenPair(
      refreshToken: RefreshTokenString.buildRefreshTokenString(
        refreshToken: refreshTokenRow,
        secret: newSecret,
      ),
      accessToken: JwtUtil.createJwt(refreshTokenRow),
    );
  }

  /// Removes all refresh tokens for the given [authUserId].
  ///
  /// Active access tokens will still continue to work until the expiry time is reached.
  static Future<void> destroyAllRefreshTokens(
    final Session session, {
    required final UuidValue authUserId,
  }) async {
    final auths = await RefreshToken.db.deleteWhere(
      session,
      where: (final row) => row.authUserId.equals(authUserId),
    );

    if (auths.isEmpty) return;

    // Notify clients about the revoked authentication for the user
    await session.messages.authenticationRevoked(
      authUserId,
      RevokedAuthenticationUser(),
    );
  }

  /// Removes a specific refresh token.
  ///
  /// This does not affect the user's other authentications.
  ///
  /// Any access tokens associated with this refresh token will continue to work
  /// until they expire.
  static Future<void> destroyRefreshToken(
    final Session session, {
    required final UuidValue refreshTokenId,
  }) async {
    final refreshToken = (await RefreshToken.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(refreshTokenId),
    ))
        .firstOrNull;

    if (refreshToken == null) {
      return;
    }

    // Notify the client about the revoked authentication for the specific
    // refresh token.
    await session.messages.authenticationRevoked(
      refreshToken.authUserId,
      RevokedAuthenticationAuthId(authId: refreshTokenId.toString()),
    );
  }

  static String _generateRefreshTokenFixedSecret() {
    return generateRandomString(16);
  }

  static String _generateRefreshTokenSecret() {
    return generateRandomString(64);
  }
}

extension on Set<Scope> {
  Set<String> get names => ({
        for (final scope in this)
          if (scope.name != null) scope.name!,
      });
}

extension on RefreshToken {
  bool get isExpired {
    return lastUpdated.isBefore(DateTime.now()
        .subtract(AuthenticationTokenConfig.current.refreshTokenLifetime));
  }
}
