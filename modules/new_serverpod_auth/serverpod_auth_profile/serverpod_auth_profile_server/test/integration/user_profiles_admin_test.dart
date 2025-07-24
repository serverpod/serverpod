import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an `AuthUser` with a `UserProfile`,',
    (final sessionBuilder, final endpoints) {
      final profileData = UserProfileData(
        userName: 'username',
        fullName: 'Full Name',
        email: 'test@serverpod.dev',
      );

      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        final user1 = await AuthUsers.create(session);
        authUserId = user1.id;

        await UserProfiles.createUserProfile(session, authUserId, profileData);
      });

      test(
        'when listing without any criteria, then the profile with data is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
          );

          expect(profiles, hasLength(1));
          expect(profiles.single.authUserId, authUserId);
          expect(profiles.single.userName, profileData.userName);
          expect(profiles.single.fullName, profileData.fullName);
          expect(profiles.single.email, profileData.email);
        },
      );

      test(
        'when listing with the matching `email` parameter, then the profile is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            email: profileData.email,
          );

          expect(profiles, hasLength(1));
        },
      );

      test(
        'when listing with the matching `username` parameter, then the profile is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            userName: profileData.userName,
          );

          expect(profiles, hasLength(1));
        },
      );

      test(
        'when listing with the matching `fullName` parameter, then the profile is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            fullName: profileData.fullName,
          );

          expect(profiles, hasLength(1));
        },
      );

      test(
        'when listing with no matching criteria, then no profiles are returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            email: 'does-not-match',
          );

          expect(profiles, isEmpty);
        },
      );

      test(
        'when listing with one matching and one non-matching criteria, then no profiles are returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            email: profileData.email,
            userName: 'does-not-match',
          );

          expect(profiles, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given two `AuthUser`s with identical `UserProfile`s,',
    (final sessionBuilder, final endpoints) {
      final profileData = UserProfileData(
        userName: 'username',
        fullName: 'Full Name',
        email: 'test@serverpod.dev',
      );

      late Session session;
      late UuidValue authUserId1;
      late UuidValue authUserId2;

      setUp(() async {
        session = sessionBuilder.build();

        final user1 = await AuthUsers.create(session);
        authUserId1 = user1.id;
        final user2 = await AuthUsers.create(session);
        authUserId2 = user2.id;

        await UserProfiles.createUserProfile(session, user1.id, profileData);
        await UserProfiles.createUserProfile(session, user2.id, profileData);
      });

      test(
        'when listing without any criteria, then all users are returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
          );

          expect(profiles, hasLength(2));
          expect(
            profiles.authUserIds,
            unorderedEquals([authUserId1, authUserId2]),
          );
        },
      );
    },
  );

  withServerpod(
    'Given two `AuthUser`s with unique `UserProfile`s,',
    (final sessionBuilder, final endpoints) {
      final profileData1 = UserProfileData(
        userName: 'user1',
        fullName: 'Full Name One',
        email: 'one@serverpod.dev',
      );
      final profileData2 = UserProfileData(
        userName: 'user2',
        fullName: 'Full Name Two',
        email: 'two@serverpod.dev',
      );

      late Session session;
      late UuidValue authUserId1;
      late UuidValue authUserId2;

      setUp(() async {
        session = sessionBuilder.build();

        final user1 = await AuthUsers.create(session);
        authUserId1 = user1.id;
        final user2 = await AuthUsers.create(session);
        authUserId2 = user2.id;

        await UserProfiles.createUserProfile(session, user1.id, profileData1);
        await UserProfiles.createUserProfile(session, user2.id, profileData2);
      });

      test(
        'when listing with a criteria for user1, then only that one is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            email: profileData1.email,
          );

          expect(profiles, hasLength(1));
          expect(profiles.single.authUserId, authUserId1);
        },
      );

      test(
        'when listing with a criteria for user2, then only that one is returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            userName: profileData2.userName,
          );

          expect(profiles, hasLength(1));
          expect(profiles.single.authUserId, authUserId2);
        },
      );

      test(
        'when listing with a criteria for user1 combined with one for user2, then no profiles are returned.',
        () async {
          final profiles = await UserProfiles.admin.listUserProfiles(
            session,
            email: profileData1.email,
            userName: profileData2.userName,
          );

          expect(profiles, isEmpty);
        },
      );
    },
  );
}

extension on Iterable<UserProfileModel> {
  Set<UuidValue> get authUserIds => {...map((final p) => p.authUserId)};
}
