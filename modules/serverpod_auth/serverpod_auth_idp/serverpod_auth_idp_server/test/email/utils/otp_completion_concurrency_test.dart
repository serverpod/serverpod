import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  const verificationCode = '123456';

  withServerpod(
    '[OTP login completion concurrency]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;

      Future<String> startAndVerify(final String email) async {
        final otpLoginRequestId = await fixture.emailIdp.startOtpLogin(
          session,
          email: email,
        );
        return (await fixture.emailIdp.verifyOtpLoginCode(
          session,
          otpLoginRequestId: otpLoginRequestId,
          verificationCode: verificationCode,
        )).token;
      }

      Future<List<Object>> runConcurrently(
        final Future<Object> Function(Session session) complete,
      ) {
        return Future.wait<Object>([
          for (final attemptSession in [
            sessionBuilder.build(),
            sessionBuilder.build(),
          ])
            () async {
              try {
                return await complete(attemptSession);
              } catch (error) {
                return error;
              }
            }(),
        ]);
      }

      final isInvalidRequestException = isA<EmailAccountRequestException>()
          .having(
            (final e) => e.reason,
            'reason',
            EmailAccountRequestExceptionReason.invalid,
          );

      setUp(() {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: EmailIdpConfig(
            secretHashPepper: 'pepper',
            sendOtpLoginVerificationCode:
                (
                  final session, {
                  required final email,
                  required final otpLoginRequestId,
                  required final verificationCode,
                  required final transaction,
                }) {},
            otpLoginVerificationCodeGenerator: () => verificationCode,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'Given a verified otp login for an existing account, '
        'when two sessions concurrently finish the login, '
        'then one is signed in and the other gets an EmailAccountRequestException with reason "invalid".',
        () async {
          const email = 'otp-login-race@serverpod.dev';
          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: email,
          );
          final otpLoginToken = await startAndVerify(email);

          final results = await runConcurrently(
            (final attemptSession) => fixture.emailIdp.finishOtpLogin(
              attemptSession,
              otpLoginToken: otpLoginToken,
            ),
          );

          expect(
            results,
            unorderedMatches([isA<AuthSuccess>(), isInvalidRequestException]),
          );
          final tokens = await fixture.tokenManager.listTokens(
            session,
            authUserId: authUser.id,
          );
          expect(tokens, hasLength(1));
        },
      );

      test(
        'Given a verified otp login without account, '
        'when two sessions concurrently finish the registration, '
        'then one account is created and the other session gets an EmailAccountRequestException with reason "invalid".',
        () async {
          const email = 'otp-registration-race@serverpod.dev';
          final otpLoginToken = await startAndVerify(email);

          final results = await runConcurrently(
            (final attemptSession) => fixture.emailIdp.finishOtpRegistration(
              attemptSession,
              otpLoginToken: otpLoginToken,
            ),
          );

          expect(
            results,
            unorderedMatches([isA<AuthSuccess>(), isInvalidRequestException]),
          );
          expect(await EmailAccount.db.count(session), 1);
        },
      );
    },
  );
}
