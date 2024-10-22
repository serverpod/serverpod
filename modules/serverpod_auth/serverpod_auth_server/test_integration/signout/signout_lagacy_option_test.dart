import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given different legacy sign-out options',
    (sessionBuilder, endpoints) {
      late String userName;
      late String email;
      late String password;
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        userName = 'test';
        email = 'test@serverpod.dev';
        password = 'password';
        await Emails.createUser(session, userName, email, password);
      });

      test(
        'when default legacy sign-out option is used then the user is signed out of all devices',
        () async {
          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          // Sign in on another device
          var authKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            hasLength(2),
            reason:
                'Expected two auth keys after signing in on another device.',
          );

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKey.userId,
              {},
              authId: '${authKey.id}',
            ),
          );
          session = sessionBuilder.build();

          // Use default legacy sign-out option (all devices)
          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            isEmpty,
            reason:
                'Expected all auth keys to be deleted after signing out all devices using default legacy option.',
          );
        },
      );

      test(
        'when legacy sign-out option is set to all devices then the user is signed out of all devices',
        () async {
          // Set sign-out behavior to all devices
          AuthConfig.set(AuthConfig(
            legacyUserSignOutBehavior: SignOutOption.allDevices,
          ));

          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

          // Sign in on another device
          var authKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason:
                'Expected two auth keys after signing in on another device.',
          );

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKey.userId,
              {},
              authId: '${authKey.id}',
            ),
          );
          session = sessionBuilder.build();
          // Sign out all devices
          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            isEmpty,
            reason:
                'Expected all auth keys to be deleted after signing out all devices.',
          );
        },
      );

      test(
        'when legacy sign-out option is set to current device then only the current session is signed out',
        () async {
          // Set sign-out behavior to current device only
          AuthConfig.set(AuthConfig(
            legacyUserSignOutBehavior: SignOutOption.currentDevice,
          ));

          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

          // Sign in on another device
          var authKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason:
                'Expected two auth keys after signing in on another device.',
          );

          sessionBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authKey.userId,
              {},
              authId: '${authKey.id}',
            ),
          );
          session = sessionBuilder.build();

          // Sign out from the current device only
          await endpoints.status.signOut(sessionBuilder);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason:
                'Expected one auth key to remain after signing out the current device.',
          );
        },
      );
    },
  );
}
