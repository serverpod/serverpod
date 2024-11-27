import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  var userId1 = 1;
  var userId2 = 2;
  var invalidUserId = -1;
  var invalidAuthKeyId = -1;

  withServerpod(
    'Given a user signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        await Future.wait([
          UserAuthentication.signInUser(session, userId1, 'email'),
          UserAuthentication.signInUser(session, userId1, 'email'),
        ]);

        var authKeys = await AuthKey.db.find(
          session,
          where: (row) => row.userId.equals(userId1),
        );
        assert(authKeys.length == 2, 'Expected 2 auth keys after signing in.');
      });

      tearDown(() async {
        await AuthKey.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      test(
        'when signing out then user is signed out of all devices',
        () async {
          await UserAuthentication.signOutUser(session, userId: userId1);

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          expect(authKeys, isEmpty);
        },
      );

      test(
        'when revoking auth key then only the revoked auth key is deleted',
        () async {
          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          var secondAuthKey = authKeys.last;

          await UserAuthentication.revokeAuthKey(
            session,
            authKeyId: "${secondAuthKey.id!}",
          );

          authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          expect(authKeys, hasLength(1));
        },
      );

      test(
        'when signing out with invalid userId then no keys are deleted',
        () async {
          await UserAuthentication.signOutUser(session, userId: invalidUserId);

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          expect(authKeys, hasLength(2));
        },
      );

      test(
        'when revoking with invalid authKeyId then no keys are deleted',
        () async {
          await UserAuthentication.revokeAuthKey(
            session,
            authKeyId: "$invalidAuthKeyId",
          );

          var authKeys = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          expect(authKeys, hasLength(2));
        },
      );
    },
  );

  withServerpod(
    'Given two users signed in to multiple devices',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        await Future.wait([
          UserAuthentication.signInUser(session, userId1, 'email'),
          UserAuthentication.signInUser(session, userId1, 'email'),
          UserAuthentication.signInUser(session, userId2, 'email'),
          UserAuthentication.signInUser(session, userId2, 'email'),
        ]);

        var authKeysUser1 = await AuthKey.db.find(
          session,
          where: (row) => row.userId.equals(userId1),
        );
        var authKeysUser2 = await AuthKey.db.find(
          session,
          where: (row) => row.userId.equals(userId2),
        );
        assert(authKeysUser1.length == 2, 'Expected 2 auth keys for user 1.');
        assert(authKeysUser2.length == 2, 'Expected 2 auth keys for user 2.');
      });

      tearDown(() async {
        await AuthKey.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      test(
        'when signing out user1 then user1 is signed out but user2 remains signed in',
        () async {
          await UserAuthentication.signOutUser(session, userId: userId1);

          var authKeysUser1 = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          var authKeysUser2 = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId2),
          );
          expect(authKeysUser1, isEmpty);
          expect(authKeysUser2, hasLength(2));
        },
      );

      test(
        'when revoking auth key for user1 then user1 loses one authentication key but user2 remains unaffected',
        () async {
          var authKeysUser1 = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          var secondAuthKeyUser1 = authKeysUser1.last;

          await UserAuthentication.revokeAuthKey(
            session,
            authKeyId: "${secondAuthKeyUser1.id!}",
          );

          var authKeysUser1After = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId1),
          );
          var authKeysUser2 = await AuthKey.db.find(
            session,
            where: (row) => row.userId.equals(userId2),
          );
          expect(authKeysUser1After, hasLength(1));
          expect(authKeysUser2, hasLength(2));
        },
      );
    },
  );
}
