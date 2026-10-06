import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given email accounts for userToKeep and userToRemove',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailPasswordlessIdpTestFixture fixture;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailPasswordlessIdpTestFixture();

        userToKeep = await fixture.authUsers.create(session);
        userToRemove = await fixture.authUsers.create(session);

        await fixture.createEmailAccount(
          session,
          authUserId: userToKeep.id,
          email: 'keep@serverpod.dev',
        );
        await fixture.createEmailAccount(
          session,
          authUserId: userToRemove.id,
          email: 'remove@serverpod.dev',
          passwordHash: r'$argon2id$hash',
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when the auth users are merged', () {
        setUp(() async {
          await session.db.transaction(
            (final transaction) => fixture.idp.mergeAuthUsers(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            ),
          );
        });

        test(
          'then the email accounts of both users belong to userToKeep.',
          () async {
            final accounts = await EmailAccount.db.find(session);

            expect(accounts, hasLength(2));
            expect(
              accounts.map((final a) => a.authUserId),
              everyElement(userToKeep.id),
            );
          },
        );

        test(
          'then the password hash of the moved account is retained.',
          () async {
            final account = await EmailAccount.db.findFirstRow(
              session,
              where: (final t) => t.email.equals('remove@serverpod.dev'),
            );

            expect(account!.passwordHash, r'$argon2id$hash');
          },
        );

        test('then merging again has no further effect.', () async {
          await session.db.transaction(
            (final transaction) => fixture.idp.mergeAuthUsers(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            ),
          );

          final accounts = await EmailAccount.db.find(session);
          expect(accounts, hasLength(2));
          expect(
            accounts.map((final a) => a.authUserId),
            everyElement(userToKeep.id),
          );
        });

        test(
          'then merging through the email identity provider as well has no further effect.',
          () async {
            final emailIdp = EmailIdp(
              const EmailIdpConfig(secretHashPepper: 'pepper'),
              tokenManager: fixture.tokenManager,
            );

            await session.db.transaction(
              (final transaction) => emailIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              ),
            );

            final accounts = await EmailAccount.db.find(session);
            expect(accounts, hasLength(2));
            expect(
              accounts.map((final a) => a.authUserId),
              everyElement(userToKeep.id),
            );
          },
        );
      });
    },
  );
}
