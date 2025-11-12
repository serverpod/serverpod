import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given account request created',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'newuser@serverpod.dev';
      const allowedPassword = 'AllowedPassword123!';
      late String registrationToken;
      const accountRequestVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        final verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime:
                accountRequestVerificationCodeLifetime,
            passwordValidationFunction: (final password) =>
                password == allowedPassword,
          ),
        );

        accountRequestId = await fixture.emailIDP.startRegistration(
          session,
          email: email,
        );

        registrationToken = await fixture.emailIDP.verifyRegistrationCode(
          session,
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when finishRegistration is called with valid parameters', () {
        late Future<AuthSuccess> authSuccessFuture;

        setUp(() async {
          authSuccessFuture = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: registrationToken,
            password: allowedPassword,
          );
        });

        test('then it returns auth success', () async {
          await expectLater(authSuccessFuture, completion(isA<AuthSuccess>()));
        });

        test('then account can be used to authenticate', () async {
          await authSuccessFuture;

          final result = session.db.transaction(
            (final transaction) => fixture.emailIDP.login(
              session,
              email: email,
              password: allowedPassword,
              transaction: transaction,
            ),
          );

          await expectLater(result, completion(isA<AuthSuccess>()));
        });

        test('then user profile is created', () async {
          final authSuccess = await authSuccessFuture;
          final profile = await fixture.userProfiles
              .maybeFindUserProfileByUserId(
                session,
                authSuccess.authUserId,
              );

          expect(profile, isNotNull);
          expect(profile?.email, equals(email));
        });

        test('then the new users has no scopes (default behavior)', () async {
          final authSuccess = await authSuccessFuture;

          expect(authSuccess.scopeNames, isEmpty);
        });
      });

      test(
        'when finishRegistration is called with invalid registration token then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: '$registrationToken-invalid',
            password: allowedPassword,
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
        'when finishRegistration is called with invalid password then it throws EmailAccountRequestException with reason "policyViolation"',
        () async {
          final result = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: registrationToken,
            password: '$allowedPassword-invalid',
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.policyViolation,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given verified expired account request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      const email = 'expired@serverpod.dev';
      const password = 'Password123!';
      late String registrationToken;
      const accountRequestVerificationCodeLifetime = Duration(hours: 1);

      setUp(() async {
        session = sessionBuilder.build();

        final verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            registrationVerificationCodeLifetime:
                accountRequestVerificationCodeLifetime,
          ),
        );

        await withClock(
          Clock.fixed(
            DateTime.now().subtract(
              accountRequestVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
            accountRequestId = await fixture.emailIDP.startRegistration(
              session,
              email: email,
            );

            registrationToken = await fixture.emailIDP.verifyRegistrationCode(
              session,
              accountRequestId: accountRequestId,
              verificationCode: verificationCode,
            );
          },
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when finishRegistration is called with valid parameters then it throws EmailAccountRequestException with reason "expired"',
        () async {
          final result = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: registrationToken,
            password: password,
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

      test(
        'when finishRegistration is called with invalid verification code then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: '$registrationToken-invalid',
            password: password,
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
        fixture = EmailIDPTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when finishRegistration is called then it throws EmailAccountRequestException with reason "invalid"',
        () async {
          final result = fixture.emailIDP.finishRegistration(
            session,
            registrationToken: const Uuid().v4(),
            password: 'some-password',
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
}
