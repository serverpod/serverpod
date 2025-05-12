import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `UserProfiles` implementation and an existing `AuthUser`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();
        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        authUserId = authUser.id!;
      });

      test(
        'when creating a user profile, then it can be looked up by (auth) user ID.',
        () async {
          await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId, userName: 'test_user'),
          );

          final foundUserProfile = await UserProfiles.maybeFindUserByUserId(
            session,
            authUserId,
          );

          expect(foundUserProfile?.authUserId, authUserId);
          expect(foundUserProfile?.userName, 'test_user');
        },
      );

      test(
        'when trying to create a second user profile for the same auth user, then this fails.',
        () async {
          await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId),
          );

          await expectLater(
            () async => await UserProfiles.createUserProfile(
              session,
              UserProfileModel(authUserId: authUserId),
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
        'when creating a new user profile, then `onBeforeUserProfileCreated` can be used to modify it before persisting.',
        () async {
          UserProfileConfig.current = UserProfileConfig(
            onBeforeUserProfileCreated: (final session, final userProfile) =>
                userProfile.copyWith(fullName: 'overwritten full name'),
          );

          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId),
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
          UserProfileConfig.current = UserProfileConfig(
              onAfterUserProfileCreated: (final session, final userProfile) {
            createdProfileFromCallback = userProfile;
          });

          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId),
          );

          expect(
            createdUserProfile.toJsonForProtocol(),
            equals(createdProfileFromCallback?.toJsonForProtocol()),
          );
        },
      );

      test(
        'when updating a user profile, then `onBeforeUserProfileUpdated` is invoked with the new profile to be set.',
        () async {
          UserProfileModel? updatedProfileFromCallback;
          UserProfileConfig.current = UserProfileConfig(
              onBeforeUserProfileUpdated: (final session, final userProfile) {
            updatedProfileFromCallback = userProfile;
            return userProfile.copyWith(
              userName: 'username from onBeforeUserProfileUpdated hook',
            );
          });

          await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId),
          );

          // Insert does not count as update
          expect(updatedProfileFromCallback, null);

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
        'when updating a user profile, then `onAfterUserProfileUpdated` is invoked with the updated profile.',
        () async {
          UserProfileModel? updatedProfileFromCallback;
          UserProfileConfig.current = UserProfileConfig(
              onAfterUserProfileUpdated: (final session, final userProfile) {
            updatedProfileFromCallback = userProfile;
          });

          await UserProfiles.createUserProfile(
            session,
            UserProfileModel(authUserId: authUserId),
          );

          // Insert does not count as update
          expect(updatedProfileFromCallback, null);

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
        'when looking for an existing user profile by email, then it finds the matches case-insensitively.',
        () async {
          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfileModel(
              authUserId: authUserId,
              email: 'Test@serverpod.Dev',
            ),
          );

          expect(
            createdUserProfile.email,
            'test@serverpod.dev',
          );

          final resultFromLowerCase =
              await UserProfiles.maybeFindUserProfileByEmail(
            session,
            'test@serverpod.dev',
          );

          expect(resultFromLowerCase?.authUserId, authUserId);

          final resultFromUppercase =
              await UserProfiles.maybeFindUserProfileByEmail(
            session,
            'TEST@SERVERPOD.DEV',
          );

          expect(resultFromUppercase?.authUserId, authUserId);
        },
      );

      test(
        'when looking for an existing user profile by email, then no result is returned if 2 profiles use the same email.',
        () async {
          const email = 'double@serverpod.dev';

          final userA = await AuthUser.db.insertRow(
            session,
            AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
          );

          final userB = await AuthUser.db.insertRow(
            session,
            AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
          );

          final profileA = await UserProfiles.createUserProfile(
            session,
            UserProfileModel(
              authUserId: userA.id!,
              email: email,
            ),
          );

          final profileB = await UserProfiles.createUserProfile(
            session,
            UserProfileModel(
              authUserId: userB.id!,
              email: email,
            ),
          );

          expect(profileA.authUserId, userA.id!);
          expect(profileB.authUserId, userB.id!);

          final matchesByEmail = await UserProfiles.maybeFindUserProfileByEmail(
            session,
            email,
          );

          expect(matchesByEmail, isNull);
        },
      );
    },
  );

  withServerpod('Given the `UserProfiles` and an `AuthUser` with a profile,',
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
        UserProfileModel(authUserId: authUserId),
      );
    });

    test('when deleting the user profile, then the auth user is unaffected.',
        () async {
      final userProfile = await UserProfiles.maybeFindUserByUserId(
        session,
        authUserId,
      );
      expect(userProfile, isNotNull);

      await UserProfiles.deleteProfileForUser(session, authUserId);

      final profileAfterDelete = await UserProfiles.maybeFindUserByUserId(
        session,
        authUserId,
      );
      final authUserAfterDelete = await AuthUser.db.findById(
        session,
        authUserId,
      );

      expect(
        profileAfterDelete,
        isNull,
      );
      expect(
        authUserAfterDelete,
        isNotNull,
      );
    });

    test('when deleting the auth user, then the profile is cleaned up as well.',
        () async {
      await AuthUser.db.deleteRow(session, authUser);

      final authUserAfterDelete = await AuthUser.db.findById(
        session,
        authUserId,
      );
      final profileAfterDelete = await UserProfiles.maybeFindUserByUserId(
        session,
        authUserId,
      );

      expect(
        authUserAfterDelete,
        isNull,
      );
      expect(
        profileAfterDelete,
        isNull,
      );
    });

    test(
        'when the image is updated, then the new URL is available on the profile on read.',
        () async {
      // NOTE: This exercises only the libray-internal part of the image handling, as we don't have access to object storage in this test

      await UserProfiles.setUserImageFromOwnedUrl(
        session,
        authUserId,
        1,
        Uri.parse('https://serverpod.dev/image1.png'),
      );

      final readUpdatedProfile = await UserProfiles.maybeFindUserByUserId(
        session,
        authUserId,
      );

      expect(
        readUpdatedProfile?.imageUrl.toString(),
        'https://serverpod.dev/image1.png',
      );

      await UserProfiles.setUserImageFromOwnedUrl(
        session,
        authUserId,
        2,
        Uri.parse('https://serverpod.dev/image2.png'),
      );

      final readUpdatedProfile2 = await UserProfiles.maybeFindUserByUserId(
        session,
        authUserId,
      );

      expect(
        readUpdatedProfile2?.imageUrl.toString(),
        'https://serverpod.dev/image2.png',
      );
    });
  });
}
