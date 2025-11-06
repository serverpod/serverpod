import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given verified account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
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

        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
                session,
                email: email,
                password: password,
                transaction: transaction,
              ),
        );

        accountRequestId = result.accountRequestId!;

        // Verify the request
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when get verified email account request by id is called then it returns the account request',
        () async {
          final request = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.getVerifiedEmailAccountRequestById(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          expect(request, isNotNull);
          expect(request.id, equals(accountRequestId));
          expect(request.email, equals(email));
          expect(request.verifiedAt, isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given unverified account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
                session,
                email: email,
                password: password,
                transaction: transaction,
              ),
        );

        accountRequestId = result.accountRequestId!;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when get verified email account request by id is called then it throws request not verified exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.getVerifiedEmailAccountRequestById(
                  session,
                  accountRequestId: accountRequestId,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAccountRequestNotVerifiedException>()),
          );
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
        'when get verified email account request by id is called then it throws request not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.getVerifiedEmailAccountRequestById(
                  session,
                  accountRequestId: accountRequestId,
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
}
