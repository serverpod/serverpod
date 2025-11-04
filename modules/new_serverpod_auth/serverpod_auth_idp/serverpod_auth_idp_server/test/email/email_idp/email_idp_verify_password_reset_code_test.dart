import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

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
      const password = 'Password123!';
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
          ),
        );

        final authUser = await fixture.createAuthUser(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
          'when verifyPasswordResetCode is called with generated verification code',
          () {
        late Future<SetPasswordCredentials> verifyPasswordResetCodeResult;

        setUp(() async {
          verifyPasswordResetCodeResult =
              fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
          );
        });

        test('then it succeeds and returns set password credentials', () async {
          final result = await verifyPasswordResetCodeResult;
          expect(result.passwordResetRequestId, equals(passwordResetRequestId));
          expect(result.verificationCode, isNotEmpty);
        });
      });

      test(
          'when verifyPasswordResetCode is called with invalid verification code then it throws EmailAccountPasswordResetException with reason "invalid"',
          () async {
        final result = fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: '$verificationCode-invalid',
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.invalid,
            ),
          ),
        );
      });

      test(
          'when verifyPasswordResetCode is called with valid credentials after expiration then it throws EmailAccountPasswordResetException with reason "expired"',
          () async {
        await withClock(
            Clock.fixed(DateTime.now().add(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            )), () async {
          final result = fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.expired,
              ),
            ),
          );
        });
      });

      test(
          'when verifyPasswordResetCode is called with invalid credentials after expiration then it throws EmailAccountPasswordResetException with reason "expired"',
          () async {
        await withClock(
            Clock.fixed(DateTime.now().add(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            )), () async {
          final result = fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: '$verificationCode-invalid',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.expired,
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
      const password = 'Password123!';
      await fixture.createEmailAccount(
        session,
        authUserId: authUser.id,
        email: email,
        password: EmailAccountPassword.fromString(password),
      );

      passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
        session,
        email: email,
      );

      // Verify the password reset code (this marks it as used)
      await fixture.emailIDP.verifyPasswordResetCode(
        session,
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: verificationCode,
      );
    });

    tearDown(() async {
      await fixture.tearDown(session);
    });

    test(
        'when verifyPasswordResetCode is called again with valid verification code then it throws EmailAccountPasswordResetException with reason "invalid"',
        () async {
      final result = fixture.emailIDP.verifyPasswordResetCode(
        session,
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: verificationCode,
      );

      await expectLater(
        result,
        throwsA(
          isA<EmailAccountPasswordResetException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountPasswordResetExceptionReason.invalid,
          ),
        ),
      );
    });

    test(
        'when verifyPasswordResetCode is called with expired request that has been verified then it throws EmailAccountPasswordResetException with reason "expired"',
        () async {
      await withClock(
          Clock.fixed(DateTime.now().add(
            passwordResetVerificationCodeLifetime + const Duration(hours: 1),
          )), () async {
        final result = fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.expired,
            ),
          ),
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
        const password = 'Password123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );

        // Attempt with invalid credentials
        try {
          await fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountPasswordResetException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verifyPasswordResetCode is called with valid verification code then it succeeds and returns set password credentials',
          () async {
        final result = await fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );

        expect(result.passwordResetRequestId, equals(passwordResetRequestId));
        expect(result.verificationCode, isNotEmpty);
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
        const password = 'Password123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );

        // Try to verify after expiration
        await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ), () async {
          try {
            await fixture.emailIDP.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: verificationCode,
            );
          } on EmailAccountPasswordResetException {
            // Expected - this should delete the request
          }
        });
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verifyPasswordResetCode is called with valid credentials then it throws EmailAccountPasswordResetException with reason "invalid"',
          () async {
        final result = fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.invalid,
            ),
          ),
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
        const password = 'Password123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );

        // Make attempts up to the limit
        try {
          await fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountPasswordResetException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verifyPasswordResetCode is called with valid credentials then it throws EmailAccountPasswordResetException with reason "invalid"',
          () async {
        final result = fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.invalid,
            ),
          ),
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
        const password = 'Password123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        passwordResetRequestId = await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );

        // Exhaust allowed attempts
        try {
          await fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountPasswordResetException {
          // Expected
        }

        // Go past the allowed attempts
        try {
          await fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountPasswordResetException {
          // Expected - this should delete the request
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verifyPasswordResetCode is called with valid verification code then throws EmailAccountPasswordResetException with reason "invalid"',
          () async {
        final result = fixture.emailIDP.verifyPasswordResetCode(
          session,
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );

        await expectLater(
          result,
          throwsA(
            isA<EmailAccountPasswordResetException>().having(
              (final e) => e.reason,
              'reason',
              EmailAccountPasswordResetExceptionReason.invalid,
            ),
          ),
        );
      });
    },
  );

  withServerpod('Given no password reset request created',
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: TestTags.concurrencyOneTestTags,
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
        'when verifyPasswordResetCode is called then it throws EmailAccountPasswordResetException with reason "invalid"',
        () async {
      final result = fixture.emailIDP.verifyPasswordResetCode(
        session,
        passwordResetRequestId: const Uuid().v4obj(),
        verificationCode: 'some-code',
      );

      await expectLater(
        result,
        throwsA(
          isA<EmailAccountPasswordResetException>().having(
            (final e) => e.reason,
            'reason',
            EmailAccountPasswordResetExceptionReason.invalid,
          ),
        ),
      );
    });
  });
}
