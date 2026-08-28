import 'package:http/http.dart' as http;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';
import 'apple_test_utils.dart';

/// Reproduces the Sign in with Apple account takeover, at the endpoint.
///
/// Apple publishes one global JWKS, so any developer team's token carries a
/// signature this server accepts. The endpoint then resolved the account by
/// the token's email address, so a token obtained from a victim in the
/// attacker's own app authenticated as whoever held that address here.
///
/// The invariant: only a token Apple minted for this application can sign
/// anyone in.
void main() {
  const victimEmail = 'victim@example.com';
  const attackerAppleSubject = '000999.attacker.0001';

  withServerpod('Given an existing email/password account,', (
    final sessionBuilder,
    final endpoints,
  ) {
    setUp(configureAppleTestAuth);
    tearDown(resetAppleTestAuth);

    setUp(() async {
      final session = sessionBuilder.build();
      final user = await Emails.createUser(
        session,
        'victim',
        victimEmail,
        'a-password-the-attacker-does-not-know',
      );
      expect(user, isNotNull);
    });

    test(
      'when authenticating with another app\'s token for that email, '
      'then no session is issued.',
      () async {
        final response = await _authenticate(
          endpoints,
          sessionBuilder,
          identityToken: signAppleIdentityToken(
            subject: attackerAppleSubject,
            email: victimEmail,
            audience: 'com.attacker.their-own-app',
          ),
          userIdentifier: attackerAppleSubject,
          email: victimEmail,
        );

        expect(
          response.success,
          isFalse,
          reason: 'Only the audience separates this token from one of ours.',
        );
        expect(
          response.failReason,
          AuthenticationFailReason.invalidCredentials,
        );
      },
    );

    test(
      'when authenticating with an expired token for that email, '
      'then no session is issued.',
      () async {
        final longAgo = DateTime.now().toUtc().subtract(
          const Duration(days: 30),
        );

        final response = await _authenticate(
          endpoints,
          sessionBuilder,
          identityToken: signAppleIdentityToken(
            subject: attackerAppleSubject,
            email: victimEmail,
            issuedAt: longAgo,
            expiresAt: longAgo.add(const Duration(minutes: 10)),
          ),
          userIdentifier: attackerAppleSubject,
          email: victimEmail,
        );

        expect(
          response.success,
          isFalse,
          reason: 'A captured token must not stay usable indefinitely.',
        );
      },
    );

    test(
      'when authenticating while Apple\'s key endpoint is unreachable, '
      'then it is not the caller\'s fault.',
      () async {
        final response = await _authenticate(
          endpoints,
          sessionBuilder,
          identityToken: signAppleIdentityToken(
            subject: attackerAppleSubject,
            email: victimEmail,
          ),
          userIdentifier: attackerAppleSubject,
          email: victimEmail,
          client: () => appleKeysClient(statusCode: 503),
        );

        expect(
          response.failReason,
          AuthenticationFailReason.internalError,
          reason: 'An outage at Apple is not a bad credential.',
        );
      },
    );

    group(
      'when authenticating with a token carrying that email unverified,',
      () {
        late AuthenticationResponse response;

        setUp(() async {
          response = await _authenticate(
            endpoints,
            sessionBuilder,
            identityToken: signAppleIdentityToken(
              subject: attackerAppleSubject,
              email: victimEmail,
              emailVerified: false,
            ),
            userIdentifier: attackerAppleSubject,
            email: victimEmail,
          );
        });

        test('then it does not sign in as that account.', () async {
          expect(response.userInfo?.email, isNot(victimEmail));
        });

        test('then the address is not stored on the new account.', () async {
          expect(
            response.userInfo?.email,
            isNull,
            reason: 'A stored address stays linkable by the next lookup.',
          );
        });
      },
    );

    group('and Sign in with Apple is not configured,', () {
      setUp(() => AuthConfig.set(AuthConfig()));

      test(
        'when authenticating with an otherwise valid token, '
        'then no session is issued.',
        () async {
          final response = await _authenticate(
            endpoints,
            sessionBuilder,
            identityToken: signAppleIdentityToken(
              subject: attackerAppleSubject,
              email: victimEmail,
            ),
            userIdentifier: attackerAppleSubject,
            email: victimEmail,
          );

          expect(
            response.success,
            isFalse,
            reason: 'An unconfigured server cannot tell whose token this is.',
          );
          expect(
            response.failReason,
            AuthenticationFailReason.internalError,
            reason: 'A misconfiguration must not read as a bad credential.',
          );
        },
      );
    });
  });

  withServerpod('Given no existing account,', (
    final sessionBuilder,
    final endpoints,
  ) {
    setUp(configureAppleTestAuth);
    tearDown(resetAppleTestAuth);

    test(
      'when authenticating with a token minted for this application, '
      'then a session is issued.',
      () async {
        const subject = '000123.legitimate.0001';

        final response = await _authenticate(
          endpoints,
          sessionBuilder,
          identityToken: signAppleIdentityToken(
            subject: subject,
            email: 'new-user@example.com',
          ),
          userIdentifier: subject,
          email: 'new-user@example.com',
        );

        expect(response.success, isTrue, reason: response.failReason?.name);
        expect(response.userInfo?.userIdentifier, subject);
      },
    );
  });
}

/// Calls the Apple endpoint with Apple's JWKS endpoint served locally.
Future<AuthenticationResponse> _authenticate(
  final TestEndpoints endpoints,
  final TestSessionBuilder sessionBuilder, {
  required final String identityToken,
  required final String userIdentifier,
  required final String? email,
  final http.Client Function()? client,
}) {
  return http.runWithClient(
    () => endpoints.apple.authenticate(
      sessionBuilder,
      AppleAuthInfo(
        userIdentifier: userIdentifier,
        email: email,
        fullName: 'Test User',
        nickname: 'test',
        identityToken: identityToken,
        authorizationCode: 'authorization-code',
      ),
    ),
    client ?? appleKeysClient,
  );
}
