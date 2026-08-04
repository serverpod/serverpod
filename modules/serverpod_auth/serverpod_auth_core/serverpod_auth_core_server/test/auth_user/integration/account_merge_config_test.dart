import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();

  withServerpod(
    'Given userToKeep does not exist,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToRemove = await authUsers.create(session);
      });

      test(
        'when the default core data merge handler is called, '
        'then it throws AuthUserNotFoundException.',
        () async {
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
    },
  );

  withServerpod(
    'Given userToRemove does not exist,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
      });

      test(
        'when the default core data merge handler is called, '
        'then it throws AuthUserNotFoundException.',
        () async {
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
    },
  );

  withServerpod(
    'Given both users exist with different scopes,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();

        userToKeep = await authUsers.create(
          session,
          scopes: {Scope.admin},
        );

        userToRemove = await authUsers.create(
          session,
          scopes: {const Scope('test')},
        );
      });

      test(
        'when the default core data merge handler is called, '
        'then scopes are merged into userToKeep.',
        () async {
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
    },
  );

  withServerpod(
    'Given userToRemove is blocked,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session, blocked: true);
      });

      test(
        'when the default core data merge handler is called, '
        'then userToKeep becomes blocked.',
        () async {
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
          expect(updatedUserToKeep?.blocked, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given userToKeep is blocked and userToRemove is not blocked,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session, blocked: true);
        userToRemove = await authUsers.create(session);
      });

      test(
        'when the default core data merge handler is called, '
        'then userToKeep remains blocked.',
        () async {
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
          expect(updatedUserToKeep?.blocked, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given userToRemove has refresh tokens,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

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
      });

      test(
        'when the default core data merge handler is called, '
        'then refresh tokens are moved to userToKeep.',
        () async {
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
    },
  );

  withServerpod(
    'Given userToRemove has server side sessions,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await ServerSideSession.db.insertRow(
          session,
          ServerSideSession(
            authUserId: userToRemove.id,
            scopeNames: {},
            sessionKeyHash: ByteData(16),
            sessionKeySalt: ByteData(16),
            method: 'test',
          ),
        );
      });

      test(
        'when the default core data merge handler is called, '
        'then server side sessions are moved to userToKeep.',
        () async {
          await session.db.transaction(
            (final transaction) async =>
                AccountMergeConfig.defaultCoreDataMergeHandler(
                  session,
                  userToKeepId: userToKeep.id,
                  userToRemoveId: userToRemove.id,
                  transaction: transaction,
                ),
          );

          final serverSideSession = await ServerSideSession.db.findFirstRow(
            session,
          );
          expect(serverSideSession?.authUserId, userToKeep.id);
        },
      );
    },
  );

  withServerpod(
    'Given userToRemove has a profile and userToKeep does not,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        await UserProfile.db.insertRow(
          session,
          UserProfile(authUserId: userToRemove.id, fullName: 'Remove Name'),
        );
      });

      test(
        'when the default core data merge handler is called, '
        'then the profile is moved to userToKeep.',
        () async {
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
    },
  );

  withServerpod(
    'Given both users have profiles,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

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
      });

      test(
        'when the default core data merge handler is called, '
        'then fields are merged into userToKeep profile.',
        () async {
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

  withServerpod(
    'Given only the userToRemove profile has an image,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthUserModel userToKeep;
      late AuthUserModel userToRemove;
      late UserProfile keepProfile;
      late UserProfile removeProfile;
      late UserProfileImage sourceImage;

      setUp(() async {
        session = sessionBuilder.build();
        userToKeep = await authUsers.create(session);
        userToRemove = await authUsers.create(session);

        keepProfile = await UserProfile.db.insertRow(
          session,
          UserProfile(authUserId: userToKeep.id),
        );

        removeProfile = await UserProfile.db.insertRow(
          session,
          UserProfile(authUserId: userToRemove.id),
        );

        sourceImage = await UserProfileImage.db.insertRow(
          session,
          UserProfileImage(
            userProfileId: removeProfile.id!,
            storageId: 'public',
            path: 'source-image.png',
            url: Uri.parse('https://example.com/source-image.png'),
          ),
        );

        await UserProfile.db.updateRow(
          session,
          removeProfile.copyWith(imageId: sourceImage.id),
          columns: (final t) => [t.imageId],
        );
      });

      test(
        'when the default core data merge handler and cleanup handler are called, '
        'then the image is moved to the userToKeep profile and survives cleanup.',
        () async {
          await session.db.transaction((final transaction) async {
            await AccountMergeConfig.defaultCoreDataMergeHandler(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
            await AccountMergeConfig.defaultMergeCleanupHandler(
              session,
              userToKeepId: userToKeep.id,
              userToRemoveId: userToRemove.id,
              transaction: transaction,
            );
          });

          final mergedProfile = await UserProfile.db.findById(
            session,
            keepProfile.id!,
          );
          final movedImage = await UserProfileImage.db.findById(
            session,
            sourceImage.id!,
          );
          expect(mergedProfile?.imageId, sourceImage.id);
          expect(movedImage?.userProfileId, keepProfile.id);
          expect(
            await AuthUser.db.findById(session, userToRemove.id),
            isNull,
          );
        },
      );
    },
  );
}
