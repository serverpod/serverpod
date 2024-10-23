import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  AuthConfig.set(
    AuthConfig(
      sendValidationSms: (session, phoneNumber, validationCode) async {
        print(
            'Sending validation sms to $phoneNumber with code $validationCode');
        return true;
      },
      extraSaltyHash: false,
    ),
  );

  group('Given create account request ', () {
    var userName = 'test';
    var phoneNumber = '+79999999999';
    var password = 'password';

    tearDown(() async {
      await PhoneCreateAccountRequest.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    setUp(() async {
      await Phones.createAccountRequest(
          session, userName, phoneNumber, password);
    });

    test('when inspecting password hash then password is hashed using Argon2id',
        () async {
      var createAccountRequest =
          await PhoneCreateAccountRequest.db.findFirstRow(
        session,
        where: (t) =>
            t.userName.equals(userName) & t.phoneNumber.equals(phoneNumber),
      );

      expect(
        createAccountRequest,
        isNotNull,
        reason: 'Failed to find create account request',
      );
      var passwordHash = createAccountRequest!.hash;

      expect(
        passwordHash,
        contains('argon2id'),
        reason: 'Password hash is not using Argon2id',
      );
    });
  });

  group('Given a created user', () {
    var userName = 'test';
    var phoneNumber = '+79999999999';
    var password = 'password';

    tearDown(() async {
      await Future.wait([
        UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        PhoneAuth.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        UserImage.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      ]);
    });

    setUp(() async {
      await Phones.createUser(session, userName, phoneNumber, password);
    });

    test(
        'when inspecting phone auth hash then password is hashed using Argon2id',
        () async {
      var phoneAuth = await PhoneAuth.db.findFirstRow(
        session,
        where: (t) => t.phoneNumber.equals(phoneNumber),
      );
      expect(
        phoneAuth,
        isNotNull,
        reason: 'Failed to find phone auth entry',
      );

      var passwordHash = phoneAuth!.hash;
      expect(
        passwordHash,
        contains('argon2id'),
        reason: 'Password hash is not using Argon2id',
      );
    });
  });

  group('Given password not matching the hash when validating password', () {
    // This is the hash from the password 'hunter4'
    var hunter4PasswordHash =
        '2ee3dc6432300eabf9630ac7827d6dd23fd23cc9120ec4cd58f8f66bd3ce2db9';
    var notHunter4PasswordHash =
        '1d24f0d21861e659c50c87ae03b679dc66ac7dd5fb1b03140e53f9331eeb0a31';

    test('then validation fails.', () async {
      expect(
        await Phones.validatePasswordHash(
          'notHunter4',
          hunter4PasswordHash,
        ),
        isFalse,
      );
    });

    test(
        'then validation failure callback is called with generated hash and passed in hash.',
        () async {
      late String actualStoredHash;
      late String actualPasswordHash;

      await Phones.validatePasswordHash(
        'notHunter4',
        hunter4PasswordHash,
        onValidationFailure: ({
          required String storedHash,
          required String passwordHash,
        }) {
          actualStoredHash = storedHash;
          actualPasswordHash = passwordHash;
        },
      );

      expect(actualStoredHash, hunter4PasswordHash);
      expect(actualPasswordHash, notHunter4PasswordHash);
    });
  });
}
