import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given password reset request exists within verification code lifetime',
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
        'when deleting password reset requests without older than then request can still be completed',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequests(
                  session,
                  olderThan: null,
                  emailAccountId: null,
                  transaction: transaction,
                ),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  passwordResetRequestId: passwordResetRequestId,
                  verificationCode: verificationCode,
                  newPassword: 'NewPassword123!',
                  transaction: transaction,
                ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );

      test(
        'when deleting request that are older than zero then attempting to complete request throws request not found exception',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequests(
                  session,
                  olderThan: Duration.zero,
                  emailAccountId: null,
                  transaction: transaction,
                ),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  passwordResetRequestId: passwordResetRequestId,
                  verificationCode: verificationCode,
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
    'Given password reset request exists created before verification code lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue passwordResetRequestId;
      const verificationCode = '12345678';
      const passwordResetVerificationCodeLifetime = Duration(hours: 1);
      late Clock clockBeforeTimeframe;

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
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
        );

        clockBeforeTimeframe = Clock.fixed(
          DateTime.now().subtract(
            passwordResetVerificationCodeLifetime + const Duration(minutes: 30),
          ),
        );

        passwordResetRequestId = await withClock(
          clockBeforeTimeframe,
          () => session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      // This test validates that we accurately remove expired requests by
      // attempting to complete a request in the past that should have been removed.
      test(
        'when deleting password reset requests without older than then attempting to complete request in the past throws request not found exception',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequests(
                  session,
                  olderThan: null,
                  emailAccountId: null,
                  transaction: transaction,
                ),
          );

          await withClock(clockBeforeTimeframe, () async {
            final result = session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.completePasswordReset(
                    session,
                    passwordResetRequestId: passwordResetRequestId,
                    verificationCode: verificationCode,
                    newPassword: 'NewPassword123!',
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
    },
  );

  withServerpod(
    'Given password reset requests for two users',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue firstPasswordResetRequestId;
      late UuidValue secondPasswordResetRequestId;
      late UuidValue firstEmailAccountId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );

        // Create first user and password reset request
        final firstAuthUser = await fixture.createAuthUser(session);
        const firstEmail = 'test1@serverpod.dev';
        final firstEmailAccount = await fixture.createEmailAccount(
          session,
          authUserId: firstAuthUser.id,
          email: firstEmail,
        );
        firstEmailAccountId = firstEmailAccount.id!;
        firstPasswordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: firstEmail,
            transaction: transaction,
          ),
        );

        // Create second user and password reset request
        final secondAuthUser = await fixture.createAuthUser(session);
        const secondEmail = 'test2@serverpod.dev';
        await fixture.createEmailAccount(
          session,
          authUserId: secondAuthUser.id,
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
        'when deleting password reset request for first user then second user can still complete its request',
        () async {
          final secondResult = session.db.transaction((
            final transaction,
          ) async {
            await fixture.passwordResetUtil.deletePasswordResetRequests(
              session,
              olderThan: Duration.zero,
              emailAccountId: firstEmailAccountId,
              transaction: transaction,
            );

            return fixture.passwordResetUtil.completePasswordReset(
              session,
              passwordResetRequestId: secondPasswordResetRequestId,
              verificationCode: verificationCode,
              newPassword: 'NewPassword123!',
              transaction: transaction,
            );
          });

          await expectLater(secondResult, completion(isA<UuidValue>()));
        },
      );

      group('when deleting password reset request for all users', () {
        setUp(() async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequests(
                  session,
                  olderThan: Duration.zero,
                  emailAccountId: null,
                  transaction: transaction,
                ),
          );
        });

        test('then first user cannot complete its request', () async {
          final firstResult = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  passwordResetRequestId: firstPasswordResetRequestId,
                  verificationCode: verificationCode,
                  newPassword: 'NewPassword123!',
                  transaction: transaction,
                ),
          );
          await expectLater(
            firstResult,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        });

        test('then second user cannot complete its request', () async {
          final secondResult = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  passwordResetRequestId: secondPasswordResetRequestId,
                  verificationCode: verificationCode,
                  newPassword: 'NewPassword123!',
                  transaction: transaction,
                ),
          );

          await expectLater(
            secondResult,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        });
      });
    },
  );
}
