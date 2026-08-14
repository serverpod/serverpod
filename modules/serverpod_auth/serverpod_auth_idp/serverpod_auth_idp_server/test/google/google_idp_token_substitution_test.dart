import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

/// Tests that the verified ID token - and only the verified ID token - decides
/// which account a Google login authenticates.
///
/// `fetchAccountDetails` verifies the ID token against Google's JWKS with the
/// audience pinned to this application's client ID. When an access token is
/// supplied as well, it then reads `/oauth2/v3/userinfo` and takes the identity
/// from there instead.
///
/// That endpoint honours any valid access token regardless of which OAuth
/// client minted it, so an access token is not bound to this application the
/// way an ID token is. An attacker who runs their own Google OAuth app can
/// obtain an access token for a victim of that app, pair it with their own
/// genuine ID token for this application, and have the login resolve to the
/// victim's account.
///
/// The invariant: an access token may enrich the profile, never redirect the
/// login onto a different account.
void main() {
  withServerpod('Given two users with linked Google accounts,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late GoogleIdp googleIdp;
    late UuidValue signingInAuthUserId;
    late UuidValue otherAuthUserId;

    const signingInGoogleSub = 'google-sub-signing-in';
    const otherGoogleSub = 'google-sub-other';

    setUp(() async {
      session = sessionBuilder.build();

      googleIdp = GoogleIdp(
        _googleIdpConfig(),
        tokenIssuer: const TestTokenIssuer(),
        userProfiles: UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        ),
      );

      signingInAuthUserId = await _createGoogleUser(
        session,
        userIdentifier: signingInGoogleSub,
      );
      otherAuthUserId = await _createGoogleUser(
        session,
        userIdentifier: otherGoogleSub,
      );
    });

    test(
      'when an ID token is paired with an access token belonging to a '
      'different Google account, then no session is issued for the account '
      'the access token belongs to.',
      () async {
        AuthSuccess result;
        try {
          result = await _login(
            googleIdp,
            session,
            idTokenSubject: signingInGoogleSub,
            userInfo: _userInfo(subject: otherGoogleSub),
          );
        } on Exception {
          // Rejecting the mismatched pair outright is an acceptable outcome;
          // what matters is that it does not resolve to the other account.
          return;
        }

        expect(
          result.authUserId,
          isNot(otherAuthUserId),
          reason:
              'The verified ID token names the signing-in user, so the '
              'userinfo response fetched with the substituted access token '
              'must not be able to redirect the login onto another account.',
        );
      },
    );

    test(
      'when an ID token is paired with an access token belonging to a '
      'different Google account, then the login is rejected.',
      () async {
        await expectLater(
          _login(
            googleIdp,
            session,
            idTokenSubject: signingInGoogleSub,
            userInfo: _userInfo(subject: otherGoogleSub),
          ),
          throwsA(isA<GoogleIdTokenVerificationException>()),
        );
      },
    );

    test(
      'when an ID token is paired with an access token for the same Google '
      'account, then the login succeeds for that account.',
      () async {
        final result = await _login(
          googleIdp,
          session,
          idTokenSubject: signingInGoogleSub,
          userInfo: _userInfo(subject: signingInGoogleSub),
        );

        expect(result.authUserId, signingInAuthUserId);
      },
    );

    test(
      'when an ID token is presented without an access token, '
      'then the login succeeds for the account named by the ID token.',
      () async {
        final result = await _login(
          googleIdp,
          session,
          idTokenSubject: signingInGoogleSub,
          userInfo: null,
        );

        expect(result.authUserId, signingInAuthUserId);
      },
    );
  });
}

/// Signs in through [GoogleIdp.login] with Google's JWKS and userinfo
/// endpoints served locally.
///
/// The ID token is genuinely signed and genuinely verified - only the network
/// is stubbed. A null [userInfo] means no access token is sent, so userinfo is
/// never consulted.
Future<AuthSuccess> _login(
  final GoogleIdp googleIdp,
  final Session session, {
  required final String idTokenSubject,
  required final Map<String, dynamic>? userInfo,
}) {
  final idToken = createSignedIdToken(
    subject: idTokenSubject,
    issuer: 'https://accounts.google.com',
    audience: _googleClientId,
    claims: {
      'email': '$idTokenSubject@gmail.com',
      'email_verified': true,
      'given_name': 'IdToken',
      'name': 'IdToken Name',
    },
  );

  return http.runWithClient(
    () => googleIdp.login(
      session,
      idToken: idToken,
      accessToken: userInfo == null ? null : 'access-token-for-another-client',
    ),
    () => _googleClient(userInfo: userInfo),
  );
}

/// A response body as returned by Google's `/oauth2/v3/userinfo`.
Map<String, dynamic> _userInfo({required final String subject}) {
  return {
    'sub': subject,
    'email': '$subject@gmail.com',
    'email_verified': true,
    'name': 'Userinfo Name',
    'given_name': 'Userinfo',
  };
}

http.Client _googleClient({required final Map<String, dynamic>? userInfo}) {
  final certsUrl = Uri.https('www.googleapis.com', '/oauth2/v3/certs');
  final userInfoUrl = Uri.https('www.googleapis.com', '/oauth2/v3/userinfo');

  return MockClient((final request) async {
    if (request.url == certsUrl) {
      return http.Response(
        jsonEncode({
          'keys': [testRsaPublicJwk],
        }),
        200,
      );
    }

    if (request.url == userInfoUrl) {
      if (userInfo == null) {
        fail('userinfo was requested even though no access token was sent.');
      }
      return http.Response(jsonEncode(userInfo), 200);
    }

    fail('Unexpected request to ${request.url}');
  });
}

Future<UuidValue> _createGoogleUser(
  final Session session, {
  required final String userIdentifier,
}) async {
  final authUser = await const AuthUsers().create(session);

  await GoogleAccount.db.insertRow(
    session,
    GoogleAccount(
      userIdentifier: userIdentifier,
      email: '$userIdentifier@gmail.com',
      authUserId: authUser.id,
    ),
  );

  return authUser.id;
}

GoogleIdpConfig _googleIdpConfig() {
  return GoogleIdpConfig(
    clientSecret: GoogleClientSecret.fromJson({
      'web': {
        'client_id': _googleClientId,
        'client_secret': 'secret',
        'redirect_uris': ['uri'],
      },
    }),
  );
}

const _googleClientId = 'test-client-id';
