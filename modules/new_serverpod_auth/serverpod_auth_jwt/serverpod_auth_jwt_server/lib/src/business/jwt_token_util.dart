import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

@internal
abstract class JwtUtil {
  /// The auth user ID is set as `subject` and the refresh token ID for which this access token is generated is set as `jwtId`.
  // TODO: Since we thread the refresh token ID around and now support external verification, we do indeed need to support a second factor/input for the refresh token verification
  static String createJwt(
    final RefreshToken refreshToken,
  ) {
    final jwt = JWT(
      {
        'scopeNames': refreshToken.scopeNames.toList(),
      },
      jwtId: refreshToken.id!.toString(),
      subject: refreshToken.authUserId.toString(),
      issuer: _jwtTokenIssuer,
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
      expiresIn: AuthenticationTokenConfig.current.defaultAccessTokenLifetime,
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

    final jwt = JWT.verify(
      accessToken,
      key,
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
}
