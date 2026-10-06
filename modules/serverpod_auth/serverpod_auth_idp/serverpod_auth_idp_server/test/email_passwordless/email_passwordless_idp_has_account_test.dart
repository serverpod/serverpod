import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an unauthenticated session',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      test('when hasAccount is called then it returns false.', () async {
        final fixture = EmailPasswordlessIdpTestFixture();

        expect(await fixture.idp.hasAccount(sessionBuilder.build()), isFalse);
      });
    },
  );

  withServerpod(
    'Given an authenticated session',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session setupSession;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue authUserId;

      setUp(() async {
        setupSession = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        authUserId = (await fixture.authUsers.create(setupSession)).id;
      });

      tearDown(() async {
        await fixture.tearDown(setupSession);
      });

      Session authenticatedSession() => sessionBuilder
          .copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId.uuid,
              {},
            ),
          )
          .build();

      test(
        'when the user has no email account then hasAccount returns false.',
        () async {
          expect(await fixture.idp.hasAccount(authenticatedSession()), isFalse);
        },
      );

      test(
        'when the user has an account without a password then hasAccount returns true.',
        () async {
          await fixture.createEmailAccount(
            setupSession,
            authUserId: authUserId,
            email: 'test@serverpod.dev',
          );

          expect(await fixture.idp.hasAccount(authenticatedSession()), isTrue);
        },
      );

      test(
        'when the user has an account with a password then hasAccount returns true.',
        () async {
          await fixture.createEmailAccount(
            setupSession,
            authUserId: authUserId,
            email: 'test@serverpod.dev',
            passwordHash: r'$argon2id$hash',
          );

          expect(await fixture.idp.hasAccount(authenticatedSession()), isTrue);
        },
      );
    },
  );
}
