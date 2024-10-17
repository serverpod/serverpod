import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an authenticated user', () {
    var userName = 'test';
    var email = 'test@serverpod.dev';
    var password = 'password';

    setUp(() async {
      await Emails.createUser(session, userName, email, password);
    });

    tearDown(() async {
      await Future.wait([
        UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        EmailAuth.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        AuthKey.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      ]);
    });

    test(
      'when signing out all devices then all auth keys are deleted',
      () async {
        var authResponse = await Emails.authenticate(session, email, password);
        expect(
          authResponse.success,
          isTrue,
          reason: 'Failed to authenticate user.',
        );

        var userId = authResponse.userInfo?.id;
        expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

        session.updateAuthenticated(
          await authenticationHandler(
            session,
            "${authResponse.keyId!}:${authResponse.key!}",
          ),
        );

        var authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );

        expect(
          authKeys,
          hasLength(1),
          reason: 'Expected one auth key initially.',
        );

        // Sign in user on another device then add a second auth key.
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

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );

        expect(
          authKeys,
          hasLength(2),
          reason: 'Expected two auth keys after signing in on another device.',
        );

        await UserAuthentication.signOutAllDevices(session);

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
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
        var authResponse = await Emails.authenticate(session, email, password);
        expect(
          authResponse.success,
          isTrue,
          reason: 'Failed to authenticate user.',
        );

        var userId = authResponse.userInfo?.id;
        expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

        session.updateAuthenticated(
          await authenticationHandler(
            session,
            "${authResponse.keyId!}:${authResponse.key!}",
          ),
        );

        var authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(authKeys, hasLength(1),
            reason: 'Expected one auth key initially.');

        // Sign in user on another device then add a second auth key.
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

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(authKeys, hasLength(2), reason: 'Expected two auth keys.');

        await UserAuthentication.signOutCurrentDevice(session);

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
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
        var authResponse = await Emails.authenticate(session, email, password);
        expect(
          authResponse.success,
          isTrue,
          reason: 'Failed to authenticate user.',
        );

        var userId = authResponse.userInfo?.id;
        expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

        session.updateAuthenticated(
          await authenticationHandler(
            session,
            "${authResponse.keyId!}:${authResponse.key!}",
          ),
        );

        var authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(authKeys, hasLength(1),
            reason: 'Expected one auth key initially.');

        // Sign in user on another device then add a second auth key.
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

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(authKeys, hasLength(2), reason: 'Expected two auth keys.');

        await UserAuthentication.signOutAllDevices(session, userId: userId);

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
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
        var authResponse = await Emails.authenticate(session, email, password);
        expect(
          authResponse.success,
          isTrue,
          reason: 'Failed to authenticate user.',
        );

        var userId = authResponse.userInfo?.id;
        expect(userId, isNotNull, reason: 'Failed to retrieve user ID.');

        session.updateAuthenticated(
          await authenticationHandler(
            session,
            "${authResponse.keyId!}:${authResponse.key!}",
          ),
        );

        var authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(
          authKeys,
          hasLength(1),
          reason: 'Expected one auth key initially.',
        );

        // Sign in user on another device then add a second auth key.
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

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(authKeys, hasLength(2), reason: 'Expected two auth keys.');

        // Use the deprecated method to sign out.
        // ignore: deprecated_member_use
        await UserAuthentication.signOutUser(session);

        authKeys = await session.db.find<AuthKey>(
          where: AuthKey.t.userId.equals(userId),
        );
        expect(
          authKeys,
          isEmpty,
          reason:
              'Expected all auth keys to be deleted after using deprecated signOutUser method.',
        );
      },
    );
  });
}
