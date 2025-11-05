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
      const password = 'Foobar123!';
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
          'when starting account creation with valid email and password then it returns account request created result with account request id',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: allowedPassword,
            transaction: transaction,
          ),
        );

        expect(result.result,
            equals(EmailAccountRequestResult.accountRequestCreated));
        expect(result.accountRequestId, isNotNull);
        expect(result.accountRequestId, isA<UuidValue>());
      });

      test(
          'when starting account creation with uppercase email then account creation can be verified with lowercase email',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email.toUpperCase(),
            password: allowedPassword,
            transaction: transaction,
          ),
        );

        final verificationResult = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: result.accountRequestId!,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(verificationResult, completes);
      });

      test(
          'when starting account creation with email with spaces then account create can be verified with trimmed email',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: '  $email  ',
            password: allowedPassword,
            transaction: transaction,
          ),
        );

        final verificationResult = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: result.accountRequestId!,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        await expectLater(verificationResult, completes);
      });

      test(
          'when starting account creation with password violating password policy then it throws password policy violation exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailPasswordPolicyViolationException>()),
        );
      });

      test(
          'when starting account creation with invalid email format then it returns email invalid result',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: 'not-an-email',
            password: allowedPassword,
            transaction: transaction,
          ),
        );

        expect(result.result, equals(EmailAccountRequestResult.emailInvalid));
        expect(result.accountRequestId, isNull);
      });
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
    const password = 'Foobar123!';
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
          sendRegistrationVerificationCode: (
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

      final result = await session.db.transaction(
        (final transaction) => fixture.accountCreationUtil.startAccountCreation(
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
        'then captured email matches the email used to request account creation',
        () async {
      expect(capturedEmail, equals(email));
    });

    test(
        'then captured account request id matches the id returned from start account creation',
        () async {
      expect(capturedAccountRequestId, equals(accountRequestId));
    });

    test(
        'then captured verification code matches the code generated by the configured verification code generator',
        () async {
      expect(capturedVerificationCode, equals(verificationCode));
    });
  });

  withServerpod(
    'Given existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        final authUser = await fixture.createAuthUser(session);

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
          'when starting account creation with same email then it returns email already registered result',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        expect(result.result,
            equals(EmailAccountRequestResult.emailAlreadyRegistered));
        expect(result.accountRequestId, isNull);
      });
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
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        // Create initial account request
        await session.db.transaction(
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

      test(
          'when starting account creation with same email then it returns email already requested result',
          () async {
        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        expect(result.result,
            equals(EmailAccountRequestResult.emailAlreadyRequested));
        expect(result.accountRequestId, isNull);
      });
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
      const password = 'Foobar123!';
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
                fixture.accountCreationUtil.startAccountCreation(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when starting account creation with same email then it returns account request created result',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        await expectLater(
            result,
            completion(isA<EmailIDPAccountCreationResult>().having(
                (final result) => result.result,
                'result',
                equals(EmailAccountRequestResult.accountRequestCreated))));
      });
    },
  );
}
