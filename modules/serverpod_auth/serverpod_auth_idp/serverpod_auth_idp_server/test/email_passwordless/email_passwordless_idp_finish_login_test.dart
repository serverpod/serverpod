import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_passwordless_idp_test_fixture.dart';

Matcher _throwsLoginException(
  final EmailPasswordlessLoginExceptionReason reason,
) {
  return throwsA(
    isA<EmailPasswordlessLoginException>().having(
      (final e) => e.reason,
      'reason',
      reason,
    ),
  );
}

void main() {
  withServerpod(
    'Given a started login for an email address without an account',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue loginRequestId;
      const email = 'newuser@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        loginRequestId = await fixture.idp.startLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when finishLogin is called with the correct code', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );
        });

        test('then it returns an AuthSuccess with a token.', () {
          expect(authSuccess.authStrategy, isNotNull);
          expect(authSuccess.token, isNotEmpty);
        });

        test('then the token is issued with the emailPasswordless method.', () {
          expect(fixture.idp.method, 'emailPasswordless');
        });

        test(
          'then an auth user with an email account without a password is created.',
          () async {
            final account = await EmailAccount.db.findFirstRow(
              session,
              where: (final t) => t.email.equals(email),
            );

            expect(account, isNotNull);
            expect(account!.passwordHash, isEmpty);
            expect(account.hasPassword, isFalse);
            expect(
              await AuthUser.db.findById(session, account.authUserId),
              isNotNull,
            );
          },
        );

        test('then a user profile with the email is created.', () async {
          final account = (await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals(email),
          ))!;

          final profile = await fixture.userProfiles.findUserProfileByUserId(
            session,
            account.authUserId,
          );

          expect(profile.email, email);
        });

        test('then the login request is deleted.', () async {
          expect(
            await EmailAccountLoginRequest.db.findById(session, loginRequestId),
            isNull,
          );
          expect(await SecretChallenge.db.count(session), 0);
        });

        test('then the sign-in code was not used.', () {
          expect(fixture.signUpCodes, hasLength(1));
          expect(fixture.signInCodes, isEmpty);
        });
      });

      group('when finishLogin is called with a wrong code', () {
        test(
          'then it throws EmailPasswordlessLoginException with reason invalid.',
          () async {
            await expectLater(
              fixture.idp.finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: '000000',
              ),
              _throwsLoginException(
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            );
          },
        );

        test('then no account is created.', () async {
          await fixture.idp
              .finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: '000000',
              )
              .then((final _) {}, onError: (final _) {});

          expect(await EmailAccount.db.count(session), 0);
        });

        test('then the correct code can still be used afterwards.', () async {
          await fixture.idp
              .finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: '000000',
              )
              .then((final _) {}, onError: (final _) {});

          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            completion(isA<AuthSuccess>()),
          );
        });
      });

      group(
        'when finishLogin is called with wrong codes more often than the allowed attempts',
        () {
          setUp(() async {
            for (var i = 0; i < 3; i++) {
              await fixture.idp
                  .finishLogin(
                    session,
                    loginRequestId: loginRequestId,
                    verificationCode: '00000$i',
                  )
                  .then((final _) {}, onError: (final _) {});
            }
          });

          test(
            'then the next attempt throws EmailPasswordlessLoginException with reason tooManyAttempts.',
            () async {
              await expectLater(
                fixture.idp.finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: '000009',
                ),
                _throwsLoginException(
                  EmailPasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              );
            },
          );

          test('then the correct code is rejected as well.', () async {
            await expectLater(
              fixture.idp.finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              ),
              _throwsLoginException(
                EmailPasswordlessLoginExceptionReason.tooManyAttempts,
              ),
            );
          });

          test('then the login request is deleted.', () async {
            await fixture.idp
                .finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: '000009',
                )
                .then((final _) {}, onError: (final _) {});

            expect(
              await EmailAccountLoginRequest.db.findById(
                session,
                loginRequestId,
              ),
              isNull,
            );
            expect(await SecretChallenge.db.count(session), 0);
          });
        },
      );

      group('when finishLogin is called after the request has expired', () {
        late DateTime afterExpiry;

        setUp(() {
          afterExpiry = DateTime.now().add(const Duration(minutes: 11));
        });

        test(
          'then it throws EmailPasswordlessLoginException with reason expired for the correct code.',
          () async {
            await withClock(Clock.fixed(afterExpiry), () async {
              await expectLater(
                fixture.idp.finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: fixtureVerificationCode,
                ),
                _throwsLoginException(
                  EmailPasswordlessLoginExceptionReason.expired,
                ),
              );
            });
          },
        );

        test(
          'then it throws EmailPasswordlessLoginException with reason invalid for a wrong code, to not leak that the request exists.',
          () async {
            await withClock(Clock.fixed(afterExpiry), () async {
              await expectLater(
                fixture.idp.finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: '000000',
                ),
                _throwsLoginException(
                  EmailPasswordlessLoginExceptionReason.invalid,
                ),
              );
            });
          },
        );

        test('then the expired request is deleted.', () async {
          await withClock(Clock.fixed(afterExpiry), () async {
            await fixture.idp
                .finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: fixtureVerificationCode,
                )
                .then((final _) {}, onError: (final _) {});
          });

          expect(
            await EmailAccountLoginRequest.db.findById(session, loginRequestId),
            isNull,
          );
        });
      });

      group('when finishLogin is called with an unknown login request ID', () {
        test(
          'then it throws EmailPasswordlessLoginException with the same reason as for a wrong code.',
          () async {
            await expectLater(
              fixture.idp.finishLogin(
                session,
                loginRequestId: const Uuid().v7obj(),
                verificationCode: fixtureVerificationCode,
              ),
              _throwsLoginException(
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            );
          },
        );
      });

      group('when finishLogin is called twice with the correct code', () {
        setUp(() async {
          await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );
        });

        test(
          'then the second call throws EmailPasswordlessLoginException with reason invalid.',
          () async {
            await expectLater(
              fixture.idp.finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              ),
              _throwsLoginException(
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            );
          },
        );

        test('then only one account exists.', () async {
          expect(await EmailAccount.db.count(session), 1);
        });
      });

      group(
        'when finishLogin is called concurrently with the correct code',
        () {
          late List<Object> results;

          setUp(() async {
            results = await Future.wait<Object>([
              for (var i = 0; i < 3; i++)
                () async {
                  final callSession = sessionBuilder.build();
                  try {
                    return await fixture.idp.finishLogin(
                      callSession,
                      loginRequestId: loginRequestId,
                      verificationCode: fixtureVerificationCode,
                    );
                  } catch (error) {
                    return error;
                  }
                }(),
            ]);
          });

          test('then exactly one call succeeds.', () {
            expect(results.whereType<AuthSuccess>(), hasLength(1));
          });

          test('then the other calls fail as for a used code.', () {
            expect(
              results.whereType<EmailPasswordlessLoginException>().map(
                (final e) => e.reason,
              ),
              everyElement(EmailPasswordlessLoginExceptionReason.invalid),
            );
            expect(results, hasLength(3));
            expect(
              results.whereType<EmailPasswordlessLoginException>(),
              hasLength(2),
            );
          });

          test('then a single account is created.', () async {
            expect(await EmailAccount.db.count(session), 1);
            expect(await AuthUser.db.count(session), 1);
          });

          test('then no challenge is left behind.', () async {
            expect(await SecretChallenge.db.count(session), 0);
          });
        },
      );
    },
  );

  withServerpod(
    'Given an account without a password',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        final authUser = await fixture.authUsers.create(
          session,
          scopes: {const Scope('test-scope')},
        );
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when the login is started and finished with the correct code', () {
        late AuthSuccess authSuccess;
        late UuidValue loginRequestId;

        setUp(() async {
          loginRequestId = await fixture.idp.startLogin(session, email: email);
          authSuccess = await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );
        });

        test('then the sign-in code is sent, not the sign-up code.', () {
          expect(fixture.signInCodes, hasLength(1));
          expect(fixture.signUpCodes, isEmpty);
        });

        test('then it returns an AuthSuccess for the existing user.', () async {
          expect(authSuccess.authUserId, authUserId);
          expect(authSuccess.scopeNames, contains('test-scope'));
        });

        test('then no new user or account is created.', () async {
          expect(await AuthUser.db.count(session), 1);
          expect(await EmailAccount.db.count(session), 1);
        });
      });

      test(
        'when the login is finished for the email in upper case then it logs in the existing user.',
        () async {
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: email.toUpperCase(),
          );
          final authSuccess = await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );

          expect(authSuccess.authUserId, authUserId);
        },
      );

      test(
        'when logging in with a password through the email identity provider then it throws EmailAccountLoginException with reason invalidCredentials.',
        () async {
          final emailIdp = EmailIdp(
            const EmailIdpConfig(secretHashPepper: 'pepper'),
            tokenManager: fixture.tokenManager,
          );

          for (final password in ['', 'Password123!']) {
            await expectLater(
              emailIdp.login(session, email: email, password: password),
              throwsA(
                isA<EmailAccountLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailAccountLoginExceptionReason.invalidCredentials,
                ),
              ),
            );
          }
        },
      );
    },
  );

  withServerpod(
    'Given an account with a password',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late EmailIdp emailIdp;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();
        emailIdp = EmailIdp(
          const EmailIdpConfig(secretHashPepper: 'pepper'),
          tokenManager: fixture.tokenManager,
        );

        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          passwordHash: await emailIdp.utils.hashUtil.createHashFromString(
            secret: password,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when the login is started and finished with the correct code', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );
          authSuccess = await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );
        });

        test('then it logs in the existing user.', () {
          expect(authSuccess.authUserId, authUserId);
        });

        test('then the sign-in code is sent.', () {
          expect(fixture.signInCodes, hasLength(1));
        });

        test('then the password is not changed.', () async {
          final account = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals(email),
          );

          expect(account!.hasPassword, isTrue);
        });

        test('then logging in with the password still works.', () async {
          await expectLater(
            emailIdp.login(session, email: email, password: password),
            completion(isA<AuthSuccess>()),
          );
        });
      });
    },
  );

  withServerpod(
    'Given a blocked auth user with an email account',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        final authUser = await fixture.authUsers.create(session);
        await fixture.authUsers.update(
          session,
          authUserId: authUser.id,
          blocked: true,
        );
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when finishLogin is called with the correct code then it throws AuthUserBlockedException.',
        () async {
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );

          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            throwsA(isA<AuthUserBlockedException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failed login rate limit of 4 attempts for the same email',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          loginVerificationCodeAllowedAttempts: 2,
          failedLoginRateLimit: const RateLimit(
            maxAttempts: 4,
            timeframe: Duration(minutes: 5),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
        'when wrong codes are verified for several requests of the email',
        () {
          setUp(() async {
            for (var request = 0; request < 2; request++) {
              final loginRequestId = await fixture.idp.startLogin(
                session,
                email: email,
              );

              for (var attempt = 0; attempt < 2; attempt++) {
                await fixture.idp
                    .finishLogin(
                      session,
                      loginRequestId: loginRequestId,
                      verificationCode: '000000',
                    )
                    .then((final _) {}, onError: (final _) {});
              }
            }
          });

          test(
            'then the correct code of a new request is rejected with tooManyAttempts.',
            () async {
              final loginRequestId = await fixture.idp.startLogin(
                session,
                email: email,
              );

              await expectLater(
                fixture.idp.finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: fixtureVerificationCode,
                ),
                _throwsLoginException(
                  EmailPasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              );
            },
          );

          test('then other emails are not limited.', () async {
            final loginRequestId = await fixture.idp.startLogin(
              session,
              email: 'other@serverpod.dev',
            );

            await expectLater(
              fixture.idp.finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              ),
              completion(isA<AuthSuccess>()),
            );
          });

          test(
            'then the limit is lifted once the time frame has passed.',
            () async {
              await withClock(
                Clock.fixed(DateTime.now().add(const Duration(minutes: 6))),
                () async {
                  final loginRequestId = await fixture.idp.startLogin(
                    session,
                    email: email,
                  );

                  await expectLater(
                    fixture.idp.finishLogin(
                      session,
                      loginRequestId: loginRequestId,
                      verificationCode: fixtureVerificationCode,
                    ),
                    completion(isA<AuthSuccess>()),
                  );
                },
              );
            },
          );
        },
      );

      test(
        'when a login succeeds then the count of failed attempts is cleared.',
        () async {
          for (var i = 0; i < 3; i++) {
            final loginRequestId = await fixture.idp.startLogin(
              session,
              email: email,
            );
            await fixture.idp
                .finishLogin(
                  session,
                  loginRequestId: loginRequestId,
                  verificationCode: '000000',
                )
                .then((final _) {}, onError: (final _) {});
            await fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            );
          }

          final remainingAttempts = await RateLimitedRequestAttempt.db.count(
            session,
            where: (final t) =>
                t.domain.equals('email_passwordless') &
                t.source.equals('failed_login'),
          );
          expect(remainingAttempts, 0);
        },
      );
    },
  );

  withServerpod(
    'Given sign-up is not allowed',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const unknownEmail = 'unknown@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(allowSignUp: false);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when a login is started for an unknown email', () {
        late UuidValue loginRequestId;

        setUp(() async {
          loginRequestId = await fixture.idp.startLogin(
            session,
            email: unknownEmail,
          );
        });

        test(
          'then finishLogin throws the same exception as for a wrong code on a real request.',
          () async {
            final knownAuthUser = await fixture.authUsers.create(session);
            await fixture.createEmailAccount(
              session,
              authUserId: knownAuthUser.id,
              email: 'known@serverpod.dev',
            );
            final realLoginRequestId = await fixture.idp.startLogin(
              session,
              email: 'known@serverpod.dev',
            );

            Object? fakeError;
            Object? realError;
            try {
              await fixture.idp.finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: '000000',
              );
            } catch (e) {
              fakeError = e;
            }
            try {
              await fixture.idp.finishLogin(
                session,
                loginRequestId: realLoginRequestId,
                verificationCode: '000000',
              );
            } catch (e) {
              realError = e;
            }

            expect(
              fakeError,
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            );
            expect(
              realError,
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            );
          },
        );

        test('then no account is created even for the fixed code.', () async {
          await fixture.idp
              .finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              )
              .then((final _) {}, onError: (final _) {});

          expect(await EmailAccount.db.count(session), 0);
        });
      });

      test(
        'when the account is removed after the login was started then finishLogin throws with reason invalid and creates no account.',
        () async {
          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: 'test@serverpod.dev',
          );
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: 'test@serverpod.dev',
          );
          await EmailAccount.db.deleteWhere(
            session,
            where: (final _) => Constant.bool(true),
          );

          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            _throwsLoginException(
              EmailPasswordlessLoginExceptionReason.invalid,
            ),
          );
          expect(await EmailAccount.db.count(session), 0);
        },
      );
    },
  );

  withServerpod(
    'Given account creation hooks',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'newuser@serverpod.dev';

      setUp(() {
        session = sessionBuilder.build();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when onBeforeAccountCreated throws', () {
        late UuidValue loginRequestId;

        setUp(() async {
          fixture = EmailPasswordlessIdpTestFixture(
            onBeforeAccountCreated:
                (
                  final session, {
                  required final email,
                  required final transaction,
                }) {
                  throw StateError('Sign-ups are closed.');
                },
          );

          loginRequestId = await fixture.idp.startLogin(session, email: email);
        });

        test('then finishLogin throws that exception.', () async {
          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            throwsA(isA<StateError>()),
          );
        });

        test('then no user, account or profile is created.', () async {
          await fixture.idp
              .finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              )
              .then((final _) {}, onError: (final _) {});

          expect(await AuthUser.db.count(session), 0);
          expect(await EmailAccount.db.count(session), 0);
        });

        test('then the code can not be used again.', () async {
          await fixture.idp
              .finishLogin(
                session,
                loginRequestId: loginRequestId,
                verificationCode: fixtureVerificationCode,
              )
              .then((final _) {}, onError: (final _) {});

          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            _throwsLoginException(
              EmailPasswordlessLoginExceptionReason.invalid,
            ),
          );
        });
      });

      group('when onAfterAccountCreated and onAfterLogin are set', () {
        final calls = <String>[];
        late UuidValue loginRequestId;

        setUp(() async {
          calls.clear();
          fixture = EmailPasswordlessIdpTestFixture(
            onBeforeAccountCreated:
                (
                  final session, {
                  required final email,
                  required final transaction,
                }) {
                  calls.add('before:$email');
                },
            onAfterAccountCreated:
                (
                  final session, {
                  required final email,
                  required final authUserId,
                  required final emailAccountId,
                  required final transaction,
                }) {
                  calls.add('created:$email');
                },
            onAfterLogin:
                (
                  final session, {
                  required final email,
                  required final authUserId,
                  required final emailAccountId,
                  required final accountCreated,
                  required final transaction,
                }) {
                  calls.add('login:$email:$accountCreated');
                },
          );

          loginRequestId = await fixture.idp.startLogin(session, email: email);
        });

        test('then they are called in order for a new account.', () async {
          await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );

          expect(calls, [
            'before:$email',
            'created:$email',
            'login:$email:true',
          ]);
        });

        test(
          'then only onAfterLogin is called for an existing account.',
          () async {
            await fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            );
            calls.clear();

            final secondLoginRequestId = await fixture.idp.startLogin(
              session,
              email: email,
            );
            await fixture.idp.finishLogin(
              session,
              loginRequestId: secondLoginRequestId,
              verificationCode: fixtureVerificationCode,
            );

            expect(calls, ['login:$email:false']);
          },
        );
      });

      group('when onAfterLogin throws for a new account', () {
        late UuidValue loginRequestId;

        setUp(() async {
          fixture = EmailPasswordlessIdpTestFixture(
            onAfterLogin:
                (
                  final session, {
                  required final email,
                  required final authUserId,
                  required final emailAccountId,
                  required final accountCreated,
                  required final transaction,
                }) {
                  throw StateError('Login rejected.');
                },
          );

          loginRequestId = await fixture.idp.startLogin(session, email: email);
        });

        test('then the account creation is rolled back.', () async {
          await expectLater(
            fixture.idp.finishLogin(
              session,
              loginRequestId: loginRequestId,
              verificationCode: fixtureVerificationCode,
            ),
            throwsA(isA<StateError>()),
          );

          expect(await EmailAccount.db.count(session), 0);
          expect(await AuthUser.db.count(session), 0);
        });
      });
    },
  );
}
