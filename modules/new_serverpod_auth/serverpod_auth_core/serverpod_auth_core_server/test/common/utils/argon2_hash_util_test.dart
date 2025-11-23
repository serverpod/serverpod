import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_auth_core_server/src/common/utils/argon2_hash_util.dart';
import 'package:test/test.dart';

void main() {
  group('Given Argon2HashUtil instance', () {
    late Argon2HashUtil hashUtil;
    const testSaltLength = 16;
    const testPepper = 'test-pepper';

    setUp(() {
      hashUtil = Argon2HashUtil(
        hashPepper: testPepper,
        hashSaltLength: testSaltLength,
      );
    });

    group('when createHashFromString is called', () {
      test('then generates hash with random salt when salt not provided.', () async {
        const testSecret = 'test-secret-123';

        final result = await hashUtil.createHashFromString(secret: testSecret);

        expect(result.hash, isNotEmpty);
        expect(result.salt, hasLength(testSaltLength));
      });

      test('then uses provided salt when salt is provided.', () async {
        const testSecret = 'test-secret-123';
        final providedSalt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final result = await hashUtil.createHashFromString(
          secret: testSecret,
          salt: providedSalt,
        );

        expect(result.salt, equals(providedSalt));
        expect(result.hash, isNotEmpty);
      });

      test('then produces different hashes with different salts.', () async {
        const testSecret = 'test-secret-123';
        final salt1 = Uint8List.fromList(List.generate(16, (i) => i + 1));
        final salt2 = Uint8List.fromList(List.generate(16, (i) => 16 - i));

        final result1 = await hashUtil.createHashFromString(
          secret: testSecret,
          salt: salt1,
        );
        final result2 = await hashUtil.createHashFromString(
          secret: testSecret,
          salt: salt2,
        );

        expect(result1.hash, isNot(equals(result2.hash)));
      });

      test('then produces identical hashes with same secret and salt.', () async {
        const testSecret = 'test-secret-123';
        final salt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final result1 = await hashUtil.createHashFromString(
          secret: testSecret,
          salt: salt,
        );
        final result2 = await hashUtil.createHashFromString(
          secret: testSecret,
          salt: salt,
        );

        expect(result1.hash, equals(result2.hash));
      });

      test('then produces different hashes without provided salt.', () async {
        const testSecret = 'test-secret-123';

        final result1 = await hashUtil.createHashFromString(secret: testSecret);
        final result2 = await hashUtil.createHashFromString(secret: testSecret);

        expect(result1.hash, isNot(equals(result2.hash)));
      });

      test('then handles empty secret.', () async {
        final result = await hashUtil.createHashFromString(secret: '');
        expect(result.hash, isNotEmpty);
        expect(result.salt, isNotEmpty);
      });
    });

    group('when createHashFromBytes is called', () {
      test('then generates hash with random salt when salt not provided.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));

        final result = await hashUtil.createHashFromBytes(secret: testSecret);

        expect(result.hash, isNotEmpty);
        expect(result.salt, hasLength(testSaltLength));
      });

      test('then uses provided salt when salt is provided.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));
        final providedSalt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final result = await hashUtil.createHashFromBytes(
          secret: testSecret,
          salt: providedSalt,
        );

        expect(result.salt, equals(providedSalt));
        expect(result.hash, isNotEmpty);
      });

      test('then produces identical hashes with same secret and salt.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));
        final salt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final result1 = await hashUtil.createHashFromBytes(
          secret: testSecret,
          salt: salt,
        );
        final result2 = await hashUtil.createHashFromBytes(
          secret: testSecret,
          salt: salt,
        );

        expect(result1.hash, equals(result2.hash));
      });
    });

    group('when validateHashFromString is called', () {
      test('then returns true with correct secret.', () async {
        const testSecret = 'test-secret-123';

        final result = await hashUtil.createHashFromString(secret: testSecret);

        final isValid = await hashUtil.validateHashFromString(
          secret: testSecret,
          hash: result.hash,
          salt: result.salt,
        );

        expect(isValid, isTrue);
      });

      test('then returns false with incorrect secret.', () async {
        const testSecret = 'test-secret-123';
        const incorrectSecret = 'wrong-secret-456';

        final result = await hashUtil.createHashFromString(secret: testSecret);

        final isValid = await hashUtil.validateHashFromString(
          secret: incorrectSecret,
          hash: result.hash,
          salt: result.salt,
        );

        expect(isValid, isFalse);
      });

      test('then returns false with empty hash.', () async {
        const testSecret = 'test-secret-123';
        final emptyHash = Uint8List.fromList([]);
        final salt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final isValid = await hashUtil.validateHashFromString(
          secret: testSecret,
          hash: emptyHash,
          salt: salt,
        );

        expect(isValid, isFalse);
      });

      test('then returns false with wrong salt.', () async {
        const testSecret = 'test-secret-123';

        final result = await hashUtil.createHashFromString(secret: testSecret);
        final wrongSalt = Uint8List.fromList([
          ...result.salt.sublist(1),
          result.salt.first + 1,
        ]);

        final isValid = await hashUtil.validateHashFromString(
          secret: testSecret,
          hash: result.hash,
          salt: wrongSalt,
        );

        expect(isValid, isFalse);
      });

      test('then returns false with different pepper.', () async {
        const testSecret = 'test-secret-123';

        final result = await hashUtil.createHashFromString(secret: testSecret);

        final differentPepperHashUtil = Argon2HashUtil(
          hashPepper: '$testPepper-modified',
          hashSaltLength: testSaltLength,
        );

        final isValid = await differentPepperHashUtil.validateHashFromString(
          secret: testSecret,
          hash: result.hash,
          salt: result.salt,
        );

        expect(isValid, isFalse);
      });
    });

    group('when validateHashFromBytes is called', () {
      test('then returns true with correct secret.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));

        final result = await hashUtil.createHashFromBytes(secret: testSecret);

        final isValid = await hashUtil.validateHashFromBytes(
          secret: testSecret,
          hash: result.hash,
          salt: result.salt,
        );

        expect(isValid, isTrue);
      });

      test('then returns false with incorrect secret.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));
        final incorrectSecret = Uint8List.fromList(utf8.encode('wrong-secret-456'));

        final result = await hashUtil.createHashFromBytes(secret: testSecret);

        final isValid = await hashUtil.validateHashFromBytes(
          secret: incorrectSecret,
          hash: result.hash,
          salt: result.salt,
        );

        expect(isValid, isFalse);
      });

      test('then returns false with empty hash.', () async {
        final testSecret = Uint8List.fromList(utf8.encode('test-secret-123'));
        final emptyHash = Uint8List.fromList([]);
        final salt = Uint8List.fromList(List.generate(16, (i) => i + 1));

        final isValid = await hashUtil.validateHashFromBytes(
          secret: testSecret,
          hash: emptyHash,
          salt: salt,
        );

        expect(isValid, isFalse);
      });
    });

    group('when validating hash created with empty secret', () {
      test('then returns true with empty secret.', () async {
        final emptySecretHash = await hashUtil.createHashFromString(secret: '');

        final isValid = await hashUtil.validateHashFromString(
          secret: '',
          hash: emptySecretHash.hash,
          salt: emptySecretHash.salt,
        );

        expect(isValid, isTrue);
      });
    });
  });

  group('Given Argon2HashUtil with fallback peppers', () {
    const oldPepper = 'old-pepper-value';
    const newPepper = 'new-pepper-value';
    const testSecret = 'test-secret-123';
    const testSaltLength = 16;

    late Argon2HashUtil oldPepperHashUtil;
    late Argon2HashUtil newPepperHashUtilWithFallback;
    late HashResult oldPasswordHash;

    setUp(() async {
      oldPepperHashUtil = Argon2HashUtil(
        hashPepper: oldPepper,
        hashSaltLength: testSaltLength,
      );
      oldPasswordHash = await oldPepperHashUtil.createHashFromString(
        secret: testSecret,
      );

      newPepperHashUtilWithFallback = Argon2HashUtil(
        hashPepper: newPepper,
        fallbackHashPeppers: [oldPepper],
        hashSaltLength: testSaltLength,
      );
    });

    test('when validateHashFromString is called with old hash then returns true.', () async {
      final isValid = await newPepperHashUtilWithFallback.validateHashFromString(
        secret: testSecret,
        hash: oldPasswordHash.hash,
        salt: oldPasswordHash.salt,
      );

      expect(isValid, isTrue);
    });

    test('when validateHashFromString is called with incorrect secret then returns false.', () async {
      const incorrectSecret = '$testSecret-incorrect';

      final isValid = await newPepperHashUtilWithFallback.validateHashFromString(
        secret: incorrectSecret,
        hash: oldPasswordHash.hash,
        salt: oldPasswordHash.salt,
      );

      expect(isValid, isFalse);
    });

    test('when createHashFromString is called then new hash uses primary pepper.', () async {
      final newHash = await newPepperHashUtilWithFallback.createHashFromString(
        secret: testSecret,
      );

      final newPepperOnlyUtil = Argon2HashUtil(
        hashPepper: newPepper,
        hashSaltLength: testSaltLength,
      );

      final isValidWithNewPepper = await newPepperOnlyUtil.validateHashFromString(
        secret: testSecret,
        hash: newHash.hash,
        salt: newHash.salt,
      );

      expect(isValidWithNewPepper, isTrue);

      final oldPepperOnlyUtil = Argon2HashUtil(
        hashPepper: oldPepper,
        hashSaltLength: testSaltLength,
      );

      final isValidWithOldPepper = await oldPepperOnlyUtil.validateHashFromString(
        secret: testSecret,
        hash: newHash.hash,
        salt: newHash.salt,
      );

      expect(isValidWithOldPepper, isFalse);
    });

    test('when multiple fallback peppers are provided then validates against any of them.', () async {
      const veryOldPepper = 'very-old-pepper-value';

      final veryOldPepperHashUtil = Argon2HashUtil(
        hashPepper: veryOldPepper,
        hashSaltLength: testSaltLength,
      );
      final veryOldPasswordHash = await veryOldPepperHashUtil.createHashFromString(
        secret: testSecret,
      );

      final multiPepperHashUtil = Argon2HashUtil(
        hashPepper: newPepper,
        fallbackHashPeppers: [oldPepper, veryOldPepper],
        hashSaltLength: testSaltLength,
      );

      final isValidOld = await multiPepperHashUtil.validateHashFromString(
        secret: testSecret,
        hash: oldPasswordHash.hash,
        salt: oldPasswordHash.salt,
      );
      final isValidVeryOld = await multiPepperHashUtil.validateHashFromString(
        secret: testSecret,
        hash: veryOldPasswordHash.hash,
        salt: veryOldPasswordHash.salt,
      );

      expect(isValidOld, isTrue);
      expect(isValidVeryOld, isTrue);
    });
  });

  group('Given HashResult factory', () {
    test('when HashResult.empty() is called then creates empty hash and salt.', () {
      final emptyHashResult = HashResult.empty();

      expect(emptyHashResult.hash, isEmpty);
      expect(emptyHashResult.salt, isEmpty);
      expect(emptyHashResult.hash, isA<Uint8List>());
      expect(emptyHashResult.salt, isA<Uint8List>());
    });
  });
}
