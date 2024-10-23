import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  var userId = 1;
  withServerpod(
    'Given no legacy user sign-out option defined and user signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        await Future.wait([
          UserAuthentication.signInUser(session, userId, 'email'),
          UserAuthentication.signInUser(session, userId, 'email')
        ]);
      });

      test(
        'when signing out user then user is signed out of all devices',
        () async {
          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(authKeys, hasLength(2));

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKeys.first.userId,
              {},
              authId: '${authKeys.first.id}',
            ),
          );

          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(authKeys, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given legacy sign-out option set to all devices and user signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        AuthConfig.set(AuthConfig(
          legacyUserSignOutBehavior: SignOutBehavior.allDevices,
        ));

        await Future.wait([
          UserAuthentication.signInUser(session, userId, 'email'),
          UserAuthentication.signInUser(session, userId, 'email')
        ]);
      });

      test(
        'when signing out user then user is signed out of all devices',
        () async {
          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(authKeys, hasLength(2));

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKeys.first.userId,
              {},
              authId: '${authKeys.first.id}',
            ),
          );

          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(authKeys, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given legacy sign-out option set to current device and user signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        AuthConfig.set(AuthConfig(
          legacyUserSignOutBehavior: SignOutBehavior.currentDevice,
        ));

        await Future.wait([
          UserAuthentication.signInUser(session, userId, 'email'),
          UserAuthentication.signInUser(session, userId, 'email')
        ]);
      });

      test(
        'when signing out user then only the current device is signed out',
        () async {
          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(authKeys, hasLength(2));

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKeys.first.userId,
              {},
              authId: '${authKeys.first.id}',
            ),
          );

          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(authKeys, hasLength(1));
        },
      );
    },
  );
}
