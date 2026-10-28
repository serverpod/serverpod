import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given a user reached the registration rate limit at a fixed time,',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      const email = 'test@serverpod.dev';
      final attemptClock = Clock.fixed(DateTime.utc(2026, 1, 1));
      const maxRegistrationAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      Future<UuidValue> startRegistration() => session.db.transaction(
        (final transaction) => fixture.accountCreationUtil.startRegistration(
          session,
          email: email,
          transaction: transaction,
        ),
      );

      Future<void> deleteRegistrationAttempts({
        required final Duration? olderThan,
        final String? email,
      }) => session.db.transaction(
        (final transaction) =>
            fixture.accountCreationUtil.deleteRegistrationAttempts(
              session,
              olderThan: olderThan,
              email: email,
              transaction: transaction,
            ),
      );

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIdpTestFixture(
          config: const EmailIdpConfig(
            secretHashPepper: 'pepper',
            maxRegistrationAttempts: maxRegistrationAttempts,
          ),
        );

        await withClock(attemptClock, startRegistration);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when cleaning up with a null duration, '
        'then the user remains rate limited.',
        () async {
          await withClock(attemptClock, () async {
            await deleteRegistrationAttempts(olderThan: null);

            await expectLater(
              startRegistration(),
              throwsA(
                isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
              ),
            );
          });
        },
      );

      test(
        'when cleaning up with a zero duration in the same clock tick, '
        'then the user can start another registration.',
        () async {
          await withClock(attemptClock, () async {
            await deleteRegistrationAttempts(olderThan: Duration.zero);

            await expectLater(
              startRegistration(),
              completion(isA<UuidValue>()),
            );
          });
        },
      );

      test(
        'when cleaning up with a zero duration for a different email, '
        'then the user remains rate limited.',
        () async {
          await withClock(attemptClock, () async {
            await deleteRegistrationAttempts(
              olderThan: Duration.zero,
              email: 'other-$email',
            );

            await expectLater(
              startRegistration(),
              throwsA(
                isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
              ),
            );
          });
        },
      );

      test(
        'when cleaning up with a zero duration for the same email, '
        'then the user can start another registration.',
        () async {
          await withClock(attemptClock, () async {
            await deleteRegistrationAttempts(
              olderThan: Duration.zero,
              email: email,
            );

            await expectLater(
              startRegistration(),
              completion(isA<UuidValue>()),
            );
          });
        },
      );

      test(
        'when cleaning up with a zero duration for the same email in a '
        'different case, '
        'then the user can start another registration.',
        () async {
          await withClock(attemptClock, () async {
            await deleteRegistrationAttempts(
              olderThan: Duration.zero,
              email: email.toUpperCase(),
            );

            await expectLater(
              startRegistration(),
              completion(isA<UuidValue>()),
            );
          });
        },
      );
    },
  );
}
