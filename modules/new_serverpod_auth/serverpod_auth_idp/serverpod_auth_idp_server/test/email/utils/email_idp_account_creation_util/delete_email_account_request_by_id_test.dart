import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given pending account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

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
        'when delete email account request by id is called then attempting to verify registration code throws request not found exception',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.deleteEmailAccountRequestById(
                  session,
                  accountRequestId,
                  transaction: transaction,
                ),
          );

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
        },
      );
    },
  );

  withServerpod(
    'Given account requests exist for multiple users',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue firstAccountRequestId;
      late UuidValue secondAccountRequestId;
      const firstEmail = 'test1@serverpod.dev';
      const secondEmail = 'test2@serverpod.dev';
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

        firstAccountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: firstEmail,
            transaction: transaction,
          ),
        );

        secondAccountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
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
        'when delete email account request by id is called for one user then other user can still verify its registration code',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.deleteEmailAccountRequestById(
                  session,
                  firstAccountRequestId,
                  transaction: transaction,
                ),
          );

          final secondVerifyAccountRequestFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
                  session,
                  accountRequestId: secondAccountRequestId,
                  verificationCode: verificationCode,
                  transaction: transaction,
                ),
          );

          await expectLater(secondVerifyAccountRequestFuture, completes);
        },
      );
    },
  );
}
