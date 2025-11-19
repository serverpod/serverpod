import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given auth user',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();
        final authUser = await fixture.authUsers.create(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when create email authentication is called with password', () {
        late Future<UuidValue> createEmailAuthenticationFuture;
        setUp(() async {
          createEmailAuthenticationFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.createEmailAuthentication(
                  session,
                  authUserId: authUserId,
                  email: email,
                  password: password,
                  transaction: transaction,
                ),
          );
        });

        test('when it completes with account id', () {
          expectLater(
            createEmailAuthenticationFuture,
            completion(isA<UuidValue>()),
          );
        });

        test('then user can authenticate with password', () async {
          await createEmailAuthenticationFuture;

          final authResult = await session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          expect(authResult, equals(authUserId));
        });
      });

      test(
        'when create email authentication is called with null password then user cannot authenticate with empty password',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.createEmailAuthentication(
                  session,
                  authUserId: authUserId,
                  email: email,
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
        'when create email authentication is called with empty password then user can authenticate with empty password',
        () async {
          await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.createEmailAuthentication(
                  session,
                  authUserId: authUserId,
                  email: email,
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
