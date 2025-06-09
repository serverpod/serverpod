import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a pending account request,',
      (final sessionBuilder, final endpoints) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();

      await EmailAccounts.startAccountCreation(
        session,
        email: 'test@serverpod.dev',
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
  });

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
          authUserId: authUser.id!,
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
          authUserId: authUser.id!,
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
  );
}
