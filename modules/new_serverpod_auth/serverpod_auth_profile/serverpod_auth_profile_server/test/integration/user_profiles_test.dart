import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/protocol.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an existing `AuthUser`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        UserProfileConfig.current = UserProfileConfig();

        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );

        authUserId = authUser.id!;
      });

      test(
        'when creating a user profile, then it can be looked up by the auth user ID.',
        () async {
          await UserProfiles.createUserProfile(
            session,
            authUserId,
            UserProfileData(userName: 'test_user'),
          );

          final foundUserProfile =
              await UserProfiles.maybeFindUserProfileByUserId(
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
          UserProfileConfig.current = UserProfileConfig(
            onBeforeUserProfileCreated: (
              final session,
              final authUserId,
              final userProfile, {
              required final transaction,
            }) =>
                userProfile.copyWith(fullName: 'overwritten full name'),
          );

          final createdUserProfile = await UserProfiles.createUserProfile(
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
          UserProfileConfig.current =
              UserProfileConfig(onAfterUserProfileCreated: (
            final session,
            final userProfile, {
            required final transaction,
          }) {
            createdProfileFromCallback = userProfile;
          });

          final createdUserProfile = await UserProfiles.createUserProfile(
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
        'when `onAfterUserProfileCreated` throws during the creation of a new user profile, then the profile is not stored in the database and the error forwarded.',
        () async {
          UserProfileConfig.current =
              UserProfileConfig(onAfterUserProfileCreated: (
            final session,
            final userProfile, {
            required final transaction,
          }) {
            throw UnimplementedError();
          });

          expect(
            () => UserProfiles.createUserProfile(
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
          final createdUserProfile = await UserProfiles.createUserProfile(
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
            () => UserProfiles.findUserProfileByUserId(session, authUserId),
            throwsA(isA<UserProfileNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod('Given an `AuthUser` with an empty profile,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      UserProfileConfig.current = UserProfileConfig(
        imageFetchFunc: (final _) => onePixelPng,
      );

      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
      );
      authUserId = authUser.id!;

      await UserProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(),
      );
    });

    test(
        'when the image is updated, then the new URL is available on the profile on read.',
        () async {
      // NOTE: This exercises only the libray-internal part of the image handling, as we don't have access to object storage in this test

      await UserProfiles.setUserImageFromBytes(
        session,
        authUserId,
        onePixelPng,
      );

      final readUpdatedProfile =
          await UserProfiles.maybeFindUserProfileByUserId(
        session,
        authUserId,
      );

      expect(
        readUpdatedProfile?.imageUrl.toString(),
        allOf(contains('http://localhost'), endsWith('-1.jpg')),
      );

      final profileAfterUpdate = await UserProfiles.setUserImageFromBytes(
        session,
        authUserId,
        onePixelPng,
      );

      expect(
        profileAfterUpdate.imageUrl.toString(),
        allOf(contains('http://localhost'), endsWith('-2.jpg')),
      );

      final readUpdatedProfile2 =
          await UserProfiles.maybeFindUserProfileByUserId(
        session,
        authUserId,
      );

      expect(
        readUpdatedProfile2?.imageUrl.toString(),
        allOf(contains('http://localhost'), endsWith('-2.jpg')),
      );
    });

    test(
      'when trying to create a second user profile for the same auth user ID, then this fails.',
      () async {
        await expectLater(
          () async => await UserProfiles.createUserProfile(
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
        UserProfileConfig.current =
            UserProfileConfig(onBeforeUserProfileUpdated: (
          final session,
          final authUserId,
          final userProfile, {
          required final transaction,
        }) {
          updatedProfileFromCallback = userProfile;
          return userProfile.copyWith(
            userName: 'username from onBeforeUserProfileUpdated hook',
          );
        });

        final updatedUserProfile = await UserProfiles.changeFullName(
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
      'when `onAfterUserProfileUpdated` throws during the update of a user profile, then the update is not visible in the database.',
      () async {
        UserProfileConfig.current =
            UserProfileConfig(onAfterUserProfileUpdated: (
          final session,
          final userProfile, {
          required final transaction,
        }) {
          throw UnimplementedError();
        });

        await expectLater(
          () => UserProfiles.changeFullName(
            session,
            authUserId,
            'Updated full name',
          ),
          throwsA(isA<UnimplementedError>()),
        );

        final profile = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
          transaction: session.transaction,
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
        UserProfileConfig.current =
            UserProfileConfig(onAfterUserProfileUpdated: (
          final session,
          final userProfile, {
          required final transaction,
        }) {
          updatedProfileFromCallback = userProfile;
        });

        await UserProfiles.changeFullName(
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
        final profileBeforeUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBeforeUpdate.userName, isNull);

        final updatedResult = await UserProfiles.changeUserName(
          session,
          authUserId,
          'updated',
        );
        expect(updatedResult.userName, 'updated');

        final profileAfterUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfterUpdate.userName, 'updated');
      },
    );

    test(
      "when updating the profile's full name, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        final profileBeforeUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBeforeUpdate.fullName, isNull);

        final updatedResult = await UserProfiles.changeFullName(
          session,
          authUserId,
          'updated',
        );
        expect(updatedResult.fullName, 'updated');

        final profileAfterUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileAfterUpdate.fullName, 'updated');
      },
    );

    test(
      "when updating the profile's image from bytes, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        final profileBeforeUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBeforeUpdate.imageUrl, isNull);

        final updatedResult = await UserProfiles.setUserImageFromBytes(
          session,
          authUserId,
          onePixelPng,
        );

        expect(
          updatedResult.imageUrl.toString(),
          allOf(contains('http://localhost'), endsWith('-1.jpg')),
        );

        final profileAfterUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(
          profileAfterUpdate.imageUrl?.toString(),
          allOf(contains('http://localhost'), endsWith('-1.jpg')),
        );
      },
    );

    test(
      "when updating the profile's image from a URL, then the updated value is visible through the cached `findUserProfileByUserId` method.",
      () async {
        final profileBeforeUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );
        expect(profileBeforeUpdate.imageUrl, isNull);

        final updatedResult = await UserProfiles.setUserImageFromUrl(
          session,
          authUserId,
          Uri.parse(
            'https://serverpod.dev/external-profile-image.png',
          ),
        );

        expect(
          updatedResult.imageUrl.toString(),
          allOf(contains('http://localhost'), endsWith('-1.jpg')),
        );

        final profileAfterUpdate = await UserProfiles.findUserProfileByUserId(
          session,
          authUserId,
        );

        expect(
          profileAfterUpdate.imageUrl?.toString(),
          allOf(contains('http://localhost'), endsWith('-1.jpg')),
        );
      },
    );
  });

  withServerpod('Given an `AuthUser` with a profile with an image,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late AuthUser authUser;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
      );
      authUserId = authUser.id!;

      await UserProfiles.createUserProfile(
        session,
        authUserId,
        UserProfileData(),
      );

      await UserProfiles.setDefaultUserImage(
        session,
        authUserId,
      );
    });

    test('when deleting the user profile, then the auth user is unaffected.',
        () async {
      final userProfile = await UserProfiles.maybeFindUserProfileByUserId(
        session,
        authUserId,
      );
      expect(userProfile, isNotNull);
      expect(userProfile?.imageUrl, isNotNull);

      await UserProfiles.deleteProfileForUser(session, authUserId);

      final profileAfterDelete =
          await UserProfiles.maybeFindUserProfileByUserId(
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
    });

    test(
        'when deleting the user profile, then the images are deleted from storage as well.',
        () async {
      final userProfile = await UserProfiles.maybeFindUserProfileByUserId(
        session,
        authUserId,
      );
      expect(userProfile, isNotNull);
      expect(userProfile?.imageUrl, isNotNull);

      final imageBeforeDelete =
          (await UserProfileImage.db.find(session)).single;
      expect(
        await session.storage.fileExists(
          storageId: imageBeforeDelete.storageId,
          path: imageBeforeDelete.path,
        ),
        isTrue,
      );

      await UserProfiles.deleteProfileForUser(session, authUserId);

      expect(
        await session.storage.fileExists(
          storageId: imageBeforeDelete.storageId,
          path: imageBeforeDelete.path,
        ),
        isFalse,
      );
    });

    test('when deleting the auth user, then the profile is cleaned up as well.',
        () async {
      await AuthUser.db.deleteRow(session, authUser);

      final authUserAfterDelete = await AuthUser.db.findById(
        session,
        authUserId,
      );
      final profileAfterDelete =
          await UserProfiles.maybeFindUserProfileByUserId(
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
    });
  });
}

final onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);
