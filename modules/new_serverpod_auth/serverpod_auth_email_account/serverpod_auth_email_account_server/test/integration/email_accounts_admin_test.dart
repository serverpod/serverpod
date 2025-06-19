import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a pending account request,',
      (final sessionBuilder, final endpoints) {
    const email = 'test@serverpod.dev';
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      await EmailAccounts.startAccountCreation(
        session,
        email: email,
        password: 'Yolo12345!',
      );
    });

    test(
        'when `deleteExpiredAccountCreations` is called before the verification period has elapsed, '
        'then the account request is preserved.', () async {
      await EmailAccounts.admin.deleteExpiredAccountCreations(session);

      expect(
        await EmailAccountRequest.db.count(session),
        1,
      );
    });

    test(
        'when `deleteExpiredAccountCreations` is called after the verification period has elapsed, '
        'then the account request is deleted.', () async {
      await withClock(
        Clock.fixed(DateTime.now()
            .add(EmailAccounts.config.registrationVerificationCodeLifetime)),
        () => EmailAccounts.admin.deleteExpiredAccountCreations(session),
      );

      expect(
        await EmailAccountRequest.db.count(session),
        0,
      );
    });

    test(
      'when calling `findAccount`, it does not return an account.',
      () async {
        expect(
          await EmailAccounts.admin.findAccount(session, email: email),
          isNull,
        );
      },
    );

    test(
      'when calling `setPassword`, it fails as it only works on fully created accounts.',
      () async {
        await expectLater(
          () => EmailAccounts.admin.setPassword(
            session,
            email: email,
            password: 'Asdf123456!',
          ),
          throwsA(isA<EmailAccountNotFoundException>()),
        );
      },
    );
  });

  withServerpod(
    'Given an existing account,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;
        await createVerifiedEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: 'Yolo1234!',
        );
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
        'when calling `findAccount`, it does return the account.',
        () async {
          expect(
            await EmailAccounts.admin.findAccount(session, email: email),
            isNotNull,
          );
        },
      );

      test(
        'when calling `setPassword`, it succeeds.',
        () async {
          const newPassword = 'short1';
          await EmailAccounts.admin.setPassword(
            session,
            email: email,
            password: newPassword,
          );

          expect(
            await EmailAccounts.login(
              session,
              email: email,
              password: newPassword,
            ),
            authUserId,
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given an existing account created with `createEmailAuthentication`,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const password = 'short1';

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        await EmailAccounts.admin.createEmailAuthentication(
          session,
          authUserId: authUser.id,
          email: email,
          password: password,
        );
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
        'when calling `findAccount`, it does return the account.',
        () async {
          final account = await EmailAccounts.admin.findAccount(
            session,
            email: email,
          );

          expect(account?.authUserId, authUserId);
        },
      );

      test(
        'when calling `EmailAccounts.login`, it works right away (without verification).',
        () async {
          expect(
            await EmailAccounts.login(
              session,
              email: email,
              password: password,
            ),
            authUserId,
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given an existing account with a pending password reset request,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        await createVerifiedEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: 'Yolo1234!',
        );

        await EmailAccounts.startPasswordReset(session, email: email);
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when `deleteExpiredPasswordResetRequests` is called before the verification period has elapsed, then the password reset is kept.',
          () async {
        await EmailAccounts.admin.deleteExpiredPasswordResetRequests(session);

        expect(
          await EmailAccountPasswordResetRequest.db.count(session),
          1,
        );
      });

      test(
          'when `deleteExpiredPasswordResetRequests` is called after the verification period has elapsed, then the password reset is deleted.',
          () async {
        await withClock(
          Clock.fixed(DateTime.now()
              .add(EmailAccounts.config.passwordResetVerificationCodeLifetime)),
          () => EmailAccounts.admin.deleteExpiredPasswordResetRequests(session),
        );

        expect(
          await EmailAccountPasswordResetRequest.db.count(session),
          0,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given an existing account with a pending password reset with one failed attempt,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        await createVerifiedEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: 'Yolo1234!',
        );

        final resetRequest = await requestPasswordReset(session, email: email);

        try {
          await EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: resetRequest.$1,
            verificationCode: '----------',
            newPassword: 'Asdf987654!',
          );
        } catch (_) {
          // error expect due to invalid verification code
        }
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when `deletePasswordResetAttempts` is called before the verification period has elapsed, then the password reset attempt is kept.',
          () async {
        await EmailAccounts.admin.deletePasswordResetAttempts(session);

        expect(
          await EmailAccountPasswordResetAttempt.db.count(session),
          1,
        );
      });

      test(
          'when `deletePasswordResetAttempts` is called after the verification period has elapsed, then the password reset attempt is deleted.',
          () async {
        await withClock(
          Clock.fixed(DateTime.now()
              .add(EmailAccounts.config.maxPasswordResetAttempts.timeframe)),
          () => EmailAccounts.admin.deletePasswordResetAttempts(session),
        );

        expect(
          await EmailAccountPasswordResetAttempt.db.count(session),
          0,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a failed login attempt,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        try {
          await EmailAccounts.login(
            session,
            email: '404@serverpod.dev',
            password: 'Asdf123ll!',
          );
        } catch (_) {
          // error expect due to invalid credentials
        }
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when `deleteFailedLoginAttempts` is called before throttling period has elapsed, then the failed login attempt attempt is kept.',
          () async {
        await EmailAccounts.admin.deleteFailedLoginAttempts(session);

        expect(
          await EmailAccountFailedLoginAttempt.db.count(session),
          1,
        );
      });

      test(
          'when `deleteFailedLoginAttempts` is called after the throttling period has elapsed, then the failed login attempt is deleted.',
          () async {
        await withClock(
          Clock.fixed(DateTime.now()
              .add(EmailAccounts.config.failedLoginRateLimit.timeframe)),
          () => EmailAccounts.admin.deleteFailedLoginAttempts(session),
        );

        expect(
          await EmailAccountFailedLoginAttempt.db.count(session),
          0,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );
}
