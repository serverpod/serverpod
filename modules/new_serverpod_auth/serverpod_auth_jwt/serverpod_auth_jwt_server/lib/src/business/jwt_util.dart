import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

@internal
class JwtUtil {
  JwtUtil({
    required final AuthenticationTokenSecrets secrets,
  }) : _secrets = secrets;

  final AuthenticationTokenSecrets _secrets;

  /// Creates a new JWT for the given refresh token.
  ///
  /// The auth user ID is set as `subject`.
  /// The refresh token's ID for which this access token is generated is set as `jwtId`.
  /// If scopes are present on the fresh token configuration, they will be set on a claim named "dev.serverpod.scopeNames".
  /// Any extra claims configured with the refresh token will be added as top-level claims.
  String createJwt(final RefreshToken refreshToken) {
    final extraClaims = refreshToken.extraClaims != null
        ? (jsonDecode(refreshToken.extraClaims!) as Map).cast<String, dynamic>()
        : null;

    if (extraClaims != null) {
      for (final key in extraClaims.keys) {
        if (key.startsWith(_serverpodClaimPrefix)) {
          throw ArgumentError(
            'The refresh token contains `extraClaims` in the Serverpod name space: "$key" must not start with "$_serverpodClaimPrefix".',
            'refreshToken',
          );
        }
        if (_registeredClaims.contains(key)) {
          throw ArgumentError(
            'The refresh token contains `extraClaims` for the registered claim "$key".',
            'refreshToken',
          );
        }
      }
    }

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

    final (JWTKey key, JWTAlgorithm algorithm) = switch (_secrets.algorithm) {
      HmacSha512AuthenticationTokenAlgorithmConfiguration(:final key) => (
          key,
          JWTAlgorithm.HS512
        ),
      EcdsaSha512AuthenticationTokenAlgorithmConfiguration(:final privateKey) =>
        (privateKey, JWTAlgorithm.ES512)
    };

    return jwt.sign(
      key,
      expiresIn: AuthenticationTokens.config.accessTokenLifetime,
      algorithm: algorithm,
    );
  }

  /// Verifies and decodes the JWT access token.
  ///
  /// Throws in case of any validation failures (e.g. invalid signature or changed issuer, etc.) and in any case when parsing the expected contained data fails.
  /// In practice, when this is used via [AuthenticationTokens.authenticationHandler], these errors will all be caught and a `null` `AuthenticationInfo?` will be returned instead.
  VerifiedJwtData verifyJwt(final String accessToken) {
    final jwt = _verifyJwt(accessToken);

    final UuidValue refreshTokenId;
    try {
      refreshTokenId = UuidValue.fromString(jwt.jwtId!);
    } catch (e) {
      throw ArgumentError(
        'The refresh token ID could not be read from the JWT\'s `id` claim: "${jwt.jwtId}"',
        'accessToken',
      );
    }

    final UuidValue authUserId;
    try {
      authUserId = UuidValue.fromString(jwt.subject!);
    } catch (e) {
      throw ArgumentError(
        'The auth user ID could not be read from the JWT\'s `subject` claim: "${jwt.subject}"',
        'accessToken',
      );
    }

    final Set<Scope> scopes;
    try {
      final scopeNamesClaim =
          (jwt.payload as Map)[_serverpodScopeNamesClaimKey];
      final scopeNames = scopeNamesClaim != null
          ? (scopeNamesClaim as List).cast<String>()
          : const <String>[];

      scopes = {
        for (final scopeName in scopeNames) Scope(scopeName),
      };
    } catch (e) {
      throw ArgumentError(
        "The scopes could not be read from the JWT's `$_serverpodScopeNamesClaimKey` claim.",
        'accessToken',
      );
    }

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

  /// Verifies the JWT's signature and returns its data.
  ///
  /// If reading with the primary algorithm fails, the fallback (if configured) is tried.
  /// In case neither of the keys work, and error is thrown.
  JWT _verifyJwt(final String accessToken) {
    try {
      return JWT.verify(
        accessToken,
        _secrets.algorithm.verificationKey,
        issuer: _issuer,
      );
    } catch (_) {
      final fallbackAlgorithm = _secrets.fallbackVerificationAlgorithm;
      if (fallbackAlgorithm == null) {
        rethrow;
      }

      return JWT.verify(
        accessToken,
        fallbackAlgorithm.verificationKey,
        issuer: _issuer,
      );
    }
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

  static const _serverpodClaimPrefix = 'dev.serverpod.';
  static const _serverpodScopeNamesClaimKey =
      '${_serverpodClaimPrefix}scopeNames';
}

/// The data successfully verified and extracted from a JWT token.
typedef VerifiedJwtData = ({
  UuidValue refreshTokenId,
  UuidValue authUserId,
  Set<Scope> scopes,
  Map<String, dynamic> extraClaims,
});

extension on AuthenticationTokenAlgorithmConfiguration {
  JWTKey get verificationKey {
    return switch (this) {
      HmacSha512AuthenticationTokenAlgorithmConfiguration(:final key) => key,
      EcdsaSha512AuthenticationTokenAlgorithmConfiguration(:final publicKey) =>
        publicKey,
    };
  }
}

extension on FallbackAuthenticationTokenAlgorithmConfiguration {
  JWTKey get verificationKey {
    return switch (this) {
      HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration(:final key) =>
        key,
      EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration(
        :final publicKey
      ) =>
        publicKey,
    };
  }
}
