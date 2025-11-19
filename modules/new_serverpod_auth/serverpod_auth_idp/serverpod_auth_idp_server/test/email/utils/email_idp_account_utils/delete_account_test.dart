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
        'when deleteAccount is called with email then only that email account is deleted',
        () async {
          final deletedAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.deleteAccount(
              session,
              email: email1,
              authUserId: null,
              transaction: transaction,
            ),
          );

          expect(deletedAccounts, hasLength(1));
          expect(deletedAccounts.single.email, equals(email1));

          final remainingAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );
          expect(remainingAccounts, hasLength(2));
          final remainingEmails = remainingAccounts.map((final a) => a.email);
          expect(remainingEmails, isNot(contains(email1)));
          expect(remainingEmails, containsAll([email2, email3]));
        },
      );

      test(
        'when deleteAccount is called with authUserId then all accounts for that user are deleted',
        () async {
          final deletedAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.deleteAccount(
              session,
              email: null,
              authUserId: authUserId1,
              transaction: transaction,
            ),
          );

          expect(deletedAccounts, hasLength(2));
          final deletedEmails = deletedAccounts.map((final a) => a.email);
          expect(deletedEmails, containsAll([email1, email2]));
          expect(
            deletedAccounts.every((final a) => a.authUserId == authUserId1),
            isTrue,
          );

          final remainingAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );
          expect(remainingAccounts, hasLength(1));
          expect(remainingAccounts.single.email, equals(email3));
        },
      );

      test(
        'when deleteAccount is called with both email and authUserId then only matching account is deleted',
        () async {
          final deletedAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.deleteAccount(
              session,
              email: email1,
              authUserId: authUserId1,
              transaction: transaction,
            ),
          );

          expect(deletedAccounts, hasLength(1));
          expect(deletedAccounts.single.email, equals(email1));
          expect(deletedAccounts.single.authUserId, equals(authUserId1));

          final remainingAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );
          expect(remainingAccounts, hasLength(2));
          final remainingEmails = remainingAccounts.map((final a) => a.email);
          expect(remainingEmails, containsAll([email2, email3]));
          expect(remainingEmails, isNot(contains(email1)));
        },
      );

      test(
        'when deleteAccount is called with non-matching filters then no accounts are deleted',
        () async {
          final deletedAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.deleteAccount(
              session,
              email: email1,
              authUserId: authUserId2,
              transaction: transaction,
            ),
          );

          expect(deletedAccounts, isEmpty);

          final remainingAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );
          expect(remainingAccounts, hasLength(3));
        },
      );

      test(
        'when deleteAccount is called with neither email nor authUserId then all accounts are deleted',
        () async {
          final deletedAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.deleteAccount(
              session,
              email: null,
              authUserId: null,
              transaction: transaction,
            ),
          );

          expect(deletedAccounts, hasLength(3));
          final deletedEmails = deletedAccounts.map((final a) => a.email);
          expect(deletedEmails, containsAll([email1, email2, email3]));

          final remainingAccounts = await session.db.transaction(
            (final transaction) => fixture.emailIDP.utils.account.listAccounts(
              session,
              transaction: transaction,
            ),
          );
          expect(remainingAccounts, isEmpty);
        },
      );
    },
  );
}
