import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../util/test_tags.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no users,',
    (final sessionBuilder, final endpoints) {
      tearDown(() {
        EmailAccounts.config = EmailAccountConfig();
      });

      group('when calling `startRegistration`', () {
        late UuidValue receivedAccountRequestId;
        late UuidValue clientReceivedRequestId;
        String? receivedVerificationCode;

        EmailAccounts.config = EmailAccountConfig(
          sendRegistrationVerificationCode: (
            final session, {
            required final accountRequestId,
            required final email,
            required final transaction,
            required final verificationCode,
          }) {
            receivedVerificationCode = verificationCode;
            receivedAccountRequestId = accountRequestId;
          },
        );

        setUpAll(() async {
          clientReceivedRequestId =
              await endpoints.emailAccount.startRegistration(
            sessionBuilder,
            email: _getNewTestEmail(),
            password: 'Foobar123!',
          );
        });

        test('then the verification information is sent out.', () async {
          expect(receivedVerificationCode, isNotNull);
          expect(receivedAccountRequestId, isNotNull);
        });

        test('then the client received correct request id. ', () async {
          expect(clientReceivedRequestId, receivedAccountRequestId);
        });
      });

      test(
          'when calling `startRegistration` with a short password, then an error is thrown.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.startRegistration(
            sessionBuilder,
            email: _getNewTestEmail(),
            password: 'short',
          ),
          throwsA(isA<EmailAccountPasswordResetException>().having(
            (final exception) => exception.reason,
            'Reason',
            EmailAccountPasswordResetExceptionReason.policyViolation,
          )),
        );
      });

      test(
          'when calling `login` with unknown credentials, then it throws an error with `invalidCredentials`.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.login(
            sessionBuilder,
            email: _getNewTestEmail(),
            password: 'Password!',
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

      group('when calling `startPasswordReset` for a non existing email', () {
        UuidValue? receivedPasswordResetRequestId;
        UuidValue? clientReceivedRequestId;
        String? receivedVerificationCode;

        setUp(() async {
          EmailAccounts.config = EmailAccountConfig(
            maxPasswordResetAttempts: (
              timeframe: const Duration(seconds: 1),
              maxAttempts: 100,
            ),
            sendPasswordResetVerificationCode: (
              final session, {
              required final email,
              required final passwordResetRequestId,
              required final transaction,
              required final verificationCode,
            }) {
              receivedVerificationCode = verificationCode;
              receivedPasswordResetRequestId = passwordResetRequestId;
            },
          );

          clientReceivedRequestId =
              await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: _getNewTestEmail(),
          );
        });

        test('then no verification information is sent out.', () async {
          expect(receivedVerificationCode, isNull);
          expect(receivedPasswordResetRequestId, isNull);
        });

        test('then the client received a request id. ', () async {
          expect(clientReceivedRequestId, isNotNull);
        });

        test('then the request id does not exist on the database.', () async {
          expect(
            await EmailAccountPasswordResetRequest.db.findFirstRow(
              sessionBuilder.build(),
              where: (final t) => t.id.equals(clientReceivedRequestId!),
            ),
            isNull,
          );
        });

        test(
            'then the random request id has the same uuid version as the model to prevent leaking the fact that the email is not registered.',
            () async {
          final existingEmail = _getNewTestEmail();
          await endpoints._registerEmailAccount(
            sessionBuilder,
            email: existingEmail,
            password: 'Foobar123!',
          );

          final validPasswordResetRequest =
              await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: existingEmail,
          );

          expect(
            clientReceivedRequestId!.version,
            validPasswordResetRequest.version,
          );
        });
      });
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given a pending account request,',
    (final sessionBuilder, final endpoints) {
      late UuidValue receivedAccountRequestId;
      late String receivedVerificationCode;

      setUp(() async {
        EmailAccounts.config = EmailAccountConfig(
          sendRegistrationVerificationCode: (
            final session, {
            required final accountRequestId,
            required final email,
            required final transaction,
            required final verificationCode,
          }) {
            receivedAccountRequestId = accountRequestId;
            receivedVerificationCode = verificationCode;
          },
        );

        await endpoints.emailAccount.startRegistration(
          sessionBuilder,
          email: _getNewTestEmail(),
          password: 'Foobar123!',
        );
      });

      tearDown(() {
        EmailAccounts.config = EmailAccountConfig();
      });

      test(
          'when calling `finishRegistration`, then it succeeds returning a valid session key.',
          () async {
        final authSuccess = await endpoints.emailAccount.finishRegistration(
          sessionBuilder,
          accountRequestId: receivedAccountRequestId,
          verificationCode: receivedVerificationCode,
        );

        expect(
          await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            authSuccess.token,
          ),
          isNotNull,
        );
      });
    },
  );

  withServerpod(
    'Given an active account,',
    (final sessionBuilder, final endpoints) {
      final email = _getNewTestEmail();
      const password = 'Foobar123!';

      setUp(() async {
        await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: password,
        );
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
          'when calling `login` with the correct credentials, then it succeeds returning a valid session key.',
          () async {
        final authSuccess = await endpoints.emailAccount.login(
          sessionBuilder,
          email: email,
          password: password,
        );

        expect(
          await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            authSuccess.token,
          ),
          isNotNull,
        );
      });

      test(
          'when calling `login` with the wrong password, then it throws an error with `invalidCredentials`.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: 'some other password',
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

      group('when calling `startRegistration`', () {
        UuidValue? receivedAccountRequestId;
        UuidValue? clientReceivedRequestId;
        String? receivedVerificationCode;

        setUp(() async {
          EmailAccounts.config = EmailAccountConfig(
            sendRegistrationVerificationCode: (
              final session, {
              required final accountRequestId,
              required final email,
              required final transaction,
              required final verificationCode,
            }) {
              receivedAccountRequestId = accountRequestId;
              receivedVerificationCode = verificationCode;
            },
          );

          clientReceivedRequestId =
              await endpoints.emailAccount.startRegistration(
            sessionBuilder,
            email: email,
            password: password,
          );
        });

        test('then no verification information is sent out.', () async {
          expect(receivedVerificationCode, isNull);
          expect(receivedAccountRequestId, isNull);
        });

        test('then the client received a request id.', () async {
          expect(clientReceivedRequestId, isNotNull);
        });

        test('then the request id does not exist on the database.', () async {
          expect(
            await EmailAccountRequest.db.findFirstRow(
              sessionBuilder.build(),
              where: (final t) => t.id.equals(clientReceivedRequestId!),
            ),
            isNull,
          );
        });

        test(
            'then the random request id has the same uuid version as the model to prevent leaking the fact that the email is already registered.',
            () async {
          final validRegistrationRequest =
              await endpoints.emailAccount.startRegistration(
            sessionBuilder,
            email: _getNewTestEmail(),
            password: password,
          );

          expect(
            clientReceivedRequestId!.version,
            validRegistrationRequest.version,
          );
        });
      });

      test(
          'when calling `startPasswordReset`, then the verification code is sent out.',
          () async {
        String? receivedVerificationCode;

        EmailAccounts.config = EmailAccountConfig(
          sendPasswordResetVerificationCode: (
            final session, {
            required final email,
            required final passwordResetRequestId,
            required final transaction,
            required final verificationCode,
          }) {
            receivedVerificationCode = verificationCode;
          },
        );

        await endpoints.emailAccount.startPasswordReset(
          sessionBuilder,
          email: email,
        );

        expect(receivedVerificationCode, isNotNull);
      });
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given an email authentication for a blocked `AuthUser`,',
    (final sessionBuilder, final endpoints) {
      final email = _getNewTestEmail();
      const password = 'Foobar123!';

      setUp(() async {
        final registrationResult = await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: password,
        );

        await AuthUsers.update(
          sessionBuilder.build(),
          authUserId: registrationResult.authUserId,
          blocked: true,
        );
      });

      tearDown(() {
        EmailAccounts.config = EmailAccountConfig();
      });

      test(
          'when calling `login`, then it throws an `AuthUserBlockedException`.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: password,
          ),
          throwsA(isA<AuthUserBlockedException>()),
        );
      });
    },
  );

  withServerpod(
    'Given an auth user with a pending password reset,',
    (final sessionBuilder, final endpoints) {
      final email = _getNewTestEmail();

      late UuidValue authUserId;
      late UuidValue passwordResetRequestId;
      late String verificationCode;

      setUp(() async {
        final registrationResult = await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: 'SomePassword123!',
        );
        authUserId = registrationResult.authUserId;

        final passwordReset = await endpoints._startPasswordReset(
          sessionBuilder,
          email: email,
        );
        passwordResetRequestId = passwordReset.passwordResetRequestId;
        verificationCode = passwordReset.verificationCode;
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `finishPasswordReset` with the correct credentials, then it succeeds returning a valid session key.',
        () async {
          final authSuccess = await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            newPassword: 'NewPassword123!',
          );

          final authInfo = await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            authSuccess.token,
          );

          expect(authInfo?.authUserId, authUserId);
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given an auth user with a changed password,',
    (final sessionBuilder, final endpoints) {
      final email = _getNewTestEmail();
      const oldPassword = 'Foobar123!';
      const newPassword = 'BarFoo789?';

      late UuidValue authUserId;
      late String loginSessionKey;
      late String passwordResetSessionKey;

      setUp(() async {
        final registrationResult = await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: oldPassword,
        );
        authUserId = registrationResult.authUserId;
        loginSessionKey = registrationResult.sessionKey;

        passwordResetSessionKey = await endpoints._changePassword(
          sessionBuilder,
          email: email,
          password: newPassword,
        );
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
          'when calling `login` with the old credentials, then it throws an error.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.login(
            sessionBuilder,
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

      test(
        'when calling `login` with the new credentials, then it succeeds returning a valid session key.',
        () async {
          final authSuccess = await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          expect(
            await AuthSessions.authenticationHandler(
              sessionBuilder.build(),
              authSuccess.token,
            ),
            isNotNull,
          );
        },
      );

      test(
        'when trying to use the session key from before the password change, then the authentication handler returns `null`.',
        () async {
          expect(
            await AuthSessions.authenticationHandler(
              sessionBuilder.build(),
              loginSessionKey,
            ),
            isNull,
          );
        },
      );

      test(
        'when trying to use the session key returned from the password change, then the authentication handler returns the expected user.',
        () async {
          final authInfo = await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            passwordResetSessionKey,
          );

          expect(authInfo?.authUserId, authUserId);
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

/// A new test email to avoid colliding with existing data on the database.
String _getNewTestEmail() {
  return 'test_${const Uuid().v4().replaceAll('-', '')}@serverpod.dev';
}

extension on TestEndpoints {
  Future<({String sessionKey, UuidValue authUserId})> _registerEmailAccount(
    final TestSessionBuilder sessionBuilder, {
    required final String email,
    required final String password,
  }) async {
    late UuidValue receivedAccountRequestId;
    late String receivedVerificationCode;
    EmailAccounts.config = EmailAccountConfig(
      maxPasswordResetAttempts: (
        timeframe: const Duration(seconds: 1),
        maxAttempts: 100,
      ),
      sendRegistrationVerificationCode: (
        final session, {
        required final accountRequestId,
        required final email,
        required final transaction,
        required final verificationCode,
      }) {
        receivedAccountRequestId = accountRequestId;
        receivedVerificationCode = verificationCode;
      },
    );

    await emailAccount.startRegistration(
      sessionBuilder,
      email: email,
      password: password,
    );

    final authSuccess = await emailAccount.finishRegistration(
      sessionBuilder,
      accountRequestId: receivedAccountRequestId,
      verificationCode: receivedVerificationCode,
    );

    final authInfo = await AuthSessions.authenticationHandler(
      sessionBuilder.build(),
      authSuccess.token,
    );

    return (sessionKey: authSuccess.token, authUserId: authInfo!.authUserId);
  }

  Future<
      ({
        UuidValue passwordResetRequestId,
        String verificationCode,
      })> _startPasswordReset(
    final TestSessionBuilder sessionBuilder, {
    required final String email,
  }) async {
    late UuidValue receivedPasswordResetRequestId;
    late String receivedVerificationCode;
    EmailAccounts.config = EmailAccountConfig(
      sendPasswordResetVerificationCode: (
        final session, {
        required final email,
        required final passwordResetRequestId,
        required final transaction,
        required final verificationCode,
      }) {
        receivedPasswordResetRequestId = passwordResetRequestId;
        receivedVerificationCode = verificationCode;
      },
    );

    await emailAccount.startPasswordReset(
      sessionBuilder,
      email: email,
    );

    return (
      passwordResetRequestId: receivedPasswordResetRequestId,
      verificationCode: receivedVerificationCode,
    );
  }

  /// Returns the new session key after successful password change.
  Future<String> _changePassword(
    final TestSessionBuilder sessionBuilder, {
    required final String email,
    required final String password,
  }) async {
    final passwordReset =
        await _startPasswordReset(sessionBuilder, email: email);

    final authSuccess = await emailAccount.finishPasswordReset(
      sessionBuilder,
      passwordResetRequestId: passwordReset.passwordResetRequestId,
      verificationCode: passwordReset.verificationCode,
      newPassword: password,
    );

    return authSuccess.token;
  }
}

Future<void> _cleanUpDatabase(final Session session) async {
  await AuthUser.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountPasswordResetAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountPasswordResetRequestAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountFailedLoginAttempt.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );
}
