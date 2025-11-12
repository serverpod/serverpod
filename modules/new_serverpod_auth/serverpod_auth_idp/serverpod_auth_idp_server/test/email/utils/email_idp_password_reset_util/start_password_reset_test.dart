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
    'Given existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
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
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when requesting password reset with correct email then it succeeds and returns password reset request id',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );

      test(
        'when requesting password reset with uppercase email then it succeeds and returns password reset request id',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email.toUpperCase(),
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );

      test(
        'when requesting password reset with email with spaces then it succeeds and returns password reset request id',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: '  $email  ',
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );
    },
  );

  withServerpod(
    'Given successful password reset request when capturing output from send request verification code callback',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      late String verificationCode;
      const email = 'test@serverpod.dev';
      late String capturedEmail;
      late UuidValue capturedPasswordResetRequestId;
      late String capturedVerificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            sendPasswordResetVerificationCode:
                (
                  final session, {
                  required final String email,
                  required final UuidValue passwordResetRequestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                }) {
                  capturedEmail = email;
                  capturedPasswordResetRequestId = passwordResetRequestId;
                  capturedVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
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

      test(
        'then captured email matches the email used to request the password reset',
        () async {
          expect(capturedEmail, equals(email));
        },
      );
      test(
        'then captured password reset request id matches the id returned from the start password reset request',
        () async {
          expect(
            capturedPasswordResetRequestId,
            equals(passwordResetRequestId),
          );
        },
      );
      test(
        'then captured verification code matches the code generated by the configured verification code generator',
        () async {
          expect(capturedVerificationCode, equals(verificationCode));
        },
      );
    },
  );

  withServerpod(
    'Given an email account with password resets requests attempts matching the rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
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
        );

        // Make initial request to hit the rate limit
        await session.db.transaction(
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

      test(
        'when requesting password reset with same email within timeframe then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetTooManyAttemptsException>()),
          );
        },
      );

      test(
        'when requesting password reset with same email outside of timeframe then it succeeds and returns password reset request id',
        () async {
          await withClock(
            Clock.fixed(DateTime.now().add(maxPasswordResetAttempts.timeframe)),
            () async {
              final result = await session.db.transaction(
                (final transaction) =>
                    fixture.passwordResetUtil.startPasswordReset(
                      session,
                      email: email,
                      transaction: transaction,
                    ),
              );

              expect(result, isNotNull);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given no email account exists',
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
        'when requesting password reset then it throws email not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: 'nonexistent@serverpod.dev',
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetEmailNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given password reset has been requested for non existing email account past rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'nonexistent@serverpod.dev';
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

        // Make initial request to hit the rate limit
        try {
          await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );
        } on EmailPasswordResetEmailNotFoundException catch (_) {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when requesting password reset with same email then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetTooManyAttemptsException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given two subsequent password reset requests for the same email',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue firstPasswordResetRequestId;
      late UuidValue secondPasswordResetRequestId;
      const email = 'test@serverpod.dev';
      const fixedVerificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => fixedVerificationCode,
            maxPasswordResetAttempts: const RateLimit(
              maxAttempts: 3,
              timeframe: Duration(hours: 1),
            ),
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
        );

        firstPasswordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        secondPasswordResetRequestId = await session.db.transaction(
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

      test(
        'when attempting to complete validate the first password reset request then it throws request not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: firstPasswordResetRequestId,
                  verificationCode: fixedVerificationCode,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        },
      );

      test(
        'when attempting to verify the second password reset request then it succeeds and returns finish password reset token',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: secondPasswordResetRequestId,
                  verificationCode: fixedVerificationCode,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            completion(isA<String>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given password reset requests exist for two users',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue secondPasswordResetRequestId;
      const firstEmail = 'test1@serverpod.dev';
      const fixedVerificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => fixedVerificationCode,
            maxPasswordResetAttempts: const RateLimit(
              maxAttempts: 3,
              timeframe: Duration(hours: 1),
            ),
          ),
        );

        // First user
        final firstUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: firstUser.id,
          email: firstEmail,
        );

        await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: firstEmail,
            transaction: transaction,
          ),
        );

        // Second user
        const secondEmail = 'test2@serverpod.dev';
        final secondUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: secondUser.id,
          email: secondEmail,
        );

        secondPasswordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: secondEmail,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when first user requests a second password reset request then second user can still verify its first request',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: firstEmail,
              transaction: transaction,
            ),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: secondPasswordResetRequestId,
                  verificationCode: fixedVerificationCode,
                  transaction: transaction,
                ),
          );

          await expectLater(result, completion(isA<String>()));
        },
      );
    },
  );
}
