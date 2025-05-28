import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

@internal
abstract class JwtUtil {
  /// The auth user ID is set as `subject` and the refresh token ID for which this access token is generated is set as `jwtId`.
  static String createJwt(
    final RefreshToken refreshToken, {
    final Map<String, dynamic>? extraClaims,
  }) {
    final jwt = JWT(
      {
        ...?extraClaims,
        if (refreshToken.scopeNames.isNotEmpty)
          _serverpodScopeNamesClaimKey: refreshToken.scopeNames.toList(),
      },
      jwtId: refreshToken.id!.toString(),
      subject: refreshToken.authUserId.toString(),
      issuer: _issuer,
    );

    final (JWTKey key, JWTAlgorithm algorithm) =
        switch (AuthenticationTokenSecrets.algorithm) {
      HmacSha512AuthenticationTokenAlgorithm(:final key) => (
          SecretKey(key),
          JWTAlgorithm.HS512
        ),
      EcdsaSha512AuthenticationTokenAlgorithm(:final privateKey) => (
          ECPrivateKey(privateKey),
          JWTAlgorithm.ES512
        )
    };

    return jwt.sign(
      key,
      expiresIn: AuthenticationTokens.config.accessTokenLifetime,
      algorithm: algorithm,
    );
  }

  static ({
    UuidValue refreshTokenId,
    UuidValue authUserId,
    Set<Scope> scopes,
    Map<String, dynamic> extraClaims,
  }) verifyJwt(final String accessToken) {
    final key = switch (AuthenticationTokenSecrets.algorithm) {
      HmacSha512AuthenticationTokenAlgorithm(:final key) => SecretKey(key),
      EcdsaSha512AuthenticationTokenAlgorithm(:final publicKey) =>
        ECPublicKey(publicKey),
    };

    JWT jwt;
    try {
      jwt = JWT.verify(
        accessToken,
        key,
        issuer: _issuer,
      );
    } catch (_) {
      final fallbackAlgorithm =
          AuthenticationTokenSecrets.fallbackVerificationAlgorithm;
      if (fallbackAlgorithm == null) {
        rethrow;
      }

      final key = switch (fallbackAlgorithm) {
        HmacSha512FallbackAuthenticationTokenAlgorithm(:final key) =>
          SecretKey(key),
        EcdsaSha512FallbackAuthenticationTokenAlgorithm(:final publicKey) =>
          ECPublicKey(publicKey),
      };

      jwt = JWT.verify(
        accessToken,
        key,
        issuer: _issuer,
      );
    }

    final refreshTokenId = UuidValue.fromString(jwt.jwtId!);
    final authUserId = UuidValue.fromString(jwt.subject!);

    final scopeNamesClaim = (jwt.payload as Map)[_serverpodScopeNamesClaimKey];
    final scopeNames = scopeNamesClaim != null
        ? (scopeNamesClaim as List).cast<String>()
        : const <String>[];

    final scopes = {
      for (final scopeName in scopeNames) Scope(scopeName),
    };

    final allClaims = (jwt.payload as Map).cast<String, dynamic>();
    final extraClaims = Map.fromEntries(
      allClaims.entries.where((final e) =>
          !_registeredClaims.contains(e.key) &&
          e.key != _serverpodScopeNamesClaimKey),
    );

    return (
      refreshTokenId: refreshTokenId,
      authUserId: authUserId,
      scopes: scopes,
      extraClaims: extraClaims,
    );
  }

  static String? get _issuer => AuthenticationTokens.config.issuer;

  /// Registered claims as per https://datatracker.ietf.org/doc/html/rfc7519#section-4.1
  static const _registeredClaims = {
    'iss',
    'sub',
    'aud',
    'exp',
    'nbf',
    'iat',
    'jti',
  };

  static const _serverpodScopeNamesClaimKey = 'dev.serverpod.scopeNames';
}
