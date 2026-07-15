import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../common/business/fakes/fakes.dart';
import '../../serverpod_test_tools.dart';

void main() {
  const authUsers = AuthUsers();

  test(
    'Given a user profile entity, '
    'when converting it to a user profile model, '
    'then its public fields are preserved.',
    () {
      final authUserId = const Uuid().v4obj();
      final profile = UserProfile(
        authUserId: authUserId,
        userName: 'user-name',
        fullName: 'Full Name',
        email: 'user@example.com',
      );

      final model = profile.toModel();

      expect(model.authUserId, authUserId);
      expect(model.userName, 'user-name');
      expect(model.fullName, 'Full Name');
      expect(model.email, 'user@example.com');
    },
  );

  test(
    'Given a user profile entity, '
    'when converting it to user profile data, '
    'then its editable fields are preserved.',
    () {
      final profile = UserProfile(
        authUserId: const Uuid().v4obj(),
        userName: 'user-name',
        fullName: 'Full Name',
        email: 'user@example.com',
      );

      final data = profile.toProfileData();

      expect(data.userName, 'user-name');
      expect(data.fullName, 'Full Name');
      expect(data.email, 'user@example.com');
    },
  );

  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
      ],
    );
  });

  withServerpod(
    'Given authentication information for a user with a profile,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthenticationInfo authenticationInfo;

      setUp(() async {
        session = sessionBuilder.build();
        final authUser = await authUsers.create(session);
        await AuthServices.instance.userProfiles.createUserProfile(
          session,
          authUser.id,
          UserProfileData(userName: 'user-name'),
        );
        authenticationInfo = AuthenticationInfo(
          authUser.id.uuid,
          {},
          authId: const Uuid().v4(),
        );
      });

      test(
        'when looking up the user profile through the public extension, '
        'then the associated profile is returned.',
        () async {
          final profile = await authenticationInfo.userProfile(session);

          expect(profile?.userName, 'user-name');
        },
      );
    },
  );
}
