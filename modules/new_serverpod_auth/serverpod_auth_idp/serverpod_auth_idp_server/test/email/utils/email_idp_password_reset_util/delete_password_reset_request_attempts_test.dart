import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given max password reset attempt within timeframe has been reached for user',
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
        'when deleting password reset attempts without older than then user can still not request password reset',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequestAttempts(
                  session,
                  olderThan: null,
                  email: null,
                  transaction: transaction,
                ),
          );

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
        'when deleting password reset attempts that are older than zero then can request password reset',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequestAttempts(
                  session,
                  olderThan: Duration.zero,
                  email: null,
                  transaction: transaction,
                ),
          );

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
    },
  );

  withServerpod(
    'Given max password reset attempts exist for user in the past that is before configured timeframe',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      late Clock clockBeforeTimeframe;

      setUp(() async {
        session = sessionBuilder.build();

        const maxPasswordResetAttempts = RateLimit(
          maxAttempts: 1,
          timeframe: Duration(hours: 1),
        );
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

        clockBeforeTimeframe = Clock.fixed(
          DateTime.now().subtract(
            maxPasswordResetAttempts.timeframe + const Duration(minutes: 30),
          ),
        );

        await withClock(
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

      // This test validates that we accurately remove expired attempts by
      // attempting to create a new password reset request in the past where the
      // existing request attempts would have prevented it.
      test(
        'when deleting password reset request attempts without older than then requesting new password reset in the past succeeds',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequestAttempts(
                  session,
                  olderThan: null,
                  email: null,
                  transaction: transaction,
                ),
          );

          await withClock(clockBeforeTimeframe, () async {
            final result = session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.startPasswordReset(
                    session,
                    email: email,
                    transaction: transaction,
                  ),
            );
            await expectLater(result, completion(isA<UuidValue>()));
          });
        },
      );
    },
  );

  withServerpod(
    'Given password reset attempt within timeframe has been reached for two users',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const firstEmail = 'test1@serverpod.dev';
      const secondEmail = 'test2@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        const maxPasswordResetAttempts = RateLimit(
          maxAttempts: 1,
          timeframe: Duration(hours: 1),
        );
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            maxPasswordResetAttempts: maxPasswordResetAttempts,
          ),
        );

        // Create first user and make request to hit rate limit
        final firstAuthUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: firstAuthUser.id,
          email: firstEmail,
        );
        await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: firstEmail,
            transaction: transaction,
          ),
        );

        // Create second user and make request to hit rate limit
        final secondAuthUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: secondAuthUser.id,
          email: secondEmail,
        );
        await session.db.transaction(
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

      group('when deleting all password reset attempts for first user', () {
        setUp(() async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequestAttempts(
                  session,
                  olderThan: Duration.zero,
                  email: firstEmail,
                  transaction: transaction,
                ),
          );
        });

        test('then first user can request password reset', () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: firstEmail,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        });

        test('then second user still cannot request password reset', () async {
          final result = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: secondEmail,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetTooManyAttemptsException>()),
          );
        });
      });

      test(
        'when deleting all password reset attempts for all users then both users can request password reset',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.deletePasswordResetRequestAttempts(
                  session,
                  olderThan: Duration.zero,
                  email: null,
                  transaction: transaction,
                ),
          );

          final firstResult = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: firstEmail,
              transaction: transaction,
            ),
          );

          final secondResult = session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: secondEmail,
              transaction: transaction,
            ),
          );
          await expectLater(firstResult, completion(isA<UuidValue>()));
          await expectLater(secondResult, completion(isA<UuidValue>()));
        },
      );
    },
  );
}
