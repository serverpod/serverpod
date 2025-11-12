import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given pending account request within verification code lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

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
        'when find active email account request is called then it returns the account request',
        () async {
          final request = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.findActiveEmailAccountRequest(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          expect(request, isNotNull);
          expect(request!.id, equals(accountRequestId));
          expect(request.email, equals(email));
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
      const registrationVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeLifetime:
                registrationVerificationCodeLifetime,
          ),
        );

        accountRequestId = await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              registrationVerificationCodeLifetime + const Duration(minutes: 1),
            ),
          ),
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

      test(
        'when find active email account request is called then it returns null',
        () async {
          final request = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.findActiveEmailAccountRequest(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          expect(request, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given no account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      final accountRequestId = const Uuid().v4obj();

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when find active email account request is called then it returns null',
        () async {
          final request = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.findActiveEmailAccountRequest(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          expect(request, isNull);
        },
      );
    },
  );
}
