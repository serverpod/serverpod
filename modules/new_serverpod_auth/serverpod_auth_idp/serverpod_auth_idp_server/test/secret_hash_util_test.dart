import 'dart:typed_data';

import 'package:serverpod_auth_idp_server/src/providers/email/business/email_idp_config.dart';
import 'package:serverpod_auth_idp_server/src/utils/secret_hash_util.dart';
import 'package:test/test.dart';

import 'email/test_utils/email_idp_test_fixture.dart';

void main() {
  group('Given EmailIDPPasswordHashUtil instance', () {
    late SecretHashUtil passwordHashUtil;
    const testSaltLength = 16;

    setUp(() {
      final fixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: 'test-pepper',
          secretHashSaltLength: testSaltLength,
        ),
      );
      passwordHashUtil = fixture.passwordHashUtil;
    });

    test(
      'when createHash is called without salt then generates hash with random salt',
      () async {
        const testValue = 'test-password-123';

        final result = await passwordHashUtil.createHash(value: testValue);

        expect(result.hash, isNotEmpty);
        expect(result.salt, hasLength(testSaltLength));
      },
    );

    test(
      'when createHash is called with provided salt then uses that salt',
      () async {
        const testValue = 'test-password-123';
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

        final result = await passwordHashUtil.createHash(
          value: testValue,
          salt: providedSalt,
        );

        expect(result.salt, equals(providedSalt));
        expect(result.hash, isNotEmpty);
      },
    );

    test(
      'when createHash is called twice with same value and different salts then produces different hashes',
      () async {
        const testValue = 'test-password-123';
        final salt1 = Uint8List.fromList([
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
        final salt2 = Uint8List.fromList([
          16,
          15,
          14,
          13,
          12,
          11,
          10,
          9,
          8,
          7,
          6,
          5,
          4,
          3,
          2,
          1,
        ]);

        final result1 = await passwordHashUtil.createHash(
          value: testValue,
          salt: salt1,
        );
        final result2 = await passwordHashUtil.createHash(
          value: testValue,
          salt: salt2,
        );

        expect(result1.hash, isNot(equals(result2.hash)));
      },
    );

    test(
      'when createHash is called twice with same value and same salt then produces identical hashes',
      () async {
        const testValue = 'test-password-123';
        final salt = Uint8List.fromList([
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

        final result1 = await passwordHashUtil.createHash(
          value: testValue,
          salt: salt,
        );
        final result2 = await passwordHashUtil.createHash(
          value: testValue,
          salt: salt,
        );

        expect(result1.hash, equals(result2.hash));
      },
    );

    test(
      'when createHash is called twice with same value without providing a salt then produces different hashes',
      () async {
        const testValue = 'test-password-123';

        final result1 = await passwordHashUtil.createHash(
          value: testValue,
        );
        final result2 = await passwordHashUtil.createHash(
          value: testValue,
        );

        expect(result1.hash, isNot(equals(result2.hash)));
      },
    );

    test(
      'when createHash is called with empty value then non empty hash and salt are generated',
      () async {
        final result = await passwordHashUtil.createHash(value: '');
        expect(result.hash, isNotEmpty);
        expect(result.salt, isNotEmpty);
      },
    );
  });

  group('Given a created password hash', () {
    late SecretHashUtil passwordHashUtil;
    late HashResult passwordHash;
    const value = 'test-password-123';
    const pepper = 'my-test-pepper';

    setUp(() async {
      final fixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: pepper),
      );
      passwordHashUtil = fixture.passwordHashUtil;
      passwordHash = await passwordHashUtil.createHash(value: value);
    });

    test(
      'when validateHash is called with correct value then returns true',
      () async {
        final isValid = await passwordHashUtil.validateHash(
          value: value,
          hash: passwordHash.hash,
          salt: passwordHash.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with incorrect value then returns false',
      () async {
        const incorrectValue = '$value-incorrect';

        final isValid = await passwordHashUtil.validateHash(
          value: incorrectValue,
          hash: passwordHash.hash,
          salt: passwordHash.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when validateHash is called with empty hash then returns false',
      () async {
        final emptyHash = Uint8List.fromList([]);

        final isValid = await passwordHashUtil.validateHash(
          value: value,
          hash: emptyHash,
          salt: passwordHash.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when validateHash is called with wrong salt then returns false',
      () async {
        final wrongSalt = Uint8List.fromList([
          ...passwordHash.salt.sublist(1),
          passwordHash.salt.first + 1,
        ]);

        final isValid = await passwordHashUtil.validateHash(
          value: value,
          hash: passwordHash.hash,
          salt: wrongSalt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when validatedHash is called with valid credentials on a different password hash util using a different pepper then returns false',
      () async {
        final fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: '$pepper-modified'),
        );
        final differentPepperPasswordHashUtil = fixture.passwordHashUtil;

        final isValid = await differentPepperPasswordHashUtil.validateHash(
          value: value,
          hash: passwordHash.hash,
          salt: passwordHash.salt,
        );

        expect(isValid, isFalse);
      },
    );
  });

  group('Given a password hash created from an empty password', () {
    late SecretHashUtil passwordHashUtil;
    late HashResult emptyPasswordHash;
    setUp(() async {
      final fixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: 'test-pepper'),
      );
      passwordHashUtil = fixture.passwordHashUtil;
      emptyPasswordHash = await passwordHashUtil.createHash(value: '');
    });

    test(
      'when validateHash is called with empty password then returns true',
      () async {
        final isValid = await passwordHashUtil.validateHash(
          value: '',
          hash: emptyPasswordHash.hash,
          salt: emptyPasswordHash.salt,
        );

        expect(isValid, isTrue);
      },
    );
  });

  group('Given a password hash created with fallback pepper', () {
    late SecretHashUtil oldPepperHashUtil;
    late SecretHashUtil newPepperHashUtilWithFallback;
    late HashResult oldPasswordHash;
    const value = 'test-password-123';
    const oldPepper = 'old-pepper-value';
    const newPepper = 'new-pepper-value';

    setUp(() async {
      // Create hash with old pepper
      final oldFixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(secretHashPepper: oldPepper),
      );
      oldPepperHashUtil = oldFixture.passwordHashUtil;
      oldPasswordHash = await oldPepperHashUtil.createHash(value: value);

      // Create new util with new pepper and old pepper as fallback
      final newFixture = EmailIDPTestFixture(
        config: const EmailIDPConfig(
          secretHashPepper: newPepper,
          fallbackSecretHashPeppers: [oldPepper],
        ),
      );
      newPepperHashUtilWithFallback = newFixture.passwordHashUtil;
    });

    test(
      'when validateHash is called with hash created by old pepper then returns true',
      () async {
        final isValid = await newPepperHashUtilWithFallback.validateHash(
          value: value,
          hash: oldPasswordHash.hash,
          salt: oldPasswordHash.salt,
        );

        expect(isValid, isTrue);
      },
    );

    test(
      'when validateHash is called with incorrect value then returns false',
      () async {
        const incorrectValue = '$value-incorrect';

        final isValid = await newPepperHashUtilWithFallback.validateHash(
          value: incorrectValue,
          hash: oldPasswordHash.hash,
          salt: oldPasswordHash.salt,
        );

        expect(isValid, isFalse);
      },
    );

    test(
      'when createHash is called then new hash uses primary pepper',
      () async {
        final newHash = await newPepperHashUtilWithFallback.createHash(
          value: value,
        );

        // New hash should validate with new pepper only
        final newPepperOnlyUtil = SecretHashUtil(
          hashPepper: newPepper,
          hashSaltLength: 16,
        );

        final isValidWithNewPepper = await newPepperOnlyUtil.validateHash(
          value: value,
          hash: newHash.hash,
          salt: newHash.salt,
        );

        expect(isValidWithNewPepper, isTrue);

        // And should NOT validate with old pepper only
        final oldPepperOnlyUtil = SecretHashUtil(
          hashPepper: oldPepper,
          hashSaltLength: 16,
        );

        final isValidWithOldPepper = await oldPepperOnlyUtil.validateHash(
          value: value,
          hash: newHash.hash,
          salt: newHash.salt,
        );

        expect(isValidWithOldPepper, isFalse);
      },
    );

    test(
      'when multiple fallback peppers are provided then validates against any of them',
      () async {
        const veryOldPepper = 'very-old-pepper-value';

        // Create hash with very old pepper
        final veryOldFixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(secretHashPepper: veryOldPepper),
        );
        final veryOldPepperHashUtil = veryOldFixture.passwordHashUtil;
        final veryOldPasswordHash = await veryOldPepperHashUtil.createHash(
          value: value,
        );

        // Create util with multiple fallback peppers
        final multiPepperFixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: newPepper,
            fallbackSecretHashPeppers: [oldPepper, veryOldPepper],
          ),
        );
        final multiPepperHashUtil = multiPepperFixture.passwordHashUtil;

        // Should validate both old and very old hashes
        final isValidOld = await multiPepperHashUtil.validateHash(
          value: value,
          hash: oldPasswordHash.hash,
          salt: oldPasswordHash.salt,
        );
        final isValidVeryOld = await multiPepperHashUtil.validateHash(
          value: value,
          hash: veryOldPasswordHash.hash,
          salt: veryOldPasswordHash.salt,
        );

        expect(isValidOld, isTrue);
        expect(isValidVeryOld, isTrue);
      },
    );
  });

  group('Given PasswordHash factory', () {
    test(
      'when PasswordHash.empty() is called then creates empty hash and salt',
      () {
        final emptyPasswordHash = HashResult.empty();

        expect(emptyPasswordHash.hash, isEmpty);
        expect(emptyPasswordHash.salt, isEmpty);
        expect(emptyPasswordHash.hash, isA<Uint8List>());
        expect(emptyPasswordHash.salt, isA<Uint8List>());
      },
    );
  });
}
