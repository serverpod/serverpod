import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given multiple email accounts',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue authUserId1;
      late UuidValue authUserId2;
      const email1 = 'test1@serverpod.dev';
      const email2 = 'test2@serverpod.dev';
      const email3 = 'test3@serverpod.dev';

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        final authUser1 = await fixture.authUsers.create(session);
        authUserId1 = authUser1.id;

        final authUser2 = await fixture.authUsers.create(session);
        authUserId2 = authUser2.id;

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId1,
          email: email1,
          password: EmailAccountPassword.fromString('Password123!'),
        );

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId1,
          email: email2,
          password: EmailAccountPassword.fromString('Password123!'),
        );

        await fixture.createEmailAccount(
          session,
          authUserId: authUserId2,
          email: email3,
          password: EmailAccountPassword.fromString('Password123!'),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when listAccounts is called with email then only that email account is returned',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              email: email1,
              transaction: transaction,
            ),
          );

          expect(accounts, hasLength(1));
          expect(accounts.single.email, equals(email1));
        },
      );

      test(
        'when listAccounts is called with authUserId then all accounts for that user are returned',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              authUserId: authUserId1,
              transaction: transaction,
            ),
          );

          expect(accounts, hasLength(2));
          final emails = accounts.map((final a) => a.email);
          expect(emails, containsAll([email1, email2]));
          expect(
            accounts.every((final a) => a.authUserId == authUserId1),
            isTrue,
          );
        },
      );

      test(
        'when listAccounts is called with both email and authUserId then only matching account is returned',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              email: email1,
              authUserId: authUserId1,
              transaction: transaction,
            ),
          );

          expect(accounts, hasLength(1));
          expect(accounts.single.email, equals(email1));
          expect(accounts.single.authUserId, equals(authUserId1));
        },
      );

      test(
        'when listAccounts is called with non-matching filters then no accounts are returned',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              email: email1,
              authUserId: authUserId2,
              transaction: transaction,
            ),
          );

          expect(accounts, isEmpty);
        },
      );

      test(
        'when listAccounts is called with neither email nor authUserId then all accounts are returned',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );

          expect(accounts, hasLength(3));
          final emails = accounts.map((final a) => a.email);
          expect(emails, containsAll([email1, email2, email3]));
        },
      );

      test(
        'when listAccounts is called with uppercase email then account is found',
        () async {
          final accounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              email: email1.toUpperCase(),
              transaction: transaction,
            ),
          );

          expect(accounts, hasLength(1));
          expect(accounts.single.email, equals(email1));
        },
      );
    },
  );

  withServerpod(
    'Given no email accounts',
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

      test('when listAccounts is called then empty list is returned', () async {
        final accounts = await session.db.transaction(
          (final transaction) => fixture.emailIDP.utils.account.listAccounts(
            session,
            transaction: transaction,
          ),
        );

        expect(accounts, isEmpty);
      });
    },
  );
}
