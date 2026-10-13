import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_passwordless_test_fixture.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  const email = 'test@serverpod.dev';

  withServerpod(
    'Given an email IdP with only the passwordless login enabled',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpPasswordlessTestFixture fixture;

      setUp(() {
        session = sessionBuilder.build();
        fixture = EmailIdpPasswordlessTestFixture(passwordLoginEnabled: false);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('when logging in with a code then it succeeds.', () async {
        final loginRequestId = await fixture.idp.startPasswordlessLogin(
          session,
          email: email,
        );

        final authSuccess = await fixture.idp.finishPasswordlessLogin(
          session,
          loginRequestId: loginRequestId,
          verificationCode: fixtureVerificationCode,
        );

        expect(authSuccess.authStrategy, isNotEmpty);
      });

      test(
        'when login is called then it throws an EmailAccountLoginException with reason unknown.',
        () async {
          await expectLater(
            fixture.idp.login(session, email: email, password: 'Password123!'),
            throwsA(
              isA<EmailAccountLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountLoginExceptionReason.unknown,
              ),
            ),
          );
        },
      );

      test(
        'when startRegistration is called then it throws an EmailAccountRequestException with reason unknown.',
        () async {
          await expectLater(
            fixture.idp.startRegistration(session, email: email),
            throwsA(
              isA<EmailAccountRequestException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountRequestExceptionReason.unknown,
              ),
            ),
          );
        },
      );

      test(
        'when startPasswordReset is called then it throws an EmailAccountPasswordResetException with reason unknown.',
        () async {
          await expectLater(
            fixture.idp.startPasswordReset(session, email: email),
            throwsA(
              isA<EmailAccountPasswordResetException>().having(
                (final e) => e.reason,
                'reason',
                EmailAccountPasswordResetExceptionReason.unknown,
              ),
            ),
          );
        },
      );

      test('when the password utils are accessed then they throw.', () {
        expect(fixture.idp.utils.passwordLoginEnabled, isFalse);
        expect(() => fixture.idp.utils.authentication, throwsStateError);
        expect(() => fixture.idp.utils.accountCreation, throwsStateError);
        expect(() => fixture.idp.utils.passwordReset, throwsStateError);
      });
    },
  );

  withServerpod(
    'Given an email IdP with only the password login enabled',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIdpTestFixture fixture;

      setUp(() {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when startPasswordlessLogin is called then it throws an EmailPasswordlessLoginException with reason unknown.',
        () async {
          await expectLater(
            fixture.emailIdp.startPasswordlessLogin(session, email: email),
            throwsA(
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.unknown,
              ),
            ),
          );
        },
      );

      test(
        'when finishPasswordlessLogin is called then it throws an EmailPasswordlessLoginException with reason unknown.',
        () async {
          await expectLater(
            fixture.emailIdp.finishPasswordlessLogin(
              session,
              loginRequestId: const Uuid().v7obj(),
              verificationCode: '123456',
            ),
            throwsA(
              isA<EmailPasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                EmailPasswordlessLoginExceptionReason.unknown,
              ),
            ),
          );
        },
      );

      test('when the passwordless util is accessed then it throws.', () {
        expect(fixture.emailIdp.utils.passwordlessLoginEnabled, isFalse);
        expect(
          () => fixture.emailIdp.utils.passwordlessLogin,
          throwsStateError,
        );
      });
    },
  );

  withServerpod(
    'Given an email IdP with both logins enabled and a user that logged in with a code',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      const passwordResetCode = 'reset-code';
      late Session session;
      late EmailIdpPasswordlessTestFixture fixture;
      late AuthSuccess codeLogin;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpPasswordlessTestFixture(
          passwordConfig: EmailPasswordLoginConfig(
            passwordResetVerificationCodeGenerator: () => passwordResetCode,
          ),
        );

        final loginRequestId = await fixture.idp.startPasswordlessLogin(
          session,
          email: email,
        );
        codeLogin = await fixture.idp.finishPasswordlessLogin(
          session,
          loginRequestId: loginRequestId,
          verificationCode: fixtureVerificationCode,
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
        await EmailAccountPasswordResetRequest.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
        );
      });

      test('then the session is issued with the email method.', () async {
        final tokens = await fixture.tokenManager.listTokens(
          session,
          authUserId: codeLogin.authUserId,
        );

        expect(tokens.map((final t) => t.method), ['email']);
      });

      test(
        'when the user sets a password through a password reset then the session of the code login is revoked and the user can log in with the password.',
        () async {
          final passwordResetRequestId = await fixture.idp.startPasswordReset(
            session,
            email: email,
          );
          final finishToken = await fixture.idp.verifyPasswordResetCode(
            session,
            passwordResetRequestId: passwordResetRequestId,
            verificationCode: passwordResetCode,
          );
          await fixture.idp.finishPasswordReset(
            session,
            finishPasswordResetToken: finishToken,
            newPassword: 'Password123!',
          );

          expect(
            await fixture.tokenManager.listTokens(
              session,
              authUserId: codeLogin.authUserId,
            ),
            isEmpty,
          );

          final passwordLogin = await fixture.idp.login(
            session,
            email: email,
            password: 'Password123!',
          );
          expect(passwordLogin.authUserId, codeLogin.authUserId);
        },
      );
    },
  );
}
