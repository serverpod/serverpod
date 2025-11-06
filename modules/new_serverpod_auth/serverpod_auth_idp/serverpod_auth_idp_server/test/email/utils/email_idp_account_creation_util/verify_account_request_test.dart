import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given pending account request exists',
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
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
          'when verify account request is called with valid verification code',
          () {
        late Future<EmailAccountRequest> verifyAccountRequestFuture;
        setUp(() async {
          verifyAccountRequestFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountRequest(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );
        });
        test('then it succeeds and returns the account request', () async {
          await expectLater(
            verifyAccountRequestFuture,
            completion(
              isA<EmailAccountRequest>()
                  .having(
                    (final request) => request.id,
                    'id',
                    equals(accountRequestId),
                  )
                  .having(
                    (final request) => request.email,
                    'email',
                    equals(email),
                  ),
            ),
          );
        });

        test('then the account request can be finalized', () async {
          await verifyAccountRequestFuture;

          final authUser = await fixture.createAuthUser(session);

          final finalizeAccountRequestFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.finalizeAccountRequest(
              session,
              accountRequestId: accountRequestId,
              authUserId: authUser.id,
              transaction: transaction,
            ),
          );
          await expectLater(finalizeAccountRequestFuture, completes);
        });
      });

      test(
          'when verify account request is called with invalid verification code then it throws invalid verification code exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: '$verificationCode-invalid',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestInvalidVerificationCodeException>()),
        );
      });

      test(
          'when verify account request is called with valid code after expiration then it throws verification expired exception',
          () async {
        const registrationVerificationCodeLifetime = Duration(hours: 1);

        await withClock(
          Clock.fixed(
            DateTime.now().add(
              registrationVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
            final result = session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.verifyAccountRequest(
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
          },
        );
      });
    },
  );

  withServerpod(
    'Given account request that has been verified already',
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
          'when verify account request is called with valid verification code then it succeeds and returns the account request',
          () async {
        final request = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        expect(request, isNotNull);
        expect(request.id, equals(accountRequestId));
      });
    },
  );

  withServerpod(
    'Given account request that has been finalized',
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

        // Verify and finalize the request
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        final authUser = await fixture.createAuthUser(session);

        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.finalizeAccountRequest(
            session,
            accountRequestId: accountRequestId,
            authUserId: authUser.id,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account request is called with valid verification code then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
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

  withServerpod(
    'Given account request that has failed verification and config allows multiple attempts',
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
            registrationVerificationCodeAllowedAttempts: 2,
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

        // Make one failed attempt
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountRequest(
              session,
              accountRequestId: accountRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailAccountRequestInvalidVerificationCodeException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account request is called with valid verification code then it succeeds and returns account request',
          () async {
        final request = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        expect(request, isNotNull);
        expect(request.id, equals(accountRequestId));
      });
    },
  );

  withServerpod(
    'Given account request that has failed verification matching the allowed attempts',
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
            registrationVerificationCodeAllowedAttempts: 1,
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

        // Make one failed attempt
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountRequest(
              session,
              accountRequestId: accountRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailAccountRequestInvalidVerificationCodeException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account request is called with invalid verification code then it throws too many attempts exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'wrong-code',
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(
              isA<EmailAccountRequestVerificationTooManyAttemptsException>()),
        );
      });
    },
  );

  withServerpod(
    'Given account request that has failed verification past the maximum number of allowed attempts',
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
            registrationVerificationCodeAllowedAttempts: 1,
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

        // Exhaust allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountRequest(
              session,
              accountRequestId: accountRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailAccountRequestInvalidVerificationCodeException {
          // Expected
        }

        // Go past the allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountRequest(
              session,
              accountRequestId: accountRequestId,
              verificationCode: 'wrong-code',
              transaction: transaction,
            ),
          );
        } on EmailAccountRequestVerificationTooManyAttemptsException {
          // Expected - this should delete the request
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account request is called with valid verification code then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
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

  withServerpod(
    'Given account request was verified with expired credentials',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      const verificationCode = '12345678';
      const registrationVerificationCodeLifetime = Duration(hours: 1);

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

        // Try to verify after expiration
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              registrationVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
            try {
              await session.db.transaction(
                (final transaction) =>
                    fixture.accountCreationUtil.verifyAccountRequest(
                  session,
                  accountRequestId: accountRequestId,
                  verificationCode: verificationCode,
                  transaction: transaction,
                ),
              );
            } on EmailAccountRequestVerificationExpiredException {
              // Expected - this should delete the request
            }
          },
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account request is called with valid verification code then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
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
}
