import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../util/test_tags.dart';
import 'test_tools/serverpod_test_tools.dart';

final tokenManagerFactory = AuthSessionsTokenManagerFactory(
  AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
);

void main() {
  setUp(() async {
    AuthServices.set(
      primaryTokenManager: tokenManagerFactory,
      identityProviders: [
        EmailIdentityProviderFactory(
          const EmailIDPConfig(
            secretHashPepper: 'test',
          ),
        ),
      ],
    );
  });

  tearDown(() async {
    AuthServices.set(
      primaryTokenManager: tokenManagerFactory,
      identityProviders: [],
    );
  });

  withServerpod(
    'Given no users,',
    (final sessionBuilder, final endpoints) {
      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      group('when calling `startRegistration`', () {
        late UuidValue receivedAccountRequestId;
        late UuidValue clientReceivedRequestId;
        String? receivedVerificationCode;

        setUp(() async {
          final config = EmailIDPConfig(
            secretHashPepper: 'test',
            sendRegistrationVerificationCode:
                (
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
          AuthServices.set(
            identityProviders: [
              EmailIdentityProviderFactory(config),
            ],
            primaryTokenManager: tokenManagerFactory,
          );

          clientReceivedRequestId = await endpoints.emailAccount
              .startRegistration(
                sessionBuilder,
                email: 'test@serverpod.dev',
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
        'when calling `login` with unknown credentials, '
        'then it throws an error with reason `invalidCredentials`.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.login(
              sessionBuilder,
              email: 'test@serverpod.dev',
              password: 'Password!',
            ),
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      group('when calling `startPasswordReset` for a non existing email', () {
        UuidValue? receivedPasswordResetRequestId;
        UuidValue? clientReceivedRequestId;
        String? receivedVerificationCode;

        setUp(() async {
          final config = EmailIDPConfig(
            secretHashPepper: 'test',
            maxPasswordResetAttempts: const RateLimit(
              timeframe: Duration(seconds: 1),
              maxAttempts: 100,
            ),
            sendPasswordResetVerificationCode:
                (
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
          AuthServices.set(
            identityProviders: [
              EmailIdentityProviderFactory(config),
            ],
            primaryTokenManager: tokenManagerFactory,
          );

          clientReceivedRequestId = await endpoints.emailAccount
              .startPasswordReset(
                sessionBuilder,
                email: 'test@serverpod.dev',
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
      });
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given a pending account request,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late UuidValue receivedAccountRequestId;
      late String receivedVerificationCode;
      const verificationCodeLifetime = Duration(minutes: 15);

      setUp(() async {
        final config = EmailIDPConfig(
          secretHashPepper: 'test',
          sendRegistrationVerificationCode:
              (
                final session, {
                required final accountRequestId,
                required final email,
                required final transaction,
                required final verificationCode,
              }) {
                receivedAccountRequestId = accountRequestId;
                receivedVerificationCode = verificationCode;
              },
          registrationVerificationCodeLifetime: verificationCodeLifetime,
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );

        await endpoints.emailAccount.startRegistration(
          sessionBuilder,
          email: 'test@serverpod.dev',
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      group(
        'when calling `verifyRegistrationCode` with the correct verification code, ',
        () {
          late Future<String> verificationToken;

          setUp(() async {
            verificationToken = endpoints.emailAccount.verifyRegistrationCode(
              sessionBuilder,
              accountRequestId: receivedAccountRequestId,
              verificationCode: receivedVerificationCode,
            );
          });

          test(
            'then it succeeds returning a valid verification token.',
            () async {
              await expectLater(
                verificationToken,
                completion(isA<String>()),
              );
            },
          );

          test(
            'then the returned verification token can be used to complete the account request.',
            () async {
              final authSuccess = endpoints.emailAccount.finishRegistration(
                sessionBuilder,
                registrationToken: await verificationToken,
                password: 'Foobar123!',
              );

              await expectLater(
                authSuccess,
                completion(isA<AuthSuccess>()),
              );
            },
          );
        },
      );

      test(
        'when calling `verifyRegistrationCode` with the correct verification code after the account request has expired, '
        'then it fails with reason `expired`.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.verifyRegistrationCode(
                sessionBuilder,
                accountRequestId: receivedAccountRequestId,
                verificationCode: receivedVerificationCode,
              ),
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountRequestExceptionReason.expired,
              ),
            ),
          );
        },
      );

      test(
        'when calling `verifyRegistrationCode` with the wrong verification code, '
        'then it fails with reason `invalid`.',
        () async {
          await expectLater(
            () async => await endpoints.emailAccount.verifyRegistrationCode(
              sessionBuilder,
              accountRequestId: receivedAccountRequestId,
              verificationCode: 'wrong',
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `verifyRegistrationCode` with the wrong verification code after the account request has expired, '
        'then it fails with reason `invalid` to not leak that the request exists.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.verifyRegistrationCode(
                sessionBuilder,
                accountRequestId: receivedAccountRequestId,
                verificationCode: 'wrong',
              ),
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an invalid account request id,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `verifyRegistrationCode`, '
        'then it throws generic invalid error that does not leak that the email is not registered.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.verifyRegistrationCode(
              sessionBuilder,
              accountRequestId: const Uuid().v4obj(),
              verificationCode: '123456',
            ),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an active account,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      String? receivedVerificationCode;
      String? receivedPasswordResetCode;

      setUp(() async {
        /// This initializes the AuthServices singleton so it will override
        /// anything configured here.
        await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: password,
        );
        final config = EmailIDPConfig(
          secretHashPepper: 'test',
          sendRegistrationVerificationCode:
              (
                final session, {
                required final accountRequestId,
                required final email,
                required final transaction,
                required final verificationCode,
              }) {
                receivedVerificationCode = verificationCode;
              },
          sendPasswordResetVerificationCode:
              (
                final session, {
                required final email,
                required final passwordResetRequestId,
                required final transaction,
                required final verificationCode,
              }) {
                receivedPasswordResetCode = verificationCode;
              },
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );
      });

      tearDown(() async {
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
            await AuthServices.instance.tokenManager.validateToken(
              sessionBuilder.build(),
              authSuccess.token,
            ),
            isNotNull,
          );
        },
      );

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
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      group('when calling `startRegistration`', () {
        UuidValue? receivedAccountRequestId;
        UuidValue? clientReceivedRequestId;

        setUp(() async {
          clientReceivedRequestId = await endpoints.emailAccount
              .startRegistration(
                sessionBuilder,
                email: email,
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
      });

      test(
        'when calling `startPasswordReset`, then the verification code is sent out.',
        () async {
          await endpoints.emailAccount.startPasswordReset(
            sessionBuilder,
            email: email,
          );

          expect(receivedPasswordResetCode, isNotNull);
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given an email authentication for a blocked `AuthUser`,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        final registrationResult = await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: password,
        );

        const authUsers = AuthUsers();
        await authUsers.update(
          sessionBuilder.build(),
          authUserId: registrationResult.authUserId,
          blocked: true,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
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
        },
      );
    },
  );

  withServerpod(
    'Given an auth user with a pending password reset,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';

      late UuidValue authUserId;
      late UuidValue passwordResetRequestId;
      late String verificationCode;
      const verificationCodeLifetime = Duration(minutes: 15);

      setUp(() async {
        const config = EmailIDPConfig(
          secretHashPepper: 'test',
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );

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
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `verifyPasswordResetCode` with the correct verification code, '
        'then it succeeds',
        () async {
          final passwordReset = endpoints.emailAccount.verifyPasswordResetCode(
            sessionBuilder,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(passwordReset, completes);
        },
      );

      test(
        'when calling `verifyPasswordResetCode` with the correct verification code after the password reset request has expired, '
        'then it fails with reason `expired`.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
              ),
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.expired,
              ),
            ),
          );
        },
      );

      test(
        'when calling `verifyPasswordResetCode` the correct verification code after the email account being deleted, '
        'then an error is thrown with reason `invalid`.',
        () async {
          await EmailAccount.db.deleteWhere(
            sessionBuilder.build(),
            where: (final t) => t.authUserId.equals(authUserId),
          );

          await expectLater(
            () => endpoints.emailAccount.verifyPasswordResetCode(
              sessionBuilder,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: verificationCode,
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `verifyPasswordResetCode` with the wrong verification code, '
        'then it fails with reason `invalid`.',
        () async {
          await expectLater(
            () async => await endpoints.emailAccount.verifyPasswordResetCode(
              sessionBuilder,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `verifyPasswordResetCode` with the wrong verification code after the password reset request has expired, '
        'then it fails with reason `invalid` to not leak that the request exists.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.verifyPasswordResetCode(
                sessionBuilder,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: 'wrong',
              ),
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset` with a short password, '
        'then an error is thrown with reason `policyViolation` regardless of the finish password reset token.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.finishPasswordReset(
              sessionBuilder,
              finishPasswordResetToken: const Uuid().v4(),
              newPassword: 'short',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given an auth user with a verified password reset,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';

      late UuidValue authUserId;
      late UuidValue passwordResetRequestId;
      late String finishPasswordResetToken;
      const verificationCodeLifetime = Duration(minutes: 15);

      setUp(() async {
        const config = EmailIDPConfig(
          secretHashPepper: 'test',
        );
        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );

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
        final passwordResetVerificationCode = passwordReset.verificationCode;

        finishPasswordResetToken = await endpoints.emailAccount
            .verifyPasswordResetCode(
              sessionBuilder,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: passwordResetVerificationCode,
            );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `finishPasswordReset` with the correct finish password reset token, '
        'then it succeeds',
        () async {
          final passwordReset = endpoints.emailAccount.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: finishPasswordResetToken,
            newPassword: 'NewPassword123!',
          );

          await expectLater(passwordReset, completes);
        },
      );

      test(
        'when calling `finishPasswordReset` with the correct finish password reset token after the password reset request has expired, '
        'then it fails with reason `expired`.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.finishPasswordReset(
                sessionBuilder,
                finishPasswordResetToken: finishPasswordResetToken,
                newPassword: 'NewPassword123!',
              ),
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.expired,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset` the correct finish password reset token after the email account being deleted, '
        'then an error is thrown with reason `invalid`.',
        () async {
          await EmailAccount.db.deleteWhere(
            sessionBuilder.build(),
            where: (final t) => t.authUserId.equals(authUserId),
          );

          await expectLater(
            () => endpoints.emailAccount.finishPasswordReset(
              sessionBuilder,
              finishPasswordResetToken: finishPasswordResetToken,
              newPassword: 'NewPassword123!',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset` with the wrong finish password reset token, '
        'then it fails with reason `invalid`.',
        () async {
          await expectLater(
            () async => await endpoints.emailAccount.finishPasswordReset(
              sessionBuilder,
              finishPasswordResetToken: const Uuid().v4(),
              newPassword: 'NewPassword123!',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset` with the wrong finish password reset token after the password reset request has expired, '
        'then it fails with reason `expired`.',
        () async {
          await expectLater(
            () => withClock(
              Clock.fixed(DateTime.now().add(verificationCodeLifetime)),
              () => endpoints.emailAccount.finishPasswordReset(
                sessionBuilder,
                finishPasswordResetToken: finishPasswordResetToken,
                newPassword: 'NewPassword123!',
              ),
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.expired,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset` with a short password and wrong finish password reset token, '
        'then an error is thrown with reason `policyViolation` regardless of the finish password reset token.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.finishPasswordReset(
              sessionBuilder,
              finishPasswordResetToken: const Uuid().v4(),
              newPassword: 'short',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final exception) => exception.reason,
                'Reason',
                EmailAccountPasswordResetExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );
    },
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
  );

  withServerpod(
    'Given an invalid password reset request id,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `verifyPasswordResetCode`, '
        'then it throws generic invalid error that does not leak that the email is not registered.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.verifyPasswordResetCode(
              sessionBuilder,
              passwordResetRequestId: const Uuid().v4obj(),
              verificationCode: '123456',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when calling `finishPasswordReset`, '
        'then it throws generic invalid error that does not leak that the email is not registered.',
        () async {
          await expectLater(
            () => endpoints.emailAccount.finishPasswordReset(
              sessionBuilder,
              finishPasswordResetToken: const Uuid().v4(),
              newPassword: 'NewPassword123!',
            ),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an auth user with a changed password,',
    (final sessionBuilder, final endpoints) {
      const email = 'test@serverpod.dev';
      const oldPassword = 'Foobar123!';
      const newPassword = 'BarFoo789?';

      late String loginSessionKey;

      setUp(() async {
        const config = EmailIDPConfig(
          secretHashPepper: 'test',
        );

        AuthServices.set(
          identityProviders: [
            EmailIdentityProviderFactory(config),
          ],
          primaryTokenManager: tokenManagerFactory,
        );

        final registrationResult = await endpoints._registerEmailAccount(
          sessionBuilder,
          email: email,
          password: oldPassword,
        );
        loginSessionKey = registrationResult.sessionKey;

        await endpoints._changePassword(
          sessionBuilder,
          email: email,
          password: newPassword,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling `login` with the old credentials, then it throws an error with reason `invalidCredentials`.',
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
                EmailAccountLoginExceptionReason.invalidCredentials,
              ),
            ),
          );
        },
      );

      test(
        'when calling `login` with the new credentials, then it succeeds returning a valid session key.',
        () async {
          final authSuccess = await endpoints.emailAccount.login(
            sessionBuilder,
            email: email,
            password: newPassword,
          );

          expect(
            await AuthServices.instance.tokenManager.validateToken(
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
            await AuthServices.instance.tokenManager.validateToken(
              sessionBuilder.build(),
              loginSessionKey,
            ),
            isNull,
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
    final config = EmailIDPConfig(
      secretHashPepper: 'test',
      maxPasswordResetAttempts: const RateLimit(
        timeframe: Duration(seconds: 1),
        maxAttempts: 100,
      ),
      sendRegistrationVerificationCode:
          (
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

    AuthServices.set(
      identityProviders: [
        EmailIdentityProviderFactory(config),
      ],
      primaryTokenManager: tokenManagerFactory,
    );

    await emailAccount.startRegistration(
      sessionBuilder,
      email: email,
    );

    final verificationToken = await emailAccount.verifyRegistrationCode(
      sessionBuilder,
      accountRequestId: receivedAccountRequestId,
      verificationCode: receivedVerificationCode,
    );

    final authSuccess = await emailAccount.finishRegistration(
      sessionBuilder,
      registrationToken: verificationToken,
      password: password,
    );

    final authInfo = await AuthServices.instance.tokenManager.validateToken(
      sessionBuilder.build(),
      authSuccess.token,
    );

    return (sessionKey: authSuccess.token, authUserId: authInfo!.authUserId);
  }

  Future<({UuidValue passwordResetRequestId, String verificationCode})>
  _startPasswordReset(
    final TestSessionBuilder sessionBuilder, {
    required final String email,
  }) async {
    late UuidValue receivedPasswordResetRequestId;
    late String receivedVerificationCode;
    final config = EmailIDPConfig(
      secretHashPepper: 'test',
      sendPasswordResetVerificationCode:
          (
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
    AuthServices.set(
      identityProviders: [
        EmailIdentityProviderFactory(config),
      ],
      primaryTokenManager: tokenManagerFactory,
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
  Future<void> _changePassword(
    final TestSessionBuilder sessionBuilder, {
    required final String email,
    required final String password,
  }) async {
    final passwordReset = await _startPasswordReset(
      sessionBuilder,
      email: email,
    );

    final finishPasswordResetToken = await emailAccount.verifyPasswordResetCode(
      sessionBuilder,
      passwordResetRequestId: passwordReset.passwordResetRequestId,
      verificationCode: passwordReset.verificationCode,
    );

    await emailAccount.finishPasswordReset(
      sessionBuilder,
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: password,
    );
  }
}

Future<void> _cleanUpDatabase(final Session session) async {
  await AuthUser.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountRequest.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await EmailAccountPasswordResetCompleteAttempt.db.deleteWhere(
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
