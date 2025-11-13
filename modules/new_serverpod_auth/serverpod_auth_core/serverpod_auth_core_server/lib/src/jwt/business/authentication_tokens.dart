import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../auth_user/auth_user.dart';
import '../../generated/protocol.dart';
import 'authentication_info_from_jwt.dart';
import 'authentication_token_config.dart';
import 'authentication_tokens_admin.dart';
import 'jwt_util.dart';
import 'refresh_token_secret_hash.dart';
import 'refresh_token_string.dart';

/// Business logic for handling JWT-based access and refresh tokens.
final class AuthenticationTokens {
  /// The current JWT authentication module configuration.
  final AuthenticationTokenConfig config;

  /// Admin-related functions for managing authentication tokens.
  final AuthenticationTokensAdmin admin;

  /// The JWT utility.
  final JwtUtil jwtUtil;

  /// The refresh token secret hash.
  final RefreshTokenSecretHash refreshTokenSecretHash;

  /// Management functions for auth users.
  final AuthUsers authUsers;

  /// Creates a new instance of [AuthenticationTokens].
  AuthenticationTokens({
    required this.config,
    this.authUsers = const AuthUsers(),
  }) : admin = AuthenticationTokensAdmin(
         refreshTokenLifetime: config.refreshTokenLifetime,
       ),
       jwtUtil = JwtUtil(
         accessTokenLifetime: config.accessTokenLifetime,
         issuer: config.issuer,
         algorithm: config.algorithm,
         fallbackVerificationAlgorithm: config.fallbackVerificationAlgorithm,
       ),
       refreshTokenSecretHash = RefreshTokenSecretHash(
         refreshTokenRotatingSecretSaltLength:
             config.refreshTokenRotatingSecretSaltLength,
         refreshTokenHashPepper: config.refreshTokenHashPepper,
       );

  /// Looks up the `AuthenticationInfo` belonging to the [jwtAccessToken].
  ///
  /// In case the session token looks like a JWT, but is not valid a debug-level
  /// log entry is written.
  ///
  /// Returns `null` in any case where no valid authentication could be derived from the input.
  Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String jwtAccessToken,
  ) async {
    try {
      final tokenData = jwtUtil.verifyJwt(jwtAccessToken);

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
  Future<AuthSuccess> createTokens(
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
      final authUser = await authUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );

      if (authUser.blocked && !skipUserBlockedChecked) {
        throw AuthUserBlockedException();
      }

      scopes ??= authUser.scopes;
    }

    // Invoke the extra claims provider if configured
    final mergedExtraClaims = config.extraClaimsProvider != null
        ? await config.extraClaimsProvider!(
            session,
            AuthenticationContext(
              authUserId: authUserId,
              method: method,
              scopes: scopes,
              extraClaims: extraClaims,
            ),
          )
        : extraClaims;
    final encodedExtraClaims =
        mergedExtraClaims != null && mergedExtraClaims.isNotEmpty
        ? jsonEncode(mergedExtraClaims)
        : null;

    final secret = _generateRefreshTokenRotatingSecret();
    final newHash = await refreshTokenSecretHash.createHash(secret: secret);

    final currentTime = clock.now();

    final refreshToken = await RefreshToken.db.insertRow(
      session,
      RefreshToken(
        authUserId: authUserId,
        fixedSecret: ByteData.sublistView(_generateRefreshTokenFixedSecret()),
        rotatingSecretHash: ByteData.sublistView(newHash.hash),
        rotatingSecretSalt: ByteData.sublistView(newHash.salt),
        scopeNames: scopes.names,
        extraClaims: encodedExtraClaims,
        createdAt: currentTime,
        lastUpdatedAt: currentTime,
        method: method,
      ),
      transaction: transaction,
    );

    final token = jwtUtil.createJwt(refreshToken);

    return AuthSuccess(
      authStrategy: AuthStrategy.jwt.name,
      token: token,
      tokenExpiresAt: jwtUtil.extractExpirationDate(token),
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
  Future<AuthSuccess> refreshAccessToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    final refreshesTokenPair = await rotateRefreshToken(
      session,
      refreshToken: refreshToken,
      transaction: transaction,
    );

    final jwtData = jwtUtil.verifyJwt(refreshesTokenPair.accessToken);

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

    if (refreshTokenRow.isExpired(config.refreshTokenLifetime)) {
      await RefreshToken.db.deleteRow(
        session,
        refreshTokenRow,
        transaction: transaction,
      );

      throw RefreshTokenExpiredException();
    }

    if (!await refreshTokenSecretHash.validateHash(
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
    final newHash = await refreshTokenSecretHash.createHash(secret: newSecret);

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
      accessToken: jwtUtil.createJwt(refreshTokenRow),
    );
  }

  /// Removes all refresh tokens for the given [authUserId].
  ///
  /// Returns the list of IDs of the deleted tokens.
  ///
  /// Active access tokens will continue to work until their expiration time is reached.
  Future<List<UuidValue>> destroyAllRefreshTokens(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    final auths = await admin.deleteRefreshTokens(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (auths.isEmpty) return const [];

    await session.messages.authenticationRevoked(
      authUserId.uuid,
      RevokedAuthenticationUser(),
    );

    return auths.map((final auth) => auth.refreshTokenId).toList();
  }

  /// Removes a specific refresh token.
  ///
  /// This does not affect the user's other authentications. Returns `true` if
  /// the token was found and deleted, `false` otherwise.
  ///
  /// Any access tokens associated with this refresh token will continue to work
  /// until they expire.
  Future<bool> destroyRefreshToken(
    final Session session, {
    required final UuidValue refreshTokenId,
    final Transaction? transaction,
  }) async {
    final refreshToken = (await admin.deleteRefreshTokens(
      session,
      refreshTokenId: refreshTokenId,
      transaction: transaction,
    )).firstOrNull;

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
  Future<List<AuthenticationTokenInfo>> listAuthenticationTokens(
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

  Uint8List _generateRefreshTokenFixedSecret() {
    return generateRandomBytes(
      config.refreshTokenFixedSecretLength,
    );
  }

  Uint8List _generateRefreshTokenRotatingSecret() {
    return generateRandomBytes(
      config.refreshTokenRotatingSecretLength,
    );
  }
}

extension on Set<Scope> {
  Set<String> get names => {
    for (final scope in this)
      if (scope.name != null) scope.name!,
  };
}

extension on RefreshToken {
  bool isExpired(final Duration refreshTokenLifetime) {
    final oldestAcceptedRefreshTokenDate = clock.now().subtract(
      refreshTokenLifetime,
    );

    return lastUpdatedAt.isBefore(oldestAcceptedRefreshTokenDate);
  }
}
