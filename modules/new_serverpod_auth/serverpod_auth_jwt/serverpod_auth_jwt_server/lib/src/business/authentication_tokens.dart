import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
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
      final result = _parseAccessToken(jwtAccessToken);

      return AuthenticationInfo(
        result.authUserId,
        result.scopes,
        authId: result.refreshTokenId.toString(),
      );
    } catch (e) {
      if (e is! JWTUndefinedException) {
        session.log(
          'Invalid JWT access token',
          level: LogLevel.debug,
        );
      }

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
    final refreshToken = await RefreshToken.db.insertRow(
      session,
      RefreshToken(
        authUserId: authUserId,
        secret: _generateRefreshTokenSecret(),
        scopeNames: scopes.names,
      ),
      transaction: transaction,
    );

    return TokenPair(
      refreshToken: _buildRefreshTokenString(refreshToken: refreshToken),
      accessToken: _generateAccessToken(refreshToken: refreshToken),
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
    final String refreshTokenSecret;

    try {
      (id, refreshTokenSecret) = _parseRefreshTokenString(refreshToken);
    } catch (e, _) {
      throw RefreshTokenMalformedException();
    }

    var refreshTokenRow = await RefreshToken.db.findById(
      session,
      id,
      transaction: transaction,
    );

    if (refreshTokenRow == null) {
      throw RefreshTokenNotFoundException();
    }

    if (refreshTokenRow.secret != refreshTokenSecret) {
      await RefreshToken.db.deleteRow(session, refreshTokenRow);

      throw RefreshTokenInvalidSecretException();
    }

    if (refreshTokenRow.isExpired) {
      throw RefreshTokenExpiredException();
    }

    refreshTokenRow = await RefreshToken.db.updateRow(
        session,
        refreshTokenRow.copyWith(
          secret: _generateRefreshTokenSecret(),
          lastUpdated: DateTime.now(),
        ),
        transaction: transaction);

    return TokenPair(
      refreshToken: _buildRefreshTokenString(refreshToken: refreshTokenRow),
      accessToken: _generateAccessToken(refreshToken: refreshTokenRow),
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

  static String _generateRefreshTokenSecret() {
    return generateRandomString(64);
  }

  /// Creates a new access token for the given user.
  ///
  /// For now all tokens are signed with the symmetric "HMAC with SHA-512" algorithm.
  ///
  /// The auth user ID is set as `subject` and the refresh token ID for which this access token is generated is set as `jwtId`.
  ///
  /// NOTE: The tokens generated this way are not suitable to be given to 3rd party (untrusted) system, as they can not validate them.
  ///       To validate the token one needs access to the key used for signing (since this is currently using a symmetric algorithm),
  ///       which is not to be given out, as otherwise these system could create new tokens themselves.
  ///
  ///       Futhermore since the [refreshTokenId] is encoded in the access token, any attacker getting hold of an access token could
  ///       use this to invalidate the refresh token by making a false request with the refresh token ID and any invalid secret to the
  ///       [rotateRefreshToken] method.
  ///
  ///       Thus if the access token are ever desired to be used with such external system, they would need to switch to a public/private
  ///       asymmetric signing scheme and a layer of indirection would have to be added between the access token and its refresh tokens.
  static String _generateAccessToken({
    required final RefreshToken refreshToken,
  }) {
    final jwt = JWT(
      {
        'scopeNames': refreshToken.scopeNames.toList(),
      },
      jwtId: refreshToken.id!.toString(),
      subject: refreshToken.authUserId.toString(),
      issuer: _jwtTokenIssuer,
    );

    return jwt.sign(
      SecretKey(AuthenticationTokenSecrets.privateKey),
      expiresIn: AuthenticationTokenConfig.current.defaultAccessTokenLifetime,
      algorithm: JWTAlgorithm.HS512,
    );
  }

  static ({
    UuidValue refreshTokenId,
    UuidValue authUserId,
    Set<Scope> scopes,
  }) _parseAccessToken(final String accessToken) {
    final jwt = JWT.verify(
      accessToken,
      SecretKey(AuthenticationTokenSecrets.privateKey),
      issuer: _jwtTokenIssuer,
    );

    final refreshTokenId = UuidValue.fromString(jwt.jwtId!);
    final authUserId = UuidValue.fromString(jwt.subject!);

    final scopeNames =
        ((jwt.payload as Map)['scopeNames'] as List).cast<String>();

    final scopes = {
      for (final scopeName in scopeNames) Scope(scopeName),
    };

    return (
      refreshTokenId: refreshTokenId,
      authUserId: authUserId,
      scopes: scopes,
    );
  }

  static const _jwtTokenIssuer =
      'https://github.com/serverpod/serverpod/tree/main/modules/new_serverpod_auth/serverpod_auth_jwt_server';

  /// Prefix for refresh tokens
  /// "sajrt" being an abbreviation of "serverpod_auth_jwt RefrestToken"
  static const _refreshTokenPrefix = 'sajrt';

  /// Returns the external refresh token string
  static String _buildRefreshTokenString({
    required final RefreshToken refreshToken,
  }) {
    return '$_refreshTokenPrefix:${base64Encode(refreshToken.id!.toBytes())}:${refreshToken.secret}';
  }

  static (UuidValue id, String refreshToken) _parseRefreshTokenString(
    final String refreshToken,
  ) {
    if (!refreshToken.startsWith('$_refreshTokenPrefix:')) {
      throw ArgumentError.value(
        refreshToken,
        'refreshToken',
        'Refresh token does not start with "$_refreshTokenPrefix"',
      );
    }

    final parts = refreshToken.split(':');
    if (parts.length != 3) {
      throw ArgumentError.value(
        refreshToken,
        'refreshToken',
        'Refresh token does not consist of 3 parts separated by ":".',
      );
    }

    final refreshTokenId = UuidValue.fromByteList(base64Decode(parts[1]));

    final refreshTokeSecret = parts[2];

    return (refreshTokenId, refreshTokeSecret);
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
