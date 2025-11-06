import 'dart:async';

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
    'Given account request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late String verificationCode;
      const registrationVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime:
                registrationVerificationCodeLifetime,
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

        accountRequestId = result;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
          'when verify account creation code is called with generated verification code',
          () {
        late Future<String> verifyAccountCreationCodeResult;

        setUp(() async {
          verifyAccountCreationCodeResult = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountCreationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );
        });

        test('then it succeeds and returns complete account creation token',
            () async {
          final result = await verifyAccountCreationCodeResult;
          expect(result, isA<String>());
        });
      });

      test(
          'when called with invalid verification code then throws invalid verification code exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountCreationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: '$verificationCode-invalid-addition',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestInvalidVerificationCodeException>()),
        );
      });

      test(
          'when verify account creation code is called with valid credentials after expiration then throws request expired exception',
          () async {
        await withClock(
            Clock.fixed(DateTime.now().add(
              registrationVerificationCodeLifetime + const Duration(hours: 1),
            )), () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountCreationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailAccountRequestVerificationExpiredException>()),
          );
        });
      });

      test(
          'when verify account creation code is called with request id that does not exist then throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountCreationCode(
            session,
            accountRequestId: const Uuid().v4obj(),
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });

      test(
          'when verify account creation code is called a second time then throws verification code already used exception',
          () async {
        // First call should succeed
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountCreationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        // Second call should fail
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountCreationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
              isA<EmailAccountRequestVerificationCodeAlreadyUsedException>()),
        );
      });
    },
  );
}
