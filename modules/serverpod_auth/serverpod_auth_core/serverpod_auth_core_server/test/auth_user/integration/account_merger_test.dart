import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../common/business/fakes/fakes.dart';
import '../../serverpod_test_tools.dart';

void main() {
  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
      ],
      identityProviderBuilders: [],
    );
  });

  const authUsers = AuthUsers();

  withServerpod(
    'Given an account merger with an application hook that captures the merged users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUsers authUsers;
      late AccountMerger defaultAccountMerger;
      late UuidValue? userIdToKeepFromCallback;
      late UuidValue? userIdToRemoveFromCallback;

      setUp(() async {
        session = sessionBuilder.build();
        authUsers = const AuthUsers();
        userIdToKeepFromCallback = null;
        userIdToRemoveFromCallback = null;

        defaultAccountMerger = AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler:
                (
                  final session, {
                  required final UuidValue userToKeepId,
                  required final UuidValue userToRemoveId,
                  required final transaction,
                }) {
                  userIdToKeepFromCallback = userToKeepId;
                  userIdToRemoveFromCallback = userToRemoveId;
                },
          ),
        );
      });

      test(
        'when merging with the default cleanup handler, '
        'then the application hook is invoked and userToRemove is deleted.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          await defaultAccountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );

          expect(userIdToKeepFromCallback, userToKeep.id);
          expect(userIdToRemoveFromCallback, userToRemove.id);

          // Verify userToRemove IS deleted
          final retainedUser = await AuthUser.db.findById(
            session,
            userToRemove.id,
          );
          expect(retainedUser, isNull);
        },
      );

      test(
        'when merging with a custom non-deleting cleanup handler, '
        'then the application hook is invoked and userToRemove remains.',
        () async {
          bool cleanUpCalled = false;
          final accountMerger = AccountMerger(
            config: AccountMergeConfig.custom(
              mergeHooks: [
                AccountMergeConfig.defaultIdpMergeHandler,
                AccountMergeConfig.defaultCoreDataMergeHandler,
                (
                  final session, {
                  required final UuidValue userToKeepId,
                  required final UuidValue userToRemoveId,
                  required final transaction,
                }) {
                  userIdToKeepFromCallback = userToKeepId;
                  userIdToRemoveFromCallback = userToRemoveId;
                },
                (
                  final session, {
                  required final UuidValue userToKeepId,
                  required final UuidValue userToRemoveId,
                  required final transaction,
                }) {
                  cleanUpCalled = true;
                },
              ],
            ),
          );

          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );

          expect(userIdToKeepFromCallback, userToKeep.id);
          expect(userIdToRemoveFromCallback, userToRemove.id);
          expect(cleanUpCalled, isTrue);

          // Verify userToRemove is NOT deleted
          final retainedUser = await AuthUser.db.findById(
            session,
            userToRemove.id,
          );
          expect(retainedUser, isNotNull);
        },
      );

      test(
        'when merging with the default core data merge handler, then scopes '
        'are merged and core data is moved.',
        () async {
          // Setup User to Keep (Scope A)
          final userToKeep = await authUsers.create(
            session,
            scopes: {Scope.admin},
          );

          // Setup User to Remove (Scope B)
          final userToRemove = await authUsers.create(
            session,
            scopes: {const Scope('test')},
          );
          // Add core data for userToRemove
          // 1. Refresh Token
          await RefreshToken.db.insertRow(
            session,
            RefreshToken(
              authUserId: userToRemove.id,
              scopeNames: {},
              method: 'test',
              fixedSecret: ByteData(16),
              rotatingSecretHash: 'hash',
            ),
          );
          // 2. User Profile
          await UserProfile.db.insertRow(
            session,
            UserProfile(authUserId: userToRemove.id),
          );

          await defaultAccountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );

          // Verify Scopes Merged
          final updatedUserToKeep = await AuthUser.db.findById(
            session,
            userToKeep.id,
          );
          expect(
            updatedUserToKeep!.scopeNames,
            containsAll([Scope.admin.name!, 'test']),
          );

          // Verify Refresh Token Moved
          final refreshToken = await RefreshToken.db.findFirstRow(session);
          expect(refreshToken?.authUserId, userToKeep.id);

          // Verify User Profile Moved
          final profile = await UserProfile.db.findFirstRow(session);
          expect(profile?.authUserId, userToKeep.id);
        },
      );

      test(
        'when merging users that both have profiles, '
        'then missing userToKeep profile fields are filled from userToRemove.',
        () async {
          // Setup User to Keep await (Has Profile with only fullName)
          final userToKeep = await authUsers.create(
            session,
            scopes: {Scope.admin},
          );
          await UserProfile.db.insertRow(
            session,
            UserProfile(
              authUserId: userToKeep.id,
              fullName: 'Keep Name',
              // userName and email are null
            ),
          );

          // Setup User to Remove (Has Profile with userName and email)
          final userToRemove = await authUsers.create(
            session,
            scopes: {const Scope('test')},
          );
          await UserProfile.db.insertRow(
            session,
            UserProfile(
              authUserId: userToRemove.id,
              fullName: 'Remove Name', // Should NOT overwrite 'Keep Name'
              userName: 'remove_user', // Should fill null
              email: 'remove@example.com', // Should fill null
            ),
          );

          await defaultAccountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );

          // Verify User Profile Merged
          final profile = await UserProfile.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );
          expect(profile, isNotNull);
          expect(profile!.fullName, 'Keep Name'); // Original kept
          expect(profile.userName, 'remove_user'); // Merged
          expect(profile.email, 'remove@example.com'); // Merged
        },
      );
      test(
        'when merging with custom merge hooks, '
        'then the custom hooks receive both users.',
        () async {
          // Setup User to Keep
          final userToKeep = await authUsers.create(
            session,
            scopes: {Scope.admin},
          );
          // Setup User to Remove
          final userToRemove = await authUsers.create(
            session,
            scopes: {const Scope('test')},
          );

          var handlerInvoked = false;
          AuthUserModel? handlerUserToKeep;
          AuthUserModel? handlerUserToRemove;

          final accountMerger = AccountMerger(
            config: AccountMergeConfig.custom(
              mergeHooks: [
                AccountMergeConfig.defaultIdpMergeHandler,
                AccountMergeConfig.defaultCoreDataMergeHandler,
                (
                  final session, {
                  required final UuidValue userToKeepId,
                  required final UuidValue userToRemoveId,
                  required final transaction,
                }) async {
                  handlerInvoked = true;
                  handlerUserToKeep = userToKeep;
                  handlerUserToRemove = userToRemove;
                },
                (
                  final session, {
                  required final UuidValue userToKeepId,
                  required final UuidValue userToRemoveId,
                  required final transaction,
                }) {
                  userIdToKeepFromCallback = userToKeepId;
                  userIdToRemoveFromCallback = userToRemoveId;
                },
                AccountMergeConfig.defaultMergeCleanupHandler,
              ],
            ),
          );

          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );

          expect(handlerInvoked, isTrue);
          expect(handlerUserToKeep?.id, userToKeep.id);
          expect(handlerUserToRemove?.id, userToRemove.id);
        },
      );

      test(
        'when merging with a non-existent userToKeep, then it throws AuthUserNotFoundException.',
        () async {
          final userToRemove = await authUsers.create(session);

          await expectLater(
            () => defaultAccountMerger.merge(
              session,
              userToKeepId: const Uuid().v4obj(),
              userToRemoveId: userToRemove.id,
            ),
            throwsA(isA<AuthUserNotFoundException>()),
          );
        },
      );

      test(
        'when merging with a non-existent userToRemove, then it throws AuthUserNotFoundException.',
        () async {
          final userToKeep = await authUsers.create(session);

          await expectLater(
            () => defaultAccountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: const Uuid().v4obj(),
            ),
            throwsA(isA<AuthUserNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a single auth user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel authUser;

      setUp(() async {
        session = sessionBuilder.build();
        authUser = await authUsers.create(session);
      });

      test(
        'when attempting to merge the user with itself, '
        'then the merge is rejected without deleting the user.',
        () async {
          final accountMerger = AccountMerger(
            config: AccountMergeConfig(
              applicationMergeHandler:
                  (
                    final session, {
                    required final userToKeepId,
                    required final userToRemoveId,
                    required final transaction,
                  }) {},
            ),
          );

          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: authUser.id,
              userToRemoveId: authUser.id,
            ),
            throwsA(
              isA<ArgumentError>()
                  .having(
                    (final error) => error.name,
                    'name',
                    'userToRemoveId',
                  )
                  .having(
                    (final error) => error.message,
                    'message',
                    'The user to remove must be different from the user to keep.',
                  ),
            ),
          );
          expect(await AuthUser.db.findById(session, authUser.id), isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given the default application data merge hook,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      const authUsers = AuthUsers();

      setUp(() async {
        session = sessionBuilder.build();
      });

      test(
        'when merging two auth users, then it throws.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          const accountMerger = AccountMerger(
            config: AccountMergeConfig(),
          );

          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given two registered identity providers where the second fails after the first mutates data,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() {
        session = sessionBuilder.build();
        AuthServices.set(
          tokenManagerBuilders: [
            FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
          ],
          identityProviderBuilders: [
            PreBuiltIdpBuilder(_BlockingMergeIdentityProvider()),
            PreBuiltIdpBuilder(_ThrowingMergeIdentityProvider()),
          ],
          accountMergeConfig: AccountMergeConfig(
            applicationMergeHandler:
                (
                  final session, {
                  required final userToKeepId,
                  required final userToRemoveId,
                  required final transaction,
                }) {},
          ),
        );
      });

      test(
        'when merging the users, '
        'then every provider mutation is rolled back and both users remain.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          await expectLater(
            () => AuthServices.instance.accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
            ),
            throwsA(
              isA<StateError>().having(
                (final error) => error.message,
                'message',
                'Identity provider merge failed.',
              ),
            ),
          );

          final unchangedUserToRemove = await AuthUser.db.findById(
            session,
            userToRemove.id,
          );
          expect(unchangedUserToRemove?.blocked, isFalse);
          expect(await AuthUser.db.findById(session, userToKeep.id), isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given an account merger whose application handler fails after core migration,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;

      setUp(() {
        session = sessionBuilder.build();
        AuthServices.set(
          tokenManagerBuilders: [
            FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
          ],
          accountMergeConfig: AccountMergeConfig(
            applicationMergeHandler:
                (
                  final session, {
                  required final userToKeepId,
                  required final userToRemoveId,
                  required final transaction,
                }) => throw StateError('Application merge failed.'),
          ),
        );
        accountMerger = AuthServices.instance.accountMerger;
      });

      test(
        'when merging within an existing transaction, '
        'then the core migration is rolled back to its savepoint.',
        () async {
          final userToKeep = await authUsers.create(
            session,
            scopes: {Scope.admin},
          );
          final userToRemove = await authUsers.create(
            session,
            scopes: {const Scope('source')},
          );
          final refreshToken = await RefreshToken.db.insertRow(
            session,
            RefreshToken(
              authUserId: userToRemove.id,
              scopeNames: {},
              method: 'test',
              fixedSecret: ByteData(16),
              rotatingSecretHash: 'hash',
            ),
          );

          await session.db.transaction((final transaction) async {
            await expectLater(
              () => accountMerger.merge(
                session,
                userToKeepId: userToKeep.id,
                userToRemoveId: userToRemove.id,
                transaction: transaction,
              ),
              throwsA(
                isA<StateError>().having(
                  (final error) => error.message,
                  'message',
                  'Application merge failed.',
                ),
              ),
            );

            final unchangedUserToKeep = await AuthUser.db.findById(
              session,
              userToKeep.id,
              transaction: transaction,
            );
            final unchangedRefreshToken = await RefreshToken.db.findById(
              session,
              refreshToken.id!,
              transaction: transaction,
            );
            expect(unchangedUserToKeep?.scopeNames, {Scope.admin.name!});
            expect(unchangedRefreshToken?.authUserId, userToRemove.id);
            expect(
              await AuthUser.db.findById(
                session,
                userToRemove.id,
                transaction: transaction,
              ),
              isNotNull,
            );
          });
        },
      );
    },
  );
}

class _BlockingMergeIdentityProvider implements IdentityProvider {
  @override
  String get method => 'blocking-merge-test';

  @override
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    await AuthUser.db.updateWhere(
      session,
      where: (final t) => t.id.equals(userToRemoveId),
      columnValues: (final t) => [t.blocked(true)],
      transaction: transaction,
    );
  }
}

class _ThrowingMergeIdentityProvider implements IdentityProvider {
  @override
  String get method => 'throwing-merge-test';

  @override
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {
    throw StateError('Identity provider merge failed.');
  }
}
