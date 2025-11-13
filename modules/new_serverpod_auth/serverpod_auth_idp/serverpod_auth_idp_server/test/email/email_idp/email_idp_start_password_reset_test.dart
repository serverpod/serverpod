import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when startPasswordReset is called', () {
        late Future<UuidValue> passwordResetRequestIdFuture;
        setUp(() async {
          passwordResetRequestIdFuture = fixture.emailIDP.startPasswordReset(
            session,
            email: email,
          );
        });

        test('then it returns password reset request id', () async {
          await expectLater(
            passwordResetRequestIdFuture,
            completion(isA<UuidValue>()),
          );
        });

        test(
          'then password reset request can be used to verify password reset',
          () async {
            final passwordResetRequestId = await passwordResetRequestIdFuture;

            final passwordResetResult = fixture.emailIDP
                .verifyPasswordResetCode(
                  session,
                  passwordResetRequestId: passwordResetRequestId,
                  verificationCode: verificationCode,
                );

            await expectLater(passwordResetResult, completion(isA<String>()));
          },
        );
      });
    },
  );

  withServerpod(
    'Given existing email account with maximum allowed password reset requests',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Password123!';
      const maxPasswordResetAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            maxPasswordResetAttempts: maxPasswordResetAttempts,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        // Make initial request to hit the rate limit
        await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when requesting password reset with same email then it throws EmailAccountPasswordResetException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.startPasswordReset(
            session,
            email: email,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given no email account',
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

      group('when startPasswordReset is called', () {
        late Future<UuidValue> passwordResetRequestIdFuture;

        setUp(() async {
          // Use setup to ensure the request is made when no email account exists.
          passwordResetRequestIdFuture = fixture.emailIDP.startPasswordReset(
            session,
            email: 'nonexistent@serverpod.dev',
          );
        });

        test(
          'then it returns dummy uuid with the same version as the real request to prevent leaking the fact that the email is not registered',
          () async {
            const existingUserEmail = 'existinguser@serverpod.dev';
            final authUser = await fixture.authUsers.create(session);
            await fixture.createEmailAccount(
              session,
              authUserId: authUser.id,
              email: existingUserEmail,
            );

            final capturedPasswordResetRequestId = await fixture.emailIDP
                .startPasswordReset(
                  session,
                  email: existingUserEmail,
                );

            await expectLater(
              passwordResetRequestIdFuture,
              completion(
                isA<UuidValue>().having(
                  (final uuid) => uuid.version,
                  'version',
                  equals(capturedPasswordResetRequestId.version),
                ),
              ),
            );
          },
        );
      });
    },
  );

  withServerpod(
    'Given maximum allowed password reset requests for non-existing email account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const maxPasswordResetAttempts = RateLimit(
        maxAttempts: 1,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture(
          config: const EmailIDPConfig(
            secretHashPepper: 'pepper',
            maxPasswordResetAttempts: maxPasswordResetAttempts,
          ),
        );

        // Make initial request to hit the rate limit
        await fixture.emailIDP.startPasswordReset(
          session,
          email: email,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when requesting password reset with same email then it throws EmailAccountPasswordResetException with reason "tooManyAttempts"',
        () async {
          final result = fixture.emailIDP.startPasswordReset(
            session,
            email: email,
          );

          await expectLater(
            result,
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );
    },
  );
}
