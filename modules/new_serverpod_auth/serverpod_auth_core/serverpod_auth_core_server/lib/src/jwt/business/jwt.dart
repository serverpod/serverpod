import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/common.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/refresh_token_exceptions.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../auth_user/auth_user.dart';
import '../../generated/protocol.dart';
import 'authentication_info_from_jwt.dart';
import 'jwt_admin.dart';
import 'jwt_config.dart';
import 'jwt_util.dart';
import 'refresh_token_string.dart';

/// Business logic for handling JWT-based access and refresh tokens.
class Jwt {
  /// The current JWT authentication module configuration.
  final JwtConfig config;

  /// Admin-related functions for managing authentication tokens.
  final JwtAdmin admin;

  /// The JWT utility.
  final JwtUtil jwtUtil;

  /// The refresh token secret hash utility.
  final Argon2HashUtil refreshTokenSecretHash;

  /// Management functions for auth users.
  final AuthUsers authUsers;

  /// Creates a new instance of [Jwt].
  Jwt({
    required this.config,
    this.authUsers = const AuthUsers(),
  }) : jwtUtil = JwtUtil(
         accessTokenLifetime: config.accessTokenLifetime,
         issuer: config.issuer,
         algorithm: config.algorithm,
         fallbackVerificationAlgorithms: config.fallbackVerificationAlgorithms,
       ),
       refreshTokenSecretHash = Argon2HashUtil(
         hashPepper: config.refreshTokenHashPepper,
         fallbackHashPeppers: config.fallbackRefreshTokenHashPeppers,
         hashSaltLength: config.refreshTokenRotatingSecretSaltLength,
       ),
       admin = JwtAdmin(
         refreshTokenLifetime: config.refreshTokenLifetime,
         jwtUtil: JwtUtil(
           accessTokenLifetime: config.accessTokenLifetime,
           issuer: config.issuer,
           algorithm: config.algorithm,
           fallbackVerificationAlgorithms:
               config.fallbackVerificationAlgorithms,
         ),
         refreshTokenSecretHash: Argon2HashUtil(
           hashPepper: config.refreshTokenHashPepper,
           fallbackHashPeppers: config.fallbackRefreshTokenHashPeppers,
           hashSaltLength: config.refreshTokenRotatingSecretSaltLength,
         ),
         refreshTokenRotatingSecretLength:
             config.refreshTokenRotatingSecretLength,
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
    } on dart_jsonwebtoken.JWTUndefinedException catch (_) {
      return null;
    } on dart_jsonwebtoken.JWTException catch (e, stackTrace) {
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
            JwtContext(
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
    final newHash = await refreshTokenSecretHash.createHashFromBytes(
      secret: secret,
    );

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
  ///
  /// Automatically registers authentication revocation via
  /// `session.messages.authenticationRevoked` when refresh tokens are expired or
  /// have invalid secrets. If this behavior is not desired, use
  /// [JwtAdmin.rotateRefreshToken] instead.
  Future<AuthSuccess> refreshAccessToken(
    final Session session, {
    required final String refreshToken,
    final Transaction? transaction,
  }) async {
    return _withReplacedServerJwtException(() async {
      try {
        final refreshesTokenPair = await admin.rotateRefreshToken(
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
      } on RefreshTokenExpiredServerException catch (e) {
        await session.messages.authenticationRevoked(
          e.authUserId.uuid,
          RevokedAuthenticationAuthId(authId: e.refreshTokenId.toString()),
        );
        rethrow;
      } on RefreshTokenInvalidSecretServerException catch (e) {
        await session.messages.authenticationRevoked(
          e.authUserId.uuid,
          RevokedAuthenticationAuthId(authId: e.refreshTokenId.toString()),
        );
        rethrow;
      }
    });
  }

  /// Revokes all refresh tokens for the given [authUserId].
  ///
  /// Returns the list of IDs of the deleted tokens.
  ///
  /// Active access tokens will continue to work until their expiration time is reached.
  ///
  /// Automatically registers authentication revocation via
  /// `session.messages.authenticationRevoked` when tokens are deleted. If this
  /// behavior is not desired, use [JwtAdmin.deleteRefreshTokens] instead.
  Future<List<UuidValue>> revokeAllRefreshTokens(
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

  /// Revokes a specific refresh token.
  ///
  /// This does not affect the user's other authentications. Returns `true` if
  /// the token was found and deleted, `false` otherwise.
  ///
  /// Any access tokens associated with this refresh token will continue to work
  /// until they expire.
  ///
  /// Automatically registers authentication revocation via
  /// `session.messages.authenticationRevoked` when the token is deleted. If this
  /// behavior is not desired, use [JwtAdmin.deleteRefreshTokens]
  /// instead.
  Future<bool> revokeRefreshToken(
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

  /// List all JWT tokens matching the given filters.
  Future<List<JwtTokenInfo>> listJwtTokens(
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

    final jwtTokenInfos = [
      for (final refreshToken in refreshTokens)
        JwtTokenInfo(
          id: refreshToken.id!,
          authUserId: refreshToken.authUserId,
          scopeNames: refreshToken.scopeNames,
          createdAt: refreshToken.createdAt,
          lastUpdatedAt: refreshToken.lastUpdatedAt,
          extraClaimsJSON: refreshToken.extraClaims,
          method: refreshToken.method,
        ),
    ];

    return jwtTokenInfos;
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

  /// Replaces server-side exceptions by client-side exceptions, hiding details
  /// that could leak account information.
  static Future<T> _withReplacedServerJwtException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on RefreshTokenServerException catch (e) {
      switch (e) {
        case RefreshTokenMalformedServerException():
          throw RefreshTokenMalformedException();
        case RefreshTokenNotFoundServerException():
          throw RefreshTokenNotFoundException();
        case RefreshTokenExpiredServerException():
          throw RefreshTokenExpiredException();
        case RefreshTokenInvalidSecretServerException():
          throw RefreshTokenInvalidSecretException();
      }
    }
  }
}

extension on Set<Scope> {
  Set<String> get names => {
    for (final scope in this)
      if (scope.name != null) scope.name!,
  };
}
