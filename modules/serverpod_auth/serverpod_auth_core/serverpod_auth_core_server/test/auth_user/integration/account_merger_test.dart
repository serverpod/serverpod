import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../common/business/fakes/fakes.dart';
import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();

  setUp(() {
    AuthServices.set(
      tokenManagerBuilders: [
        FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
      ],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given an account merger with the default merge hooks and an application merge handler that captures the merged user ids, and two auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;
      UuidValue? capturedUserToKeepId;
      UuidValue? capturedUserToRemoveId;

      setUp(() async {
        session = sessionBuilder.build();
        capturedUserToKeepId = null;
        capturedUserToRemoveId = null;

        accountMerger = AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler:
                (
                  final session, {
                  required final userToKeepId,
                  required final userToRemoveId,
                  required final transaction,
                }) {
                  capturedUserToKeepId = userToKeepId;
                  capturedUserToRemoveId = userToRemoveId;
                },
          ),
        );

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);
      });

      group('when the accounts are merged,', () {
        setUp(() async {
          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );
        });

        test('then the application merge handler receives both user ids.', () {
          expect(capturedUserToKeepId, userToKeep.id);
          expect(capturedUserToRemoveId, userToRemove.id);
        });

        test('then the user to remove is deleted.', () async {
          expect(await AuthUser.db.findById(session, userToRemove.id), isNull);
        });
      });
    },
  );

  withServerpod(
    'Given an account merger with custom merge hooks that capture the merged user ids and replace the cleanup handler with one that keeps the user to remove, and two auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;
      UuidValue? capturedUserToKeepId;
      UuidValue? capturedUserToRemoveId;
      var cleanUpInvoked = false;

      setUp(() async {
        session = sessionBuilder.build();
        capturedUserToKeepId = null;
        capturedUserToRemoveId = null;
        cleanUpInvoked = false;

        accountMerger = AccountMerger(
          config: AccountMergeConfig.custom(
            mergeHooks: [
              AccountMergeConfig.defaultIdpMergeHandler,
              AccountMergeConfig.defaultCoreDataMergeHandler,
              (
                final session, {
                required final userToKeepId,
                required final userToRemoveId,
                required final transaction,
              }) {
                capturedUserToKeepId = userToKeepId;
                capturedUserToRemoveId = userToRemoveId;
              },
              (
                final session, {
                required final userToKeepId,
                required final userToRemoveId,
                required final transaction,
              }) {
                cleanUpInvoked = true;
              },
            ],
          ),
        );

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);
      });

      group('when the accounts are merged,', () {
        setUp(() async {
          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );
        });

        test('then the capturing merge hook receives both user ids.', () {
          expect(capturedUserToKeepId, userToKeep.id);
          expect(capturedUserToRemoveId, userToRemove.id);
        });

        test('then the custom cleanup handler is invoked.', () {
          expect(cleanUpInvoked, isTrue);
        });

        test('then the user to remove is not deleted.', () async {
          expect(
            await AuthUser.db.findById(session, userToRemove.id),
            isNotNull,
          );
        });
      });
    },
  );

  withServerpod(
    'Given an account merger with a no-op application merge handler, a user to keep with the admin scope, and a user to remove with the test scope that owns a refresh token and a profile,',
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

        userToKeep = await authUsers.create(session, scopes: {Scope.admin});
        userToRemove = await authUsers.create(
          session,
          scopes: {const Scope('test')},
        );

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

        await UserProfile.db.insertRow(
          session,
          UserProfile(authUserId: userToRemove.id),
        );
      });

      group('when the accounts are merged,', () {
        setUp(() async {
          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );
        });

        test('then the scopes are merged into the user to keep.', () async {
          final updatedUserToKeep = await AuthUser.db.findById(
            session,
            userToKeep.id,
          );

          expect(
            updatedUserToKeep!.scopeNames,
            containsAll([Scope.admin.name!, 'test']),
          );
        });

        test('then the refresh token is moved to the user to keep.', () async {
          final refreshToken = await RefreshToken.db.findFirstRow(session);

          expect(refreshToken?.authUserId, userToKeep.id);
        });

        test('then the profile is moved to the user to keep.', () async {
          final profile = await UserProfile.db.findFirstRow(session);

          expect(profile?.authUserId, userToKeep.id);
        });
      });
    },
  );

  withServerpod(
    'Given an account merger with a no-op application merge handler and two auth users with a profile each, where only the user to remove has a user name and an email,',
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

        userToKeep = await authUsers.create(session, scopes: {Scope.admin});
        await UserProfile.db.insertRow(
          session,
          UserProfile(
            authUserId: userToKeep.id,
            fullName: 'Keep Name',
          ),
        );

        userToRemove = await authUsers.create(
          session,
          scopes: {const Scope('test')},
        );
        await UserProfile.db.insertRow(
          session,
          UserProfile(
            authUserId: userToRemove.id,
            fullName: 'Remove Name',
            userName: 'remove_user',
            email: 'remove@example.com',
          ),
        );
      });

      group('when the accounts are merged,', () {
        setUp(() async {
          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );
        });

        test(
          'then the full name of the user to keep is not overwritten.',
          () async {
            final profile = await UserProfile.db.findFirstRow(
              session,
              where: (final t) => t.authUserId.equals(userToKeep.id),
            );

            expect(profile?.fullName, 'Keep Name');
          },
        );

        test(
          'then the user name and email are filled from the user to remove.',
          () async {
            final profile = await UserProfile.db.findFirstRow(
              session,
              where: (final t) => t.authUserId.equals(userToKeep.id),
            );

            expect(profile, isNotNull);
            expect(profile!.userName, 'remove_user');
            expect(profile.email, 'remove@example.com');
          },
        );
      });
    },
  );

  withServerpod(
    'Given an account merger with custom merge hooks that run two application hooks before the default cleanup handler, and two auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;
      UuidValue? firstHookUserToKeepId;
      UuidValue? firstHookUserToRemoveId;
      UuidValue? secondHookUserToKeepId;
      UuidValue? secondHookUserToRemoveId;

      setUp(() async {
        session = sessionBuilder.build();
        firstHookUserToKeepId = null;
        firstHookUserToRemoveId = null;
        secondHookUserToKeepId = null;
        secondHookUserToRemoveId = null;

        accountMerger = AccountMerger(
          config: AccountMergeConfig.custom(
            mergeHooks: [
              AccountMergeConfig.defaultIdpMergeHandler,
              AccountMergeConfig.defaultCoreDataMergeHandler,
              (
                final session, {
                required final userToKeepId,
                required final userToRemoveId,
                required final transaction,
              }) async {
                firstHookUserToKeepId = userToKeepId;
                firstHookUserToRemoveId = userToRemoveId;
              },
              (
                final session, {
                required final userToKeepId,
                required final userToRemoveId,
                required final transaction,
              }) {
                secondHookUserToKeepId = userToKeepId;
                secondHookUserToRemoveId = userToRemoveId;
              },
              AccountMergeConfig.defaultMergeCleanupHandler,
            ],
          ),
        );

        userToKeep = await authUsers.create(session, scopes: {Scope.admin});
        userToRemove = await authUsers.create(
          session,
          scopes: {const Scope('test')},
        );
      });

      group('when the accounts are merged,', () {
        setUp(() async {
          await accountMerger.merge(
            session,
            userToKeepId: userToKeep.id,
            userToRemoveId: userToRemove.id,
          );
        });

        test('then the first application hook receives both user ids.', () {
          expect(firstHookUserToKeepId, userToKeep.id);
          expect(firstHookUserToRemoveId, userToRemove.id);
        });

        test('then the second application hook receives both user ids.', () {
          expect(secondHookUserToKeepId, userToKeep.id);
          expect(secondHookUserToRemoveId, userToRemove.id);
        });
      });
    },
  );

  withServerpod(
    'Given an account merger with a no-op application merge handler and a user to keep that does not exist,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        accountMerger = const AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler: _noOpApplicationMergeHandler,
          ),
        );

        userToRemove = await authUsers.create(session);
      });

      test(
        'when the accounts are merged, '
        'then it throws AuthUserNotFoundException.',
        () async {
          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: const Uuid().v4obj(),
              userToRemoveId: userToRemove.id,
            ),
            throwsA(isA<AuthUserNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an account merger with a no-op application merge handler and a user to remove that does not exist,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;

      setUp(() async {
        session = sessionBuilder.build();
        accountMerger = const AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler: _noOpApplicationMergeHandler,
          ),
        );

        userToKeep = await authUsers.create(session);
      });

      test(
        'when the accounts are merged, '
        'then it throws AuthUserNotFoundException.',
        () async {
          await expectLater(
            () => accountMerger.merge(
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
    'Given an account merger with a no-op application merge handler and a single auth user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel authUser;

      setUp(() async {
        session = sessionBuilder.build();
        accountMerger = const AccountMerger(
          config: AccountMergeConfig(
            applicationMergeHandler: _noOpApplicationMergeHandler,
          ),
        );

        authUser = await authUsers.create(session);
      });

      test(
        'when merging the user with itself, '
        'then it throws an ArgumentError for the user to remove.',
        () async {
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
        },
      );

      test(
        'when merging the user with itself, '
        'then the user is not deleted.',
        () async {
          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: authUser.id,
              userToRemoveId: authUser.id,
            ),
            throwsA(isA<ArgumentError>()),
          );

          expect(await AuthUser.db.findById(session, authUser.id), isNotNull);
        },
      );
    },
  );

  withServerpod(
    'Given an account merger with the default application merge handler and two auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        accountMerger = const AccountMerger(config: AccountMergeConfig());

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);
      });

      test(
        'when the accounts are merged, '
        'then it throws an exception.',
        () async {
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
    'Given two registered identity providers where the first one blocks the user to remove and the second one fails, and two auth users,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        AuthServices.set(
          tokenManagerBuilders: [
            FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
          ],
          identityProviderBuilders: [
            PreBuiltIdpBuilder(_BlockingMergeIdentityProvider()),
            PreBuiltIdpBuilder(_ThrowingMergeIdentityProvider()),
          ],
          accountMergeConfig: const AccountMergeConfig(
            applicationMergeHandler: _noOpApplicationMergeHandler,
          ),
        );
        accountMerger = AuthServices.instance.accountMerger;

        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);
      });

      test(
        'when the accounts are merged, '
        'then it throws the StateError raised by the failing identity provider.',
        () async {
          await expectLater(
            () => accountMerger.merge(
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
        },
      );

      test(
        'when the accounts are merged, '
        'then the mutation of the first identity provider is rolled back.',
        () async {
          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
            ),
            throwsA(isA<StateError>()),
          );

          final unchangedUserToRemove = await AuthUser.db.findById(
            session,
            userToRemove.id,
          );
          expect(unchangedUserToRemove?.blocked, isFalse);
        },
      );

      test(
        'when the accounts are merged, '
        'then both users remain.',
        () async {
          await expectLater(
            () => accountMerger.merge(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
            ),
            throwsA(isA<StateError>()),
          );

          expect(await AuthUser.db.findById(session, userToKeep.id), isNotNull);
          expect(
            await AuthUser.db.findById(session, userToRemove.id),
            isNotNull,
          );
        },
      );
    },
  );

  withServerpod(
    'Given an account merger whose application merge handler fails after core migration, a user to keep with the admin scope, and a user to remove with the source scope that owns a refresh token,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AccountMerger accountMerger;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;
      late RefreshToken refreshToken;

      setUp(() async {
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

        userToKeep = await authUsers.create(session, scopes: {Scope.admin});
        userToRemove = await authUsers.create(
          session,
          scopes: {const Scope('source')},
        );
        refreshToken = await RefreshToken.db.insertRow(
          session,
          RefreshToken(
            authUserId: userToRemove.id,
            scopeNames: {},
            method: 'test',
            fixedSecret: ByteData(16),
            rotatingSecretHash: 'hash',
          ),
        );
      });

      test(
        'when merging within an existing transaction, '
        'then the core migration is rolled back to its savepoint.',
        () async {
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

/// Application merge handler which leaves the merged users untouched, so that
/// only the default merge hooks affect the outcome of a merge.
void _noOpApplicationMergeHandler(
  final Session session, {
  required final UuidValue userToKeepId,
  required final UuidValue userToRemoveId,
  required final Transaction transaction,
}) {}

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
