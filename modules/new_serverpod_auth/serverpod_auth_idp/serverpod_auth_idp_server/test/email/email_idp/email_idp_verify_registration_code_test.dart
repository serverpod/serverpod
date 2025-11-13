import 'dart:async';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

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
      late String verificationCode;
      const registrationVerificationCodeLifetime = Duration(hours: 1);
      const registrationVerificationCodeAllowedAttempts = 4;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime:
                registrationVerificationCodeLifetime,
            // This is to make sure that the test does not fail because of the rate limit
            registrationVerificationCodeAllowedAttempts:
                registrationVerificationCodeAllowedAttempts,
          ),
        );

        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
        'when verifyRegistrationCode is called with generated verification code',
        () {
          late Future<String> registrationToken;

          setUp(() async {
            registrationToken = fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
            );
          });

          test('then it succeeds and returns registration token', () async {
            final result = await registrationToken;
            expect(result, isA<String>());
          });
        },
      );

      test(
        'when verifyRegistrationCode is called with invalid verification code then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: '$verificationCode-invalid',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      group(
        'when verifyRegistrationCode is called multiple times in quick succession',
        () {
          late Future<List<String>> attempts;
          const numberOfAttempts = registrationVerificationCodeAllowedAttempts;

          setUp(() async {
            attempts = List.generate(
              numberOfAttempts,
              (final _) => fixture.emailIDP.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
              ),
            ).wait;
          });

          test(
            'then all attempts except one throw EmailAccountRequestException with reason "invalid"',
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
                          isA<EmailAccountRequestException>().having(
                            (final e) => e.reason,
                            'reason',
                            equals(EmailAccountRequestExceptionReason.invalid),
                          ),
                        ),
                      ),
                ),
              );
            },
          );

          test('then only one attempt succeeds', () async {
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

      test(
        'when verifyRegistrationCode is called with valid credentials after expiration then it throws EmailAccountRequestException with reason "expired"',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                registrationVerificationCodeLifetime + const Duration(hours: 1),
              ),
            ),
            () async {
              final result = fixture.emailIDP.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
              );

              await expectLater(
                result,
                throwsA(
                  isA<EmailAccountRequestException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailAccountRequestExceptionReason.expired,
                  ),
                ),
              );
            },
          );
        },
      );

      test(
        'when verifyRegistrationCode is called with invalid credentials after expiration then it throws EmailAccountRequestException with reason "invalid" to not leak that the request exists',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                registrationVerificationCodeLifetime + const Duration(hours: 1),
              ),
            ),
            () async {
              final result = fixture.emailIDP.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: '$verificationCode-invalid',
              );

              await expectLater(
                result,
                throwsA(
                  isA<EmailAccountRequestException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailAccountRequestExceptionReason.invalid,
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given account request that has been verified',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late String verificationCode;
      const Duration registrationVerificationCodeLifetime = Duration(days: 1);

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

        const email = 'test@serverpod.dev';
        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        // Verify the registration code (this marks it as used)
        await fixture.emailIDP.verifyRegistrationCode(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called again with valid verification code then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when verifyRegistrationCode is called with expired request that has been verified then it throws EmailAccountRequestException with reason "invalid" to not leak that the request exists',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                registrationVerificationCodeLifetime + const Duration(hours: 1),
              ),
            ),
            () async {
              final result = fixture.emailIDP.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
              );

              await expectLater(
                result,
                throwsA(
                  isA<EmailAccountRequestException>().having(
                    (final e) => e.reason,
                    'reason',
                    EmailAccountRequestExceptionReason.invalid,
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given account request that has been validated with invalid credentials and config allows multiple attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeAllowedAttempts: 2,
          ),
        );

        const email = 'test@serverpod.dev';
        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        // Attempt with invalid credentials
        try {
          await fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountRequestException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called with valid verification code then it succeeds and returns registration token',
        () async {
          final result = await fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          expect(result, isA<String>());
        },
      );
    },
  );

  withServerpod(
    'Given account request was validated with expired credentials',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
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

        const email = 'test@serverpod.dev';
        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
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
              await fixture.emailIDP.verifyRegistrationCode(
                session,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
              );
            } on EmailAccountRequestException {
              // Expected - this should delete the request
            }
          },
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called with valid credentials then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given account request that has failed verification matching the rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeAllowedAttempts: 1,
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime: const Duration(days: 1),
          ),
        );

        const email = 'test@serverpod.dev';
        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        // Make attempts up to the limit
        try {
          await fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountRequestException {
          // Expected
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called with valid credentials then it throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given existing account request that has failed to verify past the maximum number of allowed verification attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const verificationCode = '12345678';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeAllowedAttempts: 1,
            registrationVerificationCodeLifetime: Duration(days: 1),
          ),
        );

        const email = 'test@serverpod.dev';
        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        // Exhaust allowed attempts
        try {
          await fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountRequestException {
          // Expected
        }

        // Go past the allowed attempts
        try {
          await fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'wrong-code',
          );
        } on EmailAccountRequestException {
          // Expected - this should delete the request
        }
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called with valid verification code then throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
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
            passwordValidationFunction: (final password) =>
                password == 'Foobar123!',
          ),
        );

        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        // Verify and complete the request
        final registrationToken = await fixture.emailIDP.verifyRegistrationCode(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );

        await fixture.emailIDP.finishRegistration(
          session,
          registrationToken: registrationToken,
          password: password,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called with valid verification code then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given no account request created',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeAllowedAttempts: 1,
            registrationVerificationCodeLifetime: Duration(days: 1),
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when verifyRegistrationCode is called then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: const Uuid().v4obj(),
            verificationCode: 'some-code',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when verifyRegistrationCode is called past the allowed attempts then it throws EmailAccountRequestException with reason "tooManyAttempts"',
        () async {
          final accountRequestId = const Uuid().v4obj();
          // Make attempts up to the limit
          try {
            await fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: 'some-code',
            );
          } on EmailAccountRequestException {
            // Expected
          }

          final result = fixture.emailIDP.verifyRegistrationCode(
            session,
            accountRequestId: accountRequestId,
            verificationCode: 'some-code',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );
}
