import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an authenticated user',
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
        'when signing out all devices then all auth keys are deleted',
        () async {
          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(
            userId,
            isNotNull,
            reason: 'Failed to retrieve user ID.',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${authResponse.keyId!}:${authResponse.key!}",
            ),
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          final secondAuthKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${secondAuthKey.id!}:${secondAuthKey.key!}",
            ),
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

          await UserAuthentication.signOutAllDevices(session);

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
        'when signing out the current device then only the current session is deleted',
        () async {
          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(
            userId,
            isNotNull,
            reason: 'Failed to retrieve user ID.',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${authResponse.keyId!}:${authResponse.key!}",
            ),
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          final secondAuthKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${secondAuthKey.id!}:${secondAuthKey.key!}",
            ),
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason: 'Expected two auth keys.',
          );

          await UserAuthentication.signOutCurrentDevice(session);

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

      test(
        'when userId is provided then the user is signed out all devices',
        () async {
          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(
            userId,
            isNotNull,
            reason: 'Failed to retrieve user ID.',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${authResponse.keyId!}:${authResponse.key!}",
            ),
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          final secondAuthKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${secondAuthKey.id!}:${secondAuthKey.key!}",
            ),
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason: 'Expected two auth keys.',
          );

          await UserAuthentication.signOutAllDevices(session, userId: userId);

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
        'when using deprecated signOutUser method then all auth keys are deleted',
        () async {
          var authResponse =
              await Emails.authenticate(session, email, password);
          expect(
            authResponse.success,
            isTrue,
            reason: 'Failed to authenticate user.',
          );

          var userId = authResponse.userInfo?.id;
          expect(
            userId,
            isNotNull,
            reason: 'Failed to retrieve user ID.',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${authResponse.keyId!}:${authResponse.key!}",
            ),
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          final secondAuthKey = await UserAuthentication.signInUser(
            session,
            userId!,
            'email',
          );

          session.updateAuthenticated(
            await authenticationHandler(
              session,
              "${secondAuthKey.id!}:${secondAuthKey.key!}",
            ),
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason: 'Expected two auth keys.',
          );

          // Use the deprecated method to sign out.
          // ignore: deprecated_member_use
          await UserAuthentication.signOutUser(session);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            isEmpty,
            reason:
                'Expected all auth keys to be deleted after using deprecated signOutUser method.',
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.afterEach,
  );
}
