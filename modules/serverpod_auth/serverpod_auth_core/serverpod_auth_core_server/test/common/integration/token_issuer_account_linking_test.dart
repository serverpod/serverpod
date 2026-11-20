import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../common/business/fakes/fakes.dart';
import '../../serverpod_test_tools.dart';

/// Verifies the sign-in policy in [TokenIssuer.issueToken], which normally
/// rejects an authenticated caller asking for a token for someone else and
/// makes an exception only for an account link in progress.
void main() {
  const authUsers = AuthUsers();
  const accountLinkRequests = AccountLinkRequests();

  void setUpAuthServices() {
    AuthServices.set(
      tokenManagerBuilders: [
        FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
      ],
      identityProviderBuilders: [],
    );
  }

  Session sessionFor(
    final TestSessionBuilder sessionBuilder, {
    required final UuidValue authUserId,
    required final String authId,
  }) {
    return sessionBuilder
        .copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            authUserId.toString(),
            {},
            authId: authId,
          ),
        )
        .build();
  }

  Future<void> attachSignIn(
    final Session session, {
    required final UuidValue authUserId,
  }) {
    return session.db.transaction(
      (final transaction) => AccountLinkRequests.attachToActiveLinkRequest(
        session,
        authUserId: authUserId,
        method: 'google',
        newAccount: true,
        transaction: transaction,
      ),
    );
  }

  Future<AuthSuccess> issueTokenFor(
    final Session session, {
    required final UuidValue authUserId,
  }) {
    return AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: authUserId,
      method: 'google',
    );
  }

  withServerpod('Given two auth users,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AuthUserModel user;
    late AuthUserModel otherUser;
    const authId = 'session-a';

    setUp(() async {
      setUpAuthServices();
      final setupSession = sessionBuilder.build();
      user = await authUsers.create(setupSession);
      otherUser = await authUsers.create(setupSession);
    });

    test(
      'when an unauthenticated caller signs in, then a token is issued.',
      () async {
        final authSuccess = await issueTokenFor(
          sessionBuilder.build(),
          authUserId: user.id,
        );

        expect(authSuccess.authUserId, user.id);
      },
    );

    test('when an authenticated caller re-issues for themself, then a token is '
        'issued.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );

      final authSuccess = await issueTokenFor(session, authUserId: user.id);

      expect(authSuccess.authUserId, user.id);
    });

    test('when an authenticated caller signs in as someone else without a link '
        'request, then it is rejected.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );

      await expectLater(
        issueTokenFor(session, authUserId: otherUser.id),
        throwsA(isA<SignInWhileAuthenticatedException>()),
      );
    });

    test('when a link request exists but nothing has attached, then signing in '
        'as someone else is still rejected.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );
      await accountLinkRequests.createLinkRequest(session);

      await expectLater(
        issueTokenFor(session, authUserId: otherUser.id),
        throwsA(isA<SignInWhileAuthenticatedException>()),
      );
    });

    test('when the sign-in has attached to a link request, then a token is '
        'issued for the linked account.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );
      await accountLinkRequests.createLinkRequest(session);
      await attachSignIn(session, authUserId: otherUser.id);

      final authSuccess = await issueTokenFor(
        session,
        authUserId: otherUser.id,
      );

      expect(authSuccess.authUserId, otherUser.id);
    });

    test('when the link request attached a different account, then signing in '
        'is rejected.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );
      final thirdUser = await authUsers.create(session);
      await accountLinkRequests.createLinkRequest(session);
      await attachSignIn(session, authUserId: thirdUser.id);

      await expectLater(
        issueTokenFor(session, authUserId: otherUser.id),
        throwsA(isA<SignInWhileAuthenticatedException>()),
      );
    });

    test('when the link request was cancelled, then signing in as someone else '
        'is rejected again.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );
      await accountLinkRequests.createLinkRequest(session);
      await attachSignIn(session, authUserId: otherUser.id);
      await accountLinkRequests.cancelLinkRequest(session);

      await expectLater(
        issueTokenFor(session, authUserId: otherUser.id),
        throwsA(isA<SignInWhileAuthenticatedException>()),
      );
    });

    test('when the link request belongs to another session, then signing in as '
        'someone else is rejected.', () async {
      final session = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: authId,
      );
      await accountLinkRequests.createLinkRequest(session);
      await attachSignIn(session, authUserId: otherUser.id);

      final otherDeviceSession = sessionFor(
        sessionBuilder,
        authUserId: user.id,
        authId: 'session-b',
      );

      await expectLater(
        issueTokenFor(otherDeviceSession, authUserId: otherUser.id),
        throwsA(isA<SignInWhileAuthenticatedException>()),
      );
    });
  });
}
