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
  group('Given a valid HS512 configuration and a refresh token,', () {
    final testRefreshToken = RefreshToken(
      id: const Uuid().v4obj(),
      authUserId: const Uuid().v4obj(),
      scopeNames: {'a', 'b', 'c'},
      fixedSecret: ByteData(0),
      rotatingSecretHash: ByteData(0),
      rotatingSecretSalt: ByteData(0),
    );

    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride =
          'test-private-key-for-HS512';
      AuthenticationTokenSecrets.publicKeyTestOverride = '';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmHS512;
    });

    tearDownAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
      AuthenticationTokenSecrets.publicKeyTestOverride = null;
      AuthenticationTokenSecrets.algorithmTestOverride = null;
    });

    test('when a JWT is created, then it can be validated and read in again.',
        () {
      final token = JwtUtil.createJwt(testRefreshToken);

      final data = JwtUtil.verifyJwt(token);

      expect(data.refreshTokenId, testRefreshToken.id);
      expect(data.authUserId, testRefreshToken.authUserId);
      expect(
        data.scopes.map((final s) => s.name!),
        testRefreshToken.scopeNames,
      );
    });

    test(
        'when an issuer is configured and the JWT is inspected, then it will contain that issuer issuer.',
        () {
      AuthenticationTokens.config = AuthenticationTokenConfig(
        issuer:
            'https://github.com/serverpod/serverpod/tree/main/modules/new_serverpod_auth/serverpod_auth_jwt_server',
      );

      final token = JwtUtil.createJwt(testRefreshToken);

      expect(
        JWT.decode(token).issuer,
        isNotNull,
      );
    });

    test(
        'when the JWT is created without scopes, then it does not even contain they associated key.',
        () {
      final token = JwtUtil.createJwt(
        testRefreshToken.copyWith(scopeNames: {}),
      );

      expect(
        (JWT.decode(token).payload as Map)
            .containsKey('dev.serverpod.scopeNames'),
        isFalse,
      );
    });

    test(
        'when the JWT is created without scopes, then they come out as an empty set.',
        () {
      final token = JwtUtil.createJwt(
        testRefreshToken.copyWith(scopeNames: {}),
      );

      expect(
        JwtUtil.verifyJwt(token).scopes,
        isEmpty,
      );
    });

    test(
        'when the JWT is created with extra claims, then they come as they were set.',
        () {
      final token = JwtUtil.createJwt(
        testRefreshToken.copyWith(
          extraClaims: jsonEncode({'b': 1, 'a': 'test'}),
        ),
      );

      expect(
        JwtUtil.verifyJwt(token).extraClaims,
        equals({'b': 1, 'a': 'test'}),
      );
    });
  });

  group(
      'Given a valid HMAC configuration and JWT created from a `RefreshToken`,',
      () {
    final testRefreshToken = RefreshToken(
      id: const Uuid().v4obj(),
      authUserId: const Uuid().v4obj(),
      scopeNames: {'a', 'b', 'c'},
      fixedSecret: ByteData(0),
      rotatingSecretHash: ByteData(0),
      rotatingSecretSalt: ByteData(0),
    );

    late String token;

    setUp(() {
      AuthenticationTokens.config = AuthenticationTokenConfig();

      AuthenticationTokenSecrets.privateKeyTestOverride =
          'test-private-key-for-HS512';
      AuthenticationTokenSecrets.publicKeyTestOverride = '';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmHS512;

      token = JwtUtil.createJwt(testRefreshToken);
    });

    tearDown(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
      AuthenticationTokenSecrets.publicKeyTestOverride = null;
      AuthenticationTokenSecrets.algorithmTestOverride = null;
    });

    test(
        'when the JWT is inspected, then it will contain the `authUserId` as `subject`.',
        () {
      expect(
        JWT.decode(token).subject,
        testRefreshToken.authUserId.toString(),
      );
    });

    test(
        "when the JWT is inspected, then it will contain the `RefreshToken`'s ID as `jwtId`.",
        () {
      expect(
        JWT.decode(token).jwtId,
        testRefreshToken.id!.toString(),
      );
    });

    test(
        'when the JWT is inspected, then it will contain no issuer per the default configuration.',
        () {
      expect(
        JWT.decode(token).issuer,
        isNull,
      );
    });

    test(
        'when the JWT header is inspected, then it name the HS512 as its "alg".',
        () {
      expect(
        JWT.decode(token).header,
        equals({'alg': 'HS512', 'typ': 'JWT'}),
      );
    });

    test('when the extra claims are inspected, then they will be empty.', () {
      expect(
        JwtUtil.verifyJwt(token).extraClaims,
        isEmpty,
      );
    });

    test(
        'when the JWT is inspected, then it will contain the scopes as a list named "scopeNames" in the `payload`.',
        () {
      expect(
        (JWT.decode(token).payload as Map)['dev.serverpod.scopeNames'],
        ['a', 'b', 'c'],
      );
    });

    test('when the HMAC key is changed, then reading the token will fail.', () {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'new-secret-key';

      expect(
        () => JwtUtil.verifyJwt(token),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'when the issuer is changed, then validating the previous token will fail.',
        () {
      AuthenticationTokens.config = AuthenticationTokenConfig(
        issuer:
            'https://github.com/serverpod/serverpod/tree/main/modules/new_serverpod_auth/serverpod_auth_jwt_server',
      );

      expect(
        () => JwtUtil.verifyJwt(token),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Given a valid ES512 configuration and a refresh token,', () {
    final testRefreshToken = RefreshToken(
      id: const Uuid().v4obj(),
      authUserId: const Uuid().v4obj(),
      scopeNames: {'a', 'b', 'c'},
      fixedSecret: ByteData(0),
      rotatingSecretHash: ByteData(0),
      rotatingSecretSalt: ByteData(0),
    );

    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = _testPrivateKey;
      AuthenticationTokenSecrets.publicKeyTestOverride = _testPublicKey;
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmES512;
    });

    tearDownAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
      AuthenticationTokenSecrets.publicKeyTestOverride = null;
      AuthenticationTokenSecrets.algorithmTestOverride = null;
    });

    test(
      'when a JWT is created, then it can be validated and read in again.',
      () {
        final token = JwtUtil.createJwt(testRefreshToken);

        final data = JwtUtil.verifyJwt(token);

        expect(data.refreshTokenId, testRefreshToken.id);
        expect(data.authUserId, testRefreshToken.authUserId);
        expect(
          data.scopes.map((final s) => s.name!),
          testRefreshToken.scopeNames,
        );
      },
    );

    test(
      'when the JWT header is inspected, then it name the HS512 as its `alg.',
      () {
        final token = JwtUtil.createJwt(testRefreshToken);

        expect(
          JWT.decode(token).header,
          equals({'alg': 'ES512', 'typ': 'JWT'}),
        );
      },
    );
  });

  group(
      'Given a valid ES512 configuration and JWT created from a `RefreshToken`,',
      () {
    final testRefreshToken = RefreshToken(
      id: const Uuid().v4obj(),
      authUserId: const Uuid().v4obj(),
      scopeNames: {'a', 'b', 'c'},
      fixedSecret: ByteData(0),
      rotatingSecretHash: ByteData(0),
      rotatingSecretSalt: ByteData(0),
    );

    late String token;

    setUp(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = _testPrivateKey;
      AuthenticationTokenSecrets.publicKeyTestOverride = _testPublicKey;
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmES512;

      token = JwtUtil.createJwt(testRefreshToken);
    });

    tearDown(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
      AuthenticationTokenSecrets.publicKeyTestOverride = null;
      AuthenticationTokenSecrets.algorithmTestOverride = null;
    });

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
        () => JwtUtil.verifyJwt(token),
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

      final result = JwtUtil.verifyJwt(token);

      expect(result.authUserId, testRefreshToken.authUserId);
    });
  });
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
