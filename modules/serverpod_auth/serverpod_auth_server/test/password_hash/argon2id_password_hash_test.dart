import 'dart:convert';

import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:test/test.dart';

void main() {
  group('Given password and fixed salt', () {
    group('when generating password hash', () {
      test('then hash has 4 sections split by \$.', () {
        var passwordHash = PasswordHash.argon2id('hunter2', salt: 'saltySalt');

        var parts = passwordHash.split('\$');
        expect(parts, hasLength(4));
      });

      test('then second section contains algorithm name.', () {
        var passwordHash = PasswordHash.argon2id('hunter2', salt: 'saltySalt');

        var parts = passwordHash.split('\$');
        expect(parts[1], 'argon2id');
      });

      test('then third section contains encoded salt.', () {
        var salt = 'saltySalt';

        var passwordHash = PasswordHash.argon2id('hunter2', salt: salt);

        var parts = passwordHash.split('\$');
        expect(parts[2], const Base64Encoder().convert(salt.codeUnits));
      });

      test('then fourth section contains hash.', () {
        var expectedHash =
            'XE1myFwU/BfI2wTVT3Idp2htwbXRLkY3L5ysvmAR+iJJVfHMJEMFP7eFrRwMvsP0dygxYopuCiDGNHhJaIuE0Bm6SIIAJt/LoktWA+JzMdVAQQDF08anztJL8db3nIjqiRr7fTsEnH88zIMx0z+6X22ZIJoKHQ37wI7jTVhPgtEX8OSubOHA8JSKaGko9GoXa1IEO4PXZ/OWoCf+PELDySMIK5UvakJg4Rx6gjuQQJ612VfB0lI+Dw//h5mdbypxIQWBUp+cc8VYwOtKod2BOhEzn/h0R158/n9NaW4Zxz7mteja3K2Kl/fZwGpronzItYZMbw5j7pS96r/Jf227IQ==';

        var passwordHash = PasswordHash.argon2id('hunter2', salt: 'saltySalt');

        var parts = passwordHash.split('\$');
        expect(parts[3], expectedHash);
      });
    });

    group('when generating password hash with and without pepper', () {
      var password = 'hunter2';
      var salt = 'saltySalt';
      var pepper = 'pepper';

      var withoutPepper = PasswordHash.argon2id(password, salt: salt);
      var withPepper =
          PasswordHash.argon2id(password, salt: salt, pepper: pepper);
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
      var firstPasswordHash = PasswordHash.argon2id(password);
      var secondPasswordHash = PasswordHash.argon2id(password);
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
        () {
      var passwordHash = PasswordHash(
        PasswordHash.argon2id('hunter2'),
        legacySalt: 'saltySalt',
      );

      expect(passwordHash.shouldUpdateHash(), isFalse);
    });

    test('when checking if hash is legacy hash then method returns false.', () {
      var passwordHash = PasswordHash(
        PasswordHash.argon2id('hunter2'),
        legacySalt: 'saltySalt',
      );

      expect(passwordHash.isLegacyHash(), isFalse);
    });

    test('when validating with correct password then validator returns true',
        () {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: salt),
        legacySalt: salt,
      );

      expect(passwordHash.validate(password), isTrue);
    });

    test(
        'when validating with correct password but different legacy salt then validator returns true',
        () {
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: 'saltySalt'),
        legacySalt: 'differentSalt' /* field is ignored */,
      );

      expect(passwordHash.validate(password), isTrue);
    });

    test('when validating with incorrect password then validator returns false',
        () {
      var salt = 'saltySalt';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id('hunter2', salt: salt),
        legacySalt: salt,
      );

      expect(passwordHash.validate('chaser1'), isFalse);
    });

    test('when validating with modified salt then validator returns false', () {
      var password = 'hunter2';
      var originalPasswordHash =
          PasswordHash.argon2id(password, salt: 'original salt');

      // Replace the salt in the password hash with a different one
      var parts = originalPasswordHash.split('\$');
      parts[2] = 'modified salt';
      var modifiedPasswordHash = parts.join('\$');

      var passwordHash = PasswordHash(
        modifiedPasswordHash,
        legacySalt: 'original salt' /* field is ignored */,
      );

      expect(passwordHash.validate(password), isFalse);
    });

    test('when validating with valid pepper then validator returns true.', () {
      var salt = 'saltySalt';
      var password = 'hunter2';
      var pepper = 'pepper';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: salt, pepper: pepper),
        legacySalt: salt,
        pepper: pepper,
      );

      expect(passwordHash.validate(password), isTrue);
    });

    test('when validating with invalid pepper then validator returns false.',
        () {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: salt, pepper: 'firstPepper'),
        legacySalt: salt,
        pepper: 'differentPepper',
      );

      expect(passwordHash.validate(password), isFalse);
    });

    test('when validating with missing pepper then validator returns false.',
        () {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: salt, pepper: 'pepper'),
        legacySalt: salt,
      );

      expect(passwordHash.validate(password), isFalse);
    });

    test('when validating with added pepper then validator returns false.', () {
      var salt = 'saltySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        PasswordHash.argon2id(password, salt: salt),
        legacySalt: salt,
        pepper: 'pepper',
      );

      expect(passwordHash.validate(password), isFalse);
    });
  });

  group('Given salt that contains \$', () {
    test(
        'when generating password hash then hash still only has 4 parts split by \$.',
        () {
      var password = 'hunter2';
      var salt = 'salty\$salt';

      var passwordHash = PasswordHash.argon2id(password, salt: salt);
      var parts = passwordHash.split('\$');

      expect(parts, hasLength(4));
    });
  });
}
