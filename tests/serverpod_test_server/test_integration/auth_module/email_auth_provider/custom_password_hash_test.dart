import 'package:serverpod_auth_server/module.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  AuthConfig.set(
    AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        print('Sending validation email to $email with code $validationCode');
        return true;
      },
      passwordHashValidator:
          ({
            required password,
            required email,
            required hash,
            onError,
            onValidationFailure,
          }) async =>
              // Always return true to allow the test to proceed
              PasswordValidationSuccess(),
      // Custom password hash generator that does not hash the password
      passwordHashGenerator: (password) async => password,
      extraSaltyHash: false,
    ),
  );

  withServerpod(
    'Given a custom non-hashing password hash generator and a create account request',
    (sessionBuilder, _) {
      var session = sessionBuilder.build();
      var userName = 'test';
      var email = 'test8@serverpod.dev';
      var password = 'password';

      setUp(() async {
        await Emails.createAccountRequest(session, userName, email, password);
      });

      test(
        'when inspecting password hash then password is not hashed',
        () async {
          var emailAuth = await EmailCreateAccountRequest.db.findFirstRow(
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
        },
      );
    },
  );

  withServerpod(
    'Given a custom always true password hash validator and a created user',
    (sessionBuilder, _) {
      var session = sessionBuilder.build();
      var userName = 'test';
      var email = 'test8@serverpod.dev';
      var password = 'password';

      setUp(() async {
        await Emails.createUser(session, userName, email, password);
      });

      test(
        'when authenticating with incorrect password then user can authenticate',
        () async {
          var incorrectPassword = '$password-incorrect';
          var authResponse = await Emails.authenticate(
            session,
            email,
            incorrectPassword,
          );
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );
        },
      );
    },
  );

  withServerpod(
    'Given custom hash generator and a stored legacy password in the database',
    (sessionBuilder, _) {
      var session = sessionBuilder.build();
      var userName = 'test';
      var email = 'test@serverpod.dev';
      var password = 'hunter2';
      // Legacy hash of the password 'hunter2'
      var legacyHash =
          '0713234b3cb6a6f98f6978f17a55a54578c580698dc1d56371502be6abb457eb';

      setUp(() async {
        await Emails.createUser(session, userName, email, password);
        var entry = await EmailAuth.db.findFirstRow(
          session,
          where: (t) => t.email.equals(email),
        );
        assert(entry != null, 'Failed to find email auth entry');
        var withLegacyHash = entry!.copyWith(
          // Legacy hash of the password 'hunter2'
          hash: legacyHash,
        );
        await EmailAuth.db.updateRow(session, withLegacyHash);
      });

      test('when authenticating then hash is not migrated.', () async {
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
          reason: 'Password hash was altered during authentication.',
        );
      });
    },
  );
}
