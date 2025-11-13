import 'dart:async';

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
      const registrationVerificationCodeAllowedAttempts = 4;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeAllowedAttempts:
                registrationVerificationCodeAllowedAttempts,
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

      group(
        'when verify registration code is called with valid verification code',
        () {
          late Future<String> verifyAccountRequestFuture;
          setUp(() async {
            verifyAccountRequestFuture = session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.verifyRegistrationCode(
                    session,
                    accountRequestId: accountRequestId,
                    verificationCode: verificationCode,
                    transaction: transaction,
                  ),
            );
          });

          test('then it succeeds and returns the verification token', () async {
            await expectLater(
              verifyAccountRequestFuture,
              completion(isA<String>()),
            );
          });

          test(
            'then the returned verification token can be used to complete the account request',
            () async {
              final verificationToken = await verifyAccountRequestFuture;

              final finalizeAccountRequestFuture = session.db.transaction(
                (final transaction) =>
                    fixture.accountCreationUtil.completeAccountCreation(
                      session,
                      completeAccountCreationToken: verificationToken,
                      password: password,
                      transaction: transaction,
                    ),
              );
              await expectLater(finalizeAccountRequestFuture, completes);
            },
          );
        },
      );

      test(
        'when verify registration code is called with invalid verification code then it throws invalid verification code exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
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
        },
      );

      test(
        'when verify registration code is called with valid code after expiration then it throws verification expired exception',
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
                    fixture.accountCreationUtil.verifyRegistrationCode(
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
        },
      );

      group(
        'when verify registration code is called multiple times in quick succession',
        () {
          late Future<List<String>> attempts;
          const numberOfAttempts = registrationVerificationCodeAllowedAttempts;

          setUp(() async {
            attempts = List.generate(
              numberOfAttempts,
              (final _) => session.db.transaction(
                (final transaction) =>
                    fixture.accountCreationUtil.verifyRegistrationCode(
                      session,
                      accountRequestId: accountRequestId,
                      verificationCode: verificationCode,
                      transaction: transaction,
                    ),
              ),
            ).wait;
          });

          test(
            'then all attempts except one throw EmailAccountRequestVerificationCodeAlreadyUsedException',
            () async {
              await expectLater(
                attempts,
                throwsA(
                  isA<ParallelWaitError>()
                      .having(
                        (final e) => (e.errors as List<AsyncError?>).nonNulls,
                        'errors',
                        hasLength(numberOfAttempts - 1),
                      )
                      .having(
                        (final e) =>
                            (e.errors as List<AsyncError?>).nonNulls.map(
                              (final e) => e.error,
                            ),
                        'errors',
                        everyElement(
                          isA<
                            EmailAccountRequestVerificationCodeAlreadyUsedException
                          >(),
                        ),
                      ),
                ),
              );
            },
          );

          test('then only one attempts succeeds', () async {
            await expectLater(
              attempts,
              throwsA(
                isA<ParallelWaitError>().having(
                  (final e) => (e.values as List<String?>).nonNulls,
                  'values',
                  hasLength(1),
                ),
              ),
            );
          });
        },
      );
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
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // Verify the request
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyRegistrationCode(
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
        'when verify registration code is called with valid verification code then throws verification code already used exception',
        () async {
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
            throwsA(
              isA<EmailAccountRequestVerificationCodeAlreadyUsedException>(),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given account request that has been completed',
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
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // Verify and finalize the request
        final verificationToken = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );

        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.completeAccountCreation(
                session,
                completeAccountCreationToken: verificationToken,
                password: password,
                transaction: transaction,
              ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verify registration code is called with valid verification code then it throws request not found exception',
        () async {
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
    'Given account request that has failed verification and config allows multiple attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
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
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // Make one failed attempt
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
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
        'when verify registration code is called with valid verification code then it succeeds and returns verification token',
        () async {
          final request = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
                  session,
                  accountRequestId: accountRequestId,
                  verificationCode: verificationCode,
                  transaction: transaction,
                ),
          );

          await expectLater(request, completion(isA<String>()));
        },
      );
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
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // Make one failed attempt
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
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
        'when verify registration code is called with invalid verification code then it throws too many attempts exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
                  session,
                  accountRequestId: accountRequestId,
                  verificationCode: 'wrong-code',
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
    'Given account request that has failed verification past the maximum number of allowed attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'test@serverpod.dev';
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
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // Exhaust allowed attempts
        try {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
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
                fixture.accountCreationUtil.verifyRegistrationCode(
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
        'when verify registration code is called with valid verification code then it throws too many attempts exception',
        () async {
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
            throwsA(
              isA<EmailAccountRequestVerificationTooManyAttemptsException>(),
            ),
          );
        },
      );
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

        accountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

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
                    fixture.accountCreationUtil.verifyRegistrationCode(
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
        'when verify registration code is called with valid verification code then it throws request not found exception',
        () async {
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
}
