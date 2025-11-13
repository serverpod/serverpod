import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given no existing account or pending request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const allowedPassword = 'AllowedPassword123!';
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordValidationFunction: (final password) =>
                password == allowedPassword,
            registrationVerificationCodeGenerator: () => verificationCode,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when starting account creation with valid email and password then it returns account request id',
        () async {
          final accountRequestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          expect(accountRequestId, isA<UuidValue>());
        },
      );

      test(
        'when starting account creation with uppercase email then account creation can be verified with lowercase email',
        () async {
          final accountRequestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email.toUpperCase(),
                  transaction: transaction,
                ),
          );

          final verificationResult = session.db.transaction(
            (final transaction) => fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );

          await expectLater(verificationResult, completes);
        },
      );

      test(
        'when starting account creation with email with spaces then account create can be verified with trimmed email',
        () async {
          final accountRequestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: '  $email  ',
                  transaction: transaction,
                ),
          );

          final verificationResult = session.db.transaction(
            (final transaction) => fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
              transaction: transaction,
            ),
          );

          await expectLater(verificationResult, completes);
        },
      );

      test(
        'when starting account creation with invalid email format then it throws email invalid exception',
        () async {
          final startAccountCreationFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: 'not-an-email',
                  transaction: transaction,
                ),
          );

          await expectLater(
            startAccountCreationFuture,
            throwsA(isA<EmailAccountRequestInvalidEmailException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given successful account creation request when capturing output from send verification code callback',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late String verificationCode;
      const email = 'test@serverpod.dev';
      late String capturedEmail;
      late UuidValue capturedAccountRequestId;
      late String capturedVerificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            sendRegistrationVerificationCode:
                (
                  final session, {
                  required final String email,
                  required final UuidValue accountRequestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                }) {
                  capturedEmail = email;
                  capturedAccountRequestId = accountRequestId;
                  capturedVerificationCode = verificationCode;
                },
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
        'then captured email matches the email used to request account creation',
        () async {
          expect(capturedEmail, equals(email));
        },
      );

      test(
        'then captured account request id matches the id returned from start account creation',
        () async {
          expect(capturedAccountRequestId, equals(accountRequestId));
        },
      );

      test(
        'then captured verification code matches the code generated by the configured verification code generator',
        () async {
          expect(capturedVerificationCode, equals(verificationCode));
        },
      );
    },
  );

  withServerpod(
    'Given existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when starting account creation with same email then it throws email already registered exception',
        () async {
          final startAccountCreationFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          await expectLater(
            startAccountCreationFuture,
            throwsA(isA<EmailAccountAlreadyRegisteredException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given pending account request within verification code lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        // Create initial account request
        await session.db.transaction(
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
        'when starting account creation with same email then it throws email account request already exists exception',
        () async {
          final startAccountCreationFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          await expectLater(
            startAccountCreationFuture,
            throwsA(isA<EmailAccountRequestAlreadyExistsException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given expired pending account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
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

        // Create initial account request in the past
        await withClock(
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
        'when starting account creation with same email then a new account request is created',
        () async {
          final startAccountCreationFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          await expectLater(
            startAccountCreationFuture,
            completion(isA<UuidValue>()),
          );
        },
      );
    },
  );
}
