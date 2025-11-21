import 'dart:typed_data';

import 'package:serverpod_auth_core_server/src/jwt/business/refresh_token_secret_hash.dart';
import 'package:test/test.dart';

void main() {
  group('Given RefreshTokenSecretHash instance', () {
    late RefreshTokenSecretHash refreshTokenSecretHash;
    const testSaltLength = 16;
    const pepper = 'test-refresh-token-pepper';

    setUp(() {
      refreshTokenSecretHash = RefreshTokenSecretHash(
        refreshTokenRotatingSecretSaltLength: testSaltLength,
        refreshTokenHashPepper: pepper,
        fallbackRefreshTokenHashPeppers: [],
      );
    });

    test(
      'when createHash is called then generates hash with salt',
      () async {
        final testSecret = Uint8List.fromList([1, 2, 3, 4, 5]);

        final result = await refreshTokenSecretHash.createHash(
          secret: testSecret,
        );

        expect(result.hash, isNotEmpty);
        expect(result.salt, hasLength(testSaltLength));
      },
    );

    test(
      'when createHash is called with provided salt then uses that salt',
      () async {
        final testSecret = Uint8List.fromList([1, 2, 3, 4, 5]);
        final providedSalt = Uint8List.fromList([
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
        ]);

        final result = await refreshTokenSecretHash.createHash(
          secret: testSecret,
          salt: providedSalt,
        );

        expect(result.salt, equals(providedSalt));
        expect(result.hash, isNotEmpty);
      },
    );

    test(
      'when validateHash is called with correct secret then returns true',
      () async {
        final testSecret = Uint8List.fromList([1, 2, 3, 4, 5]);
        final hashResult = await refreshTokenSecretHash.createHash(
          secret: testSecret,
        );

        final isValid = await refreshTokenSecretHash.validateHash(
          secret: testSecret,
          hash: hashResult.hash,
          salt: hashResult.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with incorrect secret then returns false',
      () async {
        final testSecret = Uint8List.fromList([1, 2, 3, 4, 5]);
        final incorrectSecret = Uint8List.fromList([5, 4, 3, 2, 1]);
        final hashResult = await refreshTokenSecretHash.createHash(
          secret: testSecret,
        );

        final isValid = await refreshTokenSecretHash.validateHash(
          secret: incorrectSecret,
          hash: hashResult.hash,
          salt: hashResult.salt,
        );

        expect(isValid, isFalse);
      },
    );
  });

  group('Given RefreshTokenSecretHash with fallback peppers', () {
    late RefreshTokenSecretHash oldPepperHashUtil;
    late RefreshTokenSecretHash newPepperHashUtilWithFallback;
    late ({Uint8List hash, Uint8List salt}) oldHashResult;
    final testSecret = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
    const oldPepper = 'old-refresh-token-pepper';
    const newPepper = 'new-refresh-token-pepper';

    setUp(() async {
      // Create hash with old pepper
      oldPepperHashUtil = RefreshTokenSecretHash(
        refreshTokenRotatingSecretSaltLength: 16,
        refreshTokenHashPepper: oldPepper,
        fallbackRefreshTokenHashPeppers: [],
      );
      oldHashResult = await oldPepperHashUtil.createHash(secret: testSecret);

      // Create new util with new pepper and old pepper as fallback
      newPepperHashUtilWithFallback = RefreshTokenSecretHash(
        refreshTokenRotatingSecretSaltLength: 16,
        refreshTokenHashPepper: newPepper,
        fallbackRefreshTokenHashPeppers: [oldPepper],
      );
    });

    test(
      'when validateHash is called with hash created by old pepper then returns true',
      () async {
        final isValid = await newPepperHashUtilWithFallback.validateHash(
          secret: testSecret,
          hash: oldHashResult.hash,
          salt: oldHashResult.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with incorrect secret then returns false',
      () async {
        final incorrectSecret = Uint8List.fromList([8, 7, 6, 5, 4, 3, 2, 1]);

        final isValid = await newPepperHashUtilWithFallback.validateHash(
          secret: incorrectSecret,
          hash: oldHashResult.hash,
          salt: oldHashResult.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when createHash is called then new hash uses primary pepper',
      () async {
        final newHashResult = await newPepperHashUtilWithFallback.createHash(
          secret: testSecret,
        );

        // New hash should validate with new pepper only
        final newPepperOnlyUtil = RefreshTokenSecretHash(
          refreshTokenRotatingSecretSaltLength: 16,
          refreshTokenHashPepper: newPepper,
          fallbackRefreshTokenHashPeppers: [],
        );

        final isValidWithNewPepper = await newPepperOnlyUtil.validateHash(
          secret: testSecret,
          hash: newHashResult.hash,
          salt: newHashResult.salt,
        );

        expect(isValidWithNewPepper, isTrue);

        // And should NOT validate with old pepper only
        final oldPepperOnlyUtil = RefreshTokenSecretHash(
          refreshTokenRotatingSecretSaltLength: 16,
          refreshTokenHashPepper: oldPepper,
          fallbackRefreshTokenHashPeppers: [],
        );

        final isValidWithOldPepper = await oldPepperOnlyUtil.validateHash(
          secret: testSecret,
          hash: newHashResult.hash,
          salt: newHashResult.salt,
        );

        expect(isValidWithOldPepper, isFalse);
      },
    );

    test(
      'when multiple fallback peppers are provided then validates against any of them',
      () async {
        const veryOldPepper = 'very-old-refresh-token-pepper';

        // Create hash with very old pepper
        final veryOldPepperHashUtil = RefreshTokenSecretHash(
          refreshTokenRotatingSecretSaltLength: 16,
          refreshTokenHashPepper: veryOldPepper,
          fallbackRefreshTokenHashPeppers: [],
        );
        final veryOldHashResult = await veryOldPepperHashUtil.createHash(
          secret: testSecret,
        );

        // Create util with multiple fallback peppers
        final multiPepperHashUtil = RefreshTokenSecretHash(
          refreshTokenRotatingSecretSaltLength: 16,
          refreshTokenHashPepper: newPepper,
          fallbackRefreshTokenHashPeppers: [oldPepper, veryOldPepper],
        );

        // Should validate both old and very old hashes
        final isValidOld = await multiPepperHashUtil.validateHash(
          secret: testSecret,
          hash: oldHashResult.hash,
          salt: oldHashResult.salt,
        );
        final isValidVeryOld = await multiPepperHashUtil.validateHash(
          secret: testSecret,
          hash: veryOldHashResult.hash,
          salt: veryOldHashResult.salt,
        );

        expect(isValidOld, isTrue);
        expect(isValidVeryOld, isTrue);
      },
    );
  });
}
