import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../email/test_utils/email_idp_test_fixture.dart';
import '../test_tools/serverpod_test_tools.dart';

/// Verifies that identity provider sign-ins hand themselves to an active
/// account link request, and that ordinary sign-ins are left alone.
void main() {
  const authUsers = AuthUsers();
  const accountLinkRequests = AccountLinkRequests();

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

  Future<AccountLinkRequest?> requestFor(
    final Session session,
    final UuidValue authUserId,
  ) {
    return AccountLinkRequest.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
    );
  }

  withServerpod(
    'Given a signed-in user linking an existing email account,',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late EmailIdpTestFixture fixture;
      late Session linkingSession;
      late AuthUserModel user;
      late AuthUserModel emailUser;
      const email = 'link-target@serverpod.dev';
      const password = 'Password123!';
      const authId = 'session-a';

      setUp(() async {
        final setupSession = sessionBuilder.build();
        fixture = EmailIdpTestFixture(
          config: const EmailIdpConfig(
            secretHashPepper: 'pepper',
            registrationVerificationCodeGenerator: _fixedVerificationCode,
          ),
        );

        user = await authUsers.create(setupSession);
        emailUser = await authUsers.create(setupSession);
        await fixture.createEmailAccount(
          setupSession,
          authUserId: emailUser.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );

        linkingSession = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: authId,
        );
      });

      tearDown(() async {
        await fixture.tearDown(sessionBuilder.build());
        await AccountLinkRequest.db.deleteWhere(
          sessionBuilder.build(),
          where: (final t) => Constant.bool(true),
        );
      });

      test(
        'when the user signs in with that account, then it is attached to the '
        'link request and a token is issued for it.',
        () async {
          await accountLinkRequests.createLinkRequest(linkingSession);

          final authSuccess = await fixture.emailIdp.login(
            linkingSession,
            email: email,
            password: password,
          );

          expect(authSuccess.authUserId, emailUser.id);

          final request = await requestFor(linkingSession, user.id);
          expect(request!.linkedAuthUserId, emailUser.id);
          expect(request.linkedMethod, 'email');
          expect(request.linkedAccountWasCreated, isFalse);
        },
      );

      test(
        'when completing account creation for a new email account, then it '
        'attaches with newAccount true.',
        () async {
          await accountLinkRequests.createLinkRequest(linkingSession);

          const newEmail = 'new-link-account@serverpod.dev';
          final accountRequestId = await fixture.emailIdp.startRegistration(
            linkingSession,
            email: newEmail,
          );

          final registrationToken = await fixture.emailIdp
              .verifyRegistrationCode(
                linkingSession,
                accountRequestId: accountRequestId,
                verificationCode: _fixedVerificationCode(),
              );

          final authSuccess = await fixture.emailIdp.finishRegistration(
            linkingSession,
            registrationToken: registrationToken,
            password: 'NewPassword123!',
          );

          final request = await requestFor(linkingSession, user.id);
          expect(request!.linkedAuthUserId, authSuccess.authUserId);
          expect(request.linkedMethod, 'email');
          expect(request.linkedAccountWasCreated, isTrue);
        },
      );

      test(
        'when there is no link request, then signing in as another user is '
        'rejected.',
        () async {
          await expectLater(
            fixture.emailIdp.login(
              linkingSession,
              email: email,
              password: password,
            ),
            throwsA(isA<SignInWhileAuthenticatedException>()),
          );

          expect(await requestFor(linkingSession, user.id), isNull);
        },
      );

      test(
        'when the sign-in comes from another device, then nothing is attached '
        'and it is rejected.',
        () async {
          await accountLinkRequests.createLinkRequest(linkingSession);

          final otherDeviceSession = sessionFor(
            sessionBuilder,
            authUserId: user.id,
            authId: 'session-b',
          );

          await expectLater(
            fixture.emailIdp.login(
              otherDeviceSession,
              email: email,
              password: password,
            ),
            throwsA(isA<SignInWhileAuthenticatedException>()),
          );

          final request = await requestFor(linkingSession, user.id);
          expect(request!.linkedAuthUserId, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given a signed-in user with an active link request,',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session linkingSession;
      late AuthUserModel user;
      late AnonymousIdp anonymousIdp;

      setUp(() async {
        final setupSession = sessionBuilder.build();
        anonymousIdp = AnonymousIdp(
          const AnonymousIdpConfig(),
          tokenManager: ServerSideSessionsTokenManager(
            config: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'test-session-key-hash-pepper',
            ),
            authUsers: authUsers,
          ),
          authUsers: authUsers,
        );

        user = await authUsers.create(setupSession);
        linkingSession = sessionFor(
          sessionBuilder,
          authUserId: user.id,
          authId: 'session-a',
        );
        await accountLinkRequests.createLinkRequest(linkingSession);
      });

      tearDown(() async {
        await AccountLinkRequest.db.deleteWhere(
          sessionBuilder.build(),
          where: (final t) => Constant.bool(true),
        );
      });

      test(
        'when an anonymous sign-in happens, then it does not attach and is '
        'rejected.',
        () async {
          // Linking a brand new anonymous identity into an account carries no
          // credential the user could sign in with again, so the anonymous
          // provider deliberately takes no part in linking.
          await expectLater(
            anonymousIdp.login(linkingSession),
            throwsA(isA<SignInWhileAuthenticatedException>()),
          );

          final request = await requestFor(linkingSession, user.id);
          expect(request!.linkedAuthUserId, isNull);
        },
      );
    },
  );
}

String _fixedVerificationCode() => '123456';
