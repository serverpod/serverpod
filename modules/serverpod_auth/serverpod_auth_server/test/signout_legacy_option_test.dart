import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  var userId = 1;
  withServerpod(
    'Given no legacy user sign-out option defined and user signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;
      late List<AuthKey> authKeys;

      setUp(() async {
        session = sessionBuilder.build();
        authKeys = await _signInUserToMultipleDevices(session, userId);
      });

      test(
        'when signing out user then user is signed out of all devices',
        () async {
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
      late List<AuthKey> authKeys;

      setUp(() async {
        session = sessionBuilder.build();
        AuthConfig.set(AuthConfig(
          legacyUserSignOutBehavior: SignOutBehavior.allDevices,
        ));

        authKeys = await _signInUserToMultipleDevices(session, userId);
      });

      test(
        'when signing out user then user is signed out of all devices',
        () async {
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
      late List<AuthKey> authKeys;

      setUp(() async {
        session = sessionBuilder.build();
        AuthConfig.set(AuthConfig(
          legacyUserSignOutBehavior: SignOutBehavior.currentDevice,
        ));

        authKeys = await _signInUserToMultipleDevices(session, userId);
      });

      test(
        'when signing out user then only the current device is signed out',
        () async {
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

Future<List<AuthKey>> _signInUserToMultipleDevices(
  Session session,
  int userId,
) async {
  return Future.wait<AuthKey>([
    UserAuthentication.signInUser(session, userId, 'email'),
    UserAuthentication.signInUser(session, userId, 'google'),
  ]);
}
