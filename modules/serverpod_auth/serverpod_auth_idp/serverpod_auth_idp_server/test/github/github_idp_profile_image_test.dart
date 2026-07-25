import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/github.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

void main() {
  withServerpod(
    'Given a GitHub-backed user profile with an image,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UserProfile userProfile;
      late GitHubIdp githubIdp;

      const githubUserIdentifier = '123456';
      const githubProfileImageUrl =
          'https://serverpod.dev/github-profile-image.png';

      setUp(() async {
        session = sessionBuilder.build();
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        );
        githubIdp = GitHubIdp(
          GitHubIdpConfig(
            clientId: _githubClientId,
            clientSecret: _githubClientSecret,
          ),
          tokenIssuer: const TestTokenIssuer(),
          userProfiles: userProfiles,
        );

        final authUser = await const AuthUsers().create(session);
        authUserId = authUser.id;

        await GitHubAccount.db.insertRow(
          session,
          GitHubAccount(
            userIdentifier: githubUserIdentifier,
            email: 'test-${const Uuid().v4()}@github.com',
            authUserId: authUserId,
          ),
        );

        await userProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            fullName: 'GitHub User',
            email: 'test@example.com',
          ),
          imageSource: UserImageFromUrl.parse(githubProfileImageUrl),
        );

        userProfile = (await UserProfile.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        ))!;
      });

      test(
        'when the user signs in with GitHub again, '
        'then no additional profile image row is created.',
        () async {
          final imagesBeforeSignIn = await UserProfileImage.db.find(
            session,
            where: (final t) => t.userProfileId.equals(userProfile.id!),
          );
          expect(imagesBeforeSignIn, hasLength(1));

          await http.runWithClient(
            () => githubIdp.login(
              session,
              code: 'authorization-code',
              codeVerifier: 'code-verifier',
              redirectUri: 'https://serverpod.dev/auth/github/callback',
            ),
            () => _githubClient(
              userIdentifier: githubUserIdentifier,
              profileImageUrl: githubProfileImageUrl,
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

http.Client _githubClient({
  required final String userIdentifier,
  required final String profileImageUrl,
}) {
  return MockClient((final request) async {
    if (request.method == 'POST' &&
        request.url == Uri.https('github.com', '/login/oauth/access_token')) {
      return http.Response(
        jsonEncode({
          'access_token': _githubAccessToken,
        }),
        200,
      );
    }

    if (request.method == 'GET' &&
        request.url == Uri.https('api.github.com', '/user')) {
      return http.Response(
        jsonEncode({
          'id': int.parse(userIdentifier),
          'email': 'test@example.com',
          'name': 'GitHub User',
          'avatar_url': profileImageUrl,
        }),
        200,
      );
    }

    fail('Unexpected GitHub request: ${request.method} ${request.url}');
  });
}

const _githubAccessToken = 'github-access-token';
const _githubClientId = 'github-client-id';
const _githubClientSecret = 'github-client-secret';
