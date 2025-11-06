import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
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

        accountRequestId = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
          'when complete account creation is called with generated verification code',
          () {
        late Future<EmailIDPCompleteAccountCreationResult>
            completeAccountCreationFuture;
        setUp(() async {
          completeAccountCreationFuture = session.db.transaction(
            (final transaction) async {
              // First verify the verification code to get the token
              final token =
                  await fixture.accountCreationUtil.verifyAccountCreationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              );
              // Then complete the account creation with the token
              return fixture.accountCreationUtil.completeAccountCreation(
                session,
                completeAccountCreationToken: token,
                transaction: transaction,
              );
            },
          );
        });
        test('then it succeeds and returns result with auth user id and email',
            () async {
          await expectLater(
            completeAccountCreationFuture,
            completion(
              isA<EmailIDPCompleteAccountCreationResult>()
                  .having(
                    (final result) => result.authUserId,
                    'authUserId',
                    isA<UuidValue>(),
                  )
                  .having(
                    (final result) => result.email,
                    'email',
                    equals(email),
                  ),
            ),
          );
        });

        test('then a new auth user is created', () async {
          final result = await completeAccountCreationFuture;

          // Verify auth user exists
          final authUsers = await AuthUsers.list(
            session,
          );
          expect(authUsers, hasLength(1));
          expect(authUsers.first.id, equals(result.authUserId));
        });

        test('then the user can authenticate with the registered credentials',
            () async {
          final result = await completeAccountCreationFuture;

          final authResult = await session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          expect(authResult, equals(result.authUserId));
        });
      });

      test(
          'when verify account creation code is called with invalid verification code then it throws invalid verification code exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountCreationCode(
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
          'when verify account creation code is called with valid code after expiration then it throws verification expired exception',
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
          },
        );
      });
    },
  );

  withServerpod(
    'Given no account request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      final accountRequestId = const Uuid().v4obj();
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when verify account creation code is called then it throws request not found exception',
          () async {
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

        accountRequestId = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        // Make one failed attempt
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountCreationCode(
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
          'when complete account creation is called with valid verification code then it succeeds and returns result',
          () async {
        final result = await session.db.transaction(
          (final transaction) async {
            final token =
                await fixture.accountCreationUtil.verifyAccountCreationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            );
            return fixture.accountCreationUtil.completeAccountCreation(
              session,
              completeAccountCreationToken: token,
              transaction: transaction,
            );
          },
        );

        expect(result, isNotNull);
        expect(result.authUserId, isA<UuidValue>());
        expect(result.email, equals(email));
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

        accountRequestId = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        // Exhaust allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyAccountCreationCode(
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
          'when verify account creation code is called with valid verification code then it throws too many attempts exception',
          () async {
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
              isA<EmailAccountRequestVerificationTooManyAttemptsException>()),
        );
      });
    },
  );
}
