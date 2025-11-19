import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();
  withServerpod(
    'Given an existing `AuthUser`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UserProfiles userProfiles;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;
      });

      test(
        'when creating a user profile, then it can be looked up by the auth user ID.',
        () async {
          userProfiles = const UserProfiles();

          await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(userName: 'test_user'),
          );

          final foundUserProfile = await userProfiles
              .maybeFindUserProfileByUserId(
                session,
                authUserId,
              );

          expect(foundUserProfile?.authUserId, authUserId);
          expect(foundUserProfile?.userName, 'test_user');
        },
      );

      test(
        'when creating a new user profile, then `onBeforeUserProfileCreated` can be used to modify it before persisting.',
        () async {
          userProfiles = UserProfiles(
            config: UserProfileConfig(
              onBeforeUserProfileCreated:
                  (
                    final session,
                    final authUserId,
                    final userProfile, {
                    required final transaction,
                  }) => userProfile.copyWith(fullName: 'overwritten full name'),
            ),
          );

          final createdUserProfile = await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(),
          );

          expect(
            createdUserProfile.fullName,
            'overwritten full name',
          );
        },
      );

      test(
        'when creating a new user profile, then `onAfterUserProfileCreated` is invoked with the new profile after it has been written to the database.',
        () async {
          UserProfileModel? createdProfileFromCallback;
          userProfiles = UserProfiles(
            config: UserProfileConfig(
              onAfterUserProfileCreated:
                  (
                    final session,
                    final userProfile, {
                    required final transaction,
                  }) {
                    createdProfileFromCallback = userProfile;
                  },
            ),
          );

          final createdUserProfile = await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(),
          );

          expect(
            createdUserProfile.toJsonForProtocol(),
            equals(createdProfileFromCallback?.toJsonForProtocol()),
          );
        },
      );

      test(
        'when `onBeforeUserProfileCreated` throws during the creation of a new user profile, then the profile is not stored in the database and the error forwarded.',
        () async {
          final userProfiles = UserProfiles(
            config: UserProfileConfig(
              onBeforeUserProfileCreated:
                  (
                    final session,
                    final authUserId,
                    final userProfile, {
                    required final transaction,
                  }) {
                    throw UnimplementedError();
                  },
            ),
          );

          await expectLater(
            () => userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(),
            ),
            throwsA(isA<UnimplementedError>()),
          );

          expect(await UserProfile.db.find(session), isEmpty);
        },
      );

      test(
        'when `onAfterUserProfileCreated` throws during the creation of a new user profile, then the profile is not stored in the database and the error forwarded.',
        () async {
          final userProfiles = UserProfiles(
            config: UserProfileConfig(
              onAfterUserProfileCreated:
                  (
                    final session,
                    final userProfile, {
                    required final transaction,
                  }) {
                    throw UnimplementedError();
                  },
            ),
          );

          await expectLater(
            () => userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(),
            ),
            throwsA(isA<UnimplementedError>()),
          );

          expect(await UserProfile.db.find(session), isEmpty);
        },
      );

      test(
        'when creating a new profile, then the email is stored in lower-case.',
        () async {
          const userProfiles = UserProfiles();
          final createdUserProfile = await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(
              email: 'Test@serverpod.Dev',
            ),
          );

          expect(
            createdUserProfile.email,
            'test@serverpod.dev',
          );
        },
      );

      test(
        "when attempting to read a user's profile before it was created, then a `UserProfileNotFoundException` is thrown.",
        () async {
          await expectLater(
            () => userProfiles.findUserProfileByUserId(session, authUserId),
            throwsA(isA<UserProfileNotFoundException>()),
          );
        },
      );

      group(
        'when creating a user profile with image url, then image is accessible on user.',
        () {
          final userProfiles = UserProfiles(
            config: UserProfileConfig(
              /// Mock image fetch function that returns a 1x1 pixel PNG.
              imageFetchFunc: (final _) => onePixelPng,
            ),
          );
          late UserProfileModel createdProfile;
          setUp(() async {
            createdProfile = await userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(userName: 'test_user'),
              imageSource: UserImageFromUrl.parse(
                'https://serverpod.dev/external-profile-image.png',
              ),
            );
          });

          test('then the returned profile contains the image URL.', () async {
            expect(
              createdProfile.imageUrl.toString(),
              allOf(startsWith('http://localhost'), endsWith('.jpg')),
            );
          });

          test('then image is accessible stored user.', () async {
            final foundUserProfile = await userProfiles.findUserProfileByUserId(
              session,
              authUserId,
            );

            expect(
              foundUserProfile.imageUrl.toString(),
              allOf(startsWith('http://localhost'), endsWith('.jpg')),
            );
          });
        },
      );

      group(
        'when creating a user profile with image bytes',
        () {
          const userProfiles = UserProfiles();
          late UserProfileModel createdProfile;
          setUp(() async {
            createdProfile = await userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(userName: 'test_user'),
              imageSource: UserImageFromBytes(onePixelPng),
            );
          });

          test('then the returned profile contains the image URL.', () async {
            expect(
              createdProfile.imageUrl.toString(),
              allOf(startsWith('http://localhost'), endsWith('.jpg')),
            );
          });

          test('then image is accessible stored user.', () async {
            final foundUserProfile = await userProfiles.findUserProfileByUserId(
              session,
              authUserId,
            );

            expect(
              foundUserProfile.imageUrl.toString(),
              allOf(startsWith('http://localhost'), endsWith('.jpg')),
            );
          });
        },
      );
    },
  );

  withServerpod('Given an `AuthUser` with an empty profile,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await authUsers.create(session);
      authUserId = authUser.id;

      const userProfiles = UserProfiles();
      await userProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(),
      );
    });

    test(
      'when trying to create a second user profile for the same auth user ID, then this fails.',
      () async {
        const userProfiles = UserProfiles();
        await expectLater(
          () async => await userProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(),
          ),
          throwsA(
            isA<Exception>().having(
              (final e) => e.toString(),
              'message',
              contains(
                'duplicate key value violates unique constraint',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when updating a user profile, then `onBeforeUserProfileUpdated` is invoked with the new profile to be set.',
      () async {
        UserProfileData? updatedProfileFromCallback;
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            onBeforeUserProfileUpdated:
                (
                  final session,
                  final authUserId,
                  final userProfile, {
                  required final transaction,
                }) {
                  updatedProfileFromCallback = userProfile;
                  return userProfile.copyWith(
                    userName: 'username from onBeforeUserProfileUpdated hook',
                  );
                },
          ),
        );

        final updatedUserProfile = await userProfiles.changeFullName(
          session,
          authUserId,
          'Updated full name',
        );

        expect(
          updatedProfileFromCallback!.fullName,
          'Updated full name',
        );
        expect(
          updatedUserProfile.userName,
          'username from onBeforeUserProfileUpdated hook',
        );
      },
    );

    test(
      'when `onBeforeUserProfileUpdated` throws during the update of a user profile, then the update is not visible in the database.',
      () async {
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            onBeforeUserProfileUpdated:
                (
                  final session,
                  final authUserId,
                  final userProfile, {
                  required final transaction,
                }) {
                  throw UnimplementedError();
                },
          ),
        );

        await expectLater(
          () => userProfiles.changeFullName(
            session,
            authUserId,
            'Updated full name',
          ),
          throwsA(isA<UnimplementedError>()),
        );

        final profile = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(
          profile.fullName,
          isNull,
        );
      },
    );

    test(
      'when `onAfterUserProfileUpdated` throws during the update of a user profile, then the update is not visible in the database.',
      () async {
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            onAfterUserProfileUpdated:
                (
                  final session,
                  final userProfile, {
                  required final transaction,
                }) {
                  throw UnimplementedError();
                },
          ),
        );

        await expectLater(
          () => userProfiles.changeFullName(
            session,
            authUserId,
            'Updated full name',
          ),
          throwsA(isA<UnimplementedError>()),
        );

        final profile = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(
          profile.fullName,
          isNull,
        );
      },
    );

    test(
      'when updating a user profile, then `onAfterUserProfileUpdated` is invoked with the updated profile.',
      () async {
        UserProfileModel? updatedProfileFromCallback;
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            onAfterUserProfileUpdated:
                (
                  final session,
                  final userProfile, {
                  required final transaction,
                }) {
                  updatedProfileFromCallback = userProfile;
                },
          ),
        );

        await userProfiles.changeFullName(
          session,
          authUserId,
          'Updated full name',
        );

        expect(
          updatedProfileFromCallback!.fullName,
          'Updated full name',
        );
      },
    );

    test(
      "when updating the profile's user name, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        const userProfiles = UserProfiles();
        final updatedResult = await userProfiles.changeUserName(
          session,
          authUserId,
          'updated',
        );
        expect(updatedResult.userName, 'updated');

        final profileAfterUpdate = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfterUpdate.userName, 'updated');
      },
    );

    test(
      "when updating the profile's full name, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        const userProfiles = UserProfiles();
        final updatedResult = await userProfiles.changeFullName(
          session,
          authUserId,
          'updated',
        );
        expect(updatedResult.fullName, 'updated');

        final profileAfterUpdate = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfterUpdate.fullName, 'updated');
      },
    );

    test(
      "when updating the profile's image from bytes, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        const userProfiles = UserProfiles();
        final updatedResult = await userProfiles.setUserImageFromBytes(
          session,
          authUserId,
          onePixelPng,
        );

        expect(
          updatedResult.imageUrl?.toString(),
          allOf(startsWith('http://localhost'), endsWith('.jpg')),
        );

        final profileAfterUpdate = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(
          profileAfterUpdate.imageUrl,
          updatedResult.imageUrl,
        );
      },
    );

    test(
      "when updating the profile's image from a URL, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        );
        final updatedResult = await userProfiles.setUserImageFromUrl(
          session,
          authUserId,
          Uri.parse(
            'https://serverpod.dev/external-profile-image.png',
          ),
        );

        expect(
          updatedResult.imageUrl.toString(),
          allOf(startsWith('http://localhost'), endsWith('.jpg')),
        );

        final profileAfterUpdate = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(
          profileAfterUpdate.imageUrl,
          updatedResult.imageUrl,
        );
      },
    );

    test(
      'when removing the user image then no default image is added and imageUrl remains null.',
      () async {
        const userProfiles = UserProfiles();
        final profileBefore = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBefore.imageUrl, isNull);

        final updatedProfile = await userProfiles.removeUserImage(
          session,
          authUserId,
        );

        expect(updatedProfile.imageUrl, isNull);

        final profileAfter = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfter.imageUrl, isNull);

        final images = await UserProfileImage.db.find(session);
        expect(images, isEmpty);
      },
    );
  });

  withServerpod('Given an `AuthUser` with a profile with an image,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await authUsers.create(session);
      authUserId = authUser.id;

      const userProfiles = UserProfiles();
      await userProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(),
      );

      await userProfiles.setDefaultUserImage(
        session,
        authUserId,
      );
    });

    test(
      'when deleting the user profile, then the auth user is unaffected.',
      () async {
        const userProfiles = UserProfiles();
        final userProfile = await userProfiles.maybeFindUserProfileByUserId(
          session,
          authUserId,
        );
        expect(userProfile, isNotNull);
        expect(userProfile?.imageUrl, isNotNull);

        await userProfiles.deleteProfileForUser(session, authUserId);

        final profileAfterDelete = await userProfiles
            .maybeFindUserProfileByUserId(
              session,
              authUserId,
            );
        final authUserAfterDelete = await AuthUser.db.findById(
          session,
          authUserId,
        );
        final profileImagesAfterDelete = await UserProfileImage.db.find(
          session,
        );

        expect(
          profileAfterDelete,
          isNull,
        );
        expect(
          authUserAfterDelete,
          isNotNull,
        );
        expect(
          profileImagesAfterDelete,
          isEmpty,
        );
      },
    );

    test(
      'when deleting the user profile, then the images are deleted from storage as well.',
      () async {
        const userProfiles = UserProfiles();
        final userProfile = await userProfiles.maybeFindUserProfileByUserId(
          session,
          authUserId,
        );
        expect(userProfile, isNotNull);
        expect(userProfile?.imageUrl, isNotNull);

        final imageBeforeDelete = (await UserProfileImage.db.find(
          session,
        )).single;
        expect(
          await session.storage.fileExists(
            storageId: imageBeforeDelete.storageId,
            path: imageBeforeDelete.path,
          ),
          isTrue,
        );

        await userProfiles.deleteProfileForUser(session, authUserId);

        expect(
          await session.storage.fileExists(
            storageId: imageBeforeDelete.storageId,
            path: imageBeforeDelete.path,
          ),
          isFalse,
        );
      },
    );

    test(
      'when deleting the auth user, then the profile is cleaned up as well.',
      () async {
        const userProfiles = UserProfiles();
        await authUsers.delete(session, authUserId: authUserId);

        final authUserAfterDelete = await AuthUser.db.findById(
          session,
          authUserId,
        );
        final profileAfterDelete = await userProfiles
            .maybeFindUserProfileByUserId(
              session,
              authUserId,
            );
        final profileImagesAfterDelete = await UserProfileImage.db.find(
          session,
        );

        expect(
          authUserAfterDelete,
          isNull,
        );
        expect(
          profileAfterDelete,
          isNull,
        );
        expect(
          profileImagesAfterDelete,
          isEmpty,
        );
      },
    );

    test(
      'Given a user profile with an image when removing the user image then the image is deleted and imageUrl is null.',
      () async {
        const userProfiles = UserProfiles();
        final profileBeforeRemove = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBeforeRemove.imageUrl, isNotNull);

        final imageBeforeRemove = (await UserProfileImage.db.find(
          session,
        )).single;
        expect(
          await session.storage.fileExists(
            storageId: imageBeforeRemove.storageId,
            path: imageBeforeRemove.path,
          ),
          isTrue,
        );

        final updatedProfile = await userProfiles.removeUserImage(
          session,
          authUserId,
        );

        expect(updatedProfile.imageUrl, isNull);

        final profileAfterRemove = await userProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfterRemove.imageUrl, isNull);

        final imagesAfterRemove = await UserProfileImage.db.find(session);
        expect(imagesAfterRemove, isEmpty);

        expect(
          await session.storage.fileExists(
            storageId: imageBeforeRemove.storageId,
            path: imageBeforeRemove.path,
          ),
          isFalse,
        );
      },
    );
  });

  withServerpod(
    'Given an existing `AuthUser`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authUsers.create(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        // also cleans up related profile and profile images
        await authUsers.delete(session, authUserId: authUserId);
      });

      test(
        'when creating a profile and its associated image in a transaction, then there are visible in that transaction but not after a rollback.',
        () async {
          expect(session.transaction, isNull);

          await session.db.transaction<void>((final transaction) async {
            const userProfiles = UserProfiles();
            await userProfiles.createUserProfile(
              session,
              authUserId,
              UserProfileData(),
              transaction: transaction,
            );

            expect(await UserProfile.db.count(session), 0);
            expect(
              await UserProfile.db.count(session, transaction: transaction),
              1,
            );

            await userProfiles.setUserImageFromBytes(
              session,
              authUserId,
              onePixelPng,
              transaction: transaction,
            );

            expect(await UserProfileImage.db.count(session), 0);
            expect(
              await UserProfileImage.db.count(
                session,
                transaction: transaction,
              ),
              1,
            );

            await expectLater(
              () => userProfiles.changeUserName(
                session,
                authUserId,
                'updated',
              ),
              throwsA(isA<UserProfileNotFoundException>()),
            );

            await transaction.cancel();
          });

          expect(await UserProfile.db.count(session), 0);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

final onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);
