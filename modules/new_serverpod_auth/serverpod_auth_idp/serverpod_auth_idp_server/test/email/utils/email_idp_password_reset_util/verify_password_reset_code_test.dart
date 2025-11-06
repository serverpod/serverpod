import 'dart:async';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

/// Database rollbacks are disabled for these tests because rate limit is
/// logged outside of the passed in transaction.
void main() {
  withServerpod(
    'Given password reset request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late String verificationCode;
      const passwordResetVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
            config: EmailIDPConfig(
          secretHashPepper: 'pepper',
          passwordResetVerificationCodeGenerator: () => verificationCode,
          passwordResetVerificationCodeLifetime:
              passwordResetVerificationCodeLifetime,
        ));

        final authUser = await fixture.createAuthUser(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
          'when verify password reset code is called with generated verification code',
          () {
        late Future<String> verifyPasswordResetCodeResult;

        setUp(() async {
          verifyPasswordResetCodeResult = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );
        });

        test('then it succeeds and returns complete password reset token',
            () async {
          final result = await verifyPasswordResetCodeResult;
          expect(result, isA<String>());
        });
      });

      test(
          'when called with invalid verification code then throws invalid verification code exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: '$verificationCode-invalid-addition',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
        );
      });

      test(
          'when verify password reset code is called with valid credentials after expiration then throws request expired exception',
          () async {
        await withClock(
            Clock.fixed(DateTime.now().add(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            )), () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetRequestExpiredException>()),
          );
        });
      });

      test(
          'when verify password reset code is called with invalid credentials after expiration then throws invalid verification code exception',
          () async {
        await withClock(
            Clock.fixed(DateTime.now().add(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            )), () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: '$verificationCode-invalid-addition',
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
          );
        });
      });

      group(
          'when verifyPasswordResetCode is called multiple times in quick succession',
          () {
        late Future<List<String>> attempts;
        const numberOfAttempts = 3;

        setUp(() async {
          attempts = List.generate(
            numberOfAttempts,
            (final _) => session.db.transaction((final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: passwordResetRequestId,
                  verificationCode: verificationCode,
                  transaction: transaction,
                )),
          ).wait;
        });

        test(
            'then all attempts except one throw EmailPasswordResetVerificationCodeAlreadyUsedException',
            () async {
          await expectLater(
            attempts,
            throwsA(
              isA<ParallelWaitError>()
                  .having(
                    (final e) => (e.errors as List<AsyncError?>).nonNulls,
                    'errors',
                    hasLength(numberOfAttempts - 1),
                  )
                  .having(
                    (final e) => (e.errors as List<AsyncError?>).nonNulls.map(
                          (final e) => e.error,
                        ),
                    'errors',
                    everyElement(
                      isA<EmailPasswordResetVerificationCodeAlreadyUsedException>(),
                    ),
                  ),
            ),
          );
        });

        test('then only one attempts succeeds', () async {
          await expectLater(
            attempts,
            throwsA(
              isA<ParallelWaitError>().having(
                (final e) => (e.values as List<String?>).nonNulls,
                'values',
                hasLength(1),
              ),
            ),
          );
        });
      });
    },
  );

  withServerpod('Given password reset request that has been verified',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
      (final sessionBuilder, final endpoints) {
    late Session session;
    late EmailIDPTestFixture fixture;
    late UuidValue passwordResetRequestId;
    late String verificationCode;
    const Duration passwordResetVerificationCodeLifetime = Duration(days: 1);

    setUp(() async {
      session = sessionBuilder.build();

      verificationCode = const Uuid().v4().toString();
      fixture = EmailIDPTestFixture(
        config: EmailIDPConfig(
          secretHashPepper: 'pepper',
          passwordResetVerificationCodeGenerator: () => verificationCode,
          passwordResetVerificationCodeLifetime:
              passwordResetVerificationCodeLifetime,
        ),
      );

      final authUser = await fixture.createAuthUser(session);

      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
        password: EmailAccountPassword.fromString(password),
      );

      passwordResetRequestId = await session.db.transaction(
        (final transaction) => fixture.passwordResetUtil.startPasswordReset(
          session,
          email: email,
          transaction: transaction,
        ),
      );

      // Verify the password reset code (this marks it as used)
      await session.db.transaction(
        (final transaction) =>
            fixture.passwordResetUtil.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      );
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
        'when verify password reset code is called again with valid verification code then it throws verification code already used exception',
        () async {
      final result = session.db.transaction(
        (final transaction) =>
            fixture.passwordResetUtil.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
          transaction: transaction,
        ),
      );

      await expectLater(
        result,
        throwsA(isA<EmailPasswordResetVerificationCodeAlreadyUsedException>()),
      );
    });

    test(
        'when verify password reset code is called with expired request that has been verified then it throws verification code already used exception',
        () async {
      await withClock(
          Clock.fixed(DateTime.now().add(
            passwordResetVerificationCodeLifetime + const Duration(hours: 1),
          )), () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
              isA<EmailPasswordResetVerificationCodeAlreadyUsedException>()),
        );
      });
    });
  });

  withServerpod(
    'Given password reset request that has been validated with invalid credentials and config allows multiple attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeAllowedAttempts: 2,
          ),
        );

        final authUser = await fixture.createAuthUser(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final result = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        passwordResetRequestId = result;

        // Attempt with invalid credentials
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailPasswordResetInvalidVerificationCodeException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify password reset code is called with valid verification code then it succeeds and returns complete password reset token',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        expect(result, isA<String>());
      });
    },
  );

  withServerpod(
    'Given password reset request was validated with expired credentials',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const verificationCode = '12345678';
      const passwordResetVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
          ),
        );

        final authUser = await fixture.createAuthUser(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final result = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        passwordResetRequestId = result;

        // Try to verify after expiration
        await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ), () async {
          try {
            await session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
            );
          } on EmailPasswordResetRequestExpiredException {
            // Expected - this should delete the request
          }
        });
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify password reset code is called with valid credentials then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
        );
      });
    },
  );

  withServerpod(
    'Given password reset request that has failed verification matching the rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
              secretHashPepper: 'pepper',
              passwordResetVerificationCodeAllowedAttempts: 1,
              passwordResetVerificationCodeGenerator: () => verificationCode,
              passwordResetVerificationCodeLifetime: const Duration(days: 1)),
        );

        final authUser = await fixture.createAuthUser(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final result = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        passwordResetRequestId = result;

        // Make attempts up to the limit
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailPasswordResetInvalidVerificationCodeException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify password reset code is called with valid credentials then it throws too many attempts exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
              isA<EmailPasswordResetTooManyVerificationAttemptsException>()),
        );
      });
    },
  );

  withServerpod(
    'Given existing password reset that has failed to verify past the maximum number of allowed verification attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeAllowedAttempts: 1,
            passwordResetVerificationCodeLifetime: Duration(days: 1),
          ),
        );

        final authUser = await fixture.createAuthUser(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final result = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        passwordResetRequestId = result;

        // Exhaust allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailPasswordResetInvalidVerificationCodeException {
          // Expected
        }

        // Go past the allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailPasswordResetTooManyVerificationAttemptsException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify password reset code is called with valid verification code then throws not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
        );
      });
    },
  );
}
