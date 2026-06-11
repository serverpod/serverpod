import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given defaultCoreDataMergeHandler is called,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      const authUsers = AuthUsers();

      setUp(() async {
        session = sessionBuilder.build();
      });

      test(
        'when userToKeep does not exist, then it throws '
        'AuthUserNotFoundException.',
        () async {
          final userToRemove = await authUsers.create(session);

          await expectLater(
            () => session.db.transaction(
              (final transaction) async =>
                  AccountMergeConfig.defaultCoreDataMergeHandler(
                    session,
                    userToKeepId: const Uuid().v4obj(),
                    userToRemoveId: userToRemove.id,
                    transaction: transaction,
                  ),
            ),
            throwsA(isA<AuthUserNotFoundException>()),
          );
        },
      );

      test(
        'when userToRemove does not exist, then it throws '
        'AuthUserNotFoundException.',
        () async {
          final userToKeep = await authUsers.create(session);

          await expectLater(
            () => session.db.transaction(
              (final transaction) async =>
                  AccountMergeConfig.defaultCoreDataMergeHandler(
                    session,
                    userToKeepId: userToKeep.id,
                    userToRemoveId: const Uuid().v4obj(),
                    transaction: transaction,
                  ),
            ),
            throwsA(isA<AuthUserNotFoundException>()),
          );
        },
      );

      test(
        'when both users exist, then scopes are merged effectively.',
        () async {
          final userToKeep = await authUsers.create(
            session,
            scopes: {Scope.admin},
          );
          final userToRemove = await authUsers.create(
            session,
            scopes: {const Scope('test')},
          );

          await session.db.transaction(
            (final transaction) async =>
                AccountMergeConfig.defaultCoreDataMergeHandler(
                  session,
                  userToKeepId: userToKeep.id,
                  userToRemoveId: userToRemove.id,
                  transaction: transaction,
                ),
          );

          final updatedUserToKeep = await AuthUser.db.findById(
            session,
            userToKeep.id,
          );
          expect(
            updatedUserToKeep!.scopeNames,
            containsAll([Scope.admin.name!, 'test']),
          );
        },
      );

      test(
        'when userToRemove has refresh tokens, then they are moved to userToKeep.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

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

          await session.db.transaction(
            (final transaction) async =>
                AccountMergeConfig.defaultCoreDataMergeHandler(
                  session,
                  userToKeepId: userToKeep.id,
                  userToRemoveId: userToRemove.id,
                  transaction: transaction,
                ),
          );

          final refreshToken = await RefreshToken.db.findFirstRow(session);
          expect(refreshToken?.authUserId, userToKeep.id);
        },
      );

      test(
        'when userToRemove has a profile and userToKeep does not, then the profile is moved to userToKeep.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          await UserProfile.db.insertRow(
            session,
            UserProfile(authUserId: userToRemove.id, fullName: 'Remove Name'),
          );

          await session.db.transaction(
            (final transaction) async =>
                AccountMergeConfig.defaultCoreDataMergeHandler(
                  session,
                  userToKeepId: userToKeep.id,
                  userToRemoveId: userToRemove.id,
                  transaction: transaction,
                ),
          );

          final profiles = await UserProfile.db.find(session);
          expect(profiles, hasLength(1));
          expect(profiles.first.authUserId, userToKeep.id);
          expect(profiles.first.fullName, 'Remove Name');
        },
      );

      test(
        'when both users have profiles, then fields are merged into userToKeep profile.',
        () async {
          final userToKeep = await authUsers.create(session);
          final userToRemove = await authUsers.create(session);

          await UserProfile.db.insertRow(
            session,
            UserProfile(
              authUserId: userToKeep.id,
              fullName: 'Keep Name',
            ),
          );

          await UserProfile.db.insertRow(
            session,
            UserProfile(
              authUserId: userToRemove.id,
              fullName: 'Remove Name', // Should NOT overwrite 'Keep Name'
              userName: 'remove_user', // Should merge
              email: 'remove@example.com', // Should merge
            ),
          );

          await session.db.transaction(
            (final transaction) async =>
                AccountMergeConfig.defaultCoreDataMergeHandler(
                  session,
                  userToKeepId: userToKeep.id,
                  userToRemoveId: userToRemove.id,
                  transaction: transaction,
                ),
          );

          final keepProfile = await UserProfile.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToKeep.id),
          );

          expect(keepProfile, isNotNull);
          expect(keepProfile!.fullName, 'Keep Name');
          expect(keepProfile.userName, 'remove_user');
          expect(keepProfile.email, 'remove@example.com');

          // Original profile should remain for UserToRemove initially until cleanup
          final removeProfile = await UserProfile.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(userToRemove.id),
          );
          expect(removeProfile, isNotNull);
        },
      );
    },
  );
}
