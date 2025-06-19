import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
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
    });

    test(
        'when calling `UserProfile.get` for a non-existent "auth user", then an error is thrown.',
        () async {
      final session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          const Uuid().v4obj(),
          {},
        ),
      );

      await expectLater(
        () => endpoints.userProfile.get(session),
        throwsA(isA<UserProfileNotFoundException>()),
      );
    });
  });

  withServerpod(
    'Given a session for a user without a profile,',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late TestSessionBuilder session;

      setUp(() async {
        authUserId = (await AuthUsers.create(sessionBuilder.build())).id;

        session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId,
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
      });
    },
  );

  withServerpod(
    'Given a session for a user with a profile,',
    (final sessionBuilder, final endpoints) {
      late UuidValue authUserId;
      late TestSessionBuilder session;

      setUp(() async {
        authUserId = (await AuthUsers.create(sessionBuilder.build())).id;

        await UserProfiles.createUserProfile(
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
            authUserId,
            {},
          ),
        );
      });

      test(
          'when calling `UserProfile.get` for that user, then the profile is returned containing the user name.',
          () async {
        final profile = await endpoints.userProfile.get(session);

        expect(profile.userName, 'user name');
      });

      test(
          'when calling `UserProfile.get` for that user, then the profile is returned containing the full name.',
          () async {
        final profile = await endpoints.userProfile.get(session);

        expect(profile.fullName, 'Full Name');
      });

      test(
          'when calling `UserProfile.get` for that user, then the profile is returned containing the email in lower-case.',
          () async {
        final profile = await endpoints.userProfile.get(session);

        expect(profile.email, 'foo@serverpod.dev');
      });

      test(
          'when calling `UserProfile.changeUserName`, the profile with the new user name is returned.',
          () async {
        final profile = await endpoints.userProfile.changeUserName(
          session,
          'new user name',
        );

        expect(profile.userName, 'new user name');
      });

      test(
          'when calling `UserProfile.changeFullName`, the profile with the new full name is returned.',
          () async {
        final profile = await endpoints.userProfile.changeFullName(
          session,
          'New Full Name',
        );

        expect(profile.fullName, 'New Full Name');
      });
    },
  );
}
