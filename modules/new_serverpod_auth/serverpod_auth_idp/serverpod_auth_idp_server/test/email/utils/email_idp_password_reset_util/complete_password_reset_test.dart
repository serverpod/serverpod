import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

/// Database rollbacks are disabled for these tests because rate limit is
/// logged outside of the passed in transaction.
void main() {
  withServerpod(
    'Given password reset request exists',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      const allowedNewPassword = 'NewPassword123!';
      const passwordResetVerificationCodeLifetime = Duration(hours: 1);
      late String completePasswordResetToken;

      setUp(() async {
        session = sessionBuilder.build();

        final verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordValidationFunction: (final password) =>
                password == allowedNewPassword,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // First verify the password reset code to get the set password token
        completePasswordResetToken = await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group(
        'when complete password reset is called with valid complete password reset token and password',
        () {
          late Future<UuidValue> completePasswordResetResult;

          setUp(() async {
            completePasswordResetResult = session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.completePasswordReset(
                    session,
                    completePasswordResetToken: completePasswordResetToken,
                    newPassword: allowedNewPassword,
                    transaction: transaction,
                  ),
            );
          });

          test('then it succeeds and returns auth user id', () async {
            await expectLater(
              completePasswordResetResult,
              completion(authUserId),
            );
          });

          test('then new password can be used to authenticate', () async {
            await completePasswordResetResult;

            final authResult = await session.db.transaction(
              (final transaction) => fixture.authenticationUtil.authenticate(
                session,
                email: email,
                password: allowedNewPassword,
                transaction: transaction,
              ),
            );

            expect(authResult, equals(authUserId));
          });
        },
      );

      test(
        'when called with password incompatible with password policy then throws password policy violation exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken: completePasswordResetToken,
                  newPassword: '$allowedNewPassword-invalid-addition',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetPasswordPolicyViolationException>()),
          );
        },
      );

      test(
        'when called with invalid complete password reset token then throws invalid complete password reset token exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken:
                      '$completePasswordResetToken-invalid-addition',
                  newPassword: allowedNewPassword,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
          );
        },
      );

      test(
        'when complete password reset is called with valid complete password reset token after expiration then throws request expired exception',
        () async {
          await withClock(
            Clock.fixed(
              DateTime.now().add(
                passwordResetVerificationCodeLifetime +
                    const Duration(hours: 1),
              ),
            ),
            () async {
              final result = session.db.transaction(
                (final transaction) =>
                    fixture.passwordResetUtil.completePasswordReset(
                      session,
                      completePasswordResetToken: completePasswordResetToken,
                      newPassword: 'NewPassword123!',
                      transaction: transaction,
                    ),
              );

              await expectLater(
                result,
                throwsA(isA<EmailPasswordResetRequestExpiredException>()),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given password reset request exists that has not been verified by calling verifyPasswordResetCode',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      const allowedNewPassword = 'NewPassword123!';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordValidationFunction: (final password) =>
                password == allowedNewPassword,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
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
        'when complete password reset is called with invalid complete password reset token then throws set password token not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken: const Uuid().v4(),
                  newPassword: allowedNewPassword,
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetInvalidVerificationCodeException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given successful password complete request when capturing output from onPasswordResetCompleted callback',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue emailAccountId;
      late EmailIDPTestFixture fixture;
      late UuidValue onPasswordResetCompletedEmailAccountId;

      setUp(() async {
        session = sessionBuilder.build();

        final verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            onPasswordResetCompleted:
                (
                  final session, {
                  required final UuidValue emailAccountId,
                  required final Transaction? transaction,
                }) {
                  onPasswordResetCompletedEmailAccountId = emailAccountId;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        final emailAccount = await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
        emailAccountId = emailAccount.id!;

        final passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // First verify the password reset code to get the set password token
        final completePasswordResetToken = await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );

        await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.completePasswordReset(
                session,
                completePasswordResetToken: completePasswordResetToken,
                newPassword: 'NewPassword123!',
                transaction: transaction,
              ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'then the onPasswordResetCompleted callback is called with the correct email account id',
        () {
          expect(
            onPasswordResetCompletedEmailAccountId,
            equals(emailAccountId),
          );
        },
      );
    },
  );

  withServerpod(
    'Given already completed password reset request',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late String completePasswordResetToken;
      setUp(() async {
        session = sessionBuilder.build();

        const verificationCode = '12345678';
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // First verify the password reset code to get the set password token
        completePasswordResetToken = await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );

        // Complete the password reset
        await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.completePasswordReset(
                session,
                completePasswordResetToken: completePasswordResetToken,
                newPassword: 'NewPassword123!',
                transaction: transaction,
              ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when complete password reset is called with valid verification code and password then it throws request not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken: completePasswordResetToken,
                  newPassword: 'AnotherPassword123!',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given password reset request was validated with expired credentials',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late String completePasswordResetToken;

      setUp(() async {
        session = sessionBuilder.build();

        const verificationCode = '12345678';
        const passwordResetVerificationCodeLifetime = Duration(hours: 1);
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            secretHashPepper: 'pepper',
            passwordResetVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeLifetime:
                passwordResetVerificationCodeLifetime,
          ),
        );

        final authUser = await fixture.authUsers.create(session);

        const email = 'test@serverpod.dev';
        const password = 'Foobar123!';
        await fixture.createEmailAccount(
          session,
          authUserId: authUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        final passwordResetRequestId = await session.db.transaction(
          (final transaction) => fixture.passwordResetUtil.startPasswordReset(
            session,
            email: email,
            transaction: transaction,
          ),
        );

        // First verify the password reset code to get the set password token
        completePasswordResetToken = await session.db.transaction(
          (final transaction) =>
              fixture.passwordResetUtil.verifyPasswordResetCode(
                session,
                passwordResetRequestId: passwordResetRequestId,
                verificationCode: verificationCode,
                transaction: transaction,
              ),
        );

        // Try to complete after expiration
        await withClock(
          Clock.fixed(
            DateTime.now().add(
              passwordResetVerificationCodeLifetime + const Duration(hours: 1),
            ),
          ),
          () async {
            try {
              await session.db.transaction(
                (final transaction) =>
                    fixture.passwordResetUtil.completePasswordReset(
                      session,
                      completePasswordResetToken: completePasswordResetToken,
                      newPassword: 'NewPassword123!',
                      transaction: transaction,
                    ),
              );
            } on EmailPasswordResetRequestExpiredException {
              // Expected - this should delete the request
            }
          },
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when complete password reset is called with valid credentials then it throws request not found exception',
        () async {
          final result = session.db.transaction(
            (final transaction) =>
                fixture.passwordResetUtil.completePasswordReset(
                  session,
                  completePasswordResetToken: completePasswordResetToken,
                  newPassword: 'NewPassword123!',
                  transaction: transaction,
                ),
          );

          await expectLater(
            result,
            throwsA(isA<EmailPasswordResetRequestNotFoundException>()),
          );
        },
      );
    },
  );
}
