import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given an email IDP with default hash settings,',
    rollbackDatabase: RollbackDatabase.disabled,
    (
      final sessionBuilder,
      final endpoints,
    ) {
      const verificationCode = '12345678';
      late Session session;
      late EmailIdpTestFixture fixture;

      setUp(() {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
            passwordResetVerificationCodeGenerator: () => verificationCode,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when starting a registration, '
        'then the stored verification code is hashed with 4 MiB of Argon2 memory',
        () async {
          final requestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: 'hash-cost@serverpod.dev',
                  transaction: transaction,
                ),
          );

          final request = await EmailAccountRequest.db.findById(
            session,
            requestId,
            include: EmailAccountRequest.include(
              challenge: SecretChallenge.include(),
            ),
          );
          expect(
            request?.challenge?.challengeCodeHash,
            startsWith(r'$argon2id$v=19$m=4096,t=3,'),
          );
        },
      );

      test(
        'and an account with a password, '
        'when starting a password reset, '
        'then the stored verification code is hashed with 4 MiB of Argon2 memory',
        () async {
          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: 'hash-cost@serverpod.dev',
            password: EmailAccountPassword.fromString('Password123!'),
          );

          final requestId = await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: 'hash-cost@serverpod.dev',
              transaction: transaction,
            ),
          );

          final request = await EmailAccountPasswordResetRequest.db.findById(
            session,
            requestId,
            include: EmailAccountPasswordResetRequest.include(
              challenge: SecretChallenge.include(),
            ),
          );
          expect(
            request?.challenge?.challengeCodeHash,
            startsWith(r'$argon2id$v=19$m=4096,t=3,'),
          );
        },
      );

      test(
        'and a verified registration, '
        'when completing the account creation with a password, '
        'then the password is hashed with 19 MiB of Argon2 memory',
        () async {
          final requestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: 'hash-cost@serverpod.dev',
                  transaction: transaction,
                ),
          );
          final completionToken = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.verifyRegistrationCode(
                  session,
                  accountRequestId: requestId,
                  verificationCode: verificationCode,
                  transaction: transaction,
                ),
          );

          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.completeAccountCreation(
                  session,
                  completeAccountCreationToken: completionToken,
                  password: 'Password123!',
                  transaction: transaction,
                ),
          );

          final account = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('hash-cost@serverpod.dev'),
          );
          expect(
            account?.passwordHash,
            startsWith(r'$argon2id$v=19$m=19456,t=3,'),
          );
        },
      );
    },
  );
}
