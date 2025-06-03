import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

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

        await _cleanUpdatabaseEntities(session);
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
          sendRegistrationVerificationMail: (
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

      test(
          'when requesting a reset for a non-existent email, it returns "email does not exist" status.',
          () async {
        final result = await EmailAccounts.startPasswordReset(
          session,
          email: '404@serverpod.dev',
        );

        expect(result, PasswordResetResult.emailDoesNotExist);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
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
          sendRegistrationVerificationMail: (
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
        await _cleanUpdatabaseEntities(session);
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

        expect(result, isNotNull);
        expect(result?.emailAccountRequestId, pendingAccountRequestId);
        expect(result?.email, email.toLowerCase());
      });

      test(
          'when verifying the account request with an incorrect code, then it returns `null`.',
          () async {
        final result = await EmailAccounts.verifyAccountCreation(
          session,
          accountRequestId: pendingAccountRequestId,
          verificationCode: 'some invalid code',
        );

        expect(result, isNull);
      });

      test('when creating an account from the request, then it succeeds.',
          () async {
        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );

        final result = await EmailAccounts.completeAccountCreation(
          session,
          authUserId: authUser.id!,
          accountRequestId: pendingAccountRequestId,
          verificationCode: pendingAccountVerificationCode,
        );

        expect(result.email, email.toLowerCase());
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
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

        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        authUserId = authUser.id!;

        final accountCreationDetails = await _createEmailAccount(
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

        await _cleanUpdatabaseEntities(session);
      });

      test('when logging in with the original credentials, then it succeeds.',
          () async {
        final loggedInUser = await EmailAccounts.login(
          session,
          email: email,
          password: password,
        );

        expect(loggedInUser, authUserId);
      });

      test(
          'when logging in with the lower-case email variant of the credentials, then it succeeds.',
          () async {
        final loggedInUser = await EmailAccounts.login(
          session,
          email: email.toLowerCase(),
          password: password,
        );

        expect(loggedInUser, authUserId);
      });

      test(
          'when logging in with an invalid password, then it throws a `EmailAccountLoginException` initially with `invalidCredentials` and then blocks further attempts with `tooManyAttempts`.',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          maxAllowedEmailSignInAttempts: 1,
        );

        await expectLater(
          () => EmailAccounts.login(
            session,
            email: email,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.invalidCredentials,
          )),
        );

        await expectLater(
          () => EmailAccounts.login(
            session,
            email: email,
            password: 'some other password',
          ),
          throwsA(isA<EmailAccountLoginException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountLoginFailureReason.tooManyAttempts,
          )),
        );
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
          () => EmailAccounts.completeAccountCreation(
            session,
            authUserId: authUserId,
            accountRequestId: accountCreationParameters.accountRequestId,
            verificationCode: accountCreationParameters.verificationCode,
          ),
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });

      test(
          'when requesting a password reset for the account, then the process ID and verification code are given to the configured callback.',
          () async {
        UuidValue? receivedPasswordResetRequestId;
        String? receivedVerificationCode;
        EmailAccounts.config = EmailAccountConfig(
          sendPasswordResetMail: (
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

        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        authUserId = authUser.id!;

        await _createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: password,
        );

        (paswordResetRequestId, verificationCode) = await _requestPasswordReset(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await _cleanUpdatabaseEntities(session);
      });

      test(
          'when verifying the password reset with the correct code, then it succeeds.',
          () async {
        final result = await EmailAccounts.verifyPasswordReset(
          session,
          passwordResetRequestId: paswordResetRequestId,
          verificationCode: verificationCode,
        );

        expect(result, isTrue);
      });

      test(
          'when verifying the password reset with an incorrect code, then it fails.',
          () async {
        final result = await EmailAccounts.verifyPasswordReset(
          session,
          passwordResetRequestId: paswordResetRequestId,
          verificationCode: 'asdf1234',
        );

        expect(result, isFalse);
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
          'when changing the password with an incorrect verification code, then it fails with different errors for "wrong code" and "allowed attempts exhausted".',
          () async {
        EmailAccounts.config = EmailAccountConfig(
          passwordResetCodeAllowedAttempts: 1,
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
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
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

        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        authUserId = authUser.id!;

        await _createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: oldPassword,
        );

        await _resetPassword(
          session,
          email: email,
          newPassword: newPassword,
        );
      });

      tearDown(() async {
        await _cleanUpdatabaseEntities(session);
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
            isA<EmailAccountLoginException>().having((final e) => e.reason,
                'reason', EmailAccountLoginFailureReason.invalidCredentials),
          ),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

Future<
    ({
      UuidValue accountRequestId,
      String verificationCode,
      UuidValue emailAccountId,
    })> _createEmailAccount(
  final Session session, {
  required final UuidValue authUserId,
  required final String email,
  required final String password,
}) async {
  late UuidValue pendingAccountRequestId;
  late String pendingAccountVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendRegistrationVerificationMail: (
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
    password: password,
  );

  final creationResult = await EmailAccounts.completeAccountCreation(
    session,
    authUserId: authUserId,
    accountRequestId: pendingAccountRequestId,
    verificationCode: pendingAccountVerificationCode,
  );

  EmailAccounts.config = EmailAccountConfig();

  return (
    accountRequestId: pendingAccountRequestId,
    verificationCode: pendingAccountVerificationCode,
    emailAccountId: creationResult.emailAccountId,
  );
}

Future<(UuidValue paswordResetRequestId, String verificationCode)>
    _requestPasswordReset(
  final Session session, {
  required final String email,
}) async {
  late UuidValue pendingPasswordResetRequestId;
  late String pendingPasswordResetVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendPasswordResetMail: (
      final session, {
      required final email,
      required final passwordResetRequestId,
      required final transaction,
      required final verificationCode,
    }) {
      pendingPasswordResetRequestId = passwordResetRequestId;
      pendingPasswordResetVerificationCode = verificationCode;
    },
  );

  await EmailAccounts.startPasswordReset(
    session,
    email: email,
  );

  EmailAccounts.config = EmailAccountConfig();

  return (pendingPasswordResetRequestId, pendingPasswordResetVerificationCode);
}

Future<void> _resetPassword(
  final Session session, {
  required final String email,
  required final String newPassword,
}) async {
  late UuidValue pendingPasswordResetRequestId;
  late String pendingPasswordResetVerificationCode;
  EmailAccounts.config = EmailAccountConfig(
    sendPasswordResetMail: (
      final session, {
      required final email,
      required final passwordResetRequestId,
      required final transaction,
      required final verificationCode,
    }) {
      pendingPasswordResetRequestId = passwordResetRequestId;
      pendingPasswordResetVerificationCode = verificationCode;
    },
  );

  await EmailAccounts.startPasswordReset(
    session,
    email: email,
  );

  EmailAccounts.config = EmailAccountConfig();

  await EmailAccounts.completePasswordReset(
    session,
    passwordResetRequestId: pendingPasswordResetRequestId,
    verificationCode: pendingPasswordResetVerificationCode,
    newPassword: newPassword,
  );
}

Future<void> _cleanUpdatabaseEntities(final Session session) async {
  await AuthUser.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountRequest.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountFailedLoginAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountPasswordResetAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );

  await EmailAccountRequestCompletionAttempt.db.deleteWhere(
    session,
    where: (final t) => Constant.bool(true),
  );
}
