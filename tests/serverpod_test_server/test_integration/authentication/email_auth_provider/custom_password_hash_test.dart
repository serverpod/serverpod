import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  AuthConfig.set(
    AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        print('Sending validation email to $email with code $validationCode');
        return true;
      },
      passwordHashValidator: (
        password,
        email,
        hash, {
        onError,
        onValidationFailure,
      }) =>
          Future.value(true),
      passwordHashGenerator: (password) => Future.value(password),
      extraSaltyHash: false,
    ),
  );

  group('Given create account request without hashing generator', () {
    var userName = 'test';
    var email = 'test8@serverpod.dev';
    var password = 'password';

    tearDown(() async {
      await EmailCreateAccountRequest.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    setUp(() async {
      await Emails.createUser(session, userName, email, password);
    });

    test('when inspecting password hash then password is not hashed', () async {
      var emailAuth = await EmailAuth.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );

      expect(
        emailAuth,
        isNotNull,
        reason: 'Failed to find create account',
      );
      var passwordHash = emailAuth!.hash;

      expect(
        passwordHash,
        password,
        reason: 'Password hash is not the same as password',
      );
    });

    test('then user can authenticate', () async {
      var authResponse = await Emails.authenticate(session, email, password);
      expect(authResponse.success, isTrue,
          reason: 'Failed to authenticate user.');
    });
  });

  group(
      'Given custom hash generator and a stored legacy password in the database',
      () {
    var userName = 'test';
    var email = 'test@serverpod.dev';
    var password = 'hunter2';
    var legacyHash =
        '0713234b3cb6a6f98f6978f17a55a54578c580698dc1d56371502be6abb457eb';

    tearDown(() async {
      await Future.wait([
        UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        EmailAuth.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        UserImage.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      ]);
    });

    setUp(() async {
      await Emails.createUser(session, userName, email, password);
      var entry = await EmailAuth.db
          .findFirstRow(session, where: (t) => t.email.equals(email));
      assert(entry != null, 'Failed to find email auth entry');
      var withLegacyHash = entry!.copyWith(
        // Legacy hash of the password 'hunter2'
        hash: legacyHash,
      );
      await EmailAuth.db.updateRow(session, withLegacyHash);
    });

    test('then user can authenticate', () async {
      var authResponse = await Emails.authenticate(session, email, password);
      expect(authResponse.success, isTrue,
          reason: 'Failed to authenticate user.');
    });

    test('then hash is not migrated.', () async {
      await Emails.authenticate(session, email, password);
      var emailAuth = await EmailAuth.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );
      expect(
        emailAuth,
        isNotNull,
        reason: 'Failed to find email auth entry for user.',
      );

      var passwordHash = emailAuth!.hash;
      expect(
        passwordHash,
        legacyHash,
        reason: 'Password hash was migrated to Argon2id.',
      );
    });
  });
}
