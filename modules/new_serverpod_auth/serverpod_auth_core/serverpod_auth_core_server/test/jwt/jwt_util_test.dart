import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/jwt_util.dart';
import 'package:serverpod_auth_core_server/src/jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  group('Given a valid HS512 configuration and', () {
    late JwtUtil jwtUtil;

    setUp(() {
      final authenticationTokens = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: _hs512Algorithm(),
          refreshTokenHashPepper: 'test-pepper',
        ),
      );
      jwtUtil = authenticationTokens.jwtUtil;
    });

    group('a plain refresh token,', () {
      late RefreshToken refreshToken;
      setUp(() {
        refreshToken = _createRefreshToken();
      });

      test(
        'when a JWT is requested for the refresh token, then it succeeds.',
        () {
          expect(
            jwtUtil.createJwt(refreshToken),
            isNotEmpty,
          );
        },
      );

      test(
        'when two JWTs are created within the same second, then they are unique.',
        () {
          final refreshToken = _createRefreshToken();
          final jwt1 = jwtUtil.createJwt(refreshToken);
          final jwt2 = jwtUtil.createJwt(refreshToken);
          expect(jwt1, isNot(jwt2));
        },
      );
    });

    group('a refresh token containing a reserved claim,', () {
      late RefreshToken refreshToken;
      setUp(() {
        refreshToken = _createRefreshToken().copyWith(
          extraClaims: jsonEncode({'iss': 'foo'}),
        );
      });

      test(
        'when a JWT is requested for the refresh token, then it throws an error.',
        () {
          expect(
            () => jwtUtil.createJwt(refreshToken),
            throwsArgumentError,
          );
        },
      );
    });

    group('a refresh token containing a claim in the Serverpod namespace,', () {
      late RefreshToken refreshToken;
      setUp(() {
        refreshToken = _createRefreshToken().copyWith(
          extraClaims: jsonEncode({'dev.serverpod.x': 'foo'}),
        );
      });

      test(
        'when a JWT is requested for the refresh token, then it throws an error.',
        () {
          expect(
            () => jwtUtil.createJwt(refreshToken),
            throwsArgumentError,
          );
        },
      );
    });

    group('a JWT token for a plain refresh token,', () {
      late RefreshToken refreshToken;
      late String jwt;

      setUp(() {
        refreshToken = _createRefreshToken();
        jwt = jwtUtil.createJwt(refreshToken);
      });

      test('when the JWT is verified, then it returns successfully.', () {
        expect(jwtUtil.verifyJwt(jwt), isNotNull);
      });

      test(
        'when the JWT is inspected, then its `refreshTokenId` matches the refresh token.',
        () {
          final tokenData = jwtUtil.verifyJwt(jwt);
          expect(tokenData.refreshTokenId, refreshToken.id);
        },
      );

      test(
        'when the JWT is inspected, then its `authUserId` matches the refresh token.',
        () {
          final tokenData = jwtUtil.verifyJwt(jwt);
          expect(tokenData.authUserId, refreshToken.authUserId);
        },
      );

      test(
        'when the JWT is decoded, then it will contain the `authUserId` as `subject`.',
        () {
          expect(
            JWT.decode(jwt).subject,
            refreshToken.authUserId.toString(),
          );
        },
      );

      test(
        'when the JWT is decoded, then it contains an unique `jwtId` that is different from the refresh token ID.',
        () {
          expect(JWT.decode(jwt).jwtId, isNotNull);
          expect(JWT.decode(jwt).jwtId, isNot(refreshToken.id!.toString()));
        },
      );

      test(
        'when the JWT is decoded, then it contains the refresh token ID claim.',
        () {
          expect(
            (JWT.decode(jwt).payload as Map)['dev.serverpod.refreshTokenId'],
            refreshToken.id!.toString(),
          );
        },
      );

      test(
        'when the JWT is decoded, then it will contain no issuer per the default configuration.',
        () {
          expect(
            JWT.decode(jwt).issuer,
            isNull,
          );
        },
      );

      test(
        'when the JWT header is decoded, then it names the HS512 as its "alg".',
        () {
          expect(
            JWT.decode(jwt).header,
            equals({'alg': 'HS512', 'typ': 'JWT'}),
          );
        },
      );

      test(
        'when the JWT without scopes is decoded, then it does not even contain they associated key.',
        () {
          expect(
            (JWT.decode(jwt).payload as Map).containsKey(
              'dev.serverpod.scopeNames',
            ),
            isFalse,
          );
        },
      );

      test('when the JWT is inspected, then its `extraClaims` are empty.', () {
        final tokenData = jwtUtil.verifyJwt(jwt);

        expect(
          tokenData.extraClaims,
          isEmpty,
        );
      });

      group('an access token for a refresh token with scopes defined,', () {
        late RefreshToken refreshToken;
        late String jwt;

        setUp(() {
          refreshToken = _createRefreshToken().copyWith(
            scopeNames: {'a', 'b', 'c'},
          );
          jwt = jwtUtil.createJwt(refreshToken);
        });

        test(
          'when the JWT data is inspected, then its `scopes` match the refresh token.',
          () {
            final tokenData = jwtUtil.verifyJwt(jwt);
            expect(
              tokenData.scopes.map((final s) => s.name),
              containsAllInOrder({'a', 'b', 'c'}),
            );
          },
        );

        test(
          'when the JWT with scopes is decoded, then it contains the scopes as a List as the claim "dev.serverpod.scopeNames".',
          () {
            expect(
              (JWT.decode(jwt).payload as Map)['dev.serverpod.scopeNames'],
              ['a', 'b', 'c'],
            );
          },
        );

        test(
          'when the JWT data is inspected, then its `extraClaims` are empty.',
          () {
            final tokenData = jwtUtil.verifyJwt(jwt);

            expect(
              tokenData.extraClaims,
              isEmpty,
            );
          },
        );
      });

      group('an access token for a refresh token with extra claims defined,', () {
        late RefreshToken refreshToken;
        late String jwt;

        setUp(() {
          refreshToken = _createRefreshToken().copyWith(
            extraClaims: jsonEncode({'b': 1, 'a': 'test'}),
          );
          jwt = jwtUtil.createJwt(refreshToken);
        });

        test(
          'when the JWT data is inspected, then its `extraClaims` match the refresh token ones.',
          () {
            final tokenData = jwtUtil.verifyJwt(jwt);

            expect(
              tokenData.extraClaims,
              {'b': 1, 'a': 'test'},
            );
          },
        );
      });
    });
  });

  test(
    'Given a token issued with HMAC when validated by HMAC with different key then validation fails',
    () {
      final jwt = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('First Key'),
          ),
          refreshTokenHashPepper: 'test-pepper',
        ),
      ).jwtUtil.createJwt(_createRefreshToken());

      final differentKeyHS512Util = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('Second Key'),
          ),
          refreshTokenHashPepper: 'test-pepper',
        ),
      ).jwtUtil;

      expect(
        () => differentKeyHS512Util.verifyJwt(jwt),
        throwsA(isA<Exception>()),
      );
    },
  );

  test(
    'Given a token issued with issuer configured when decoding token then issuer is present',
    () {
      const issuer =
          'https://github.com/serverpod/serverpod/tree/main/modules/new_serverpod_auth/serverpod_auth_jwt_server';

      final jwt = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: _hs512Algorithm(),
          refreshTokenHashPepper: 'test-pepper',
          issuer: issuer,
        ),
      ).jwtUtil.createJwt(_createRefreshToken());

      expect(
        JWT.decode(jwt).issuer,
        issuer,
      );
    },
  );

  test(
    'Given a HS512 token when validated by a HS512 JWTUtil with a different issuer then validation fails',
    () {
      final initialHS512Util = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: _hs512Algorithm(),
          refreshTokenHashPepper: 'test-pepper',
          issuer: 'some issuer',
        ),
      ).jwtUtil;
      final jwt = initialHS512Util.createJwt(_createRefreshToken());

      final differentIssuerHS512Util = AuthenticationTokens(
        config: AuthenticationTokenConfig(
          algorithm: _hs512Algorithm(),
          refreshTokenHashPepper: 'test-pepper',
          issuer: 'different issuer',
        ),
      ).jwtUtil;

      expect(
        () => differentIssuerHS512Util.verifyJwt(jwt),
        throwsA(isA<Exception>()),
      );
    },
  );

  group(
    'Given a valid ES512 configuration and JWT from a plain refresh token,',
    () {
      late JwtUtil jwtUtil;
      late RefreshToken refreshToken;
      late String jwt;

      setUp(() {
        final authenticationTokens = AuthenticationTokens(
          config: AuthenticationTokenConfig(
            algorithm: _es512Algorithm(),
            refreshTokenHashPepper: 'test-pepper',
          ),
        );

        jwtUtil = authenticationTokens.jwtUtil;

        refreshToken = _createRefreshToken();
        jwt = jwtUtil.createJwt(refreshToken);
      });

      test(
        'when a JWT is verified, then its data is returned.',
        () {
          expect(
            jwtUtil.verifyJwt(jwt),
            isNotNull,
          );
        },
      );

      test(
        'when the JWT is decoded, then it names HS512 as its `alg.',
        () {
          expect(
            JWT.decode(jwt).header,
            equals({'alg': 'ES512', 'typ': 'JWT'}),
          );
        },
      );

      test('when validated by HMAC, then the validation fails.', () {
        final authenticationTokens = AuthenticationTokens(
          config: AuthenticationTokenConfig(
            algorithm: _hs512Algorithm(),
            refreshTokenHashPepper: 'test-pepper',
          ),
        );
        final hmacJwtUtil = authenticationTokens.jwtUtil;

        expectLater(
          () => hmacJwtUtil.verifyJwt(jwt),
          throwsA(isA<Error>()),
        );
      });

      test(
        'when the configuration is changed to HMAC with the previous public key as a fallback, then the validation succeeds.',
        () {
          final authenticationTokens = AuthenticationTokens(
            config: AuthenticationTokenConfig(
              algorithm: _hs512Algorithm(),
              refreshTokenHashPepper: 'test-pepper',
              fallbackVerificationAlgorithm: _es512Algorithm(),
            ),
          );
          final es512JwtUtil = authenticationTokens.jwtUtil;

          final result = es512JwtUtil.verifyJwt(jwt);
          expect(result.authUserId, refreshToken.authUserId);
        },
      );
    },
  );
}

