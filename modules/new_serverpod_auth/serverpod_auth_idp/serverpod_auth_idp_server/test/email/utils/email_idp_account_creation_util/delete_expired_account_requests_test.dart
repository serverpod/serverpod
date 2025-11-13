import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given account request within verification code lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
          ),
        );

        accountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
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
        'when deleting expired account requests then request can still be verified',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.deleteExpiredAccountRequests(
                  session,
                  transaction: transaction,
                ),
          );

          // Should still succeed
          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );

          await expectLater(result, completes);
        },
      );
    },
  );

  withServerpod(
    'Given expired account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const verificationCode = '12345678';
      const registrationVerificationCodeLifetime = Duration(hours: 1);
      late Clock clockBeforeTimeframe;

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime:
                registrationVerificationCodeLifetime,
          ),
        );

        clockBeforeTimeframe = Clock.fixed(
          DateTime.now().subtract(
            registrationVerificationCodeLifetime + const Duration(minutes: 1),
          ),
        );
        accountRequestId = await withClock(
          clockBeforeTimeframe,
          () => session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
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
      // attempting to verify an expired request within the valid timeframe
      // of that request.
      test(
        'when deleting expired account requests then attempting to verify expired request within requests timeframe throws request not found exception',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.deleteExpiredAccountRequests(
                  session,
                  transaction: transaction,
                ),
          );

          await withClock(clockBeforeTimeframe, () async {
            final result = session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.verifyRegistrationCode(
                    session,
                    accountRequestId: accountRequestId,
                    verificationCode: verificationCode,
                    transaction: transaction,
                  ),
            );

            await expectLater(
              result,
              throwsA(isA<EmailAccountRequestNotFoundException>()),
            );
          });
        },
      );
    },
  );
}
