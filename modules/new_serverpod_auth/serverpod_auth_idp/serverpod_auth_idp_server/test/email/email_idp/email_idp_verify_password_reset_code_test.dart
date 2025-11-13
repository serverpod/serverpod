import 'dart:async';

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
      const passwordResetVerificationCodeAllowedAttempts = 4;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
            // This is to make sure that the test does not fail because of the rate limit
            passwordResetVerificationCodeAllowedAttempts:
                passwordResetVerificationCodeAllowedAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

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
          late Future<String> completePasswordResetToken;

          setUp(() async {
            completePasswordResetToken = fixture.emailIDP
                .verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: passwordResetRequestId,
                  verificationCode: verificationCode,
                );
          });

          test(
            'then it succeeds and returns complete password reset token',
            () async {
              final result = await completePasswordResetToken;
              expect(result, isA<String>());
            },
          );
        },
      );

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
        },
      );

      group(
        'when verifyPasswordResetCode is called multiple times in quick succession',
        () {
          late Future<List<String>> attempts;
          const numberOfAttempts = passwordResetVerificationCodeAllowedAttempts;

          setUp(() async {
            attempts = List.generate(
              numberOfAttempts,
              (final _) => fixture.emailIDP.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
              ),
            ).wait;
          });

          test(
            'then all attempts except one throw EmailAccountPasswordResetException with reason "invalid"',
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
                        (final e) =>
                            (e.errors as List<AsyncError?>).nonNulls.map(
                              (final e) => e.error,
                            ),
                        'errors',
                        everyElement(
                          isA<EmailAccountPasswordResetException>().having(
                            (final e) => e.reason,
                            'reason',
                            equals(
                              EmailAccountPasswordResetExceptionReason.invalid,
                            ),
                          ),
                        ),
                      ),
                ),
              );
            },
          );

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
        },
      );

      test(
        'when verifyPasswordResetCode is called with valid credentials after expiration then it throws EmailAccountPasswordResetException with reason "expired"',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
                    EmailAccountPasswordResetExceptionReason.expired,
                  ),
                ),
              );
            },
          );
        },
      );

      test(
        'when verifyPasswordResetCode is called with invalid credentials after expiration then it throws EmailAccountPasswordResetException with reason "invalid" to not leak that the request exists',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given password reset request that has been verified',
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

        final authUser = await fixture.authUsers.create(session);

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
        },
      );

      test(
        'when verifyPasswordResetCode is called with expired request that has been verified then it throws EmailAccountPasswordResetException with reason "invalid" to not leak that the request exists',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
            },
          );
        },
      );
    },
  );

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

        final authUser = await fixture.authUsers.create(session);

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
        'when verifyPasswordResetCode is called with valid verification code then it succeeds and returns complete password reset token',
        () async {
          final result = await fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: verificationCode,
          );

          expect(result, isA<String>());
        },
      );
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

        final authUser = await fixture.authUsers.create(session);

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
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
            try {
              await fixture.emailIDP.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
              );
            } on EmailAccountPasswordResetException {
              // Expected - this should delete the request
            }
          },
        );
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
        },
      );
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
            passwordResetVerificationCodeLifetime: const Duration(days: 1),
          ),
        );

        final authUser = await fixture.authUsers.create(session);

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
        'when verifyPasswordResetCode is called with valid credentials then it throws EmailAccountPasswordResetException with reason "tooManyAttempts"',
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
                EmailAccountPasswordResetExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
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

        final authUser = await fixture.authUsers.create(session);

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
        'when verifyPasswordResetCode is called with valid verification code then throws EmailAccountPasswordResetException with reason "tooManyAttempts"',
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
                EmailAccountPasswordResetExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given no password reset request created',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeAllowedAttempts: 1,
            passwordResetVerificationCodeLifetime: Duration(days: 1),
          ),
        );
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
        },
      );

      test(
        'when verifyPasswordResetCode is called passed the allowed attempts then it throws EmailAccountPasswordResetException with reason "tooManyAttempts"',
        () async {
          final passwordResetRequestId = const Uuid().v4obj();
          // Make attempts up to the limit
          try {
            await fixture.emailIDP.verifyPasswordResetCode(
              session,
              passwordResetRequestId: passwordResetRequestId,
              verificationCode: 'some-code',
            );
          } on EmailAccountPasswordResetException {
            // Expected
          }

          final result = fixture.emailIDP.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: 'some-code',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );
}