/// Returns a basic refresh token, without scopes or extra claims
RefreshToken _createRefreshToken() {
  return RefreshToken(
    id: const Uuid().v4obj(),
    authUserId: const Uuid().v4obj(),
    scopeNames: {},
    fixedSecret: ByteData(0),
    rotatingSecretHash: ByteData(0),
    rotatingSecretSalt: ByteData(0),
    method: 'test',
  );
}

HmacSha512AuthenticationTokenAlgorithmConfiguration _hs512Algorithm() {
  return AuthenticationTokenAlgorithm.hmacSha512(
    SecretKey('test-private-key-for-HS512'),
  );
}

EcdsaSha512AuthenticationTokenAlgorithmConfiguration _es512Algorithm() {
  return AuthenticationTokenAlgorithm.ecdsaSha512(
    privateKey: ECPrivateKey(_testPrivateKey),
    publicKey: ECPublicKey(_testPublicKey),
  );
}

const _testPrivateKey = '''-----BEGIN EC PRIVATE KEY-----
MHQCAQEEINCRiJnNDnzfo2So2tWY4AIuzeC2ZBp/hmMDcZz3Fh45oAcGBSuBBAAK
oUQDQgAE0aELkvG/Xeo5y6o0WXRAjlediLptGz7Q8zjDmpGFXkKBYZ6IiL7JJ2Tk
cHzd83bmeUeGX33RGTYFPXs5t/VBnw==
-----END EC PRIVATE KEY-----''';

const _testPublicKey = '''-----BEGIN PUBLIC KEY-----
MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAE0aELkvG/Xeo5y6o0WXRAjlediLptGz7Q
8zjDmpGFXkKBYZ6IiL7JJ2TkcHzd83bmeUeGX33RGTYFPXs5t/VBnw==
-----END PUBLIC KEY-----''';
