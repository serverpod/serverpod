import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  var userId = 1;

  group('Given an authenticated user', () {
    tearDown(() async {
      session.updateAuthenticated(null);
      await AuthKey.db.deleteWhere(
        session,
        where: (row) => Constant.bool(true),
      );
    });

    test(
      'when updateSession is true then the session is updated with authentication info',
      () async {
        await UserAuthentication.signInUser(
          session,
          userId,
          'email',
          updateSession: true,
        );

        var auth = await session.authenticated;

        expect(
          auth,
          isNotNull,
          reason:
              'Expected session to be updated with user authentication info.',
        );
        expect(
          auth?.userIdentifier,
          equals('$userId'),
          reason: 'User ID in session should match the signed-in user ID.',
        );
        expect(
          auth?.userId,
          equals(userId),
          reason: 'User ID in session should match the signed-in user ID.',
        );
      },
    );

    test(
      'when updateSession is false then the session is not updated with authentication info',
      () async {
        await UserAuthentication.signInUser(
          session,
          userId,
          'email',
          updateSession: false,
        );

        var auth = await session.authenticated;

        expect(
          auth,
          isNull,
          reason:
              'Expected session to not be updated with user authentication info.',
        );
      },
    );

    test(
      'when updateSession is not provided (default behavior) then the session is updated with authentication info',
      () async {
        await UserAuthentication.signInUser(
          session,
          userId,
          'email',
        );

        var auth = await session.authenticated;

        expect(
          auth,
          isNotNull,
          reason:
              'Expected session to be updated with user authentication info by default.',
        );
        expect(
          auth?.userIdentifier,
          equals('$userId'),
          reason: 'User ID in session should match the signed-in user ID.',
        );
        expect(
          auth?.userId,
          equals(userId),
          reason: 'User ID in session should match the signed-in user ID.',
        );
      },
    );
  });
}
