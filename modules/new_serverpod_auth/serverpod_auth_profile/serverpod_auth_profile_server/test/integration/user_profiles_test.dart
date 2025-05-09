import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `UserSessions` implementation, ',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();
        final user = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        authUserId = user.id!;
      });

      test(
        'when creating a user profile, then it can be looked up by (auth) user ID.',
        () async {
          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          final foundUserProfile = await UserProfiles.maybeFindUserByUserId(
            session,
            authUserId,
          );

          expect(
            createdUserProfile.id,
            foundUserProfile?.id,
          );
          expect(
            foundUserProfile?.authUserId,
            authUserId,
          );
        },
      );

      test(
        'when trying to create a second user profile for the same auth user, then this fails.',
        () async {
          await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          await expectLater(
            () async => await UserProfiles.createUserProfile(
              session,
              UserProfile(authUserId: authUserId),
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
            UserProfile(authUserId: authUserId),
          );

          expect(
            createdUserProfile.fullName,
            'overwritten full name',
          );
        },
      );

      test(
        'when creating a new user profile, then `onBeforeUserProfileCreated` can to redirect to an existing one profile (avoiding a conflict).',
        () async {
          final existingProfile = await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          UserProfileConfig.current = UserProfileConfig(
            onBeforeUserProfileCreated: (final session, final userProfile) =>
                existingProfile,
          );

          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          expect(
            existingProfile.id,
            createdUserProfile.id,
          );
        },
      );

      test(
        'when creating a new user profile, then `onAfterUserProfileCreated` is invoked with the new profile after it has been written to the database.',
        () async {
          UserProfile? createdProfileFromCallback;
          UserProfileConfig.current = UserProfileConfig(
              onAfterUserProfileCreated: (final session, final userProfile) {
            createdProfileFromCallback = userProfile;
          });

          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          expect(
            createdProfileFromCallback?.id,
            isNotNull,
          );
          expect(
            identical(createdUserProfile, createdProfileFromCallback),
            isTrue,
          );
        },
      );

      test(
        'when updating a user profile, then `onAfterUserProfileUpdated` is invoked with the updated profile.',
        () async {
          UserProfile? updatedProfileFromCallback;
          UserProfileConfig.current = UserProfileConfig(
              onAfterUserProfileUpdated: (final session, final userProfile) {
            updatedProfileFromCallback = userProfile;
          });

          final createdUserProfile = await UserProfiles.createUserProfile(
            session,
            UserProfile(authUserId: authUserId),
          );

          // Insert does not count as update
          expect(updatedProfileFromCallback, null);

          await UserProfiles.changeFullName(
            session,
            authUserId,
            'Updated full name',
          );

          expect(
            updatedProfileFromCallback?.id,
            createdUserProfile.id!,
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
            UserProfile(
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

          expect(
            resultFromLowerCase?.id,
            createdUserProfile.id!,
          );

          final resultFromUppercase =
              await UserProfiles.maybeFindUserProfileByEmail(
            session,
            'TEST@SERVERPOD.DEV',
          );

          expect(
            resultFromUppercase?.id,
            createdUserProfile.id!,
          );
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
            UserProfile(
              authUserId: userA.id!,
              email: email,
            ),
          );

          final profileB = await UserProfiles.createUserProfile(
            session,
            UserProfile(
              authUserId: userB.id!,
              email: email,
            ),
          );

          expect(profileA.id, isNot(profileB.id));

          final matchesByEmail = await UserProfiles.maybeFindUserProfileByEmail(
            session,
            email,
          );

          expect(matchesByEmail, isNull);
        },
      );
    },
  );
}
