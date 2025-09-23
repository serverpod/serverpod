import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../auth_user/auth_user.dart';
import '../../generated/protocol.dart';
import 'authentication_info_from_jwt.dart';
import 'authentication_token_config.dart';
import 'authentication_token_secrets.dart';
import 'authentication_tokens_admin.dart';
import 'jwt_util.dart';
import 'refresh_token_secret_hash.dart';
import 'refresh_token_string.dart';

/// Business logic for handling JWT-based access and refresh tokens.
abstract final class AuthenticationTokens {
  /// The current JWT authentication module configuration.
  static AuthenticationTokenConfig config = AuthenticationTokenConfig();

  /// Admin-related functions for managing authentication tokens.
  static final admin = AuthenticationTokensAdmin();

  /// Looks up the `AuthenticationInfo` belonging to the [jwtAccessToken].
  ///
  /// In case the session token looks like a JWT, but is not valid a debug-level
  /// log entry is written.
  ///
  /// Returns `null` in any case where no valid authentication could be derived from the input.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String jwtAccessToken,
  ) async {
    try {
      final tokenData = _jwtUtil.verifyJwt(jwtAccessToken);

      return AuthenticationInfoFromJwt.fromJwtVerificationResult(tokenData);
    } on JWTUndefinedException catch (_) {
      return null;
    } on JWTException catch (e, stackTrace) {
      // All "known" JWT exceptions, e.g. expired, invalid signature, etc.
      session.log(
        'Invalid JWT access token',
        level: LogLevel.debug,
        exception: e,
        stackTrace: stackTrace,
      );

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Creates a new token pair for the given auth user.
  ///
  /// This is akin to creating a new session, and should be used after a successful login or registration.
  static Future<AuthSuccess> createTokens(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,

    /// The scopes to apply to the token.
    ///
    /// By default forwards all of the [AuthUser]'s scopes to the session.
    Set<Scope>? scopes,

    /// Extra claims to be added to the JWT.
    ///
    /// These are added on the top level of the payload, so be sure not to conflict with the [registered claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1),
    /// as those will always overwrite any custom claims given here.
    ///
    /// These claims will be embedded in every access token (also across rotations) and then sent along with any request. This should be taken into account with regard to the total size of the added claims.
    final Map<String, dynamic>? extraClaims,

    /// Whether to skip the check if the user is blocked (in which case a
    /// [AuthUserBlockedException] would be thrown).
    ///
    /// Should only to be used if the caller is sure that the user is not
    /// blocked.
    final bool skipUserBlockedChecked = false,
    final Transaction? transaction,
  }) async {
    if (!skipUserBlockedChecked || scopes == null) {
      final authUser = await AuthUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );

      if (authUser.blocked && !skipUserBlockedChecked) {
        throw AuthUserBlockedException();
      }

      scopes ??= authUser.scopes;
    }

    final secret = _generateRefreshTokenRotatingSecret();
    final newHash = await _refreshTokenSecretHash.createHash(secret: secret);

    final currentTime = clock.now();

    final refreshToken = await RefreshToken.db.insertRow(
      session,
      RefreshToken(
        authUserId: authUserId,
        fixedSecret: ByteData.sublistView(_generateRefreshTokenFixedSecret()),
        rotatingSecretHash: ByteData.sublistView(newHash.hash),
        rotatingSecretSalt: ByteData.sublistView(newHash.salt),
        scopeNames: scopes.names,
        extraClaims: extraClaims != null ? jsonEncode(extraClaims) : null,
        createdAt: currentTime,
        lastUpdatedAt: currentTime,
        method: method,
      ),
      transaction: transaction,
    );

    final token = _jwtUtil.createJwt(refreshToken);

    return AuthSuccess(
      authStrategy: AuthStrategy.jwt.name,
      token: token,
      tokenExpiresAt: _jwtUtil.extractExpirationDate(token),
      refreshToken: RefreshTokenString.buildRefreshTokenString(
        refreshToken: refreshToken,
        rotatingSecret: secret,
      ),
      authUserId: authUserId,
      scopeNames: scopes.names,
    );
  }

  /// Returns a access token while also rotating the refresh token.
  ///
  /// Invalidates the previous refresh token as security best practice.
  static Future<AuthSuccess> refreshAccessToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    final refreshesTokenPair = await rotateRefreshToken(
      session,
      refreshToken: refreshToken,
      transaction: transaction,
    );

    final jwtData = _jwtUtil.verifyJwt(refreshesTokenPair.accessToken);

    return AuthSuccess(
      authStrategy: AuthStrategy.jwt.name,
      token: refreshesTokenPair.accessToken,
      tokenExpiresAt: jwtData.tokenExpiresAt,
      refreshToken: refreshesTokenPair.refreshToken,
      authUserId: jwtData.authUserId,
      scopeNames: jwtData.scopes.names,
    );
  }

  /// Returns a new refresh / access token pair.
  ///
  /// This invalidates the previous refresh token.
  /// Previously created access tokens for this refresh token will continue to work until they expire.
  static Future<TokenPair> rotateRefreshToken(
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

      throw RefreshTokenMalformedException();
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
      // If the `fixedSecret` does not match, we do not delete the refresh token.
      // (Since the `id` is encoded on every access token and thus might be known to 3rd parties or leak, even after the access token itself has expired.)
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

    if (!await _refreshTokenSecretHash.validateHash(
      secret: refreshTokenData.rotatingSecret,
      hash: Uint8List.sublistView(refreshTokenRow.rotatingSecretHash),
      salt: Uint8List.sublistView(refreshTokenRow.rotatingSecretSalt),
    )) {
      await RefreshToken.db.deleteRow(
        session,
        refreshTokenRow,
        transaction: transaction,
      );

      throw RefreshTokenInvalidSecretException();
    }

    final newSecret = _generateRefreshTokenRotatingSecret();
    final newHash = await _refreshTokenSecretHash.createHash(secret: newSecret);

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

  /// Removes all refresh tokens for the given [authUserId].
  ///
  /// Returns the list of IDs of the deleted tokens.
  ///
  /// Active access tokens will continue to work until their expiration time is reached.
  static Future<List<UuidValue>> destroyAllRefreshTokens(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    final auths = await RefreshToken.db.deleteWhere(
      session,
      where: (final row) => row.authUserId.equals(authUserId),
      transaction: transaction,
    );

    if (auths.isEmpty) return const [];

    await session.messages.authenticationRevoked(
      authUserId.uuid,
      RevokedAuthenticationUser(),
    );

    return [
      for (final auth in auths)
        if (auth.id != null) auth.id!,
    ];
  }

  /// Removes a specific refresh token.
  ///
  /// This does not affect the user's other authentications. Returns `true` if
  /// the token was found and deleted, `false` otherwise.
  ///
  /// Any access tokens associated with this refresh token will continue to work
  /// until they expire.
  static Future<bool> destroyRefreshToken(
    final Session session, {
    required final UuidValue refreshTokenId,
    final Transaction? transaction,
  }) async {
    final refreshToken = (await RefreshToken.db.deleteWhere(
      session,
      where: (final row) => row.id.equals(refreshTokenId),
      transaction: transaction,
    ))
        .firstOrNull;

    if (refreshToken == null) {
      return false;
    }

    // Notify the client about the revoked authentication for the specific
    // refresh token.
    await session.messages.authenticationRevoked(
      refreshToken.authUserId.uuid,
      RevokedAuthenticationAuthId(authId: refreshTokenId.toString()),
    );

    return true;
  }

  /// List all authentication tokens belonging to the given [authUserId].
  static Future<List<AuthenticationTokenInfo>> listAuthenticationTokens(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return admin.listAuthenticationTokens(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );
  }

  static Uint8List _generateRefreshTokenFixedSecret() {
    return generateRandomBytes(
      AuthenticationTokens.config.refreshTokenFixedSecretLength,
    );
  }

  static Uint8List _generateRefreshTokenRotatingSecret() {
    return generateRandomBytes(
      AuthenticationTokens.config.refreshTokenRotatingSecretLength,
    );
  }

  /// The secrets configuration.
  static final __secrets = AuthenticationTokenSecrets();

  /// Secrets to the used for testing. Also affects the internally used [JwtUtil] and [RefreshTokenSecretHash]
  @visibleForTesting
  static AuthenticationTokenSecrets? secretsTestOverride;
  static AuthenticationTokenSecrets get _secrets =>
      secretsTestOverride ?? __secrets;

  static JwtUtil get _jwtUtil => JwtUtil(secrets: _secrets);

  static RefreshTokenSecretHash get _refreshTokenSecretHash =>
      RefreshTokenSecretHash(secrets: _secrets);
}

extension on Set<Scope> {
  Set<String> get names => ({
        for (final scope in this)
          if (scope.name != null) scope.name!,
      });
}

extension on RefreshToken {
  bool get isExpired {
    final oldestAcceptedRefreshTokenDate =
        clock.now().subtract(AuthenticationTokens.config.refreshTokenLifetime);

    return lastUpdatedAt.isBefore(oldestAcceptedRefreshTokenDate);
  }
}
