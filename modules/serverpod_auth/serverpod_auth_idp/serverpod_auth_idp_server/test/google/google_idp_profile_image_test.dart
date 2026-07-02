import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

void main() {
  withServerpod(
    'Given a Google-backed user profile with an image,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UserProfile userProfile;
      late GoogleIdp googleIdp;

      const googleUserIdentifier = 'google-user-id';
      const googleProfileImageUrl =
          'https://serverpod.dev/google-profile-image.png';

      setUp(() async {
        session = sessionBuilder.build();
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        );
        googleIdp = GoogleIdp(
          _googleIdpConfig(),
          tokenIssuer: const TestTokenIssuer(),
          userProfiles: userProfiles,
        );

        final authUser = await const AuthUsers().create(session);
        authUserId = authUser.id;

        await GoogleAccount.db.insertRow(
          session,
          GoogleAccount(
            userIdentifier: googleUserIdentifier,
            email: 'test-${const Uuid().v4()}@gmail.com',
            authUserId: authUserId,
          ),
        );

        await userProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            fullName: 'Google User',
            email: 'test@example.com',
          ),
          imageSource: UserImageFromUrl.parse(googleProfileImageUrl),
        );

        userProfile = (await UserProfile.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        ))!;
      });

      test(
        'when the user signs in with Google again, '
        'then no additional profile image row is created.',
        () async {
          final imagesBeforeSignIn = await UserProfileImage.db.find(
            session,
            where: (final t) => t.userProfileId.equals(userProfile.id!),
          );
          expect(imagesBeforeSignIn, hasLength(1));

          final idToken = _createGoogleIdToken(
            googleUserIdentifier: googleUserIdentifier,
            profileImageUrl: googleProfileImageUrl,
          );

          await http.runWithClient(
            () => googleIdp.login(
              session,
              idToken: idToken,
              accessToken: null,
            ),
            googleJwksClient,
          );

          final imagesAfterSignIn = await UserProfileImage.db.find(
            session,
            where: (final t) => t.userProfileId.equals(userProfile.id!),
          );
          expect(imagesAfterSignIn, hasLength(1));
        },
      );
    },
  );
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

String _createGoogleIdToken({
  required final String googleUserIdentifier,
  required final String profileImageUrl,
}) {
  return createSignedIdToken(
    subject: googleUserIdentifier,
    issuer: 'https://accounts.google.com',
    audience: _googleClientId,
    claims: {
      'email': 'test@example.com',
      'given_name': 'Google',
      'name': 'Google User',
      'picture': profileImageUrl,
      'email_verified': true,
    },
  );
}

const _googleClientId = 'test-client-id';
