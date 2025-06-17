import 'package:clock/clock.dart';
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
          'when trying to create a new account with a short password, '
          'then an error is thrown for short passwords.', () async {
        await expectLater(
          () => EmailAccounts.startAccountCreation(
            session,
            email: 'test@serverpod.dev',
            password: 'short',
          ),
          throwsA(isA<EmailAccountPasswordPolicyViolationException>()),
        );
      });

      test(
          'when requesting a new account, '
          'then the configured callback is invoked with a valid process ID and verification code.',
          () async {
        UuidValue? receivedAccountRequestId;
        String? receivedVerificationCode;
        EmailAccounts.config = EmailAccountConfig(
          sendRegistrationVerificationCode: (
            final session, {
            required final email,
            required final accountRequestId,
            required final verificationCode,
            required final transaction,
          }) {
            receivedAccountRequestId = accountRequestId;
            receivedVerificationCode = verificationCode;
          },
        );

        final result = await EmailAccounts.startAccountCreation(
          session,
          email: 'test123@serverpod.dev',
          password: 'Abc1234!',
        );

        expect(receivedAccountRequestId, isNotNull);
        expect(receivedVerificationCode, isNotNull);

        expect(result.result, EmailAccountRequestResult.accountRequestCreated);
        expect(result.accountRequestId, receivedAccountRequestId);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a pending email account request,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      late Session session;
      late UuidValue pendingAccountRequestId;
      late String pendingAccountVerificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        EmailAccounts.config = EmailAccountConfig(
          sendRegistrationVerificationCode: (
            final session, {
            required final email,
            required final accountRequestId,
            required final verificationCode,
            required final transaction,
          }) {
            pendingAccountRequestId = accountRequestId;
            pendingAccountVerificationCode = verificationCode;
          },
        );

        await EmailAccounts.startAccountCreation(
          session,
          email: email,
          password: 'Abc1234!',
        );

        EmailAccounts.config = EmailAccountConfig();
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when requesting a new account for the same email address, then it fails with an "already requested" error.',
          () async {
        final result = await EmailAccounts.startAccountCreation(
          session,
          email: email,
          password: '1223456789',
        );

        expect(
          result.result,
          EmailAccountRequestResult.emailAlreadyRequested,
        );
        expect(result.accountRequestId, isNull);
      });

      test(
          'when requesting a new account for the same email address in all lower-case, then it fails with an "already requested" error.',
          () async {
        final result = await EmailAccounts.startAccountCreation(
          session,
          email: email.toLowerCase(),
          password: '1223456789',
        );

        expect(
          result.result,
          EmailAccountRequestResult.emailAlreadyRequested,
        );
        expect(result.accountRequestId, isNull);
      });

      test(
          'when verifying the account request with the correct code, then it passes and returns the associated email.',
          () async {
        final result = await EmailAccounts.verifyAccountCreation(
          session,
          accountRequestId: pendingAccountRequestId,
          verificationCode: pendingAccountVerificationCode,
        );

        expect(result.emailAccountRequestId, pendingAccountRequestId);
        expect(result.email, email.toLowerCase());
      });

      test(
          'when verifying the account request with an incorrect code, then it throw a `EmailAccountRequestUnauthorizedException`.',
          () async {
        await expectLater(
          () => EmailAccounts.verifyAccountCreation(
            session,
            accountRequestId: pendingAccountRequestId,
            verificationCode: 'some invalid code',
          ),
          throwsA(isA<EmailAccountRequestUnauthorizedException>()),
        );
      });

      test(
          'when verifying the account request after it has expired, then it throw a `EmailAccountRequestExpiredException`.',
          () async {
        await expectLater(
          () => withClock(
            Clock.fixed(DateTime.now().add(
                EmailAccounts.config.registrationVerificationCodeLifetime)),
            () => EmailAccounts.verifyAccountCreation(
              session,
              accountRequestId: pendingAccountRequestId,
              verificationCode: pendingAccountVerificationCode,
            ),
          ),
          throwsA(isA<EmailAccountRequestExpiredException>()),
        );
      });

      test(
          'when verifying the account request with an invalid verification code, then fails with the correct error for each try.',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          registrationVerificationCodeAllowedAttempts: 1,
        );

        await expectLater(
          () => EmailAccounts.verifyAccountCreation(
            session,
            accountRequestId: pendingAccountRequestId,
            verificationCode: 'wrong code',
          ),
          throwsA(isA<EmailAccountRequestUnauthorizedException>()),
        );

        await expectLater(
          () => EmailAccounts.verifyAccountCreation(
            session,
            accountRequestId: pendingAccountRequestId,
            verificationCode: 'wrong code',
          ),
          throwsA(isA<EmailAccountRequestTooManyAttemptsException>()),
        );

        await expectLater(
          () => EmailAccounts.verifyAccountCreation(
            session,
            accountRequestId: pendingAccountRequestId,
            verificationCode: 'wrong code',
          ),
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });

      test(
          'when creating an account from the unverified request, then it fails.',
          () async {
        final authUser = await createAuthUser(session);

        await expectLater(
          () => EmailAccounts.completeAccountCreation(
            session,
            authUserId: authUser.id,
            accountRequestId: pendingAccountRequestId,
          ),
          throwsA(isA<EmailAccountRequestNotVerifiedException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );

  withServerpod(
    'Given a verified email account request,',
    (final sessionBuilder, final endpoints) {
      const email = 'Test1@serverpod.dev';
      late Session session;
      late UuidValue pendingAccountRequestId;

      setUp(() async {
        session = sessionBuilder.build();

        late final String pendingAccountVerificationCode;
        EmailAccounts.config = EmailAccountConfig(
          sendRegistrationVerificationCode: (
            final session, {
            required final email,
            required final accountRequestId,
            required final verificationCode,
            required final transaction,
          }) {
            pendingAccountRequestId = accountRequestId;
            pendingAccountVerificationCode = verificationCode;
          },
        );

        await EmailAccounts.startAccountCreation(
          session,
          email: email,
          password: 'Abc1234!',
        );

        await EmailAccounts.verifyAccountCreation(
          session,
          accountRequestId: pendingAccountRequestId,
          verificationCode: pendingAccountVerificationCode,
        );

        EmailAccounts.config = EmailAccountConfig();
      });

      tearDown(() async {
        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when creating an account from the verified request, then it succeeds.',
          () async {
        final authUser = await createAuthUser(session);

        final result = await EmailAccounts.completeAccountCreation(
          session,
          authUserId: authUser.id,
          accountRequestId: pendingAccountRequestId,
        );

        expect(result.email, email.toLowerCase());
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
      late ({
        UuidValue accountRequestId,
        String verificationCode,
      }) accountCreationParameters;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await createAuthUser(session);
        authUserId = authUser.id;

        final accountCreationDetails = await createVerifiedEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
        );

        accountCreationParameters = (
          accountRequestId: accountCreationDetails.accountRequestId,
          verificationCode: accountCreationDetails.verificationCode,
        );
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await cleanUpEmailAccountDatabaseEntities(session);
      });

      test(
          'when attempting to create a new account using the same email in upper case, then it fails.',
          () async {
        final result = await EmailAccounts.startAccountCreation(
          session,
          email: email.toUpperCase(),
          password: password,
        );

        expect(result.result, EmailAccountRequestResult.emailAlreadyRegistered);
      });

      test(
          'when attempting to create the account again with same account request data, then it fails.',
          () async {
        await expectLater(
          () => EmailAccounts.verifyAccountCreation(
            session,
            accountRequestId: accountCreationParameters.accountRequestId,
            verificationCode: accountCreationParameters.verificationCode,
          ),
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
  );
}
