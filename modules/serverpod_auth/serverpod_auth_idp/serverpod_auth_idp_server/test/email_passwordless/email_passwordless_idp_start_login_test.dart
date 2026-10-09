import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given no account for the email address',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'newuser@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when startLogin is called', () {
        late UuidValue loginRequestId;

        setUp(() async {
          loginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );
        });

        test('then it returns the ID of a login request.', () async {
          final request = await EmailAccountLoginRequest.db.findById(
            session,
            loginRequestId,
          );

          expect(request, isNotNull);
          expect(request!.email, email);
        });

        test('then the sign-up code is sent.', () {
          expect(fixture.signUpCodes, hasLength(1));
          expect(fixture.signUpCodes.single.email, email);
          expect(fixture.signUpCodes.single.loginRequestId, loginRequestId);
          expect(
            fixture.signUpCodes.single.verificationCode,
            fixtureVerificationCode,
          );
        });

        test('then no sign-in code is sent.', () {
          expect(fixture.signInCodes, isEmpty);
        });

        test('then the code is not stored in plain text.', () async {
          final request = await EmailAccountLoginRequest.db.findById(
            session,
            loginRequestId,
            include: EmailAccountLoginRequest.include(
              challenge: SecretChallenge.include(),
            ),
          );

          expect(
            request!.challenge!.challengeCodeHash,
            isNot(contains(fixtureVerificationCode)),
          );
        });
      });

      group('when startLogin is called with a padded, upper case email', () {
        setUp(() async {
          await fixture.idp.startLogin(
            session,
            email: '  NewUser@Serverpod.dev ',
          );
        });

        test('then the request is created for the normalized email.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests.map((final r) => r.email), [email]);
          expect(fixture.signUpCodes.single.email, email);
        });
      });

      group('when startLogin is called with an invalid email', () {
        test(
          'then it throws EmailPasswordlessLoginException with reason invalidEmail.',
          () async {
            await expectLater(
              fixture.idp.startLogin(session, email: 'not-an-email'),
              throwsA(
                isA<EmailPasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailPasswordlessLoginExceptionReason.invalidEmail,
                ),
              ),
            );
          },
        );

        test('then no code is sent.', () async {
          await fixture.idp
              .startLogin(session, email: 'not-an-email')
              .then((final _) {}, onError: (final _) {});

          expect(fixture.signUpCodes, isEmpty);
          expect(fixture.signInCodes, isEmpty);
        });
      });

      group('when startLogin is called more often than the rate limit', () {
        setUp(() async {
          fixture = EmailPasswordlessIdpTestFixture(
            loginRequestRateLimit: const RateLimit(
              maxAttempts: 2,
              timeframe: Duration(minutes: 5),
            ),
          );

          await fixture.idp.startLogin(session, email: email);
          await fixture.idp.startLogin(session, email: email);
        });

        test(
          'then it throws EmailPasswordlessLoginException with reason rateLimited.',
          () async {
            await expectLater(
              fixture.idp.startLogin(session, email: email),
              throwsA(
                isA<EmailPasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailPasswordlessLoginExceptionReason.rateLimited,
                ),
              ),
            );
          },
        );

        test('then only the allowed requests send a code.', () async {
          await fixture.idp
              .startLogin(session, email: email)
              .then((final _) {}, onError: (final _) {});

          expect(fixture.signUpCodes, hasLength(2));
        });

        test('then other email addresses are not affected.', () async {
          await expectLater(
            fixture.idp.startLogin(session, email: 'other@serverpod.dev'),
            completion(isA<UuidValue>()),
          );
        });
      });

      group('when the send callback throws', () {
        late Future<UuidValue> loginRequestIdFuture;

        setUp(() async {
          fixture = EmailPasswordlessIdpTestFixture(
            sendSignUpOverride:
                (
                  final session, {
                  required final email,
                  required final loginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) => throw Exception('mail server is down'),
          );

          loginRequestIdFuture = fixture.idp.startLogin(
            session,
            email: email,
          );
        });

        test('then startLogin still returns the request ID.', () async {
          await expectLater(loginRequestIdFuture, completion(isA<UuidValue>()));
        });

        test('then the login request is kept.', () async {
          final loginRequestId = await loginRequestIdFuture;

          expect(
            await EmailAccountLoginRequest.db.findById(session, loginRequestId),
            isNotNull,
          );
        });
      });

      group('when startLogin is called concurrently for the same email', () {
        late List<Object> results;

        setUp(() async {
          results = await Future.wait<Object>([
            for (var i = 0; i < 4; i++)
              () async {
                final callSession = sessionBuilder.build();
                try {
                  return await fixture.idp.startLogin(
                    callSession,
                    email: email,
                  );
                } catch (error) {
                  return error;
                }
              }(),
          ]);
        });

        test('then at least one call succeeds.', () {
          expect(results.whereType<UuidValue>(), isNotEmpty);
        });

        test(
          'then every call that does not succeed fails with reason resendCooldown, and never returns an ID.',
          () {
            final failures = results.where((final r) => r is! UuidValue);

            expect(
              failures,
              everyElement(
                isA<EmailPasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailPasswordlessLoginExceptionReason.resendCooldown,
                ),
              ),
            );
          },
        );

        test('then every returned ID belongs to a code that was sent.', () {
          expect(
            fixture.signUpCodes.map((final c) => c.loginRequestId).toSet(),
            results.whereType<UuidValue>().toSet(),
          );
        });

        test('then there is a single login request for the email.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests, hasLength(1));
        });
      });

      group('when the send callback runs', () {
        late bool senderCalled;
        Transaction? transactionPassed;
        late bool requestVisibleToOthers;
        late bool senderAwaited;

        setUp(() async {
          senderCalled = false;
          transactionPassed = null;
          requestVisibleToOthers = false;
          senderAwaited = false;
          fixture = EmailPasswordlessIdpTestFixture(
            sendSignUpOverride:
                (
                  final session, {
                  required final email,
                  required final loginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) async {
                  senderCalled = true;
                  transactionPassed = transaction;
                  final request = await EmailAccountLoginRequest.db.findById(
                    sessionBuilder.build(),
                    loginRequestId,
                  );
                  requestVisibleToOthers = request != null;
                  await Future<void>.delayed(const Duration(milliseconds: 50));
                  senderAwaited = true;
                },
          );

          await fixture.idp.startLogin(session, email: email);
        });

        test('then no transaction is passed to it.', () {
          expect(senderCalled, isTrue);
          expect(transactionPassed, isNull);
        });

        test('then the login request has already been committed.', () {
          expect(requestVisibleToOthers, isTrue);
        });

        test('then startLogin waits for it to finish.', () {
          expect(senderAwaited, isTrue);
        });
      });
    },
  );

  withServerpod(
    'Given an account without a password',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        final authUser = await fixture.authUsers.create(session);
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
        'when startLogin is called then the sign-in code is sent and the sign-up code is not.',
        () async {
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );

          expect(fixture.signInCodes, hasLength(1));
          expect(fixture.signInCodes.single.email, email);
          expect(fixture.signInCodes.single.loginRequestId, loginRequestId);
          expect(fixture.signUpCodes, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a pending login request that is younger than the resend cooldown',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue loginRequestId;
      const email = 'test@serverpod.dev';
      const resendCooldown = Duration(seconds: 60);

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          resendCooldown: resendCooldown,
        );

        loginRequestId = await fixture.idp.startLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when startLogin is called again for the same email', () {
        late Future<UuidValue> secondCall;

        setUp(() {
          secondCall = fixture.idp.startLogin(session, email: email);
          secondCall.ignore();
        });

        test(
          'then it throws EmailPasswordlessLoginException with reason resendCooldown and returns no ID.',
          () async {
            await expectLater(
              secondCall,
              throwsA(
                isA<EmailPasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  EmailPasswordlessLoginExceptionReason.resendCooldown,
                ),
              ),
            );
          },
        );

        test('then no new code is sent.', () async {
          await secondCall.then((final _) {}, onError: (final _) {});

          expect(fixture.signUpCodes, hasLength(1));
        });

        test('then the pending request stays valid.', () async {
          await secondCall.then((final _) {}, onError: (final _) {});

          final result = fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );

          await expectLater(result, completion(isA<AuthSuccess>()));
        });
      });

      group('when startLogin is called many times within the cooldown', () {
        setUp(() async {
          for (var i = 0; i < 10; i++) {
            await fixture.idp
                .startLogin(session, email: email)
                .then((final _) {}, onError: (final _) {});
          }
        });

        test('then the rejected calls do not use up the rate limit.', () async {
          final secondLoginRequestId = await withClock(
            Clock.fixed(DateTime.now().add(resendCooldown * 2)),
            () => fixture.idp.startLogin(session, email: email),
          );

          expect(secondLoginRequestId, isNot(loginRequestId));
        });
      });

      group('when startLogin is called after the resend cooldown', () {
        late UuidValue secondLoginRequestId;

        setUp(() async {
          secondLoginRequestId = await withClock(
            Clock.fixed(DateTime.now().add(resendCooldown * 2)),
            () => fixture.idp.startLogin(session, email: email),
          );
        });

        test('then it returns a new request ID.', () {
          expect(secondLoginRequestId, isNot(loginRequestId));
        });

        test('then a new code is sent.', () {
          expect(fixture.signUpCodes, hasLength(2));
        });

        test('then the previous request is replaced.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests.map((final r) => r.id), [secondLoginRequestId]);
        });

        test('then the previous challenge is deleted.', () async {
          final challenges = await SecretChallenge.db.find(session);

          expect(challenges, hasLength(1));
        });
      });
    },
  );

  withServerpod(
    'Given a pending login request and a resend cooldown, with concurrent calls',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          resendCooldown: const Duration(seconds: 60),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startLogin is called concurrently then exactly one call succeeds, the others get reason resendCooldown, and only one code is sent.',
        () async {
          final results = await Future.wait<Object>([
            for (var i = 0; i < 4; i++)
              () async {
                try {
                  return await fixture.idp.startLogin(
                    sessionBuilder.build(),
                    email: email,
                  );
                } catch (error) {
                  return error;
                }
              }(),
          ]);

          final ids = results.whereType<UuidValue>().toList();
          expect(ids, hasLength(1));
          expect(
            results.where((final r) => r is! UuidValue),
            everyElement(
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.resendCooldown,
              ),
            ),
          );
          expect(fixture.signUpCodes.map((final c) => c.loginRequestId), ids);
          expect(
            (await EmailAccountLoginRequest.db.find(session)).map(
              (final r) => r.id,
            ),
            ids,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a pending login request that is older than the lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue loginRequestId;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          resendCooldown: const Duration(minutes: 5),
          loginVerificationCodeLifetime: const Duration(minutes: 10),
        );

        loginRequestId = await fixture.idp.startLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startLogin is called then the expired request is replaced.',
        () async {
          final secondLoginRequestId = await withClock(
            Clock.fixed(DateTime.now().add(const Duration(minutes: 15))),
            () => fixture.idp.startLogin(session, email: email),
          );

          expect(secondLoginRequestId, isNot(loginRequestId));
          expect(fixture.signUpCodes, hasLength(2));
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
      const knownEmail = 'known@serverpod.dev';
      const unknownEmail = 'unknown@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          allowSignUp: false,
          resendCooldown: const Duration(seconds: 60),
        );

        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: knownEmail,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when startLogin is called for an unknown email', () {
        late UuidValue loginRequestId;
        late UuidValue realLoginRequestId;

        setUp(() async {
          loginRequestId = await fixture.idp.startLogin(
            session,
            email: unknownEmail,
          );
          realLoginRequestId = await fixture.idp.startLogin(
            session,
            email: knownEmail,
          );
        });

        test(
          'then it returns an ID with the same version as the one of a real request.',
          () {
            expect(loginRequestId.version, realLoginRequestId.version);
          },
        );

        test('then nothing is sent for it.', () {
          expect(
            [...fixture.signUpCodes, ...fixture.signInCodes].map(
              (final c) => c.email,
            ),
            [knownEmail],
          );
        });

        test(
          'then a decoy request with a stored code hash exists for it, like for the known email.',
          () async {
            final requests = await EmailAccountLoginRequest.db.find(
              session,
              include: EmailAccountLoginRequest.include(
                challenge: SecretChallenge.include(),
              ),
            );

            expect(
              requests.map((final r) => r.email),
              unorderedEquals([knownEmail, unknownEmail]),
            );
            final decoy = requests.singleWhere(
              (final r) => r.id == loginRequestId,
            );
            final real = requests.singleWhere(
              (final r) => r.id == realLoginRequestId,
            );
            expect(decoy.challenge!.challengeCodeHash, isNotEmpty);
            expect(
              decoy.challenge!.challengeCodeHash.length,
              real.challenge!.challengeCodeHash.length,
            );
          },
        );
      });

      group('when the decoy code of an unknown email is guessed correctly', () {
        late UuidValue loginRequestId;
        late Future<AuthSuccess> finishFuture;

        setUp(() async {
          loginRequestId = await fixture.idp.startLogin(
            session,
            email: unknownEmail,
          );

          final request = await EmailAccountLoginRequest.db.findById(
            session,
            loginRequestId,
          );
          await SecretChallenge.db.updateRow(
            session,
            SecretChallenge(
              id: request!.challengeId,
              challengeCodeHash: await fixture.idp.utils.hashUtil
                  .createHashFromString(secret: '654321'),
            ),
          );

          finishFuture = fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: '654321',
          );
          finishFuture.ignore();
        });

        test('then finishLogin fails with reason invalid.', () async {
          await expectLater(
            finishFuture,
            throwsA(
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.invalid,
              ),
            ),
          );
        });

        test('then no account or user is created.', () async {
          await finishFuture.then((final _) {}, onError: (final _) {});

          expect(
            await EmailAccount.db.find(
              session,
              where: (final t) => t.email.equals(unknownEmail),
            ),
            isEmpty,
          );
          expect(await AuthUser.db.count(session), 1);
        });

        test('then the decoy request is consumed.', () async {
          await finishFuture.then((final _) {}, onError: (final _) {});

          expect(
            await EmailAccountLoginRequest.db.findById(session, loginRequestId),
            isNull,
          );
        });
      });

      group('when startLogin is repeated within the resend cooldown', () {
        Future<List<Object>> repeated(final String email) async => [
          for (var i = 0; i < 3; i++)
            await fixture.idp
                .startLogin(session, email: email)
                .then<Object>(
                  (final id) => id,
                  onError: (final Object e) => e,
                ),
        ];

        test(
          'then known and unknown emails alike get the first ID and then reason resendCooldown, and never a pending ID again.',
          () async {
            final unknownResults = await repeated(unknownEmail);
            final knownResults = await repeated(knownEmail);

            for (final results in [unknownResults, knownResults]) {
              expect(results.first, isA<UuidValue>());
              expect(
                results.skip(1),
                everyElement(
                  isA<EmailPasswordlessLoginException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailPasswordlessLoginExceptionReason.resendCooldown,
                  ),
                ),
              );
            }
          },
        );

        test('then the code is only sent once, for the known email.', () async {
          await repeated(unknownEmail);
          await repeated(knownEmail);

          expect(fixture.signInCodes, hasLength(1));
          expect(fixture.signUpCodes, isEmpty);
        });
      });
    },
  );

  for (final (name, resendCooldown) in [
    ('without a resend cooldown', Duration.zero),
    ('with a resend cooldown', const Duration(seconds: 60)),
  ]) {
    withServerpod(
      'Given sign-up is not allowed, $name',
      rollbackDatabase: RollbackDatabase.disabled,
      (final sessionBuilder, final endpoints) {
        late Session session;
        late EmailPasswordlessIdpTestFixture fixture;
        const knownEmail = 'known@serverpod.dev';
        const unknownEmail = 'unknown@serverpod.dev';

        setUp(() async {
          session = sessionBuilder.build();
          fixture = EmailPasswordlessIdpTestFixture(
            allowSignUp: false,
            resendCooldown: resendCooldown,
          );

          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: knownEmail,
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        Future<String> outcome(final Future<Object?> Function() call) async {
          try {
            final result = await call();
            return result is UuidValue ? 'id(v${result.version})' : 'ok';
          } on EmailPasswordlessLoginException catch (e) {
            return e.reason.name;
          }
        }

        Future<List<String>> sequence(final String email) async {
          final outcomes = <String>[];
          var id = UuidValue.fromString(const Uuid().v7());

          Future<void> start() async {
            outcomes.add(
              await outcome(
                () async => id = await fixture.idp.startLogin(
                  session,
                  email: email,
                ),
              ),
            );
          }

          Future<void> wrongFinish() async {
            outcomes.add(
              await outcome(
                () => fixture.idp.finishLogin(
                  session,
                  loginRequestId: id,
                  verificationCode: '000000',
                ),
              ),
            );
          }

          await start();
          for (var i = 0; i < 4; i++) {
            await wrongFinish();
          }
          await start();
          for (var i = 0; i < 3; i++) {
            await wrongFinish();
          }

          return outcomes;
        }

        test(
          'when startLogin, 4 wrong finishLogin, startLogin and 3 wrong finishLogin are called then known and unknown emails have identical outcomes.',
          () async {
            final unknownOutcomes = await sequence(unknownEmail);
            final knownOutcomes = await sequence(knownEmail);

            expect(unknownOutcomes, knownOutcomes);
            expect(knownOutcomes.first, startsWith('id(v'));
            expect(
              knownOutcomes.sublist(1, 5),
              ['invalid', 'invalid', 'invalid', 'tooManyAttempts'],
            );
          },
        );

        test(
          'when the sequence has run then the only difference is that a code is sent for the known email.',
          () async {
            await sequence(unknownEmail);
            expect(fixture.signInCodes, isEmpty);
            expect(fixture.signUpCodes, isEmpty);

            await sequence(knownEmail);
            expect(fixture.signInCodes, isNotEmpty);
          },
        );
      },
    );
  }

  group('Given an invalid configuration', () {
    EmailPasswordlessIdpTestFixture build({
      final Duration loginVerificationCodeLifetime = const Duration(
        minutes: 10,
      ),
      final int loginVerificationCodeAllowedAttempts = 3,
      final Duration resendCooldown = const Duration(seconds: 60),
      final int secretHashSaltLength = 16,
      final RateLimit failedLoginRateLimit = const RateLimit(
        maxAttempts: 5,
        timeframe: Duration(minutes: 5),
      ),
    }) => EmailPasswordlessIdpTestFixture(
      loginVerificationCodeLifetime: loginVerificationCodeLifetime,
      loginVerificationCodeAllowedAttempts:
          loginVerificationCodeAllowedAttempts,
      resendCooldown: resendCooldown,
      secretHashSaltLength: secretHashSaltLength,
      failedLoginRateLimit: failedLoginRateLimit,
    );

    test('when the default values are used then it is accepted.', () {
      expect(build, returnsNormally);
    });

    test(
      'when the allowed attempts are 0 then it throws an ArgumentError.',
      () {
        expect(
          () => build(loginVerificationCodeAllowedAttempts: 0),
          throwsArgumentError,
        );
      },
    );

    test('when the lifetime is zero then it throws an ArgumentError.', () {
      expect(
        () => build(loginVerificationCodeLifetime: Duration.zero),
        throwsArgumentError,
      );
    });

    test(
      'when the resend cooldown is negative then it throws an ArgumentError.',
      () {
        expect(
          () => build(resendCooldown: const Duration(seconds: -1)),
          throwsArgumentError,
        );
      },
    );

    test(
      'when the resend cooldown is zero then it is accepted.',
      () {
        expect(() => build(resendCooldown: Duration.zero), returnsNormally);
      },
    );

    test(
      'when the resend cooldown is not shorter than the lifetime then it throws an ArgumentError.',
      () {
        expect(
          () => build(resendCooldown: const Duration(minutes: 10)),
          throwsArgumentError,
        );
      },
    );

    test(
      'when the salt length is below 8 then it throws an ArgumentError.',
      () {
        expect(
          () => build(secretHashSaltLength: 7),
          throwsArgumentError,
        );
        expect(() => build(secretHashSaltLength: 8), returnsNormally);
      },
    );

    test(
      'when a rate limit allows no attempts then it throws an ArgumentError.',
      () {
        expect(
          () => build(
            failedLoginRateLimit: const RateLimit(
              maxAttempts: 0,
              timeframe: Duration(minutes: 5),
            ),
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
