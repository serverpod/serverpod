import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given no users,', (final sessionBuilder, final endpoints) {
    test(
      'when calling `UserProfile.get` with an unauthenticated user, then an error is thrown.',
      () async {
        await expectLater(
          () => endpoints.userProfile.get(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'when calling `UserProfile.get` for a non-existent "auth user", then an error is thrown.',
      () async {
        final session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            const Uuid().v4obj().uuid,
            {},
          ),
        );

        await expectLater(
          () => endpoints.userProfile.get(session),
          throwsA(isA<UserProfileNotFoundException>()),
        );
      },
    );
  });

  withServerpod(
    'Given a session for a user without a profile,',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late TestSessionBuilder session;

      setUp(() async {
        const authUsers = AuthUsers();
        authUserId = (await authUsers.create(sessionBuilder.build())).id;

        session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.uuid,
            {},
          ),
        );
      });

      test(
        'when calling `UserProfile.get` for that user, then an error is thrown.',
        () async {
          await expectLater(
            () => endpoints.userProfile.get(session),
            throwsA(isA<UserProfileNotFoundException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a session for a user with a profile,',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late TestSessionBuilder session;

      setUp(() async {
        const authUsers = AuthUsers();
        authUserId = (await authUsers.create(sessionBuilder.build())).id;

        const userProfiles = UserProfiles();
        await userProfiles.createUserProfile(
          sessionBuilder.build(),
          authUserId,
          UserProfileData(
            userName: 'user name',
            fullName: 'Full Name',
            email: 'Foo@serverpod.dev',
          ),
        );

        session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.uuid,
            {},
          ),
        );
      });

      test(
        'when calling `UserProfile.get` for that user, then the profile is returned containing the user name.',
        () async {
          final profile = await endpoints.userProfile.get(session);

          expect(profile.userName, 'user name');
        },
      );

      test(
        'when calling `UserProfile.get` for that user, then the profile is returned containing the full name.',
        () async {
          final profile = await endpoints.userProfile.get(session);

          expect(profile.fullName, 'Full Name');
        },
      );

      test(
        'when calling `UserProfile.get` for that user, then the profile is returned containing the email in lower-case.',
        () async {
          final profile = await endpoints.userProfile.get(session);

          expect(profile.email, 'foo@serverpod.dev');
        },
      );

      test(
        'when calling `UserProfile.changeUserName`, the profile with the new user name is returned.',
        () async {
          final profile = await endpoints.userProfile.changeUserName(
            session,
            'new user name',
          );

          expect(profile.userName, 'new user name');
        },
      );

      test(
        'when calling `UserProfile.changeFullName`, the profile with the new full name is returned.',
        () async {
          final profile = await endpoints.userProfile.changeFullName(
            session,
            'New Full Name',
          );

          expect(profile.fullName, 'New Full Name');
        },
      );
    },
  );

  withServerpod(
    'Given a session for a user with a profile and an image,',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late TestSessionBuilder session;

      setUp(() async {
        const authUsers = AuthUsers();
        authUserId = (await authUsers.create(sessionBuilder.build())).id;

        const userProfiles = UserProfiles();
        await userProfiles.createUserProfile(
          sessionBuilder.build(),
          authUserId,
          UserProfileData(userName: 'user name'),
        );

        await userProfiles.setDefaultUserImage(
          sessionBuilder.build(),
          authUserId,
        );

        session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.uuid,
            {},
          ),
        );
      });

      test(
        'when calling `UserProfile.removeUserImage` then the image is removed and imageUrl is null.',
        () async {
          final profileBefore = await endpoints.userProfile.get(session);
          expect(profileBefore.imageUrl, isNotNull);

          final updatedProfile = await endpoints.userProfile.removeUserImage(
            session,
          );

          expect(updatedProfile.imageUrl, isNull);

          final profileAfter = await endpoints.userProfile.get(session);
          expect(profileAfter.imageUrl, isNull);
        },
      );
    },
  );
}
