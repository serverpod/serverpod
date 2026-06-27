import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'package:serverpod_auth_idp_server/providers/facebook.dart';
import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';

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
        'from userToRemove is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await EmailIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          // Verify moved
          final movedAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('remove@example.com'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);

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

          // Verify moved
          final movedAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_remove'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);

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

          // Verify moved
          final movedAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_remove'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);

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

          // Verify moved
          final movedAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_remove'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);

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

          // Verify moved
          final movedAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_remove'),
          );
          expect(movedAccount, isNotNull);
          expect(movedAccount!.authUserId, userToKeep.id);

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
    'Given active IDPs and multiple accounts',
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

        // Facebook Account
        final facebookAccount = FacebookAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'facebook_123',
        );
        await FacebookAccount.db.insertRow(session, facebookAccount);

        // Microsoft Account
        final microsoftAccount = MicrosoftAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'microsoft_123',
        );
        await MicrosoftAccount.db.insertRow(session, microsoftAccount);

        // Passkey Account
        final passkeyAccount = PasskeyAccount(
          authUserId: userToRemove.id,
          keyId: ByteData(16),
          keyIdBase64: 'base64',
          clientDataJSON: ByteData(16),
          attestationObject: ByteData(16),
          originalChallenge: ByteData(16),
        );
        await PasskeyAccount.db.insertRow(session, passkeyAccount);

        // Initialize AuthServices with a dummy provider that migrates both Apple and Google accounts
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'pepper'),
          ],
          identityProviderBuilders: [
            PreBuiltIdpBuilder(TestMergeIdp()),
          ],
        );
      });

      test(
        'when AccountMerger.merge is used then all active IDP accounts are migrated',
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

          final movedFacebookAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('facebook_123'),
          );
          expect(movedFacebookAccount, isNotNull);
          expect(movedFacebookAccount!.authUserId, userToKeep.id);

          final movedMicrosoftAccount = await MicrosoftAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('microsoft_123'),
          );
          expect(movedMicrosoftAccount, isNotNull);
          expect(movedMicrosoftAccount!.authUserId, userToKeep.id);

          final movedPasskeyAccount = await PasskeyAccount.db.findFirstRow(
            session,
            where: (final t) => t.keyIdBase64.equals('base64'),
          );
          expect(movedPasskeyAccount, isNotNull);
          expect(movedPasskeyAccount!.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given FacebookAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = FacebookAccount(authUserId: userToRemove.id, userIdentifier: 'facebook_123');
        await FacebookAccount.db.insertRow(session, account);
      });

      test(
        'when FacebookIdp.migrate is called then the FacebookAccount is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await FacebookIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(movedAccount, isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given FacebookAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = FacebookAccount(authUserId: userToKeep.id, userIdentifier: 'facebook_keep');
        await FacebookAccount.db.insertRow(session, existingAccount);

        final accountToRemove = FacebookAccount(authUserId: userToRemove.id, userIdentifier: 'facebook_123');
        await FacebookAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when FacebookIdp.migrate is called then the FacebookAccount from userToRemove is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await FacebookIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final keptAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(keptAccount, isNotNull);

          final deletedAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToRemove.id),
          );
          expect(deletedAccount, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given MicrosoftAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = MicrosoftAccount(authUserId: userToRemove.id, userIdentifier: 'microsoft_123');
        await MicrosoftAccount.db.insertRow(session, account);
      });

      test(
        'when MicrosoftIdp.migrate is called then the MicrosoftAccount is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await MicrosoftIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await MicrosoftAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(movedAccount, isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given MicrosoftAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = MicrosoftAccount(authUserId: userToKeep.id, userIdentifier: 'microsoft_keep');
        await MicrosoftAccount.db.insertRow(session, existingAccount);

        final accountToRemove = MicrosoftAccount(authUserId: userToRemove.id, userIdentifier: 'microsoft_123');
        await MicrosoftAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when MicrosoftIdp.migrate is called then the MicrosoftAccount from userToRemove is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await MicrosoftIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final keptAccount = await MicrosoftAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(keptAccount, isNotNull);

          final deletedAccount = await MicrosoftAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToRemove.id),
          );
          expect(deletedAccount, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given PasskeyAccount for userToRemove',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = PasskeyAccount(authUserId: userToRemove.id, keyId: ByteData(16), keyIdBase64: 'base64', clientDataJSON: ByteData(16), attestationObject: ByteData(16), originalChallenge: ByteData(16));
        await PasskeyAccount.db.insertRow(session, account);
      });

      test(
        'when PasskeyIdp.migrate is called then the PasskeyAccount is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await PasskeyIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final movedAccount = await PasskeyAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(movedAccount, isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given PasskeyAccount exists for userToKeep',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = PasskeyAccount(authUserId: userToKeep.id, keyId: ByteData(16), keyIdBase64: 'base64', clientDataJSON: ByteData(16), attestationObject: ByteData(16), originalChallenge: ByteData(16));
        await PasskeyAccount.db.insertRow(session, existingAccount);

        final accountToRemove = PasskeyAccount(authUserId: userToRemove.id, keyId: ByteData(16), keyIdBase64: 'base64', clientDataJSON: ByteData(16), attestationObject: ByteData(16), originalChallenge: ByteData(16));
        await PasskeyAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when PasskeyIdp.migrate is called then the PasskeyAccount from userToRemove is moved to userToKeep',
        () async {
          await session.db.transaction((final transaction) async {
            await PasskeyIdp.migrate(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final keptAccount = await PasskeyAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(keptAccount, isNotNull);

          final deletedAccount = await PasskeyAccount.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToRemove.id),
          );
          expect(deletedAccount, isNull);
        },
      );
    },
  );
}

class TestMergeIdp implements AccountMergeHandlerProvider {
  @override
  AccountMergeHandler get accountMergeHook =>
      (
        final session, {
        required final userToKeepId,
        required final userToRemoveId,
        required final transaction,
      }) async {
        await Future.wait([
          AppleIdp.migrate(
            session,
            userToKeepId: userToKeepId,
            userToRemoveId: userToRemoveId,
            transaction: transaction,
          ),
          GoogleIdp.migrate(
            session,
            userToKeepId: userToKeepId,
            userToRemoveId: userToRemoveId,
            transaction: transaction,
          ),
          FacebookIdp.migrate(
            session,
            userToKeepId: userToKeepId,
            userToRemoveId: userToRemoveId,
            transaction: transaction,
          ),
          MicrosoftIdp.migrate(
            session,
            userToKeepId: userToKeepId,
            userToRemoveId: userToRemoveId,
            transaction: transaction,
          ),
          PasskeyIdp.migrate(
            session,
            userToKeepId: userToKeepId,
            userToRemoveId: userToRemoveId,
            transaction: transaction,
          ),
        ]);
      };
}
