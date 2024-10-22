import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an authenticated user',
    (sessionBuilder, _) {
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
        'when signing out all auth keys are deleted',
        () async {
          var authResponse = await Emails.authenticate(
            session,
            email,
            password,
          );
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

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          await UserAuthentication.signInUser(
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
                'Expected two auth keys after signing in on another session.',
          );

          await UserAuthentication.signOutUser(session);

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );

          expect(
            authKeys,
            isEmpty,
            reason: 'Expected all auth keys to be deleted after signing out.',
          );
        },
      );

      test(
        'when revoking auth key only one auth key is deleted',
        () async {
          var authResponse = await Emails.authenticate(
            session,
            email,
            password,
          );
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

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(2),
            reason: 'Expected two auth keys.',
          );

          await UserAuthentication.revokeAuthKey(
            session,
            authKeyId: secondAuthKey.id!,
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason:
                'Expected one auth key to remain after revoking one session.',
          );
        },
      );

      test(
        'when userId is provided all auth keys are deleted',
        () async {
          var authResponse = await Emails.authenticate(
            session,
            email,
            password,
          );
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

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            hasLength(1),
            reason: 'Expected one auth key initially.',
          );

          await UserAuthentication.signInUser(
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
            reason: 'Expected two auth keys.',
          );

          await UserAuthentication.signOutUser(
            session,
            userId: userId,
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId),
          );
          expect(
            authKeys,
            isEmpty,
            reason: 'Expected all auth keys to be deleted.',
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.afterEach,
  );
}
