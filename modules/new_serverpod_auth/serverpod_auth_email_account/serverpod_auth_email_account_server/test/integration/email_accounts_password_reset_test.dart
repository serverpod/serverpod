import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when requesting a reset for a non-existent email, it returns "email does not exist" status (for internal use).',
          () async {
        final result = await EmailAccounts.startPasswordReset(
          session,
          email: '404@serverpod.dev',
        );

        expect(result, PasswordResetResult.emailDoesNotExist);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a registered email account,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      const password = 'asdf1234';
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        await createVerifiedEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
        );
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when requesting a password reset for the account, then the process ID and verification code are given to the configured callback.',
          () async {
        UuidValue? receivedPasswordResetRequestId;
        String? receivedVerificationCode;
        EmailAccounts.config = EmailAccountConfig(
          sendPasswordResetVerificationCode: (
            final session, {
            required final email,
            required final passwordResetRequestId,
            required final verificationCode,
            required final transaction,
          }) {
            receivedPasswordResetRequestId = passwordResetRequestId;
            receivedVerificationCode = verificationCode;
          },
        );

        await EmailAccounts.startPasswordReset(
          session,
          email: email.toUpperCase(),
        );

        expect(receivedPasswordResetRequestId, isNotNull);
        expect(receivedVerificationCode, isNotNull);
      });

      test('when requesting too many password resets, then an error is thrown.',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          maxPasswordResetAttempts: (
            maxAttempts: 1,
            timeframe: const Duration(hours: 1)
          ),
        );

        await EmailAccounts.startPasswordReset(
          session,
          email: email,
        );

        await expectLater(
          () => EmailAccounts.startPasswordReset(
            session,
            email: email.toUpperCase(),
          ),
          throwsA(
            isA<EmailAccountPasswordResetRequestTooManyAttemptsException>(),
          ),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a pending password reset request,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      const password = 'asdf1234';
      late Session session;
      late UuidValue authUserId;
      late UuidValue paswordResetRequestId;
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        await createVerifiedEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
        );

        (paswordResetRequestId, verificationCode) = await requestPasswordReset(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when changing the password with the correct verification code, then it returns the auth user ID.',
          () async {
        final result = await EmailAccounts.completePasswordReset(
          session,
          passwordResetRequestId: paswordResetRequestId,
          verificationCode: verificationCode,
          newPassword: '1234asdf!!!',
        );

        expect(result, authUserId);
      });

      test(
          'when changing the password with an incorrect verification code, then it fails with different errors for "wrong code" and "allowed attempts exhausted" and from then on with "not found".',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          passwordResetVerificationCodeAllowedAttempts: 1,
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: paswordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailAccountPasswordResetRequestUnauthorizedException>()),
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: paswordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailAccountPasswordResetTooManyAttemptsException>()),
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: paswordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailAccountPasswordResetRequestNotFoundException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a completed password reset,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      const oldPassword = 'old123456';
      const newPassword = 'new1234!';
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        await createVerifiedEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: oldPassword,
        );

        await resetPassword(
          session,
          email: email,
          newPassword: newPassword,
        );
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test('when using the new credentials for the login, then it succeeds.',
          () async {
        final userId = await EmailAccounts.login(
          session,
          email: email,
          password: newPassword,
        );

        expect(userId, authUserId);
      });

      test('when using the old credentials for the login, then it fails.',
          () async {
        await expectLater(
          () => EmailAccounts.login(
            session,
            email: email,
            password: oldPassword,
          ),
          throwsA(
            isA<EmailAccountLoginException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountLoginFailureReason.invalidCredentials,
            ),
          ),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );
}
