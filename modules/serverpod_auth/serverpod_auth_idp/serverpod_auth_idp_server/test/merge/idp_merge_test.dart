import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/facebook.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';

import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  const AuthUsers authUsers = AuthUsers();
  final tokenManager = ServerSideSessionsTokenManager(
    config: ServerSideSessionsConfig(
      sessionKeyHashPepper: 'test-session-key-hash-pepper',
    ),
    authUsers: authUsers,
  );
  final anonymousIdp = AnonymousIdp(
    const AnonymousIdpConfig(),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );
  final appleIdp = AppleIdp(
    const AppleIdpConfig(
      serviceIdentifier: 'test-service-identifier',
      bundleIdentifier: 'test-bundle-identifier',
      redirectUri: 'https://example.com/callback',
      teamId: 'test-team-id',
      keyId: 'test-key-id',
      key: 'test-key',
    ),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );
  final emailIdp = EmailIdp(
    const EmailIdpConfig(secretHashPepper: 'test-secret-hash-pepper'),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );
  final facebookIdp = FacebookIdp(
    const FacebookIdpConfig(
      appId: 'test-app-id',
      appSecret: 'test-app-secret',
    ),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );
  final firebaseIdp = FirebaseIdp(
    const FirebaseIdpConfig(
      credentials: FirebaseServiceAccountCredentials(
        projectId: 'test-project-id',
      ),
    ),
    tokenIssuer: tokenManager,
    authUsers: authUsers,
  );
  final githubIdp = GitHubIdp(
    GitHubIdpConfig(
      clientId: 'test-client-id',
      clientSecret: 'test-client-secret',
    ),
    tokenIssuer: tokenManager,
    authUsers: authUsers,
  );
  final googleIdp = GoogleIdp(
    GoogleIdpConfig(
      clientSecret: GoogleClientSecret.fromJson({
        'web': {
          'client_id': 'test-client-id',
          'client_secret': 'test-client-secret',
          'redirect_uris': <String>[],
        },
      }),
    ),
    tokenIssuer: tokenManager,
    authUsers: authUsers,
  );
  final microsoftIdp = MicrosoftIdp(
    MicrosoftIdpConfig(
      clientId: 'test-client-id',
      clientSecret: 'test-client-secret',
      fetchProfilePhoto: false,
    ),
    tokenIssuer: tokenManager,
    authUsers: authUsers,
  );
  final passkeyIdp = PasskeyIdp(
    const PasskeyIdpConfig(hostname: 'localhost'),
    tokenManager: tokenManager,
    authUsers: authUsers,
  );
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
    'Given an EmailAccount for userToRemove,',
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
        'when EmailIdp.mergeAuthUsers is called, '
        'then the EmailAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await emailIdp.mergeAuthUsers(
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
    'Given EmailAccounts for userToKeep and userToRemove,',
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
        'when EmailIdp.mergeAuthUsers is called, '
        'then the EmailAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await emailIdp.mergeAuthUsers(
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
    'Given a GoogleAccount for userToRemove,',
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
        'when GoogleIdp.mergeAuthUsers is called, '
        'then the GoogleAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await googleIdp.mergeAuthUsers(
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
    'Given GoogleAccounts for userToKeep and userToRemove,',
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
        'when GoogleIdp.mergeAuthUsers is called, '
        'then the GoogleAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await googleIdp.mergeAuthUsers(
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
    'Given an AppleAccount for userToRemove,',
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
        'when AppleIdp.mergeAuthUsers is called, '
        'then the AppleAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await appleIdp.mergeAuthUsers(
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
    'Given AppleAccounts for userToKeep and userToRemove,',
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
        'when AppleIdp.mergeAuthUsers is called, '
        'then the AppleAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await appleIdp.mergeAuthUsers(
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
    'Given a FirebaseAccount for userToRemove,',
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
        'when FirebaseIdp.mergeAuthUsers is called, '
        'then the FirebaseAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await firebaseIdp.mergeAuthUsers(
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
    'Given FirebaseAccounts for userToKeep and userToRemove,',
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
        'when FirebaseIdp.mergeAuthUsers is called, '
        'then the FirebaseAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await firebaseIdp.mergeAuthUsers(
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
    'Given a GitHubAccount for userToRemove,',
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
        'when GitHubIdp.mergeAuthUsers is called, '
        'then the GitHubAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await githubIdp.mergeAuthUsers(
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
    'Given GitHubAccounts for userToKeep and userToRemove,',
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
        'when GitHubIdp.mergeAuthUsers is called, '
        'then the GitHubAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await githubIdp.mergeAuthUsers(
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
    'Given all identity providers with account data for userToRemove,',
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

        final emailAccount = EmailAccount(
          authUserId: userToRemove.id,
          email: 'test-merge@example.com',
          passwordHash: 'hash',
        );
        await EmailAccount.db.insertRow(session, emailAccount);

        final firebaseAccount = FirebaseAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'firebase_123',
        );
        await FirebaseAccount.db.insertRow(session, firebaseAccount);

        final githubAccount = GitHubAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'github_123',
        );
        await GitHubAccount.db.insertRow(session, githubAccount);

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

        // Register the actual identity provider implementations so the test
        // exercises the required IdentityProvider contract.
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'pepper_12345'),
          ],
          identityProviderBuilders: [
            PreBuiltIdpBuilder(anonymousIdp),
            PreBuiltIdpBuilder(appleIdp),
            PreBuiltIdpBuilder(emailIdp),
            PreBuiltIdpBuilder(facebookIdp),
            PreBuiltIdpBuilder(firebaseIdp),
            PreBuiltIdpBuilder(githubIdp),
            PreBuiltIdpBuilder(googleIdp),
            PreBuiltIdpBuilder(microsoftIdp),
            PreBuiltIdpBuilder(passkeyIdp),
          ],
        );
      });

      test(
        'when AccountMerger.merge is called, '
        'then every registered IDP migrates its account data.',
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

          final movedEmailAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('test-merge@example.com'),
          );
          expect(movedEmailAccount, isNotNull);
          expect(movedEmailAccount!.authUserId, userToKeep.id);

          final movedFirebaseAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_123'),
          );
          expect(movedFirebaseAccount, isNotNull);
          expect(movedFirebaseAccount!.authUserId, userToKeep.id);

          final movedGitHubAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_123'),
          );
          expect(movedGitHubAccount, isNotNull);
          expect(movedGitHubAccount!.authUserId, userToKeep.id);

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
    'Given a FacebookAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = FacebookAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'facebook_123',
        );
        await FacebookAccount.db.insertRow(session, account);
      });

      test(
        'when FacebookIdp.mergeAuthUsers is called, '
        'then the FacebookAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await facebookIdp.mergeAuthUsers(
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
    'Given FacebookAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = FacebookAccount(
          authUserId: userToKeep.id,
          userIdentifier: 'facebook_keep',
        );
        await FacebookAccount.db.insertRow(session, existingAccount);

        final accountToRemove = FacebookAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'facebook_123',
        );
        await FacebookAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when FacebookIdp.mergeAuthUsers is called, '
        'then the FacebookAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await facebookIdp.mergeAuthUsers(
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
    'Given a MicrosoftAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = MicrosoftAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'microsoft_123',
        );
        await MicrosoftAccount.db.insertRow(session, account);
      });

      test(
        'when MicrosoftIdp.mergeAuthUsers is called, '
        'then the MicrosoftAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await microsoftIdp.mergeAuthUsers(
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
    'Given MicrosoftAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = MicrosoftAccount(
          authUserId: userToKeep.id,
          userIdentifier: 'microsoft_keep',
        );
        await MicrosoftAccount.db.insertRow(session, existingAccount);

        final accountToRemove = MicrosoftAccount(
          authUserId: userToRemove.id,
          userIdentifier: 'microsoft_123',
        );
        await MicrosoftAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when MicrosoftIdp.mergeAuthUsers is called, '
        'then the MicrosoftAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await microsoftIdp.mergeAuthUsers(
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
    'Given a PasskeyAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final account = PasskeyAccount(
          authUserId: userToRemove.id,
          keyId: ByteData(16),
          keyIdBase64: 'base64',
          clientDataJSON: ByteData(16),
          attestationObject: ByteData(16),
          originalChallenge: ByteData(16),
        );
        await PasskeyAccount.db.insertRow(session, account);
      });

      test(
        'when PasskeyIdp.mergeAuthUsers is called, '
        'then the PasskeyAccount is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await passkeyIdp.mergeAuthUsers(
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
    'Given PasskeyAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        final existingAccount = PasskeyAccount(
          authUserId: userToKeep.id,
          keyId: ByteData(16),
          keyIdBase64: 'base64',
          clientDataJSON: ByteData(16),
          attestationObject: ByteData(16),
          originalChallenge: ByteData(16),
        );
        await PasskeyAccount.db.insertRow(session, existingAccount);

        final accountToRemove = PasskeyAccount(
          authUserId: userToRemove.id,
          keyId: ByteData(16),
          keyIdBase64: 'base64_2',
          clientDataJSON: ByteData(16),
          attestationObject: ByteData(16),
          originalChallenge: ByteData(16),
        );
        await PasskeyAccount.db.insertRow(session, accountToRemove);
      });

      test(
        'when PasskeyIdp.mergeAuthUsers is called, '
        'then the PasskeyAccount from userToRemove is moved to userToKeep.',
        () async {
          await session.db.transaction((final transaction) async {
            await passkeyIdp.mergeAuthUsers(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final keptAccounts = await PasskeyAccount.db.find(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(keptAccounts, hasLength(2));

          final deletedAccounts = await PasskeyAccount.db.find(
            session,
            where: (final t) => t.authUserId.equals(userToRemove.id),
          );
          expect(deletedAccounts, isEmpty);
        },
      );
    },
  );
}
