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
      phonePasswordHashValidator: (
        password,
        hash, {
        onError,
        onValidationFailure,
      }) async =>
          // Always return true to allow the test to proceed
          true,
      // Custom password hash generator that does not hash the password
      phonePasswordHashGenerator: (password) async => password,
      extraSaltyHash: false,
    ),
  );

  group(
      'Given a custom non-hashing password hash generator and a create account request',
      () {
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

    test('when inspecting password hash then password is not hashed', () async {
      var phoneAuth = await PhoneCreateAccountRequest.db.findFirstRow(
        session,
        where: (t) => t.phoneNumber.equals(phoneNumber),
      );

      expect(
        phoneAuth,
        isNotNull,
        reason: 'Failed to find create account',
      );
      var passwordHash = phoneAuth!.hash;

      expect(
        passwordHash,
        password,
        reason: 'Password hash is not the same as password',
      );
    });
  });

  group('Given a custom always true password hash validator and a created user',
      () {
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
        'when authenticating with incorrect password then user can authenticate',
        () async {
      var incorrectPassword = '$password-incorrect';
      var authResponse =
          await Phones.authenticate(session, phoneNumber, incorrectPassword);
      expect(authResponse.success, isTrue,
          reason: 'Failed to authenticate user.');
    });
  });
}
