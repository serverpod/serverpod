import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'authentication_token_config.dart';
import 'authentication_tokens.dart';

/// Utility methods for creating and verifying JWT tokens.
class JwtUtil {
  /// Creates a new [JwtUtil] instance.
  JwtUtil({
    required final Duration accessTokenLifetime,
    required final String? issuer,
    required final AuthenticationTokenAlgorithm algorithm,
    required final AuthenticationTokenAlgorithm? fallbackVerificationAlgorithm,
  }) : _accessTokenLifetime = accessTokenLifetime,
       _issuer = issuer,
       _algorithm = algorithm,
       _fallbackVerificationAlgorithm = fallbackVerificationAlgorithm;

  final AuthenticationTokenAlgorithm _algorithm;
  final AuthenticationTokenAlgorithm? _fallbackVerificationAlgorithm;
  final Duration _accessTokenLifetime;
  final String? _issuer;

  /// Creates a new JWT for the given refresh token.
  ///
  /// The auth user ID is set as `subject`. An UUID `jwtId` is generated for
  /// each access token to ensure token uniqueness. The refresh token's ID is
  /// stored in the claim "dev.serverpod.refreshTokenId". If scopes are present
  /// on the refresh token configuration, they will be set on a claim named
  /// "dev.serverpod.scopeNames". Any extra claims configured with the refresh
  /// token will be added as top-level claims.
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
        _serverpodRefreshTokenIdClaimKey: refreshToken.id!.toString(),
      },
      jwtId: const Uuid().v4obj().toString(),
      subject: refreshToken.authUserId.toString(),
      issuer: _issuer,
    );

    final (JWTKey key, JWTAlgorithm algorithm) = switch (_algorithm) {
      HmacSha512AuthenticationTokenAlgorithmConfiguration(:final key) => (
        key,
        JWTAlgorithm.HS512,
      ),
      EcdsaSha512AuthenticationTokenAlgorithmConfiguration(:final privateKey) =>
        (privateKey, JWTAlgorithm.ES512),
    };

    return jwt.sign(
      key,
      expiresIn: _accessTokenLifetime,
      algorithm: algorithm,
    );
  }

  /// Verifies and decodes the JWT access token.
  ///
  /// Throws in case of any validation failures (e.g. invalid signature or changed issuer, etc.) and in any case when parsing the expected contained data fails.
  /// In practice, when this is used via [AuthenticationTokens.authenticationHandler], these errors will all be caught and a `null` `AuthenticationInfo?` will be returned instead.
  VerifiedJwtData verifyJwt(final String accessToken) {
    final jwt = _verifyJwt(accessToken);
    final allClaims = (jwt.payload as Map).cast<String, dynamic>();

    final UuidValue refreshTokenId;
    try {
      final tokenStr = allClaims[_serverpodRefreshTokenIdClaimKey] as String;
      refreshTokenId = UuidValue.withValidation(tokenStr);
    } catch (e) {
      throw ArgumentError(
        "The refresh token ID could not be read from the JWT's `$_serverpodRefreshTokenIdClaimKey` claim.",
        'accessToken',
      );
    }

    final UuidValue authUserId;
    try {
      authUserId = UuidValue.withValidation(jwt.subject!);
    } catch (e) {
      throw ArgumentError(
        'The auth user ID could not be read from the JWT\'s `subject` claim: "${jwt.subject}"',
        'accessToken',
      );
    }

    final Set<Scope> scopes;
    try {
      final scopeNamesClaim = allClaims[_serverpodScopeNamesClaimKey];
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

    final extraClaims = Map.fromEntries(
      allClaims.entries.where(
        (final e) =>
            !_registeredClaims.contains(e.key) &&
            e.key != _serverpodScopeNamesClaimKey &&
            e.key != _serverpodRefreshTokenIdClaimKey,
      ),
    );

    return (
      refreshTokenId: refreshTokenId,
      tokenExpiresAt: _extractExpirationDate(allClaims),
      authUserId: authUserId,
      scopes: scopes,
      extraClaims: extraClaims,
    );
  }

  /// Extracts the expiration date from a JWT token.
  DateTime extractExpirationDate(final String accessToken) {
    final jwt = _verifyJwt(accessToken);
    final payload = (jwt.payload as Map).cast<String, dynamic>();
    return _extractExpirationDate(payload);
  }

  DateTime _extractExpirationDate(final Map<String, dynamic> payload) {
    final exp = payload['exp'];
    if (exp is! num) throw ArgumentError('JWT payload missing "exp" key');
    final expMillis = (exp * 1000).toInt();
    return DateTime.fromMillisecondsSinceEpoch(expMillis, isUtc: true);
  }

  /// Verifies the JWT's signature and returns its data.
  ///
  /// If reading with the primary algorithm fails, the fallback (if configured) is tried.
  /// In case neither of the keys work, and error is thrown.
  JWT _verifyJwt(final String accessToken) {
    try {
      return JWT.verify(
        accessToken,
        _algorithm.verificationKey,
        issuer: _issuer,
      );
    } catch (_) {
      final fallbackAlgorithm = _fallbackVerificationAlgorithm;
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

  /// Prefix for Serverpod-specific JWT claims.
  static const _serverpodClaimPrefix = 'dev.serverpod.';

  /// Claim for Serverpod scopes embedded in the access token.
  static const _serverpodScopeNamesClaimKey =
      '${_serverpodClaimPrefix}scopeNames';

  /// Claim carrying the RefreshToken ID associated with this access token.
  static const _serverpodRefreshTokenIdClaimKey =
      '${_serverpodClaimPrefix}refreshTokenId';
}

/// The data successfully verified and extracted from a JWT token.
typedef VerifiedJwtData = ({
  UuidValue refreshTokenId,
  DateTime tokenExpiresAt,
  UuidValue authUserId,
  Set<Scope> scopes,
  Map<String, dynamic> extraClaims,
});
