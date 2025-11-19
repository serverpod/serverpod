import 'dart:async';
import 'dart:convert';

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
          ),
        );

        final authUser = await fixture.authUsers.create(session);

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

          test(
            'then it succeeds and returns complete password reset token',
            () async {
              final result = await verifyPasswordResetCodeResult;
              expect(result, isA<String>());
            },
          );
        },
      );

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
        },
      );

      test(
        'when verify password reset code is called with valid credentials after expiration then throws request expired exception',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
                throwsA(isA<EmailPasswordResetRequestExpiredException>()),
              );
            },
          );
        },
      );

      test(
        'when verify password reset code is called with invalid credentials after expiration then throws invalid verification code exception',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
                throwsA(
                  isA<EmailPasswordResetInvalidVerificationCodeException>(),
                ),
              );
            },
          );
        },
      );

      group(
        'when verifyPasswordResetCode is called multiple times in quick succession',
        () {
          late Future<List<String>> attempts;
          const numberOfAttempts = 3;

          setUp(() async {
            attempts = List.generate(
              numberOfAttempts,
              (final _) => session.db.transaction(
                (final transaction) =>
                    fixture.passwordResetUtil.verifyPasswordResetCode(
                      session,
                      passwordResetRequestId: passwordResetRequestId,
                      verificationCode: verificationCode,
                      transaction: transaction,
                    ),
              ),
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
                        (final e) =>
                            (e.errors as List<AsyncError?>).nonNulls.map(
                              (final e) => e.error,
                            ),
                        'errors',
                        everyElement(
                          isA<
                            EmailPasswordResetVerificationCodeAlreadyUsedException
                          >(),
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
      late String completePasswordResetToken;
      const passwordResetVerificationCodeAllowedAttempts = 2;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
            passwordResetVerificationCodeAllowedAttempts:
                passwordResetVerificationCodeAllowedAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

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
        completePasswordResetToken = await session.db.transaction(
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
            throwsA(
              isA<EmailPasswordResetVerificationCodeAlreadyUsedException>(),
            ),
          );
        },
      );

      test(
        'when verify password reset code is called with expired request that has been verified then it throws verification code already used exception',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
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
                  isA<EmailPasswordResetVerificationCodeAlreadyUsedException>(),
                ),
              );
            },
          );
        },
      );

      group(
        'when exceeding the allowed number of attempts then it throws too many attempts exception',
        () {
          late Future<String> verifyPasswordResetCodeFuture;

          setUp(() async {
            assert(
              fixture.config.passwordResetVerificationCodeAllowedAttempts == 2,
              'Assuming only two attempts are allowed allowed so that the third attempt will exceed the threshold',
            );
            final firstAttempt = session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: passwordResetRequestId,
                    verificationCode: verificationCode,
                    transaction: transaction,
                  ),
            );

            try {
              await firstAttempt;
            } on EmailPasswordResetVerificationCodeAlreadyUsedException {
              // Expected
            }

            verifyPasswordResetCodeFuture = session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: passwordResetRequestId,
                    verificationCode: verificationCode,
                    transaction: transaction,
                  ),
            );
          });

          test('then it throws too many attempts exception', () async {
            await expectLater(
              verifyPasswordResetCodeFuture,
              throwsA(
                isA<EmailPasswordResetTooManyVerificationAttemptsException>(),
              ),
            );
          });

          test('then password reset can still be completed', () async {
            try {
              await verifyPasswordResetCodeFuture;
            } catch (_) {
              // Expecting an exception
            }

            final result = await session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.completePasswordReset(
                    session,
                    completePasswordResetToken: completePasswordResetToken,
                    newPassword: 'NewPassword123!',
                    transaction: transaction,
                  ),
            );

            expect(result, isA<UuidValue>());
          });
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
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
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
          },
        );
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
              isA<EmailPasswordResetTooManyVerificationAttemptsException>(),
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
        'when verify password reset code is called with valid verification code then too many attempts exception is thrown',
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
              isA<EmailPasswordResetTooManyVerificationAttemptsException>(),
            ),
          );
        },
      );

      test(
        'when complete password reset is called then it throws request not found exception',
        () async {
          // This test depends in implementation details but ensures we remove the
          // request and behave as expected when attempting to complete a removed
          // password reset request.

          // This needs to be updated if the implementation details for the token change.
          final mockedToken = base64Encode(
            utf8.encode('$passwordResetRequestId:mocked-tokend'),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken: mockedToken,
                  newPassword: 'NewPassword123!',
                  transaction: transaction,
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
    'Given no password reset request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue nonExistentPasswordResetRequestId;
      const passwordResetVerificationCodeAllowedAttempts = 1;

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeAllowedAttempts:
                passwordResetVerificationCodeAllowedAttempts,
            passwordResetVerificationCodeGenerator: () => '12345678',
            passwordResetVerificationCodeLifetime: const Duration(days: 1),
          ),
        );

        nonExistentPasswordResetRequestId = const Uuid().v4obj();

        // Make attempts up to the limit with invalid verification codes
        for (int i = 0; i < passwordResetVerificationCodeAllowedAttempts; i++) {
          try {
            await session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: nonExistentPasswordResetRequestId,
                    verificationCode: 'wrong-code',
                    transaction: transaction,
                  ),
            );
          } on EmailPasswordResetRequestNotFoundException {
            // Expected - the request doesn't exist
          }
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verify password reset code is called and it exceeds the maximum number of allowed verification attempts then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: nonExistentPasswordResetRequestId,
                  verificationCode: 'any-code',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailPasswordResetTooManyVerificationAttemptsException>(),
            ),
          );
        },
      );
    },
  );
}
