import 'package:serverpod_auth_idp_server/src/providers/email/business/email_idp_config.dart';
import 'package:serverpod_auth_idp_server/src/utils/secret_hash_util.dart';
import 'package:test/test.dart';

import 'email/test_utils/email_idp_test_fixture.dart';

void main() {
  group('Given SecretHashUtil with fallback pepper configured', () {
    late SecretHashUtil primaryUtil;
    late SecretHashUtil fallbackUtil;
    late SecretHashUtil utilWithFallback;
    late HashResult hashWithOldPepper;
    const testValue = 'test-password-123';
    const primaryPepper = 'new-pepper';
    const fallbackPepper = 'old-pepper';

    setUp(() async {
      // Create util with old (fallback) pepper
      final oldFixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: fallbackPepper),
      );
      fallbackUtil = oldFixture.passwordHashUtil;

      // Create hash with old pepper
      hashWithOldPepper = await fallbackUtil.createHash(value: testValue);

      // Create util with new primary pepper only
      final newFixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: primaryPepper),
      );
      primaryUtil = newFixture.passwordHashUtil;

      // Create util with new primary pepper and old fallback pepper
      final fallbackFixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: primaryPepper,
          fallbackSecretHashPepper: fallbackPepper,
        ),
      );
      utilWithFallback = fallbackFixture.passwordHashUtil;
    });

    test(
      'when validateHash is called with hash created by old pepper then returns true',
      () async {
        final isValid = await utilWithFallback.validateHash(
          value: testValue,
          hash: hashWithOldPepper.hash,
          salt: hashWithOldPepper.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with hash created by old pepper on util without fallback then returns false',
      () async {
        final isValid = await primaryUtil.validateHash(
          value: testValue,
          hash: hashWithOldPepper.hash,
          salt: hashWithOldPepper.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when validateHash is called with incorrect value on hash created by old pepper then returns false',
      () async {
        final isValid = await utilWithFallback.validateHash(
          value: 'wrong-password',
          hash: hashWithOldPepper.hash,
          salt: hashWithOldPepper.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when validateHash is called with hash created by new primary pepper then returns true',
      () async {
        final newHash = await utilWithFallback.createHash(value: testValue);

        final isValid = await utilWithFallback.validateHash(
          value: testValue,
          hash: newHash.hash,
          salt: newHash.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with onFallbackValidated callback and fallback validates then callback is invoked',
      () async {
        HashResult? rehashedValue;

        final isValid = await utilWithFallback.validateHash(
          value: testValue,
          hash: hashWithOldPepper.hash,
          salt: hashWithOldPepper.salt,
          onFallbackValidated: (final newHash) async {
            rehashedValue = newHash;
          },
        );

        expect(isValid, isTrue);
        expect(rehashedValue, isNotNull);
        expect(rehashedValue!.hash, isNotEmpty);
        expect(rehashedValue!.salt, isNotEmpty);
        // The new hash should be different from the old hash
        expect(rehashedValue!.hash, isNot(equals(hashWithOldPepper.hash)));
      },
    );

    test(
      'when validateHash is called with onFallbackValidated callback and primary validates then callback is not invoked',
      () async {
        final newHash = await utilWithFallback.createHash(value: testValue);
        var callbackInvoked = false;

        final isValid = await utilWithFallback.validateHash(
          value: testValue,
          hash: newHash.hash,
          salt: newHash.salt,
          onFallbackValidated: (final rehashedValue) async {
            callbackInvoked = true;
          },
        );

        expect(isValid, isTrue);
        expect(callbackInvoked, isFalse);
      },
    );

    test(
      'when validateHash is called with rehashed password then validates with primary pepper',
      () async {
        HashResult? rehashedValue;

        // First validation uses fallback and rehashes
        await utilWithFallback.validateHash(
          value: testValue,
          hash: hashWithOldPepper.hash,
          salt: hashWithOldPepper.salt,
          onFallbackValidated: (final newHash) async {
            rehashedValue = newHash;
          },
        );

        expect(rehashedValue, isNotNull);

        // Second validation should work with primary pepper only
        final isValidWithPrimary = await primaryUtil.validateHash(
          value: testValue,
          hash: rehashedValue!.hash,
          salt: rehashedValue!.salt,
        );

        expect(isValidWithPrimary, isTrue);
      },
    );
  });

  group('Given SecretHashUtil without fallback pepper configured', () {
    late SecretHashUtil util;
    late HashResult hash;
    const testValue = 'test-password-123';

    setUp(() async {
      final fixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: 'test-pepper'),
      );
      util = fixture.passwordHashUtil;
      hash = await util.createHash(value: testValue);
    });

    test(
      'when validateHash is called with onFallbackValidated callback then callback is not invoked',
      () async {
        var callbackInvoked = false;

        final isValid = await util.validateHash(
          value: testValue,
          hash: hash.hash,
          salt: hash.salt,
          onFallbackValidated: (final newHash) async {
            callbackInvoked = true;
          },
        );

        expect(isValid, isTrue);
        expect(callbackInvoked, isFalse);
      },
    );
  });

  group('Given SecretHashUtil with empty password hash', () {
    late SecretHashUtil utilWithFallback;
    final emptyHash = HashResult.empty();
    const testValue = 'test-password-123';

    setUp(() {
      final fixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: 'new-pepper',
          fallbackSecretHashPepper: 'old-pepper',
        ),
      );
      utilWithFallback = fixture.passwordHashUtil;
    });

    test(
      'when validateHash is called with empty hash then returns false without trying fallback',
      () async {
        var callbackInvoked = false;

        final isValid = await utilWithFallback.validateHash(
          value: testValue,
          hash: emptyHash.hash,
          salt: emptyHash.salt,
          onFallbackValidated: (final newHash) async {
            callbackInvoked = true;
          },
        );

        expect(isValid, isFalse);
        expect(callbackInvoked, isFalse);
      },
    );
  });

  group('Given multiple different peppers', () {
    late SecretHashUtil util1;
    late SecretHashUtil util2WithFallback1;
    late SecretHashUtil util3WithFallback2;
    late HashResult hashWithPepper1;
    late HashResult hashWithPepper2;
    const testValue = 'test-password-123';
    const pepper1 = 'pepper-generation-1';
    const pepper2 = 'pepper-generation-2';
    const pepper3 = 'pepper-generation-3';

    setUp(() async {
      // Create hash with pepper 1
      final fixture1 = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: pepper1),
      );
      util1 = fixture1.passwordHashUtil;
      hashWithPepper1 = await util1.createHash(value: testValue);

      // Create util with pepper 2 and fallback to pepper 1
      final fixture2 = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: pepper2,
          fallbackSecretHashPepper: pepper1,
        ),
      );
      util2WithFallback1 = fixture2.passwordHashUtil;

      // Create hash with pepper 2
      hashWithPepper2 = await util2WithFallback1.createHash(value: testValue);

      // Create util with pepper 3 and fallback to pepper 2
      final fixture3 = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: pepper3,
          fallbackSecretHashPepper: pepper2,
        ),
      );
      util3WithFallback2 = fixture3.passwordHashUtil;
    });

    test(
      'when validating hash from pepper 1 with util using pepper 2 and fallback 1 then returns true',
      () async {
        final isValid = await util2WithFallback1.validateHash(
          value: testValue,
          hash: hashWithPepper1.hash,
          salt: hashWithPepper1.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validating hash from pepper 2 with util using pepper 3 and fallback 2 then returns true',
      () async {
        final isValid = await util3WithFallback2.validateHash(
          value: testValue,
          hash: hashWithPepper2.hash,
          salt: hashWithPepper2.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validating hash from pepper 1 with util using pepper 3 and fallback 2 then returns false',
      () async {
        final isValid = await util3WithFallback2.validateHash(
          value: testValue,
          hash: hashWithPepper1.hash,
          salt: hashWithPepper1.salt,
        );

        expect(isValid, isFalse);
      },
    );
  });
}
