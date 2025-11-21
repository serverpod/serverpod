import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_auth_core_server/src/common/util/argon2id_hash_util.dart';
import 'package:test/test.dart';

void main() {
  group('Given Argon2idHashUtil instance', () {
    late Argon2idHashUtil hashUtil;
    const testSaltLength = 16;
    const testPepper = 'test-pepper';

    setUp(() {
      hashUtil = Argon2idHashUtil(
        hashPepper: testPepper,
        hashSaltLength: testSaltLength,
      );
    });

    group('when using String input', () {
      test(
        'Given createHashFromString is called without salt when hash is created then generates hash with random salt.',
        () async {
          const testValue = 'test-password-123';

          final result = await hashUtil.createHashFromString(value: testValue);

          expect(result.hash, isNotEmpty);
          expect(result.salt, hasLength(testSaltLength));
        },
      );

      test(
        'Given createHashFromString is called with provided salt when hash is created then uses that salt.',
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

          final result = await hashUtil.createHashFromString(
            value: testValue,
            salt: providedSalt,
          );

          expect(result.salt, equals(providedSalt));
          expect(result.hash, isNotEmpty);
        },
      );

      test(
        'Given createHashFromString is called twice with same value and different salts when hashes are compared then produces different hashes.',
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

          final result1 = await hashUtil.createHashFromString(
            value: testValue,
            salt: salt1,
          );
          final result2 = await hashUtil.createHashFromString(
            value: testValue,
            salt: salt2,
          );

          expect(result1.hash, isNot(equals(result2.hash)));
        },
      );

      test(
        'Given createHashFromString is called twice with same value and same salt when hashes are compared then produces identical hashes.',
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

          final result1 = await hashUtil.createHashFromString(
            value: testValue,
            salt: salt,
          );
          final result2 = await hashUtil.createHashFromString(
            value: testValue,
            salt: salt,
          );

          expect(result1.hash, equals(result2.hash));
        },
      );

      test(
        'Given createHashFromString is called twice with same value without providing a salt when hashes are compared then produces different hashes.',
        () async {
          const testValue = 'test-password-123';

          final result1 = await hashUtil.createHashFromString(
            value: testValue,
          );
          final result2 = await hashUtil.createHashFromString(
            value: testValue,
          );

          expect(result1.hash, isNot(equals(result2.hash)));
        },
      );

      test(
        'Given createHashFromString is called with empty value when hash is created then non empty hash and salt are generated.',
        () async {
          final result = await hashUtil.createHashFromString(value: '');

          expect(result.hash, isNotEmpty);
          expect(result.salt, isNotEmpty);
        },
      );
    });

    group('when using Uint8List input', () {
      test(
        'Given createHashFromBytes is called without salt when hash is created then generates hash with random salt.',
        () async {
          final testSecret = Uint8List.fromList(utf8.encode('test-secret'));

          final result = await hashUtil.createHashFromBytes(secret: testSecret);

          expect(result.hash, isNotEmpty);
          expect(result.salt, hasLength(testSaltLength));
        },
      );

      test(
        'Given createHashFromBytes is called with provided salt when hash is created then uses that salt.',
        () async {
          final testSecret = Uint8List.fromList(utf8.encode('test-secret'));
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

          final result = await hashUtil.createHashFromBytes(
            secret: testSecret,
            salt: providedSalt,
          );

          expect(result.salt, equals(providedSalt));
          expect(result.hash, isNotEmpty);
        },
      );

      test(
        'Given createHashFromBytes is called twice with same secret and same salt when hashes are compared then produces identical hashes.',
        () async {
          final testSecret = Uint8List.fromList(utf8.encode('test-secret'));
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

          final result1 = await hashUtil.createHashFromBytes(
            secret: testSecret,
            salt: salt,
          );
          final result2 = await hashUtil.createHashFromBytes(
            secret: testSecret,
            salt: salt,
          );

          expect(result1.hash, equals(result2.hash));
        },
      );
    });

    group('when validating String hashes', () {
      const value = 'test-password-123';
      late HashResult passwordHash;

      setUp(() async {
        passwordHash = await hashUtil.createHashFromString(value: value);
      });

      test(
        'Given validateHashFromString is called with correct value when validated then returns true.',
        () async {
          final isValid = await hashUtil.validateHashFromString(
            value: value,
            hash: passwordHash.hash,
            salt: passwordHash.salt,
          );

          expect(isValid, isTrue);
        },
      );

      test(
        'Given validateHashFromString is called with incorrect value when validated then returns false.',
        () async {
          const incorrectValue = '$value-incorrect';

          final isValid = await hashUtil.validateHashFromString(
            value: incorrectValue,
            hash: passwordHash.hash,
            salt: passwordHash.salt,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Given validateHashFromString is called with empty hash when validated then returns false.',
        () async {
          final emptyHash = Uint8List.fromList([]);

          final isValid = await hashUtil.validateHashFromString(
            value: value,
            hash: emptyHash,
            salt: passwordHash.salt,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Given validateHashFromString is called with wrong salt when validated then returns false.',
        () async {
          final wrongSalt = Uint8List.fromList([
            ...passwordHash.salt.sublist(1),
            passwordHash.salt.first + 1,
          ]);

          final isValid = await hashUtil.validateHashFromString(
            value: value,
            hash: passwordHash.hash,
            salt: wrongSalt,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Given validateHashFromString is called with valid credentials on a different hash util using a different pepper when validated then returns false.',
        () async {
          final differentPepperHashUtil = Argon2idHashUtil(
            hashPepper: '$testPepper-modified',
            hashSaltLength: testSaltLength,
          );

          final isValid = await differentPepperHashUtil.validateHashFromString(
            value: value,
            hash: passwordHash.hash,
            salt: passwordHash.salt,
          );

          expect(isValid, isFalse);
        },
      );
    });

    group('when validating Uint8List hashes', () {
      late Uint8List secret;
      late HashResult secretHash;

      setUp(() async {
        secret = Uint8List.fromList(utf8.encode('test-secret-bytes'));
        secretHash = await hashUtil.createHashFromBytes(secret: secret);
      });

      test(
        'Given validateHashFromBytes is called with correct secret when validated then returns true.',
        () async {
          final isValid = await hashUtil.validateHashFromBytes(
            secret: secret,
            hash: secretHash.hash,
            salt: secretHash.salt,
          );

          expect(isValid, isTrue);
        },
      );

      test(
        'Given validateHashFromBytes is called with incorrect secret when validated then returns false.',
        () async {
          final incorrectSecret = Uint8List.fromList(
            utf8.encode('incorrect-secret'),
          );

          final isValid = await hashUtil.validateHashFromBytes(
            secret: incorrectSecret,
            hash: secretHash.hash,
            salt: secretHash.salt,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Given validateHashFromBytes is called with empty hash when validated then returns false.',
        () async {
          final emptyHash = Uint8List.fromList([]);

          final isValid = await hashUtil.validateHashFromBytes(
            secret: secret,
            hash: emptyHash,
            salt: secretHash.salt,
          );

          expect(isValid, isFalse);
        },
      );
    });

    group('when validating empty String password hash', () {
      late HashResult emptyPasswordHash;

      setUp(() async {
        emptyPasswordHash = await hashUtil.createHashFromString(value: '');
      });

      test(
        'Given validateHashFromString is called with empty password when validated then returns true.',
        () async {
          final isValid = await hashUtil.validateHashFromString(
            value: '',
            hash: emptyPasswordHash.hash,
            salt: emptyPasswordHash.salt,
          );

          expect(isValid, isTrue);
        },
      );
    });

    group('when testing cross-compatibility', () {
      test(
        'Given hash created from String when validated with same bytes then returns true.',
        () async {
          const testValue = 'test-password-123';
          final testBytes = Uint8List.fromList(utf8.encode(testValue));

          final hashFromString = await hashUtil.createHashFromString(
            value: testValue,
          );

          final isValid = await hashUtil.validateHashFromBytes(
            secret: testBytes,
            hash: hashFromString.hash,
            salt: hashFromString.salt,
          );

          expect(isValid, isTrue);
        },
      );

      test(
        'Given hash created from bytes when validated with same String then returns true.',
        () async {
          const testValue = 'test-password-123';
          final testBytes = Uint8List.fromList(utf8.encode(testValue));

          final hashFromBytes = await hashUtil.createHashFromBytes(
            secret: testBytes,
          );

          final isValid = await hashUtil.validateHashFromString(
            value: testValue,
            hash: hashFromBytes.hash,
            salt: hashFromBytes.salt,
          );

          expect(isValid, isTrue);
        },
      );
    });
  });

  group('Given HashResult factory', () {
    test(
      'Given HashResult.empty() is called when created then creates empty hash and salt.',
      () {
        final emptyHashResult = HashResult.empty();

        expect(emptyHashResult.hash, isEmpty);
        expect(emptyHashResult.salt, isEmpty);
        expect(emptyHashResult.hash, isA<Uint8List>());
        expect(emptyHashResult.salt, isA<Uint8List>());
      },
    );
  });
}
