import 'dart:convert';

import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a hash from the legacy hash used as password for argon2id hash when generating hash using same salt and base password then same hash is produced',
      () async {
    var password = 'hunter2';
    var legacySalt = 'legacySalt';
    var salt = 'saltySalt';

    var legacyHash = await PasswordHash.legacyHash(password, legacySalt);
    var argon2idPasswordHashFromLegacy =
        await PasswordHash.argon2id(legacyHash, salt: salt);
    var expectedHash = argon2idPasswordHashFromLegacy.split('\$')[3];

    var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
      legacyHash,
      legacySalt: legacySalt,
      salt: salt,
    );

    var actualHash = passwordHash.split('\$')[3];

    expect(actualHash, expectedHash);
  });

  group('Given legacyHash, legacy salt and fixed salt', () {
    group('when generating password hash', () {
      test('then hash has 4 sections split by \$.', () async {
        var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          'legacyHash',
          legacySalt: 'legacySalt',
          salt: 'saltySalt',
        );

        var parts = passwordHash.split('\$');
        expect(parts, hasLength(4));
      });

      test('then second section contains algorithm name.', () async {
        var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          'legacyHash',
          legacySalt: 'legacySalt',
          salt: 'saltySalt',
        );

        var parts = passwordHash.split('\$');
        expect(parts[1], 'migratedLegacy');
      });

      test('then third section contains encoded salt.', () async {
        var salt = 'saltySalt';

        var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          'legacyHash',
          legacySalt: 'legacySalt',
          salt: salt,
        );

        var parts = passwordHash.split('\$');
        expect(parts[2], const Base64Encoder().convert(salt.codeUnits));
      });

      test('then fourth section contains hash.', () async {
        var expectedHash =
            'aF5cAla/wBZ6Ka/kpGfmBC9kOftCRBr5srDZFhtAiF9SUqNUwefbsHBJZDX9cOo2B7MHNZzJDbNRg2VH6+VJtp70gHdveN7EJGrcSsaiReI1x4pX/sQ0l78FhIZ/+vYsuFGDCcr4qg1bkIk6apwmGMzJjKMSKy07bPXNcemm3EPhuCC9OLeBQHtS642TsWVKX9412XxGR2aDbRIDJItBMfWlLH0i3JSWxqcUZLtES7bwcvPdqj68jHT6nzAzFJAiOg4NkaTLye/SlKe/q6LjUci/NYYkJ9ujNnJD410E4AR6yVJqWZaGJMTrr38A0Vigayj4IvPaYaMCwho9Pr8/Jg==';

        var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          'legacyHash',
          legacySalt: 'legacySalt',
          salt: 'saltySalt',
        );

        var parts = passwordHash.split('\$');
        expect(parts[3], expectedHash);
      });
    });

    group('when generating password hash with and without pepper', () {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var salt = 'saltySalt';
      var pepper = 'pepper';

      late String withoutPepper;
      late String withPepper;
      setUpAll(() async {
        withoutPepper = await PasswordHash.migratedLegacyToArgon2idHash(
          password,
          legacySalt: legacySalt,
          salt: salt,
        );
        withPepper = await PasswordHash.migratedLegacyToArgon2idHash(
          password,
          legacySalt: legacySalt,
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
      var legacySalt = 'legacySalt';
      late String firstPasswordHash;
      late String secondPasswordHash;

      setUpAll(() async {
        firstPasswordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          password,
          legacySalt: legacySalt,
        );
        secondPasswordHash = await PasswordHash.migratedLegacyToArgon2idHash(
          password,
          legacySalt: legacySalt,
        );
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
      var salt = 'saltySalt';
      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          'hunter2',
          legacySalt: salt,
        ),
        legacySalt: salt,
      );

      expect(passwordHash.shouldUpdateHash(), isTrue);
    });

    test('when checking if hash is legacy hash then method returns true.',
        () async {
      var salt = 'saltySalt';
      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          'hunter2',
          legacySalt: salt,
        ),
        legacySalt: salt,
      );

      expect(passwordHash.isLegacyHash(), isFalse);
    });
    test('when validating with correct password then validator returns true',
        () async {
      var salt = 'saltySalt';
      var legacySalt = 'legacySalt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: salt,
        ),
        legacySalt: legacySalt,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test(
        'when validating with correct password but different legacy salt then validator returns false',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: 'saltySalt',
        ),
        legacySalt: 'differentLegacySalt',
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with incorrect password then validator returns false',
        () async {
      var salt = 'saltySalt';
      var legacySalt = 'legacySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash('hunter2', legacySalt),
          legacySalt: legacySalt,
          salt: salt,
        ),
        legacySalt: legacySalt,
      );

      expect(await passwordHash.validate('chaser1'), isFalse);
    });

    test('when validating with modified salt then validator returns false',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var originalPasswordHash =
          await PasswordHash.migratedLegacyToArgon2idHash(
        await PasswordHash.legacyHash(password, legacySalt),
        legacySalt: legacySalt,
        salt: 'original salt',
      );

      // Replace the salt in the password hash with a different one
      var parts = originalPasswordHash.split('\$');
      parts[2] = 'modified salt';
      var modifiedPasswordHash = parts.join('\$');

      var passwordHash = PasswordHash(
        modifiedPasswordHash,
        legacySalt: legacySalt,
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with valid pepper then validator returns true.',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var salt = 'saltySalt';
      var pepper = 'pepper';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: salt,
          pepper: pepper,
        ),
        legacySalt: legacySalt,
        pepper: pepper,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test('when validating with invalid pepper then validator returns false.',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var salt = 'saltySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: salt,
          pepper: 'pepper',
        ),
        legacySalt: legacySalt,
        pepper: 'differentPepper',
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with missing pepper then validator returns false.',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var salt = 'saltySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: salt,
          pepper: 'pepper',
        ),
        legacySalt: legacySalt,
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when validating with added pepper then validator returns false.',
        () async {
      var password = 'hunter2';
      var legacySalt = 'legacySalt';
      var salt = 'saltySalt';

      var passwordHash = PasswordHash(
        await PasswordHash.migratedLegacyToArgon2idHash(
          await PasswordHash.legacyHash(password, legacySalt),
          legacySalt: legacySalt,
          salt: salt,
        ),
        legacySalt: legacySalt,
        pepper: 'pepper',
      );

      expect(await passwordHash.validate(password), isFalse);
    });
  });

  group('Given salt that contains \$', () {
    test(
        'when generating password hash then hash still only has 4 parts split by \$.',
        () async {
      var legacySalt = 'legacySalt';
      var salt = 'salty\$salt';

      var passwordHash = await PasswordHash.migratedLegacyToArgon2idHash(
        await PasswordHash.legacyHash('hunter2', legacySalt),
        legacySalt: legacySalt,
        salt: salt,
      );
      var parts = passwordHash.split('\$');

      expect(parts, hasLength(4));
    });
  });
}
