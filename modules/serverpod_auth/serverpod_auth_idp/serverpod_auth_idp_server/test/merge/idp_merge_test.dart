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

  setUp(() {
    // Reset the global auth services before every test, so that the identity
    // providers registered by a single group cannot leak into the others.
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
      ],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given an EmailAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: userToRemove.id,
            email: 'test-merge@example.com',
            passwordHash: 'hash',
          ),
        );
      });

      test(
        'when the auth users are merged through the email identity provider, '
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
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given EmailAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: userToKeep.id,
            email: 'keep@example.com',
            passwordHash: 'hash',
          ),
        );

        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: userToRemove.id,
            email: 'remove@example.com',
            passwordHash: 'hash',
          ),
        );
      });

      group(
        'when the auth users are merged through the email identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await emailIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the EmailAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await EmailAccount.db.findFirstRow(
                session,
                where: (final t) => t.email.equals('remove@example.com'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the EmailAccount of userToKeep is retained.', () async {
            final keptAccount = await EmailAccount.db.findFirstRow(
              session,
              where: (final t) => t.email.equals('keep@example.com'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no EmailAccount remains for userToRemove.', () async {
            final remainingAccounts = await EmailAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a GoogleAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await GoogleAccount.db.insertRow(
          session,
          GoogleAccount(
            authUserId: userToRemove.id,
            email: 'test-merge-google@example.com',
            userIdentifier: 'google_123',
          ),
        );
      });

      test(
        'when the auth users are merged through the Google identity provider, '
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
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GoogleAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await GoogleAccount.db.insertRow(
          session,
          GoogleAccount(
            authUserId: userToKeep.id,
            email: 'keep-google@example.com',
            userIdentifier: 'google_keep',
          ),
        );

        await GoogleAccount.db.insertRow(
          session,
          GoogleAccount(
            authUserId: userToRemove.id,
            email: 'remove-google@example.com',
            userIdentifier: 'google_remove',
          ),
        );
      });

      group(
        'when the auth users are merged through the Google identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await googleIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the GoogleAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await GoogleAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('google_remove'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the GoogleAccount of userToKeep is retained.', () async {
            final keptAccount = await GoogleAccount.db.findFirstRow(
              session,
              where: (final t) => t.userIdentifier.equals('google_keep'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no GoogleAccount remains for userToRemove.', () async {
            final remainingAccounts = await GoogleAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given an AppleAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await AppleAccount.db.insertRow(
          session,
          AppleAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'apple_123',
            refreshToken: 'refresh_token',
            refreshTokenRequestedWithBundleIdentifier: false,
          ),
        );
      });

      test(
        'when the auth users are merged through the Apple identity provider, '
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
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given AppleAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await AppleAccount.db.insertRow(
          session,
          AppleAccount(
            authUserId: userToKeep.id,
            userIdentifier: 'apple_keep',
            refreshToken: 'refresh_token_keep',
            refreshTokenRequestedWithBundleIdentifier: false,
          ),
        );

        await AppleAccount.db.insertRow(
          session,
          AppleAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'apple_remove',
            refreshToken: 'refresh_token_remove',
            refreshTokenRequestedWithBundleIdentifier: false,
          ),
        );
      });

      group(
        'when the auth users are merged through the Apple identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await appleIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the AppleAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await AppleAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('apple_remove'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the AppleAccount of userToKeep is retained.', () async {
            final keptAccount = await AppleAccount.db.findFirstRow(
              session,
              where: (final t) => t.userIdentifier.equals('apple_keep'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no AppleAccount remains for userToRemove.', () async {
            final remainingAccounts = await AppleAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a FirebaseAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await FirebaseAccount.db.insertRow(
          session,
          FirebaseAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'firebase_123',
          ),
        );
      });

      test(
        'when the auth users are merged through the Firebase identity provider, '
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
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given FirebaseAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await FirebaseAccount.db.insertRow(
          session,
          FirebaseAccount(
            authUserId: userToKeep.id,
            userIdentifier: 'firebase_keep',
          ),
        );

        await FirebaseAccount.db.insertRow(
          session,
          FirebaseAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'firebase_remove',
          ),
        );
      });

      group(
        'when the auth users are merged through the Firebase identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await firebaseIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the FirebaseAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await FirebaseAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('firebase_remove'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the FirebaseAccount of userToKeep is retained.', () async {
            final keptAccount = await FirebaseAccount.db.findFirstRow(
              session,
              where: (final t) => t.userIdentifier.equals('firebase_keep'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no FirebaseAccount remains for userToRemove.', () async {
            final remainingAccounts = await FirebaseAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a GitHubAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'github_123',
          ),
        );
      });

      test(
        'when the auth users are merged through the GitHub identity provider, '
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
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given GitHubAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            authUserId: userToKeep.id,
            userIdentifier: 'github_keep',
          ),
        );

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'github_remove',
          ),
        );
      });

      group(
        'when the auth users are merged through the GitHub identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await githubIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the GitHubAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await GitHubAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('github_remove'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the GitHubAccount of userToKeep is retained.', () async {
            final keptAccount = await GitHubAccount.db.findFirstRow(
              session,
              where: (final t) => t.userIdentifier.equals('github_keep'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no GitHubAccount remains for userToRemove.', () async {
            final remainingAccounts = await GitHubAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a FacebookAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'facebook_123',
          ),
        );
      });

      test(
        'when the auth users are merged through the Facebook identity provider, '
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
            where: (final t) => t.userIdentifier.equals('facebook_123'),
          );
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given FacebookAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            authUserId: userToKeep.id,
            userIdentifier: 'facebook_keep',
          ),
        );

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'facebook_123',
          ),
        );
      });

      group(
        'when the auth users are merged through the Facebook identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await facebookIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the FacebookAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await FacebookAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('facebook_123'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the FacebookAccount of userToKeep is retained.', () async {
            final keptAccount = await FacebookAccount.db.findFirstRow(
              session,
              where: (final t) => t.userIdentifier.equals('facebook_keep'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no FacebookAccount remains for userToRemove.', () async {
            final remainingAccounts = await FacebookAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a MicrosoftAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await MicrosoftAccount.db.insertRow(
          session,
          MicrosoftAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'microsoft_123',
          ),
        );
      });

      test(
        'when the auth users are merged through the Microsoft identity provider, '
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
            where: (final t) => t.userIdentifier.equals('microsoft_123'),
          );
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given MicrosoftAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await MicrosoftAccount.db.insertRow(
          session,
          MicrosoftAccount(
            authUserId: userToKeep.id,
            userIdentifier: 'microsoft_keep',
          ),
        );

        await MicrosoftAccount.db.insertRow(
          session,
          MicrosoftAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'microsoft_123',
          ),
        );
      });

      group(
        'when the auth users are merged through the Microsoft identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await microsoftIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the MicrosoftAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await MicrosoftAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('microsoft_123'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test(
            'then the MicrosoftAccount of userToKeep is retained.',
            () async {
              final keptAccount = await MicrosoftAccount.db.findFirstRow(
                session,
                where: (final t) => t.userIdentifier.equals('microsoft_keep'),
              );

              expect(keptAccount?.authUserId, userToKeep.id);
            },
          );

          test('then no MicrosoftAccount remains for userToRemove.', () async {
            final remainingAccounts = await MicrosoftAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a PasskeyAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await PasskeyAccount.db.insertRow(
          session,
          PasskeyAccount(
            authUserId: userToRemove.id,
            keyId: ByteData(16),
            keyIdBase64: 'base64',
            clientDataJSON: ByteData(16),
            attestationObject: ByteData(16),
            originalChallenge: ByteData(16),
          ),
        );
      });

      test(
        'when the auth users are merged through the passkey identity provider, '
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
            where: (final t) => t.keyIdBase64.equals('base64'),
          );
          expect(movedAccount?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given PasskeyAccounts for userToKeep and userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await PasskeyAccount.db.insertRow(
          session,
          PasskeyAccount(
            authUserId: userToKeep.id,
            keyId: ByteData(16),
            keyIdBase64: 'base64',
            clientDataJSON: ByteData(16),
            attestationObject: ByteData(16),
            originalChallenge: ByteData(16),
          ),
        );

        await PasskeyAccount.db.insertRow(
          session,
          PasskeyAccount(
            authUserId: userToRemove.id,
            keyId: ByteData(16),
            keyIdBase64: 'base64_2',
            clientDataJSON: ByteData(16),
            attestationObject: ByteData(16),
            originalChallenge: ByteData(16),
          ),
        );
      });

      group(
        'when the auth users are merged through the passkey identity provider,',
        () {
          setUp(() async {
            await session.db.transaction((final transaction) async {
              await passkeyIdp.mergeAuthUsers(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              );
            });
          });

          test(
            'then the PasskeyAccount from userToRemove is moved to userToKeep.',
            () async {
              final movedAccount = await PasskeyAccount.db.findFirstRow(
                session,
                where: (final t) => t.keyIdBase64.equals('base64_2'),
              );

              expect(movedAccount?.authUserId, userToKeep.id);
            },
          );

          test('then the PasskeyAccount of userToKeep is retained.', () async {
            final keptAccount = await PasskeyAccount.db.findFirstRow(
              session,
              where: (final t) => t.keyIdBase64.equals('base64'),
            );

            expect(keptAccount?.authUserId, userToKeep.id);
          });

          test('then no PasskeyAccount remains for userToRemove.', () async {
            final remainingAccounts = await PasskeyAccount.db.find(
              session,
              where: (final t) => t.authUserId.equals(userToRemove.id),
            );

            expect(remainingAccounts, isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given an AnonymousAccount for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await AnonymousAccount.db.insertRow(
          session,
          AnonymousAccount(authUserId: userToRemove.id),
        );
      });

      test(
        'when the auth users are merged through the anonymous identity provider, '
        'then the AnonymousAccount is left with userToRemove.',
        () async {
          await session.db.transaction((final transaction) async {
            await anonymousIdp.mergeAuthUsers(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final anonymousAccount = await AnonymousAccount.db.findFirstRow(
            session,
          );
          expect(anonymousAccount?.authUserId, userToRemove.id);
        },
      );
    },
  );

  withServerpod(
    'Given an account merger with a no-op application merge handler, all identity providers registered, and account data for userToRemove,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();

        accountMerger = const AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler: _noOpApplicationMergeHandler,
          ),
        );

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await AnonymousAccount.db.insertRow(
          session,
          AnonymousAccount(authUserId: userToRemove.id),
        );

        await AppleAccount.db.insertRow(
          session,
          AppleAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'apple_123',
            refreshToken: 'refresh_token',
            refreshTokenRequestedWithBundleIdentifier: false,
          ),
        );

        await GoogleAccount.db.insertRow(
          session,
          GoogleAccount(
            authUserId: userToRemove.id,
            email: 'test-merge-google@example.com',
            userIdentifier: 'google_123',
          ),
        );

        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: userToRemove.id,
            email: 'test-merge@example.com',
            passwordHash: 'hash',
          ),
        );

        await FirebaseAccount.db.insertRow(
          session,
          FirebaseAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'firebase_123',
          ),
        );

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'github_123',
          ),
        );

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'facebook_123',
          ),
        );

        await MicrosoftAccount.db.insertRow(
          session,
          MicrosoftAccount(
            authUserId: userToRemove.id,
            userIdentifier: 'microsoft_123',
          ),
        );

        await PasskeyAccount.db.insertRow(
          session,
          PasskeyAccount(
            authUserId: userToRemove.id,
            keyId: ByteData(16),
            keyIdBase64: 'base64',
            clientDataJSON: ByteData(16),
            attestationObject: ByteData(16),
            originalChallenge: ByteData(16),
          ),
        );

        // Register the actual identity provider implementations so the test
        // exercises the required IdentityProvider contract.
        //
        // The type arguments are mandatory: inside a list literal typed as
        // `List<IdentityProviderBuilder>`, `PreBuiltIdpBuilder(idp)` infers
        // `IdentityProvider` for its type argument, and since the providers are
        // registered keyed by that type, every provider but the last one would
        // be dropped.
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'pepper_12345'),
          ],
          identityProviderBuilders: [
            PreBuiltIdpBuilder<AnonymousIdp>(anonymousIdp),
            PreBuiltIdpBuilder<AppleIdp>(appleIdp),
            PreBuiltIdpBuilder<EmailIdp>(emailIdp),
            PreBuiltIdpBuilder<FacebookIdp>(facebookIdp),
            PreBuiltIdpBuilder<FirebaseIdp>(firebaseIdp),
            PreBuiltIdpBuilder<GitHubIdp>(githubIdp),
            PreBuiltIdpBuilder<GoogleIdp>(googleIdp),
            PreBuiltIdpBuilder<MicrosoftIdp>(microsoftIdp),
            PreBuiltIdpBuilder<PasskeyIdp>(passkeyIdp),
          ],
        );
      });

      group('when the auth users are merged,', () {
        setUp(() async {
          await session.db.transaction((final transaction) async {
            await accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });
        });

        test('then the AppleAccount is moved to userToKeep.', () async {
          final movedAccount = await AppleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('apple_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the GoogleAccount is moved to userToKeep.', () async {
          final movedAccount = await GoogleAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('google_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the EmailAccount is moved to userToKeep.', () async {
          final movedAccount = await EmailAccount.db.findFirstRow(
            session,
            where: (final t) => t.email.equals('test-merge@example.com'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the FirebaseAccount is moved to userToKeep.', () async {
          final movedAccount = await FirebaseAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('firebase_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the GitHubAccount is moved to userToKeep.', () async {
          final movedAccount = await GitHubAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('github_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the FacebookAccount is moved to userToKeep.', () async {
          final movedAccount = await FacebookAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('facebook_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the MicrosoftAccount is moved to userToKeep.', () async {
          final movedAccount = await MicrosoftAccount.db.findFirstRow(
            session,
            where: (final t) => t.userIdentifier.equals('microsoft_123'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test('then the PasskeyAccount is moved to userToKeep.', () async {
          final movedAccount = await PasskeyAccount.db.findFirstRow(
            session,
            where: (final t) => t.keyIdBase64.equals('base64'),
          );

          expect(movedAccount?.authUserId, userToKeep.id);
        });

        test(
          'then the AnonymousAccount is removed with the discarded auth user.',
          () async {
            expect(await AnonymousAccount.db.find(session), isEmpty);
          },
        );
      });
    },
  );
}

/// Application merge handler which leaves the merged users untouched, so that
/// only the identity provider merge hooks affect the outcome of a merge.
void _noOpApplicationMergeHandler(
  final Session session, {
  required final UuidValue userToKeepId,
  required final UuidValue userToRemoveId,
  required final Transaction transaction,
}) {}
