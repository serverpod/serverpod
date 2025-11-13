import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given email account',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late EmailIDPTestFixture fixture;
      late EmailAccount emailAccount;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
        emailAccount = await fixture.createEmailAccount(
          session,
          authUserId: authUserId,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when set password is called with new password then user can authenticate with password',
        () async {
          const newPassword = 'new$password';

          await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.setPassword(
              session,
              emailAccount: emailAccount,
              password: newPassword,
              transaction: transaction,
            ),
          );

          final authResult = await session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: newPassword,
              transaction: transaction,
            ),
          );

          expect(authResult, equals(authUserId));
        },
      );

      test(
        'when set password is called with null password then user cannot authenticate with empty password',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.setPassword(
              session,
              emailAccount: emailAccount,
              password: null,
              transaction: transaction,
            ),
          );

          final authResult = session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: '',
              transaction: transaction,
            ),
          );

          await expectLater(
            authResult,
            throwsA(isA<EmailAuthenticationInvalidCredentialsException>()),
          );
        },
      );

      test(
        'when set password is called with empty password then user can authenticate with empty password',
        () async {
          await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.setPassword(
              session,
              emailAccount: emailAccount,
              password: '',
              transaction: transaction,
            ),
          );

          final authResult = await session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: '',
              transaction: transaction,
            ),
          );

          expect(authResult, equals(authUserId));
        },
      );
    },
  );
}
