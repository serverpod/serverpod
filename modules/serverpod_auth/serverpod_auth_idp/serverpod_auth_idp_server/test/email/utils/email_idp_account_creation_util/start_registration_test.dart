import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given no existing account or pending request',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      const email = 'test@serverpod.dev';
      const allowedPassword = 'AllowedPassword123!';
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
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
            (final transaction) => fixture.emailIdp.verifyRegistrationCode(
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
            (final transaction) => fixture.emailIdp.verifyRegistrationCode(
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
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late UuidValue accountRequestId;
      late String verificationCode;
      const email = 'test@serverpod.dev';
      late String capturedEmail;
      late UuidValue capturedAccountRequestId;
      late String capturedVerificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
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
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIdpTestFixture();

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
    'Given pending account request',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIdpTestFixture();

        // Create initial account request
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

      group('when starting another account creation with same email', () {
        late UuidValue newAccountRequestId;
        setUp(() async {
          newAccountRequestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );
        });

        test('then it returns a new request id', () async {
          expect(accountRequestId, isNot(equals(newAccountRequestId)));
        });

        test('then it deletes the existing request', () async {
          final oldRequest = await EmailAccountRequest.db.findById(
            session,
            accountRequestId,
          );
          expect(oldRequest, isNull);
        });

        test('then the new request exists on the database', () async {
          final newRequest = await EmailAccountRequest.db.findById(
            session,
            newAccountRequestId,
          );
          expect(newRequest, isNotNull);
          expect(newRequest!.id, equals(newAccountRequestId));
          expect(newRequest.email, equals(email));
          expect(newRequest.challengeId, isNotNull);
          expect(newRequest.createdAt, isNotNull);
        });
      });
    },
  );

  withServerpod(
    'Given registration attempts matching the rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      late int sentVerificationCodes;
      const email = 'test@serverpod.dev';
      const maxRegistrationAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        sentVerificationCodes = 0;

        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            maxRegistrationAttempts: maxRegistrationAttempts,
            sendRegistrationVerificationCode:
                (
                  final session, {
                  required final String email,
                  required final UuidValue accountRequestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                }) {
                  sentVerificationCodes++;
                },
          ),
        );

        // Make initial request to hit the rate limit
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
        'when starting registration with same email within timeframe then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
            ),
          );
        },
      );

      test(
        'when starting registration with same email within timeframe then no additional verification code is sent',
        () async {
          try {
            await session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.startRegistration(
                    session,
                    email: email,
                    transaction: transaction,
                  ),
            );
          } on EmailAccountRequestVerificationTooManyAttemptsException catch (
            _
          ) {
            // Expected
          }

          expect(sentVerificationCodes, equals(1));
        },
      );

      test(
        'when starting registration with same email in different casing within timeframe then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: '  ${email.toUpperCase()}  ',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
            ),
          );
        },
      );

      test(
        'when starting registration with a different email then it succeeds and returns account request id',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: 'other-$email',
                  transaction: transaction,
                ),
          );

          await expectLater(result, completion(isA<UuidValue>()));
        },
      );

      test(
        'when starting registration with same email outside of timeframe then it succeeds and returns account request id',
        () async {
          await withClock(
            Clock.fixed(DateTime.now().add(maxRegistrationAttempts.timeframe)),
            () async {
              final result = await session.db.transaction(
                (final transaction) =>
                    fixture.accountCreationUtil.startRegistration(
                      session,
                      email: email,
                      transaction: transaction,
                    ),
              );

              expect(result, isNotNull);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given registration has been started for an already registered email past rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;
      const email = 'test@serverpod.dev';
      const maxRegistrationAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: const EmailIdpConfig(
            secretHashPepper: 'pepper',
            maxRegistrationAttempts: maxRegistrationAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
        );

        // Make initial request to hit the rate limit
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );
        } on EmailAccountAlreadyRegisteredException catch (_) {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when starting registration with same email then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: email,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a rate limit of one registration attempt',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: const EmailIdpConfig(
            secretHashPepper: 'pepper',
            maxRegistrationAttempts: RateLimit(
              maxAttempts: 1,
              timeframe: Duration(hours: 1),
            ),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when starting registration with invalid email then the attempt is not counted',
        () async {
          for (var i = 0; i < 2; i++) {
            try {
              await session.db.transaction(
                (final transaction) =>
                    fixture.accountCreationUtil.startRegistration(
                      session,
                      email: 'not-an-email',
                      transaction: transaction,
                    ),
              );
            } on EmailAccountRequestInvalidEmailException catch (_) {
              // Expected
            }
          }

          final attempts = await RateLimitedRequestAttempt.db.count(
            session,
            where: (final t) =>
                t.domain.equals('email') & t.source.equals('account_creation'),
          );
          expect(attempts, isZero);
        },
      );
    },
  );
}
