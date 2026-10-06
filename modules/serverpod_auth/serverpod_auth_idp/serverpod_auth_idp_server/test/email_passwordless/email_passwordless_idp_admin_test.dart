import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an existing auth user',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        authUserId = (await fixture.authUsers.create(session)).id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when createAccount is called', () {
        late UuidValue emailAccountId;

        setUp(() async {
          emailAccountId = await session.db.transaction(
            (final transaction) => fixture.idp.admin.createAccount(
              session,
              authUserId: authUserId,
              email: ' Test@Serverpod.dev ',
              transaction: transaction,
            ),
          );
        });

        test(
          'then it creates an account with the normalized email and no password.',
          () async {
            final account = await EmailAccount.db.findById(
              session,
              emailAccountId,
            );

            expect(account!.email, email);
            expect(account.authUserId, authUserId);
            expect(account.passwordHash, isEmpty);
          },
        );

        test('then the user can log in with a code.', () async {
          final loginRequestId = await fixture.idp.startLogin(
            session,
            email: email,
          );

          final authSuccess = await fixture.idp.finishLogin(
            session,
            loginRequestId: loginRequestId,
            verificationCode: fixtureVerificationCode,
          );

          expect(authSuccess.authUserId, authUserId);
          expect(fixture.signInCodes, hasLength(1));
        });
      });
    },
  );

  withServerpod(
    'Given login requests that are expired and still valid',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late UuidValue expiredRequestId;
      late UuidValue validRequestId;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        expiredRequestId = await withClock(
          Clock.fixed(DateTime.now().subtract(const Duration(hours: 1))),
          () => fixture.idp.startLogin(session, email: 'old@serverpod.dev'),
        );
        validRequestId = await fixture.idp.startLogin(
          session,
          email: 'new@serverpod.dev',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when deleteExpiredLoginRequests is called', () {
        setUp(() async {
          await fixture.idp.admin.deleteExpiredLoginRequests(session);
        });

        test('then the expired request is deleted.', () async {
          expect(
            await EmailAccountLoginRequest.db.findById(
              session,
              expiredRequestId,
            ),
            isNull,
          );
        });

        test('then the valid request is kept.', () async {
          expect(
            await EmailAccountLoginRequest.db.findById(session, validRequestId),
            isNotNull,
          );
        });

        test(
          'then the challenge of the expired request is deleted too.',
          () async {
            expect(await SecretChallenge.db.count(session), 1);
          },
        );
      });

      group('when deleteLoginRequestById is called for the valid request', () {
        setUp(() async {
          await fixture.idp.admin.deleteLoginRequestById(
            session,
            validRequestId,
          );
        });

        test('then only that request and its challenge are deleted.', () async {
          final requests = await EmailAccountLoginRequest.db.find(session);

          expect(requests.map((final r) => r.id), [expiredRequestId]);
          expect(await SecretChallenge.db.count(session), 1);
        });
      });

      test(
        'when deleteLoginRequestById is called for an unknown ID then it does nothing.',
        () async {
          await fixture.idp.admin.deleteLoginRequestById(
            session,
            const Uuid().v7obj(),
          );

          expect(await EmailAccountLoginRequest.db.count(session), 2);
        },
      );
    },
  );

  withServerpod(
    'Given rate limited login attempts for an email',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture(
          loginRequestRateLimit: const RateLimit(
            maxAttempts: 1,
            timeframe: Duration(minutes: 5),
          ),
        );

        await fixture.idp.startLogin(session, email: email);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteLoginAttemptsForEmail is called then the email can request a code again.',
        () async {
          await expectLater(
            fixture.idp.startLogin(session, email: email),
            throwsA(isA<EmailPasswordlessLoginException>()),
          );

          await fixture.idp.admin.deleteLoginAttemptsForEmail(
            session,
            email: email.toUpperCase(),
          );

          await expectLater(
            fixture.idp.startLogin(session, email: email),
            completion(isA<UuidValue>()),
          );
        },
      );

      test(
        'when deleteExpiredLoginAttempts is called after the time frame then the attempts are deleted.',
        () async {
          await withClock(
            Clock.fixed(DateTime.now().add(const Duration(minutes: 6))),
            () => fixture.idp.admin.deleteExpiredLoginAttempts(session),
          );

          expect(
            await RateLimitedRequestAttempt.db.count(
              session,
              where: (final t) => t.domain.equals('email_passwordless'),
            ),
            0,
          );
        },
      );
    },
  );
}
