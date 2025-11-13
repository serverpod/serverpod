import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given a verified account request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late String verificationToken;
      const email = 'test@serverpod.dev';
      const allowedPassword = 'Foobar123!';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            passwordValidationFunction: (final password) =>
                password == allowedPassword,
          ),
        );

        accountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        verificationToken = await session.db.transaction(
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

      group(
        'when complete account creation is called with valid verification token',
        () {
          late Future<EmailIDPCompleteAccountCreationResult>
          completeAccountCreationFuture;
          setUp(() async {
            completeAccountCreationFuture = session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.completeAccountCreation(
                    session,
                    completeAccountCreationToken: verificationToken,
                    password: allowedPassword,
                    transaction: transaction,
                  ),
            );
          });
          test(
            'then it succeeds and returns result with auth user id, account request id and email',
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
                        (final result) => result.accountRequestId,
                        'accountRequestId',
                        isA<UuidValue>(),
                      )
                      .having(
                        (final result) => result.email,
                        'email',
                        equals(email),
                      ),
                ),
              );
            },
          );

          test('then a new auth user is created', () async {
            final result = await completeAccountCreationFuture;

            // Verify auth user exists
            final authUsers = await fixture.authUsers.list(
              session,
            );
            expect(authUsers, hasLength(1));
            expect(authUsers.single.id, equals(result.authUserId));
          });

          test(
            'then the user can authenticate with the registered credentials',
            () async {
              final result = await completeAccountCreationFuture;

              final authResult = await session.db.transaction(
                (final transaction) => fixture.authenticationUtil.authenticate(
                  session,
                  email: email,
                  password: allowedPassword,
                  transaction: transaction,
                ),
              );

              expect(authResult, equals(result.authUserId));
            },
          );
        },
      );

      test(
        'when complete account creation is called with invalid password then it throws password policy violation exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: verificationToken,
                  password: '$allowedPassword-invalid',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordPolicyViolationException>()),
          );
        },
      );

      test(
        'when complete account creation is called with invalid verification token then it throws invalid verification code exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: '$verificationToken-invalid',
                  password: allowedPassword,
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
        'when complete account creation is called with valid verification token after expiration then it throws verification expired exception',
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
                    fixture.accountCreationUtil.completeAccountCreation(
                      session,
                      completeAccountCreationToken: verificationToken,
                      password: allowedPassword,
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
    },
  );

  withServerpod(
    'Given an unverified account request exists',
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

        // Create account request but DON'T verify it
        accountRequestId = await session.db.transaction(
          (final transaction) => fixture.accountCreationUtil.startRegistration(
            session,
            email: email,
            transaction: transaction,
          ),
        );
      });

      test(
        'when complete account creation is called with token for unverified request then it throws not verified exception',
        () async {
          // Create a fake token with correct format but for unverified request
          final fakeToken = base64Encode(
            utf8.encode('$accountRequestId:fake-token'),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: fakeToken,
                  password: 'ValidPassword123!',
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
    'Given no account request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when complete account creation is called with invalid verification token then it throws invalid verification code exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: 'invalid',
                  password: 'Foobar123!',
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
        'when complete account creation is called with correctly formatted but missing verification token then it throws not found exception',
        () async {
          // This test depends in implementation details but ensures we return not
          // found exception when the token is not found.

          // This needs to be updated if the implementation details for the token change.
          final mockedToken = base64Encode(
            utf8.encode('${const Uuid().v7()}:mocked-token'),
          );

          final result = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: mockedToken,
                  password: 'Foobar123!',
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
