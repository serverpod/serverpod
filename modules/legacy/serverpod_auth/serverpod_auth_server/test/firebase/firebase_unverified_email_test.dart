import 'package:http/testing.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/business/firebase_auth.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';
import 'firebase_auth_mock.dart';

/// Tests that a Firebase sign-in cannot reach an existing account through an
/// email address Firebase has not verified.
///
/// The endpoint resolves the account by email before falling back to the
/// Firebase subject, and Firebase issues valid tokens carrying
/// `email_verified: false` for addresses a user typed in at registration. An
/// attacker who self-registers the victim's address in the application's own
/// Firebase project would be signed in as the victim.
///
/// The invariant: an unverified address identifies nobody.
void main() {
  const victimEmail = 'victim@example.com';
  const attackerUid = 'attacker-firebase-uid';

  withServerpod('Given an existing email/password account,', (
    final sessionBuilder,
    final endpoints,
  ) {
    Future<AuthenticationResponse> signIn({
      required final Object? emailVerified,
    }) => endpoints.firebase.authenticate(
      sessionBuilder,
      generateMockIdToken(
        uid: attackerUid,
        overrides: {'email': victimEmail, 'email_verified': emailVerified},
      ),
    );

    setUp(() async {
      _installFirebaseAuthManager(uid: attackerUid);

      final session = sessionBuilder.build();
      final user = await Emails.createUser(
        session,
        'victim',
        victimEmail,
        'a-password-the-attacker-does-not-know',
      );
      expect(user, isNotNull);
    });

    tearDown(() => FirebaseAuth.authManagerOverride = null);

    group(
      'when authenticating with a token carrying that email unverified,',
      () {
        late AuthenticationResponse response;

        setUp(() async {
          response = await signIn(emailVerified: false);
        });

        test('then it does not sign in as that account.', () async {
          expect(
            response.userInfo?.email,
            isNot(victimEmail),
            reason: 'Only a verified address says who the caller is.',
          );
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

    test(
      'when authenticating with a token carrying that email verified, '
      'then it signs in as that account.',
      () async {
        final response = await signIn(emailVerified: true);

        expect(response.success, isTrue, reason: response.failReason?.name);
        expect(
          response.userInfo?.email,
          victimEmail,
          reason: 'Reaching an account by verified address still works.',
        );
      },
    );

    test(
      'when authenticating with a token sending `email_verified` as the '
      'string true, then the address counts as verified.',
      () async {
        final response = await signIn(emailVerified: 'true');

        expect(
          response.success,
          isTrue,
          reason: 'A claim of the wrong type must not take the sign in down.',
        );
        expect(
          response.userInfo?.email,
          victimEmail,
          reason: 'The Apple path accepts the string form, so this must too.',
        );
      },
    );

    test(
      'when authenticating with a token sending `email_verified` as a number, '
      'then the sign in still completes without the address.',
      () async {
        final response = await signIn(emailVerified: 1);

        expect(response.success, isTrue);
        expect(
          response.userInfo?.email,
          isNull,
          reason: 'An unreadable claim is not Firebase vouching for anything.',
        );
      },
    );
  });
}

/// Points [FirebaseAuth] at a manager whose Firebase and OpenID backends are
/// served locally, so tokens from [generateMockIdToken] verify.
void _installFirebaseAuthManager({required final String uid}) {
  FirebaseAuth.authManagerOverride = FirebaseAuthManager(
    testAccountServiceJson,
    authClient: MockClient(
      FirebaseAuthBackendMock(
        userJson: crateUserRecord(
          uuid: uid,
          validSince: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ).onHttpCall,
    ),
    openIdClient: MockClient(FirebaseOpenIdBackendMock().onHttpCall),
  );
}
