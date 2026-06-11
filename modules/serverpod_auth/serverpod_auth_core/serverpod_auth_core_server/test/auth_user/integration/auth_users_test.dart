import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();

  withServerpod('Given an auth user created without parameters,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late AuthUserModel authUser;

    setUp(() async {
      session = sessionBuilder.build();

      authUser = await authUsers.create(session);
    });

    test('when inspecting it, then the scopes are empty.', () {
      expect(authUser.scopeNames, isEmpty);
    });

    test('when inspecting it, then it is not blocked.', () {
      expect(authUser.blocked, isFalse);
    });

    test(
      'when updating it, then the returned model contains the new value.',
      () async {
        final updatedAuthUser = await authUsers.update(
          session,
          authUserId: authUser.id,
          scopes: {Scope.admin},
          blocked: true,
        );

        expect(updatedAuthUser.scopes, {Scope.admin});
        expect(updatedAuthUser.blocked, isTrue);
      },
    );

    test('when deleting it, then it is removed from the database.', () async {
      await authUsers.delete(session, authUserId: authUser.id);

      expect(await AuthUser.db.find(session), isEmpty);
    });

    test('when listing auth users, then it is returned.', () async {
      final listedAuthUsers = await authUsers.list(session);

      expect(listedAuthUsers.single.id, authUser.id);
    });
  });

  withServerpod('Given no auth users,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
    });

    test(
      'when trying to get a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.get(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );

    test(
      'when trying to update a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.update(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );

    test(
      'when trying to delete a non-existent auth user by ID, then it throws.',
      () async {
        await expectLater(
          () => authUsers.delete(session, authUserId: const Uuid().v4obj()),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      },
    );
  });

  withServerpod(
    'Given an auth user creation hook that adds admin scope and blocked,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUsers authUsers;

      setUp(() async {
        session = sessionBuilder.build();

        authUsers = AuthUsers(
          config: AuthUsersConfig(
            onBeforeAuthUserCreated:
                (
                  final session,
                  final scopes,
                  final blocked, {
                  required final transaction,
                }) => (scopes: {...scopes, Scope.admin}, blocked: true),
          ),
        );
      });

      test(
        'when creating an auth user with empty scopes, then the created auth user has admin scope and is blocked.',
        () async {
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {},
            blocked: false,
          );

          expect(createdAuthUser.scopes, {Scope.admin});
          expect(createdAuthUser.blocked, isTrue);
        },
      );

      test(
        'when creating an auth user with a custom scope, then the created auth user has the custom scope and is blocked.',
        () async {
          const customScope = Scope('test');
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {customScope},
            blocked: false,
          );

          expect(createdAuthUser.scopes, {customScope, Scope.admin});
          expect(createdAuthUser.blocked, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given an auth user creation hook that captures the created user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUsers authUsers;
      late AuthUserModel? createdAuthUserFromCallback;

      setUp(() async {
        session = sessionBuilder.build();
        createdAuthUserFromCallback = null;

        authUsers = AuthUsers(
          config: AuthUsersConfig(
            onAfterAuthUserCreated:
                (
                  final session,
                  final authUser, {
                  required final transaction,
                }) {
                  createdAuthUserFromCallback = authUser;
                },
          ),
        );
      });

      test(
        'when creating an auth user, then the hook is invoked with the created auth user.',
        () async {
          final createdAuthUser = await authUsers.create(
            session,
            scopes: {Scope.admin},
            blocked: true,
          );

          expect(
            createdAuthUser,
            equals(createdAuthUserFromCallback),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an account merge hook that captures the merged users,',
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
        'and the default cleanup function, then the hook is invoked and '
        'userToRemove is deleted.',
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
        'when merging two auth users with an empty cleanup function, then the '
        'hook is invoked and userToRemove is NOT deleted.',
        () async {
          bool cleanUpCalled = false;
          final accountMerger = AccountMerger(
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
              mergeCleanupHandler:
                  (
                    final session, {
                    required final UuidValue userToKeepId,
                    required final UuidValue userToRemoveId,
                    required final transaction,
                  }) {
                    cleanUpCalled = true;
                  },
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
        'when merging with shouldMergeCoreData=true, then UserProfiles are '
        'merged (fields filled).',
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
        'when merging with mergeHooks, then the hooks are invoked.',
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
              mergeHooks: [
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
}
