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

      test(
          'when calling `startRegistration`, then the verification code is sent out.',
          () async {
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
          },
        );

        await endpoints.emailAccount.startRegistration(
          sessionBuilder,
          email: 'test@serverpod.dev',
          password: 'Foobar123!',
        );

        expect(receivedVerificationCode, isNotNull);
      });

      test(
          'when calling `startRegistration` with a short password, then an error is thrown.',
          () async {
        await expectLater(
          () => endpoints.emailAccount.startRegistration(
            sessionBuilder,
            email: 'test@serverpod.dev',
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
            email: '404@serverpod.dev',
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
    },
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
          email: 'test@serverpod.dev',
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
      const email = 'test@serverpod.dev';
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
      const email = 'test@serverpod.dev';
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
      const email = 'test@serverpod.dev';

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
            newPassword: 'Newpassword123!',
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
      const email = 'test@serverpod.dev';
      const oldPassword = 'Foobar123!';
      const newPassword = 'Barfoo789?';

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

  withServerpod(
    'Given a migrated user whose first action is password reset,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const legacyPassword = 'LegacyPass123!';
      const newPassword = 'NewPassword456!';

      late int legacyUserId;
      late UuidValue newAuthUserId;

      setUp(() async {
        // Create a legacy user
        legacyUserId = await endpoints.emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
          sessionBuilder,
          email: email,
          password: legacyPassword,
        );

        // Migrate the user without setting a password (simulating migration without login)
        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: legacyUserId,
        );

        // Get the new auth user ID
        final newAuthUserIdResult = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .getNewAuthUserId(
          sessionBuilder,
          userId: legacyUserId,
        );
        newAuthUserId = newAuthUserIdResult!;
      });

      tearDown(() async {
        EmailAccounts.config = EmailAccountConfig();

        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when starting password reset, then the verification code is sent out.',
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
        },
      );

      test(
        'when completing password reset, then it succeeds and returns a valid session key.',
        () async {
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

          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          final authSuccess = await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            passwordResetRequestId: receivedPasswordResetRequestId,
            verificationCode: receivedVerificationCode,
            newPassword: newPassword,
          );

          final authInfo = await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            authSuccess.token,
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.authUserId, newAuthUserId);
        },
      );

      test(
        'when logging in with the new password after reset, then it succeeds.',
        () async {
          // First complete the password reset
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

          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            passwordResetRequestId: receivedPasswordResetRequestId,
            verificationCode: receivedVerificationCode,
            newPassword: newPassword,
          );

          // Reset config for login test
          EmailAccounts.config = EmailAccountConfig();

          // Now test login with the new password
          final authSuccess = await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          final authInfo = await AuthSessions.authenticationHandler(
            sessionBuilder.build(),
            authSuccess.token,
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.authUserId, newAuthUserId);
        },
      );

      test(
        'when completing password reset, then legacy password entry remains as fallback.',
        () async {
          // Verify legacy password still exists before reset
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            ),
            isTrue,
          );

          // Complete password reset
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

          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          await endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            passwordResetRequestId: receivedPasswordResetRequestId,
            verificationCode: receivedVerificationCode,
            newPassword: newPassword,
          );

          // Verify legacy password still exists after reset (remains as fallback)
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            ),
            isTrue,
          );

          // Login with the new password using regular endpoint (should not clear legacy password)
          EmailAccounts.config = EmailAccountConfig();

          await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          // Verify legacy password still exists after regular login (remains as fallback)
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            ),
            isTrue,
          );

          // Login using the password importing endpoint (should not clear legacy password since account has password)
          await endpoints.passwordImportingEmailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          // Verify legacy password still exists after password importing login (remains as fallback)
          expect(
            await endpoints.emailAccountBackwardsCompatibilityTest
                .checkLegacyPassword(
              sessionBuilder,
              email: email,
              password: legacyPassword,
            ),
            isTrue,
          );
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );
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

  // LegacyEmailPassword entries are cleaned up automatically via foreign key constraints
}
