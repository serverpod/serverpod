import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an empty environment,',
      (final sessionBuilder, final endpoints) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
    });

    tearDown(() {
      EmailAccountConfig.current = EmailAccountConfig();
    });

    test(
        'when trying to create a new account with a short password, '
        'then an error is thrown for short passwords.', () async {
      await expectLater(
        () => EmailAccounts.requestAccount(
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
      EmailAccountConfig.current = EmailAccountConfig(
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

      final result = await EmailAccounts.requestAccount(
        session,
        email: 'test123@serverpod.dev',
        password: 'Abc1234!',
      );

      expect(receivedAccountRequestId, isNotNull);
      expect(receivedVerificationCode, isNotNull);

      expect(result.result, EmailAccountRequestResult.accountRequestCreated);
      expect(result.accountRequestId, receivedAccountRequestId);
    });
  });

  withServerpod('Given a pending email account request,',
      (final sessionBuilder, final endpoints) {
    const email = 'Test1@serverpod.dev';
    late Session session;
    late UuidValue pendingAccountRequestId;
    late String pendingAccountVerificationCode;

    setUp(() async {
      session = sessionBuilder.build();

      EmailAccountConfig.current = EmailAccountConfig(
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

      await EmailAccounts.requestAccount(
        session,
        email: email,
        password: 'Abc1234!',
      );

      EmailAccountConfig.current = EmailAccountConfig();
    });

    test(
        'when requesting a new account for the same email address, then it fails with an "already requested" error.',
        () async {
      final result = await EmailAccounts.requestAccount(
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
      final result = await EmailAccounts.requestAccount(
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
      final result = await EmailAccounts.verifyAccountRequest(
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
      final result = await EmailAccounts.verifyAccountRequest(
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

      final result = await EmailAccounts.createAccount(
        session,
        authUserId: authUser.id!,
        accountRequestId: pendingAccountRequestId,
        verificationCode: pendingAccountVerificationCode,
      );

      expect(result.email, email.toLowerCase());
    });
  });

  withServerpod('Given a registered email account,',
      (final sessionBuilder, final endpoints) {
    const email = 'Test1@serverpod.dev';
    const password = 'asdf1234';
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
        password: password,
      );
    });

    tearDown(() {
      EmailAccountConfig.current = EmailAccountConfig();
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
        'when logging in with an invalid password, then it throws a `EmailAccountLoginException`.',
        () async {
      await expectLater(
        () => EmailAccounts.login(
          session,
          email: email,
          password: 'some other password',
        ),
        throwsA(isA<EmailAccountLoginException>()),
      );
    });

    test(
        'when attempting to create a new account using the same email in upper case, then it fails.',
        () async {
      final result = await EmailAccounts.requestAccount(
        session,
        email: email.toUpperCase(),
        password: password,
      );

      expect(result.result, EmailAccountRequestResult.emailAlreadyRegistered);
    });

    test(
        'when requesting a password reset for the account, then the process ID and verification code are given to the configured callback.',
        () async {
      UuidValue? receivedPasswordResetRequestId;
      String? receivedVerificationCode;
      EmailAccountConfig.current = EmailAccountConfig(
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

      await EmailAccounts.requestPasswordReset(
        session,
        email: email.toUpperCase(),
      );

      expect(receivedPasswordResetRequestId, isNotNull);
      expect(receivedVerificationCode, isNotNull);
    });
  });

  withServerpod('Given a pending password reset request,',
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

    test(
        'when verifying the password reset with the correct code, then it succeeds.',
        () async {
      final result = await EmailAccounts.verifyPasswordResetRequest(
        session,
        passwordResetRequestId: paswordResetRequestId,
        verificationCode: verificationCode,
      );

      expect(result, isTrue);
    });

    test(
        'when verifying the password reset with an incorrect code, then it fails.',
        () async {
      final result = await EmailAccounts.verifyPasswordResetRequest(
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
        'when changing the password with an incorrect verification code, then it fails.',
        () async {
      await expectLater(
        () => EmailAccounts.completePasswordReset(
          session,
          passwordResetRequestId: paswordResetRequestId,
          verificationCode: 'wrong',
          newPassword: '1234asdf!!!',
        ),
        throwsA(isA<EmailAccountPasswordResetRequestUnauthorizedException>()),
      );
    });
  });
}

Future<void> _createEmailAccount(
  final Session session, {
  required final UuidValue authUserId,
  required final String email,
  required final String password,
}) async {
  late UuidValue pendingAccountRequestId;
  late String pendingAccountVerificationCode;
  EmailAccountConfig.current = EmailAccountConfig(
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

  await EmailAccounts.requestAccount(
    session,
    email: email,
    password: password,
  );

  await EmailAccounts.createAccount(
    session,
    authUserId: authUserId,
    accountRequestId: pendingAccountRequestId,
    verificationCode: pendingAccountVerificationCode,
  );

  EmailAccountConfig.current = EmailAccountConfig();
}

Future<(UuidValue paswordResetRequestId, String verificationCode)>
    _requestPasswordReset(
  final Session session, {
  required final String email,
}) async {
  late UuidValue pendingPasswordResetRequestId;
  late String pendingPasswordResetVerificationCode;
  EmailAccountConfig.current = EmailAccountConfig(
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

  await EmailAccounts.requestPasswordReset(
    session,
    email: email,
  );

  EmailAccountConfig.current = EmailAccountConfig();

  return (pendingPasswordResetRequestId, pendingPasswordResetVerificationCode);
}
