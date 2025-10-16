import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils.dart';

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

        expect(result.result, PasswordResetResult.emailDoesNotExist);
        expect(result.passwordResetRequestId, isNull);
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

        final result = await EmailAccounts.startPasswordReset(
          session,
          email: email.toUpperCase(),
        );

        expect(receivedPasswordResetRequestId, isNotNull);
        expect(receivedVerificationCode, isNotNull);

        expect(result.result, PasswordResetResult.passwordResetSent);
        expect(result.passwordResetRequestId, receivedPasswordResetRequestId);
      });

      test(
          'when requesting too many password resets, '
          'then it throws a "too many attempts" exception.', () async {
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
          throwsA(isA<EmailPasswordResetTooManyAttemptsException>()),
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
      late UuidValue passwordResetRequestId;
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

        (passwordResetRequestId, verificationCode) = await requestPasswordReset(
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
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          newPassword: '1234asdf!!!',
        );

        expect(result, authUserId);
      });

      test(
          'when completing a password reset after the associated account was deleted, '
          'then it throws an "reset not found" exception.', () async {
        final account = await EmailAccount.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        );

        if (account != null) {
          await EmailAccount.db.deleteRow(
            session,
            account,
          );
        }

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
        );
      });

      test(
          'when completing a password reset with a password that violates policy, '
          'then it throws a "password policy violation" exception regardless of the verification code.',
          () async {
        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong',
            newPassword: 'short',
          ),
          throwsA(isA<EmailPasswordResetPasswordPolicyViolationException>()),
        );
      });

      test(
          'when trying to complete an expired password reset request with the correct verification code'
          'then it throws an "expired" exception.', () async {
        await expectLater(
          () => withClock(
            Clock.fixed(DateTime.now().add(
                EmailAccounts.config.passwordResetVerificationCodeLifetime)),
            () => EmailAccounts.completePasswordReset(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: verificationCode,
              newPassword: '1234asdf!!!',
            ),
          ),
          throwsA(isA<EmailPasswordResetRequestExpiredException>()),
        );
      });

      test(
          'when trying to complete an expired password reset request with the wrong verification code'
          'then it throws an "invalid verification code" exception to not leak that the request exists.',
          () async {
        await expectLater(
          () => withClock(
            Clock.fixed(DateTime.now().add(
                EmailAccounts.config.passwordResetVerificationCodeLifetime)),
            () => EmailAccounts.completePasswordReset(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong',
              newPassword: '1234asdf!!!',
            ),
          ),
          throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
        );
      });

      test(
          'when changing the password with an incorrect verification code, '
          'then it throws a "too many attempts" on the second attempt and "not found" on the next ones. ',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          passwordResetVerificationCodeAllowedAttempts: 1,
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(
              isA<EmailPasswordResetTooManyVerificationAttemptsException>()),
        );

        await expectLater(
          () => EmailAccounts.completePasswordReset(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong',
            newPassword: '1234asdf!!!',
          ),
          throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
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

      test(
          'when using the new credentials for an authentication, then it succeeds.',
          () async {
        final userId = await EmailAccounts.authenticate(
          session,
          email: email,
          password: newPassword,
        );

        expect(userId, authUserId);
      });

      test(
          'when using the old credentials for the login, '
          'then it throws an "invalid credentials" exception.', () async {
        await expectLater(
          () => EmailAccounts.authenticate(
            session,
            email: email,
            password: oldPassword,
          ),
          throwsA(isA<EmailAuthenticationInvalidCredentialsException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );
}
