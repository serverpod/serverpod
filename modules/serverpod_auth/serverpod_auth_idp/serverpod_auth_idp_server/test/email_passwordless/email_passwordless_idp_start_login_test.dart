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

        test('then none of the calls fails.', () {
          expect(results, everyElement(isA<UuidValue>()));
        });

        test('then there is a single login request for the email.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests, hasLength(1));
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
        late UuidValue secondLoginRequestId;

        setUp(() async {
          secondLoginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );
        });

        test('then it returns the ID of the pending request.', () {
          expect(secondLoginRequestId, loginRequestId);
        });

        test('then no new code is sent.', () {
          expect(fixture.signUpCodes, hasLength(1));
        });

        test('then the pending request stays valid.', () async {
          final result = fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );

          await expectLater(result, completion(isA<AuthSuccess>()));
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
          resendCooldown: const Duration(minutes: 30),
          loginVerificationCodeLifetime: const Duration(minutes: 10),
        );

        loginRequestId = await fixture.idp.startLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startLogin is called then the expired request is replaced even though the resend cooldown has not elapsed.',
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

        test('then no login request is stored for it.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests.map((final r) => r.email), [knownEmail]);
        });
      });

      group('when startLogin is repeated within the resend cooldown', () {
        late List<UuidValue> unknownEmailIds;
        late List<UuidValue> knownEmailIds;

        setUp(() async {
          unknownEmailIds = [
            for (var i = 0; i < 3; i++)
              await fixture.idp.startLogin(session, email: unknownEmail),
          ];
          knownEmailIds = [
            for (var i = 0; i < 3; i++)
              await fixture.idp.startLogin(session, email: knownEmail),
          ];
        });

        test(
          'then known and unknown emails alike get a new ID for every call, to not leak that the email has a pending request.',
          () {
            expect(unknownEmailIds.toSet(), hasLength(3));
            expect(knownEmailIds.toSet(), hasLength(3));
          },
        );

        test('then the code is only sent once.', () {
          expect(fixture.signInCodes, hasLength(1));
        });
      });
    },
  );
}
