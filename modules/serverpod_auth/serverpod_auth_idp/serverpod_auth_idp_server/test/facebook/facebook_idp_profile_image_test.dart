import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/facebook.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

void main() {
  withServerpod(
    'Given a Facebook-backed user profile with an image,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UserProfile userProfile;
      late FacebookIdp facebookIdp;

      const facebookUserIdentifier = 'facebook-user-id';
      const facebookProfileImageUrl =
          'https://serverpod.dev/facebook-profile-image.png';

      setUp(() async {
        session = sessionBuilder.build();
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        );
        facebookIdp = FacebookIdp(
          const FacebookIdpConfig(
            appId: _facebookAppId,
            appSecret: _facebookAppSecret,
          ),
          tokenManager: const TestTokenManager(),
          userProfiles: userProfiles,
        );

        final authUser = await const AuthUsers().create(session);
        authUserId = authUser.id;

        await FacebookAccount.db.insertRow(
          session,
          FacebookAccount(
            userIdentifier: facebookUserIdentifier,
            email: 'test-${const Uuid().v4()}@facebook.com',
            authUserId: authUserId,
          ),
        );

        await userProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            fullName: 'Facebook User',
            email: 'test@example.com',
          ),
          imageSource: UserImageFromUrl.parse(facebookProfileImageUrl),
        );

        userProfile = (await UserProfile.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        ))!;
      });

      test(
        'when the user signs in with Facebook again, '
        'then no additional profile image row is created.',
        () async {
          final imagesBeforeSignIn = await UserProfileImage.db.find(
            session,
            where: (final t) => t.userProfileId.equals(userProfile.id!),
          );
          expect(imagesBeforeSignIn, hasLength(1));

          await http.runWithClient(
            () => facebookIdp.login(
              session,
              accessToken: _facebookAccessToken,
            ),
            () => _facebookClient(
              userIdentifier: facebookUserIdentifier,
              profileImageUrl: facebookProfileImageUrl,
            ),
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

http.Client _facebookClient({
  required final String userIdentifier,
  required final String profileImageUrl,
}) {
  return MockClient((final request) async {
    final debugTokenUrl = Uri.https(
      'graph.facebook.com',
      '/debug_token',
      {
        'input_token': _facebookAccessToken,
        'access_token': '$_facebookAppId|$_facebookAppSecret',
      },
    );
    if (request.method == 'GET' && request.url == debugTokenUrl) {
      return http.Response(
        jsonEncode({
          'data': {
            'is_valid': true,
            'app_id': _facebookAppId,
          },
        }),
        200,
      );
    }

    final accountDetailsUrl = Uri.https(
      'graph.facebook.com',
      '/me',
      {
        'fields': 'id,name,first_name,last_name,email,picture.type(large)',
        'access_token': _facebookAccessToken,
      },
    );
    if (request.method == 'GET' && request.url == accountDetailsUrl) {
      return http.Response(
        jsonEncode({
          'id': userIdentifier,
          'email': 'test@example.com',
          'name': 'Facebook User',
          'first_name': 'Facebook',
          'last_name': 'User',
          'picture': {
            'data': {
              'url': profileImageUrl,
            },
          },
        }),
        200,
      );
    }

    fail('Unexpected Facebook request: ${request.method} ${request.url}');
  });
}

const _facebookAccessToken = 'facebook-access-token';
const _facebookAppId = 'facebook-app-id';
const _facebookAppSecret = 'facebook-app-secret';
