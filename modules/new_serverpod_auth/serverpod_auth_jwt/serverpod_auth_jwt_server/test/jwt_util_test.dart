import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/business/jwt_util.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';
import 'package:test/test.dart';

import 'utils/authentication_token_secrets_mock.dart';

void main() {
  group('Given a valid HS512 configuration and', () {
    late AuthenticationTokenSecretsMock secrets;
    late JwtUtil jwtUtil;

    setUp(() {
      secrets = AuthenticationTokenSecretsMock()..setHs512Algorithm();
      jwtUtil = JwtUtil(secrets: secrets);
    });

    group('a plain refresh token,', () {
      late RefreshToken refreshToken;
      setUp(() {
        refreshToken = _createRefreshToken();
      });

      test('when a JWT is requested for the refresh token, then it succeeds.',
          () {
        expect(
          jwtUtil.createJwt(refreshToken),
          isNotEmpty,
        );
      });
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
      });
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
      });
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
      });

      test(
          'when the JWT is inspected, then its `authUserId` matches the refresh token.',
          () {
        final tokenData = jwtUtil.verifyJwt(jwt);
        expect(tokenData.authUserId, refreshToken.authUserId);
      });

      test(
          'when the JWT is decoded, then it will contain the `authUserId` as `subject`.',
          () {
        expect(
          JWT.decode(jwt).subject,
          refreshToken.authUserId.toString(),
        );
      });

      test(
          "when the JWT is decoded, then it will contain the `RefreshToken`'s ID as `jwtId`.",
          () {
        expect(
          JWT.decode(jwt).jwtId,
          refreshToken.id!.toString(),
        );
      });

      test(
          'when the JWT is decoded, then it will contain no issuer per the default configuration.',
          () {
        expect(
          JWT.decode(jwt).issuer,
          isNull,
        );
      });

      test(
          'when the JWT header is decoded, then it names the HS512 as its "alg".',
          () {
        expect(
          JWT.decode(jwt).header,
          equals({'alg': 'HS512', 'typ': 'JWT'}),
        );
      });

      test(
          'when the JWT without scopes is decoded, then it does not even contain they associated key.',
          () {
        expect(
          (JWT.decode(jwt).payload as Map)
              .containsKey('dev.serverpod.scopeNames'),
          isFalse,
        );
      });

      test('when the JWT is inspected, then its `extraClaims` are empty.', () {
        final tokenData = jwtUtil.verifyJwt(jwt);

        expect(
          tokenData.extraClaims,
          isEmpty,
        );
      });

      group('when the HMAC key is changed,', () {
        setUp(() {
          secrets.algorithm =
              HmacSha512AuthenticationTokenAlgorithmConfiguration(
            key: SecretKey('another key'),
          );
        });

        test('then reading the previously created token will fail.', () {
          expect(
            () => jwtUtil.verifyJwt(jwt),
            throwsA(isA<Exception>()),
          );
        });
      });

      group('when an issuer is set,', () {
        setUp(() {
          AuthenticationTokens.config = AuthenticationTokenConfig(
            issuer: 'some issuer',
          );
        });

        tearDown(() {
          AuthenticationTokens.config = AuthenticationTokenConfig();
        });

        test('then validating the previous token will fail.', () {
          expect(
            () => jwtUtil.verifyJwt(jwt),
            throwsA(isA<Exception>()),
          );
        });
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
        });

        test(
            'when the JWT with scopes is decoded, then it contains the scopes as a List as the claim "dev.serverpod.scopeNames".',
            () {
          expect(
            (JWT.decode(jwt).payload as Map)['dev.serverpod.scopeNames'],
            ['a', 'b', 'c'],
          );
        });

        test(
            'when the JWT data is inspected, then its `extraClaims` are empty.',
            () {
          final tokenData = jwtUtil.verifyJwt(jwt);

          expect(
            tokenData.extraClaims,
            isEmpty,
          );
        });
      });

      group('an access token for a refresh token with extra claims defined,',
          () {
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
        });
      });
    });

    group('a JWT token created while an issuer was configured,', () {
      const issuer =
          'https://github.com/serverpod/serverpod/tree/main/modules/new_serverpod_auth/serverpod_auth_jwt_server';

      late RefreshToken refreshToken;
      late String jwt;

      setUp(() {
        AuthenticationTokens.config = AuthenticationTokenConfig(
          issuer: issuer,
        );

        refreshToken = _createRefreshToken();
        jwt = jwtUtil.createJwt(refreshToken);
      });

      tearDown(() {
        AuthenticationTokens.config = AuthenticationTokenConfig();
      });

      test('when the JWT is decoded, then the issuer is present.', () {
        expect(
          JWT.decode(jwt).issuer,
          issuer,
        );
      });
    });
  });

  group('Given a valid ES512 configuration and JWT from a plain refresh token,',
      () {
    late AuthenticationTokenSecretsMock secrets;
    late JwtUtil jwtUtil;
    late RefreshToken refreshToken;
    late String jwt;

    setUp(() {
      secrets = AuthenticationTokenSecretsMock()..setEs512Algorithm();
      jwtUtil = JwtUtil(secrets: secrets);

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

    test(
        'when the configuration is changed to HMAC, then the validation fails.',
        () {
      secrets.setHs512Algorithm();

      expectLater(
        () => jwtUtil.verifyJwt(jwt),
        throwsA(isA<Error>()),
      );
    });

    test(
        'when the configuration is changed to HMAC with the previous public key as a fallback, then the validation succeeds.',
        () {
      final currentEs512 = secrets.algorithm
          as EcdsaSha512AuthenticationTokenAlgorithmConfiguration;
      secrets.setHs512Algorithm();
      secrets.fallbackVerificationAlgorithm =
          EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration(
        publicKey: currentEs512.publicKey,
      );

      final result = jwtUtil.verifyJwt(jwt);

      expect(result.authUserId, refreshToken.authUserId);
    });
  });
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
  );
}
