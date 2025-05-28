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
        'scopeNames': refreshToken.scopeNames.toList(),
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
      expiresIn: AuthenticationTokenConfig.current.accessTokenLifetime,
      algorithm: algorithm,
    );
  }

  static ({
    UuidValue refreshTokenId,
    UuidValue authUserId,
    Set<Scope> scopes,
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

  static String? get _issuer => AuthenticationTokenConfig.current.issuer;
}
