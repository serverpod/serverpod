import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  const AuthUsers authUsers = AuthUsers();
  late AuthUserModel userToKeep;
  late AuthUserModel userToRemove;

  late Session session;

  final accountMerger = AccountMerger(
    config: AccountMergeConfig(
      applicationMergeHandler:
          (
            final session, {
            required final UuidValue userToKeepId,
            required final UuidValue userToRemoveId,
            required final transaction,
          }) async {},
      mergeHooks: [defaultIdpMergeHook],
    ),
  );

  withServerpod(
    'Given EmailAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final emailAccount = EmailAccount(
          authUserId: userToRemove.id,
          email: 'test-merge@example.com',
          passwordHash: 'hash',
        );
        await EmailAccount.db.insertRow(session, emailAccount);
      });

      test(
        'when EmailIdp.migrate is called then the EmailAccount is moved to '
        'userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await EmailIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('test-merge@example.com'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given EmailAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        // Conflict account
        final existingAccount = EmailAccount(
          authUserId: userToKeep.id,
          email: 'keep@example.com',
          passwordHash: 'hash',
        );
        await EmailAccount.db.insertRow(session, existingAccount);

        // Account to remove
        final accountToRemove = EmailAccount(
          authUserId: userToRemove.id,
          email: 'remove@example.com',
          passwordHash: 'hash',
        );
        await EmailAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when EmailIdp.migrate is called then the EmailAccount '
        'from userToRemove is deleted',
        () async {
          await session.db.transaction((final transaction) async {
            await EmailIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify removed
          final deletedAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('remove@example.com'),
          );
          expect(deletedAccount, isNull);

          // Verify kept
          final keptAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('keep@example.com'),
          );
          expect(keptAccount, isNotNull);
          expect(keptAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GoogleAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final googleAccount = GoogleAccount(
          authUserId: userToRemove.id,
          email: 'test-merge-google@example.com',
          userIdentifier: 'google_123',
        );
        await GoogleAccount.db.insertRow(session, googleAccount);
      });

      test(
        'when GoogleIdp.migrate is called then the GoogleAccount is moved to '
        'userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await GoogleIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_123'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GoogleAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = GoogleAccount(
          authUserId: userToKeep.id,
          email: 'keep-google@example.com',
          userIdentifier: 'google_keep',
        );
        await GoogleAccount.db.insertRow(session, existingAccount);

        final accountToRemove = GoogleAccount(
          authUserId: userToRemove.id,
          email: 'remove-google@example.com',
          userIdentifier: 'google_remove',
        );
        await GoogleAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when GoogleIdp.migrate is called then the GoogleAccount from '
        'userToRemove is deleted',
        () async {
          await session.db.transaction((final transaction) async {
            await GoogleIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify removed
          final deletedAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_remove'),
          );
          expect(deletedAccount, isNull);

          // Verify kept
          final keptAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_keep'),
          );
          expect(keptAccount, isNotNull);
          expect(keptAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given AppleAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final appleAccount = AppleAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'apple_123',
          refreshToken: 'refresh_token',
          refreshTokenRequestedWithBundleIdentifier: false,
        );
        await AppleAccount.db.insertRow(session, appleAccount);
      });

      test(
        'when AppleIdp.migrate is called then the AppleAccount is moved to '
        'userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await AppleIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_123'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given AppleAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = AppleAccount(
          authUserId: userToKeep.id,
          userIdentifier: 'apple_keep',
          refreshToken: 'refresh_token_keep',
          refreshTokenRequestedWithBundleIdentifier: false,
        );
        await AppleAccount.db.insertRow(session, existingAccount);

        final accountToRemove = AppleAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'apple_remove',
          refreshToken: 'refresh_token_remove',
          refreshTokenRequestedWithBundleIdentifier: false,
        );
        await AppleAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when AppleIdp.migrate is called then the AppleAccount from '
        'userToRemove is deleted',
        () async {
          await session.db.transaction((final transaction) async {
            await AppleIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify removed
          final deletedAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_remove'),
          );
          expect(deletedAccount, isNull);

          // Verify kept
          final keptAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_keep'),
          );
          expect(keptAccount, isNotNull);
          expect(keptAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given FirebaseAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final firebaseAccount = FirebaseAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'firebase_123',
        );
        await FirebaseAccount.db.insertRow(session, firebaseAccount);
      });

      test(
        'when FirebaseIdp.migrate is called then the FirebaseAccount is moved '
        'to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await FirebaseIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_123'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given FirebaseAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = FirebaseAccount(
          authUserId: userToKeep.id,
          userIdentifier: 'firebase_keep',
        );
        await FirebaseAccount.db.insertRow(session, existingAccount);

        final accountToRemove = FirebaseAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'firebase_remove',
        );
        await FirebaseAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when FirebaseIdp.migrate is called then the FirebaseAccount from '
        'userToRemove is deleted',
        () async {
          await session.db.transaction((final transaction) async {
            await FirebaseIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify removed
          final deletedAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_remove'),
          );
          expect(deletedAccount, isNull);

          // Verify kept
          final keptAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_keep'),
          );
          expect(keptAccount, isNotNull);
          expect(keptAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GitHubAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final githubAccount = GitHubAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'github_123',
        );
        await GitHubAccount.db.insertRow(session, githubAccount);
      });

      test(
        'when GitHubIdp.migrate is called then the GitHubAccount is moved to '
        'userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await GitHubIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_123'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GitHubAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = GitHubAccount(
          authUserId: userToKeep.id,
          userIdentifier: 'github_keep',
        );
        await GitHubAccount.db.insertRow(session, existingAccount);

        final accountToRemove = GitHubAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'github_remove',
        );
        await GitHubAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when GitHubIdp.migrate is called then the GitHubAccount from '
        'userToRemove is deleted',
        () async {
          await session.db.transaction((final transaction) async {
            await GitHubIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify removed
          final deletedAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_remove'),
          );
          expect(deletedAccount, isNull);

          // Verify kept
          final keptAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_keep'),
          );
          expect(keptAccount, isNotNull);
          expect(keptAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given defaultIdpMergeHook and multiple accounts',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        // Apple Account
        final appleAccount = AppleAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'apple_123',
          refreshToken: 'refresh_token',
          refreshTokenRequestedWithBundleIdentifier: false,
        );
        await AppleAccount.db.insertRow(session, appleAccount);

        // Google Account
        final googleAccount = GoogleAccount(
          authUserId: userToRemove.id,
          email: 'test-merge-google@example.com',
          userIdentifier: 'google_123',
        );
        await GoogleAccount.db.insertRow(session, googleAccount);
      });

      test(
        'when defaultIdpMergeHook is used then all accounts are migrated',
        () async {
          await session.db.transaction((final transaction) async {
            await accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAppleAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_123'),
          );
          expect(movedAppleAccount, isNotNull);
          expect(movedAppleAccount!.authUserId, userToKeep.id);

          final movedGoogleAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_123'),
          );
          expect(movedGoogleAccount, isNotNull);
          expect(movedGoogleAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );
}
