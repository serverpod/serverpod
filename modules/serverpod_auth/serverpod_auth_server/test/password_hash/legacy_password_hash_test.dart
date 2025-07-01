import 'package:serverpod_auth_server/src/business/password_hash.dart';
import 'package:test/test.dart';

void main() {
  group('Given password', () {
    test('when generating hash then hash matches regression value', () async {
      // This regression hash value was derived from the old serverpod hash
      // generation algorithm.
      var expectedHash =
          '0713234b3cb6a6f98f6978f17a55a54578c580698dc1d56371502be6abb457eb';

      var actualHash =
          await PasswordHash.legacyHash('hunter2', 'serverpod password salt');

      expect(actualHash, expectedHash);
    });

    test('when validating with correct password then validator returns true',
        () async {
      var salt = 'serverpod password salt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(password, salt),
        legacySalt: salt,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test('when validating with incorrect password then validator returns false',
        () async {
      var salt = 'serverpod password salt';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash('hunter2', salt),
        legacySalt: salt,
      );

      expect(await passwordHash.validate('chaser1'), isFalse);
    });

    test('when validating with different salts then validator returns false',
        () async {
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(password, 'first salt'),
        legacySalt: 'second salt',
      );

      expect(await passwordHash.validate(password), isFalse);
    });
  });

  group('Given password and extra salt email', () {
    test(
        'when generating hash with email provided then result matches regression value',
        () async {
      // This regression hash value was derived from the old serverpod hash
      // generation algorithm.
      var expectedHash =
          '4005303e6e1effd8bc7293bc3e69fe3a480a88249453aef7f58fdcf264419147';

      var actualHash = await PasswordHash.legacyHash(
        'hunter2',
        'serverpod password salt',
        email: 'test@serverpod.dev',
      );

      expect(actualHash, expectedHash);
    });
  });

  group('Given password hash', () {
    test('when checking if hash should be updated then no update is needed.',
        () async {
      var salt = 'saltySalt';
      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          'hunter2',
          salt,
        ),
        legacySalt: salt,
      );

      expect(passwordHash.shouldUpdateHash(), isTrue);
    });

    test('when checking if hash is legacy hash then method returns true.',
        () async {
      var salt = 'saltySalt';
      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          'hunter2',
          salt,
        ),
        legacySalt: salt,
      );

      expect(passwordHash.isLegacyHash(), isTrue);
    });

    test('when matching with correct password then it evaluates to true',
        () async {
      var salt = 'serverpod password salt';
      var password = 'hunter2';
      var email = 'test@serverpod.dev';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          password,
          salt,
          email: email,
        ),
        legacySalt: salt,
        legacyEmail: email,
      );

      expect(await passwordHash.validate(password), isTrue);
    });

    test('when matching with incorrect password then it evaluates to false',
        () async {
      var salt = 'serverpod password salt';
      var email = 'test@serverpod.dev';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          'hunter2',
          salt,
          email: email,
        ),
        legacySalt: salt,
        legacyEmail: email,
      );

      expect(await passwordHash.validate('chaser1'), isFalse);
    });

    test('when matching with incorrect salt then it evaluates to false',
        () async {
      var password = 'hunter2';
      var email = 'test@serverpod.dev';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          password,
          'first salt',
          email: email,
        ),
        legacySalt: 'second salt',
        legacyEmail: email,
      );

      expect(await passwordHash.validate(password), isFalse);
    });

    test('when matching with incorrect email then it evaluates to false',
        () async {
      var salt = 'serverpod password salt';
      var password = 'hunter2';

      var passwordHash = PasswordHash(
        await PasswordHash.legacyHash(
          password,
          salt,
          email: 'first@serverpod.dev',
        ),
        legacySalt: salt,
        legacyEmail: 'second@serverpod.dev',
      );

      expect(await passwordHash.validate(password), isFalse);
    });
  });
}
