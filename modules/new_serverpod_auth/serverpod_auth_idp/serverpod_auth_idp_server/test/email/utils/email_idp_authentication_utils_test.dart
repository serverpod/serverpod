import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given existing email account',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late Session session;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late EmailIDPAuthenticationUtil authenticationUtil;

      setUp(() async {
        session = sessionBuilder.build();
        final fixture = EmailIDPTestFixture();
        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        authenticationUtil = fixture.authenticationUtil;
      });

      test(
        'when authenticating with correct credentials then it succeeds with the auth user id',
        () async {
          final result = session.db.transaction(
            (final transaction) => authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(authUserId));
        },
      );

      test(
        'when authenticating with correct password but modified casing of email then it succeeds with the auth user id',
        () async {
          final result = session.db.transaction((final transaction) async {
            return await authenticationUtil.authenticate(
              session,
              email: email.toUpperCase(),
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(result, completion(authUserId));
        },
      );

      test(
        'when authenticating with incorrect credentials then it throws an error with invalidCredentials',
        () async {
          final result = session.db.transaction(
            (final transaction) => authenticationUtil.authenticate(
              session,
              email: email,
              password: '$password-incorrect',
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationInvalidCredentialsException>()),
          );
        },
      );
    },
  );

  withServerpod('Given non-existing email account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late EmailIDPAuthenticationUtil emailIDPAuthenticationUtil;

    setUp(() async {
      session = sessionBuilder.build();
      final fixture = EmailIDPTestFixture();

      emailIDPAuthenticationUtil = fixture.authenticationUtil;
    });

    test(
      'when authenticating then it throws an error with email account not found exception',
      () async {
        final result = session.db.transaction(
          (final transaction) => emailIDPAuthenticationUtil.authenticate(
            session,
            email: 'invalid@serverpod.dev',
            password: 'invalid-password',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountNotFoundException>()),
        );
      },
    );
  });

  withServerpod(
    'Given email account that has failed to sign in past the rate limit',

    /// Disabling rollback database since we use separate transaction for
    /// logging failed sign in attempts.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late AuthUserModel authUser;
      late Session session;
      const failedLoginRateLimit = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late EmailIDPAuthenticationUtil authenticationUtil;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'test-pepper',
            failedLoginRateLimit: failedLoginRateLimit,
          ),
        );

        authUser = await fixture.authUsers.create(session);
        final authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        authenticationUtil = fixture.authenticationUtil;

        final result = session.db.transaction(
          (final transaction) => authenticationUtil.authenticate(
            session,
            email: email,
            password: '$password-incorrect',
            transaction: transaction,
          ),
        );

        try {
          await result;
        } on EmailAuthenticationInvalidCredentialsException {
          // This is expected.
        }

        final failedLoginAttempts = await EmailAccountFailedLoginAttempt.db
            .find(session, where: (final t) => t.email.equals(email));

        assert(
          failedLoginAttempts.length == failedLoginRateLimit.maxAttempts,
          'Expected ${failedLoginRateLimit.maxAttempts} failed login attempts, but got ${failedLoginAttempts.length}',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when authenticating with correct credentials then it throws an error with tooManyFailedAttempts',
        () async {
          final result = session.db.transaction((final transaction) async {
            return await authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationTooManyAttemptsException>()),
          );
        },
      );

      test(
        'when deleting all failed login attempts then account can authenticate again',
        () async {
          final result = session.db.transaction((final transaction) async {
            await authenticationUtil.deleteFailedLoginAttempts(
              session,
              transaction: transaction,

              /// Removes all failed login Attempts
              olderThan: const Duration(microseconds: 0),
            );

            return await authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(
            result,
            completion(authUser.id),
          );
        },
      );

      test(
        'when authenticating after the rate limit has expired then it succeeds',
        () async {
          await withClock(
            Clock.fixed(DateTime.now().add(failedLoginRateLimit.timeframe)),
            () async {
              final result = session.db.transaction(
                (final transaction) => authenticationUtil.authenticate(
                  session,
                  email: email,
                  password: password,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                completion(authUser.id),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given non-existing email account failed to sign in past the rate limit',

    /// Disabling rollback database since we use separate transaction for
    /// logging failed sign in attempts.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late EmailIDPAuthenticationUtil authenticationUtil;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        const RateLimit failedLoginRateLimit = RateLimit(
          maxAttempts: 1,
          timeframe: Duration(hours: 1),
        );
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'test-pepper',
            failedLoginRateLimit: failedLoginRateLimit,
          ),
        );

        authenticationUtil = fixture.authenticationUtil;

        final result = session.db.transaction(
          (final transaction) => authenticationUtil.authenticate(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        try {
          await result;
        } on EmailAccountNotFoundException {
          // This is expected.
        }

        final failedLoginAttempts = await EmailAccountFailedLoginAttempt.db
            .find(session, where: (final t) => t.email.equals(email));

        assert(
          failedLoginAttempts.length == failedLoginRateLimit.maxAttempts,
          'Expected ${failedLoginRateLimit.maxAttempts} failed login attempts, but got ${failedLoginAttempts.length}',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when authenticating with same email then it throws an error with tooManyFailedAttempts',
        () async {
          final result = session.db.transaction(
            (final transaction) => authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationTooManyAttemptsException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given non-existing email account failed to sign in past the rate limit when rate limit is configured to multiple attempts',

    /// Disabling rollback database since we use separate transaction for
    /// logging failed sign in attempts.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late EmailIDPAuthenticationUtil authenticationUtil;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        const RateLimit failedLoginRateLimit = RateLimit(
          maxAttempts: 5,
          timeframe: Duration(hours: 1),
        );
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'test-pepper',
            failedLoginRateLimit: failedLoginRateLimit,
          ),
        );

        authenticationUtil = fixture.authenticationUtil;

        for (var i = 0; i < failedLoginRateLimit.maxAttempts; i++) {
          try {
            await session.db.transaction(
              (final transaction) => authenticationUtil.authenticate(
                session,
                email: email,
                password: password,
                transaction: transaction,
              ),
            );
          } on EmailAccountNotFoundException {
            // This is expected.
          }
        }

        final failedLoginAttempts = await EmailAccountFailedLoginAttempt.db
            .find(session, where: (final t) => t.email.equals(email));

        assert(
          failedLoginAttempts.length == failedLoginRateLimit.maxAttempts,
          'Expected ${failedLoginRateLimit.maxAttempts} failed login attempts, but got ${failedLoginAttempts.length}',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when authenticating with same email then it throws an error with tooManyFailedAttempts',
        () async {
          final result = session.db.transaction(
            (final transaction) => authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationTooManyAttemptsException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given max failed login attempts withing timeframe exists for email account ',

    /// Disabling rollback database since we use separate transaction for
    /// logging failed sign in attempts.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late EmailIDPAuthenticationUtil authenticationUtil;
      late EmailIDPTestFixture fixture;
      const RateLimit failedLoginRateLimit = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'test-pepper',
            failedLoginRateLimit: failedLoginRateLimit,
          ),
        );
        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        authenticationUtil = fixture.authenticationUtil;

        final result = session.db.transaction(
          (final transaction) => authenticationUtil.authenticate(
            session,
            email: email,
            password: '$password-incorrect',
            transaction: transaction,
          ),
        );

        try {
          await result;
        } on EmailAuthenticationInvalidCredentialsException {
          // This is expected.
        }

        final failedLoginAttempts = await EmailAccountFailedLoginAttempt.db
            .find(session, where: (final t) => t.email.equals(email));

        assert(
          failedLoginAttempts.length == failedLoginRateLimit.maxAttempts,
          'Expected ${failedLoginRateLimit.maxAttempts} failed login attempts, but got ${failedLoginAttempts.length}',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when deleting failed login attempts without specifying olderThan argument then authentication within timeframe still fails',
        () async {
          final result = session.db.transaction((final transaction) async {
            await authenticationUtil.deleteFailedLoginAttempts(
              session,
              transaction: transaction,
            );

            return await authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationTooManyAttemptsException>()),
          );
        },
      );

      // when deleting all failed login attempts specifying email then authentication succeeds
      test(
        'when deleting all failed login attempts specifying email then authentication succeeds',
        () async {
          final result = session.db.transaction((final transaction) async {
            await authenticationUtil.deleteFailedLoginAttempts(
              session,
              email: email,
              transaction: transaction,
              olderThan: const Duration(microseconds: 0),
            );

            return await authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(
            result,
            completion(authUserId),
          );
        },
      );
      // when deleting all failed login attempts specifying different email then authentication within timeframe still fails
      test(
        'when deleting all failed login attempts specifying different email then authentication within timeframe still fails',
        () async {
          final result = session.db.transaction((final transaction) async {
            await authenticationUtil.deleteFailedLoginAttempts(
              session,
              email: 'different-$email',
              transaction: transaction,
              olderThan: const Duration(microseconds: 0),
            );

            return await authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            );
          });

          await expectLater(
            result,
            throwsA(isA<EmailAuthenticationTooManyAttemptsException>()),
          );
        },
      );
    },
  );
}
