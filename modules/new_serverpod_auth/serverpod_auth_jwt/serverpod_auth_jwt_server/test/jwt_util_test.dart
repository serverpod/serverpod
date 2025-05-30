import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/business/jwt_util.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';
import 'package:test/test.dart';

void main() {
  group('Given a valid HS512 configuration and', () {
    setUp(() {
      _AuthenticationTokenSecretsUtil.configureHs512Signing();
    });

    tearDown(() {
      _AuthenticationTokenSecretsUtil.clearSigning();
    });

    group('a plain refresh token,', () {
      late RefreshToken refreshToken;
      setUp(() {
        refreshToken = _createRefreshToken();
      });

      test('when a JWT is requested for the refresh token, then it succeeds.',
          () {
        expect(
          JwtUtil.createJwt(refreshToken),
          isNotEmpty,
        );
      });
    });

    group('a JWT tokend for a plain refresh token,', () {
      late RefreshToken refreshToken;
      late String jwt;

      setUp(() {
        refreshToken = _createRefreshToken();
        jwt = JwtUtil.createJwt(refreshToken);
      });

      test('when the JWT is verified, then it returns successfully.', () {
        expect(JwtUtil.verifyJwt(jwt), isNotNull);
      });

      test(
          'when the JWT is inspected, then its `refreshTokenId` matches the refresh token.',
          () {
        final tokenData = JwtUtil.verifyJwt(jwt);
        expect(tokenData.refreshTokenId, refreshToken.id);
      });

      test(
          'when the JWT is inspected, then its `authUserId` matches the refresh token.',
          () {
        final tokenData = JwtUtil.verifyJwt(jwt);
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
        final tokenData = JwtUtil.verifyJwt(jwt);

        expect(
          tokenData.extraClaims,
          isEmpty,
        );
      });

      group('when the HMAC key is changed,', () {
        setUp(() {
          AuthenticationTokenSecrets.privateKeyTestOverride = 'another key';

          // Only needed to not request the configuration from Serverpod, which does not work outside of `withServerpod` in tests
          AuthenticationTokenSecrets.fallbackAlgorithmTestOverride =
              AuthenticationTokenSecrets.algorithmHS512;
          AuthenticationTokenSecrets.fallbackKeyTestOverride =
              'no fallback either';
        });

        tearDown(() {
          _AuthenticationTokenSecretsUtil.configureHs512Signing();
        });

        test('then reading the previously created token will fail.', () {
          expect(
            () => JwtUtil.verifyJwt(jwt),
            throwsA(isA<Exception>()),
          );
        });
      });

      group('when an issuer is set,', () {
        setUp(() {
          AuthenticationTokens.config = AuthenticationTokenConfig(
            issuer: 'some issuer',
          );

          // Only needed to not request the configuration from Serverpod, which does not work outside of `withServerpod` in tests
          AuthenticationTokenSecrets.fallbackAlgorithmTestOverride =
              AuthenticationTokenSecrets.algorithmHS512;
          AuthenticationTokenSecrets.fallbackKeyTestOverride = 'test';
        });

        tearDown(() {
          AuthenticationTokens.config = AuthenticationTokenConfig();
          _AuthenticationTokenSecretsUtil.configureHs512Signing();
        });

        test('then validating the previous token will fail.', () {
          expect(
            () => JwtUtil.verifyJwt(jwt),
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
          jwt = JwtUtil.createJwt(refreshToken);
        });

        test(
            'when the JWT data is inspected, then its `scopes` match the refresh token.',
            () {
          final tokenData = JwtUtil.verifyJwt(jwt);
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
          final tokenData = JwtUtil.verifyJwt(jwt);

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
          jwt = JwtUtil.createJwt(refreshToken);
        });

        test(
            'when the JWT data is inspected, then its `extraClaims` match the refresh token ones.',
            () {
          final tokenData = JwtUtil.verifyJwt(jwt);

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
        jwt = JwtUtil.createJwt(refreshToken);
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
    late RefreshToken refreshToken;
    late String jwt;

    setUp(() {
      _AuthenticationTokenSecretsUtil.configureEs512Signing();
      refreshToken = _createRefreshToken();
      jwt = JwtUtil.createJwt(refreshToken);
    });

    tearDown(() {
      _AuthenticationTokenSecretsUtil.clearSigning();
    });

    test(
      'when a JWT is verified, then its data is returned.',
      () {
        expect(
          JwtUtil.verifyJwt(jwt),
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
      AuthenticationTokenSecrets.privateKeyTestOverride = 'new hmac key';
      AuthenticationTokenSecrets.publicKeyTestOverride = '';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmHS512;

      AuthenticationTokenSecrets.fallbackKeyTestOverride = '';
      AuthenticationTokenSecrets.fallbackAlgorithmTestOverride = '';

      expectLater(
        () => JwtUtil.verifyJwt(jwt),
        throwsA(isA<Error>()),
      );
    });

    test(
        'when the configuration is changed to HMAC with the previous public key as a fallback, then the validation succeeds.',
        () {
      AuthenticationTokenSecrets.fallbackKeyTestOverride =
          AuthenticationTokenSecrets.publicKeyTestOverride;
      AuthenticationTokenSecrets.fallbackAlgorithmTestOverride =
          AuthenticationTokenSecrets.algorithmTestOverride;

      AuthenticationTokenSecrets.privateKeyTestOverride = 'new hmac key';
      AuthenticationTokenSecrets.publicKeyTestOverride = '';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmHS512;

      final result = JwtUtil.verifyJwt(jwt);

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

extension _AuthenticationTokenSecretsUtil on AuthenticationTokenSecrets {
  static void configureHs512Signing() {
    AuthenticationTokenSecrets.privateKeyTestOverride =
        'test-private-key-for-HS512';
    AuthenticationTokenSecrets.publicKeyTestOverride = '';
    AuthenticationTokenSecrets.algorithmTestOverride =
        AuthenticationTokenSecrets.algorithmHS512;
  }

  static void configureEs512Signing() {
    AuthenticationTokenSecrets.privateKeyTestOverride = _testPrivateKey;
    AuthenticationTokenSecrets.publicKeyTestOverride = _testPublicKey;
    AuthenticationTokenSecrets.algorithmTestOverride =
        AuthenticationTokenSecrets.algorithmES512;
  }

  static void clearSigning() {
    AuthenticationTokenSecrets.privateKeyTestOverride = null;
    AuthenticationTokenSecrets.publicKeyTestOverride = null;
    AuthenticationTokenSecrets.algorithmTestOverride = null;

    AuthenticationTokenSecrets.fallbackAlgorithmTestOverride = null;
    AuthenticationTokenSecrets.fallbackKeyTestOverride = null;
  }
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
