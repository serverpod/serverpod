import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an existing auth user',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when createEmailAuthentication is called with valid parameters then it creates email authentication that can be used to authenticate',
        () async {
          final emailAccountId = await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.createEmailAuthentication(
                  session,
                  authUserId: authUserId,
                  email: email,
                  password: password,
                  transaction: transaction,
                ),
          );

          expect(emailAccountId, isA<UuidValue>());

          final authResult = await session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          expect(authResult, equals(authUserId));
        },
      );
    },
  );

  withServerpod('Given an email account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late EmailIDPTestFixture fixture;
    const email = 'test@serverpod.dev';
    late UuidValue emailAccountId;
    setUp(() async {
      session = sessionBuilder.build();
      fixture = EmailIDPTestFixture();
      final authUser = await fixture.authUsers.create(session);
      final emailAccount = await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
      );
      emailAccountId = emailAccount.id!;
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
      'when findAccount is called with uppercase email then it finds email account',
      () async {
        final result = await session.db.transaction(
          (final transaction) => fixture.emailIDP.admin.findAccount(
            session,
            email: email.toUpperCase(),
            transaction: transaction,
          ),
        );

        expect(result, isNotNull);
        expect(result?.id, equals(emailAccountId));
      },
    );
  });

  withServerpod('Given an email account without password', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late EmailIDPTestFixture fixture;
    const email = 'test@serverpod.dev';

    setUp(() async {
      session = sessionBuilder.build();
      fixture = EmailIDPTestFixture();

      final authUser = await fixture.authUsers.create(session);

      await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
        password: null,
      );
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test('when findAccount is called then hasPassword is false', () async {
      final result = await session.db.transaction(
        (final transaction) => fixture.emailIDP.admin.findAccount(
          session,
          email: email,
          transaction: transaction,
        ),
      );

      expect(result, isNotNull);
      expect(result?.hasPassword, isFalse);
    });

    test(
      'when setPassword is called with uppercase email then it sets password',
      () async {
        await session.db.transaction(
          (final transaction) => fixture.emailIDP.admin.setPassword(
            session,
            email: email.toUpperCase(),
            password: 'NewPassword123!',
            transaction: transaction,
          ),
        );

        // Verify password was set
        final result = await session.db.transaction(
          (final transaction) => fixture.emailIDP.admin.findAccount(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        expect(result?.hasPassword, isTrue);
      },
    );
  });

  withServerpod(
    'Given an email account with password',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('when findAccount is called then hasPassword is true', () async {
        final result = await session.db.transaction(
          (final transaction) => fixture.emailIDP.admin.findAccount(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        expect(result, isNotNull);
        expect(result?.hasPassword, isTrue);
      });
    },
  );

  withServerpod(
    'Given expired password reset request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const passwordResetLifetime = Duration(minutes: 15);
      late UuidValue expiredRequestId;
      final String verificationCode = const Uuid().v4().toString();
      late Clock clockBeforeTimeframe;

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeLifetime: passwordResetLifetime,
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        clockBeforeTimeframe = Clock.fixed(
          DateTime.now().subtract(
            passwordResetLifetime + const Duration(hours: 1),
          ),
        );
        // Create an expired password reset request using startPasswordReset
        await withClock(clockBeforeTimeframe, () async {
          expiredRequestId = await session.db.transaction(
            (final transaction) => fixture.emailIDP.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );
        });
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteExpiredPasswordResetRequests is called then expired request is deleted',
        () async {
          // Delete expired requests
          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteExpiredPasswordResetRequests(
                  session,
                  transaction: transaction,
                ),
          );

          // Verify expired request by trying to complete it withing request lifetime
          final result = withClock(
            clockBeforeTimeframe,
            () => session.db.transaction(
              (final transaction) =>
                  fixture.emailIDP.utils.passwordReset.verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: expiredRequestId,
                    verificationCode: verificationCode,
                    transaction: transaction,
                  ),
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an existing account request',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        accountRequestId = await session.db.transaction(
          (final transaction) => fixture.emailIDP.startRegistration(
            session,
            email: 'test@serverpod.dev',
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when findActiveEmailAccountRequest is called then it returns the request',
        () async {
          final result = await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.findActiveEmailAccountRequest(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          expect(result, isNotNull);
          expect(result?.id, equals(accountRequestId));
        },
      );

      test(
        'when deleteEmailAccountRequestById is called then it deletes the request',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteEmailAccountRequestById(
                  session,
                  accountRequestId,
                  transaction: transaction,
                ),
          );

          // Verify request was deleted
          final result = await EmailAccountRequest.db.findById(
            session,
            accountRequestId,
          );
          expect(result, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given no email account exists',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('when findAccount is called then it returns null', () async {
        final result = await session.db.transaction(
          (final transaction) => fixture.emailIDP.admin.findAccount(
            session,
            email: 'nonexistent@serverpod.dev',
            transaction: transaction,
          ),
        );

        expect(result, isNull);
      });

      test(
        'when setPassword is called then it throws EmailAccountNotFoundException',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.setPassword(
              session,
              email: 'nonexistent@serverpod.dev',
              password: 'Password123!',
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAccountNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given no account request exists',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when findActiveEmailAccountRequest is called then it returns null',
        () async {
          final result = await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.findActiveEmailAccountRequest(
                  session,
                  accountRequestId: const Uuid().v4obj(),
                  transaction: transaction,
                ),
          );

          expect(result, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given email account with maximum number of allowed password reset attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const maxPasswordResetAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            maxPasswordResetAttempts: maxPasswordResetAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        // Make initial request to hit the rate limit
        await session.db.transaction(
          (final transaction) => fixture.emailIDP.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deletePasswordResetRequestsAttemptsForEmail is called then user can request password reset again',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin
                .deletePasswordResetRequestsAttemptsForEmail(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );
    },
  );

  withServerpod(
    'Given email account with maximum number allowed failed login attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const maxFailedLoginAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            failedLoginRateLimit: maxFailedLoginAttempts,
          ),
        );
        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        // Make initial failed login attempt to hit the rate limit
        try {
          await session.db.transaction(
            (final transaction) => fixture.emailIDP.login(
              session,
              email: email,
              password: 'WrongPassword123!',
              transaction: transaction,
            ),
          );
        } on EmailAccountLoginException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteFailedLoginAttempts is called with older than zero then user can login again',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteFailedLoginAttempts(
                  session,
                  olderThan: const Duration(microseconds: 0),
                  transaction: transaction,
                ),
          );

          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.login(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<AuthSuccess>()));
        },
      );

      test(
        'when deleteFailedLoginAttempts is called without older than user is still blocked from logging in',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteFailedLoginAttempts(
                  session,
                  transaction: transaction,
                ),
          );

          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.login(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(result, throwsA(isA<EmailAccountLoginException>()));
        },
      );
    },
  );

  withServerpod(
    'Given an email account with password and password reset request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        await session.db.transaction(
          (final transaction) => fixture.emailIDP.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteEmailAccount is called with lowercase email then account is deleted',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.deleteEmailAccount(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          final result = await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.findAccount(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          expect(result, isNull);
        },
      );

      test(
        'when deleteEmailAccount is called with uppercase email then account is deleted',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.deleteEmailAccount(
              session,
              email: email.toUpperCase(),
              transaction: transaction,
            ),
          );

          final result = await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.findAccount(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          expect(result, isNull);
        },
      );

      test(
        'when deleteEmailAccount is called then related password reset requests are deleted',
        () async {
          final resetRequestsBefore = await EmailAccountPasswordResetRequest.db
              .find(
                session,
              );
          expect(resetRequestsBefore.length, greaterThan(0));

          await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.deleteEmailAccount(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          final resetRequestsAfter = await EmailAccountPasswordResetRequest.db
              .find(
                session,
              );
          expect(resetRequestsAfter, isEmpty);
        },
      );

      test(
        'when deleteEmailAccountByAuthUserId is called then account is deleted',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteEmailAccountByAuthUserId(
                  session,
                  authUserId: authUserId,
                  transaction: transaction,
                ),
          );

          final result = await session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.findAccount(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          expect(result, isNull);
        },
      );

      test(
        'when deleteEmailAccountByAuthUserId is called then related password reset requests are deleted',
        () async {
          final resetRequestsBefore = await EmailAccountPasswordResetRequest.db
              .find(
                session,
              );
          expect(resetRequestsBefore.length, greaterThan(0));

          await session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteEmailAccountByAuthUserId(
                  session,
                  authUserId: authUserId,
                  transaction: transaction,
                ),
          );

          final resetRequestsAfter = await EmailAccountPasswordResetRequest.db
              .find(
                session,
              );
          expect(resetRequestsAfter, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given no email account exists',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleteEmailAccount is called then it throws EmailAccountNotFoundException',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.admin.deleteEmailAccount(
              session,
              email: 'nonexistent@serverpod.dev',
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAccountNotFoundException>()),
          );
        },
      );

      test(
        'when deleteEmailAccountByAuthUserId is called then it throws EmailAccountNotFoundException',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.emailIDP.admin.deleteEmailAccountByAuthUserId(
                  session,
                  authUserId: const Uuid().v4obj(),
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAccountNotFoundException>()),
          );
        },
      );
    },
  );
}
