import 'dart:convert';

import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:test/test.dart';

void main() {
  group('Given password and fixed salt', () {
    group('when generating password hash', () {
      test('then hash has 4 sections split by \$.', () async {
        var passwordHash = await PasswordHash.argon2id(
          'hunter2',
          salt: 'saltySalt',
        );

        var parts = passwordHash.split('\$');
        expect(parts, hasLength(4));
      });

      test('then second section contains algorithm name.', () async {
        var passwordHash = await PasswordHash.argon2id(
          'hunter2',
          salt: 'saltySalt',
        );

        var parts = passwordHash.split('\$');
        expect(parts[1], 'argon2id');
      });

      test('then third section contains encoded salt.', () async {
        var salt = 'saltySalt';

        var passwordHash = await PasswordHash.argon2id('hunter2', salt: salt);

        var parts = passwordHash.split('\$');
        expect(parts[2], const Base64Encoder().convert(salt.codeUnits));
      });

      test('then fourth section contains hash.', () async {
        var expectedHash =
            'XE1myFwU/BfI2wTVT3Idp2htwbXRLkY3L5ysvmAR+iJJVfHMJEMFP7eFrRwMvsP0dygxYopuCiDGNHhJaIuE0Bm6SIIAJt/LoktWA+JzMdVAQQDF08anztJL8db3nIjqiRr7fTsEnH88zIMx0z+6X22ZIJoKHQ37wI7jTVhPgtEX8OSubOHA8JSKaGko9GoXa1IEO4PXZ/OWoCf+PELDySMIK5UvakJg4Rx6gjuQQJ612VfB0lI+Dw//h5mdbypxIQWBUp+cc8VYwOtKod2BOhEzn/h0R158/n9NaW4Zxz7mteja3K2Kl/fZwGpronzItYZMbw5j7pS96r/Jf227IQ==';

        var passwordHash =
            await PasswordHash.argon2id('hunter2', salt: 'saltySalt');

        var parts = passwordHash.split('\$');
        expect(parts[3], expectedHash);
      });
    });

    group('when generating password hash with and without pepper', () {
      var password = 'hunter2';
      var salt = 'saltySalt';
      var pepper = 'pepper';
      late String withoutPepper;
      late String withPepper;

      setUpAll(() async {
        withoutPepper = await PasswordHash.argon2id(password, salt: salt);
        withPepper = await PasswordHash.argon2id(
          password,
          salt: salt,
          pepper: pepper,
        );
      });
      test('then salt is same.', () {
        var withoutPepperSalt = withoutPepper.split('\$')[2];
        var withPepperSalt = withPepper.split('\$')[2];
        expect(withoutPepperSalt, withPepperSalt);
      });

      test('then hashes are different.', () {
        var withoutPepperHash = withoutPepper.split('\$')[3];
        var withPepperHash = withPepper.split('\$')[3];
        expect(withoutPepperHash, isNot(withPepperHash));
      });
    });
  });

  group('Given password', () {
    group('when generating password hash multiple times', () {
      var password = 'hunter2';
      late String firstPasswordHash;
      late String secondPasswordHash;

      setUpAll(() async {
        firstPasswordHash = await PasswordHash.argon2id(password);
        secondPasswordHash = await PasswordHash.argon2id(password);
      });
      test('then unique salt is generated.', () {
        var firstSalt = firstPasswordHash.split('\$')[2];
        var secondSalt = secondPasswordHash.split('\$')[2];
        expect(firstSalt, isNot(secondSalt));
      });

      test('then unique hash is generated.', () {
        var firstHash = firstPasswordHash.split('\$')[3];
        var secondHash = secondPasswordHash.split('\$')[3];
        expect(firstHash, isNot(secondHash));
      });
    });
  });

  group('Given password hash', () {
    test('when checking if hash should be updated then no update is needed.',
        () async {
      var passwordHash = PasswordHash(
        await PasswordHash.argon2id('hunter2'),
        legacySalt: 'saltySalt',
      );

      expect(passwordHash.shouldUpdateHash(), isFalse);
    });

    test('when checking if hash is legacy hash then method returns false.',
        () async {
      var passwordHash = PasswordHash(
        await PasswordHash.argon2id('hunter2'),
        legacySalt: 'saltySalt',
      );

      expect(passwordHash.isLegacyHash(), isFalse);
    });

    test('when validating with correct password then validator returns true',
        () async {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(password, salt: salt),
        legacySalt: salt,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test(
        'when validating with correct password but different legacy salt then validator returns true',
        () async {
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(password, salt: 'saltySalt'),
        legacySalt: 'differentSalt' /* field is ignored */,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test('when validating with incorrect password then validator returns false',
        () async {
      var salt = 'saltySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id('hunter2', salt: salt),
        legacySalt: salt,
      );

      expect(await passwordHash.validate('chaser1'), isFalse);
    });

    test('when validating with modified salt then validator returns false',
        () async {
      var password = 'hunter2';
      var originalPasswordHash =
          await PasswordHash.argon2id(password, salt: 'original salt');

      // Replace the salt in the password hash with a different one
      var parts = originalPasswordHash.split('\$');
      parts[2] = 'modified salt';
      var modifiedPasswordHash = parts.join('\$');

      var passwordHash = PasswordHash(
        modifiedPasswordHash,
        legacySalt: 'original salt' /* field is ignored */,
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with valid pepper then validator returns true.',
        () async {
      var salt = 'saltySalt';
      var password = 'hunter2';
      var pepper = 'pepper';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(password, salt: salt, pepper: pepper),
        legacySalt: salt,
        pepper: pepper,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test('when validating with invalid pepper then validator returns false.',
        () async {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(
          password,
          salt: salt,
          pepper: 'firstPepper',
        ),
        legacySalt: salt,
        pepper: 'differentPepper',
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with missing pepper then validator returns false.',
        () async {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(password, salt: salt, pepper: 'pepper'),
        legacySalt: salt,
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with added pepper then validator returns false.',
        () async {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.argon2id(password, salt: salt),
        legacySalt: salt,
        pepper: 'pepper',
      );

      expect(await passwordHash.validate(password), isFalse);
    });
  });

  group('Given salt that contains \$', () {
    test(
        'when generating password hash then hash still only has 4 parts split by \$.',
        () async {
      var password = 'hunter2';
      var salt = 'salty\$salt';

      var passwordHash = await PasswordHash.argon2id(password, salt: salt);
      var parts = passwordHash.split('\$');

      expect(parts, hasLength(4));
    });
  });
}
