import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';
import '../test_utils/profile_image_idp_test_utils.dart';

void main() {
  withServerpod(
    'Given a Microsoft-backed user profile with an image,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UserProfile userProfile;
      late MicrosoftIdp microsoftIdp;

      const microsoftUserIdentifier = 'microsoft-user-id';

      setUp(() async {
        session = sessionBuilder.build();
        final userProfiles = UserProfiles(
          config: UserProfileConfig(
            imageFetchFunc: (final _) => onePixelPng,
          ),
        );
        microsoftIdp = MicrosoftIdp(
          MicrosoftIdpConfig(
            clientId: _microsoftClientId,
            clientSecret: _microsoftClientSecret,
          ),
          tokenIssuer: const TestTokenIssuer(),
          userProfiles: userProfiles,
        );

        final authUser = await const AuthUsers().create(session);
        authUserId = authUser.id;

        await MicrosoftAccount.db.insertRow(
          session,
          MicrosoftAccount(
            userIdentifier: microsoftUserIdentifier,
            email: 'test-${const Uuid().v4()}@microsoft.com',
            authUserId: authUserId,
          ),
        );

        await userProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(
            fullName: 'Microsoft User',
            email: 'test@example.com',
          ),
          imageSource: UserImageFromBytes(onePixelPng),
        );

        userProfile = (await UserProfile.db.findFirstRow(
          session,
          where: (final t) => t.authUserId.equals(authUserId),
        ))!;
      });

      test(
        'when the user signs in with Microsoft again, '
        'then no additional profile image row is created.',
        () async {
          final imagesBeforeSignIn = await UserProfileImage.db.find(
            session,
            where: (final t) => t.userProfileId.equals(userProfile.id!),
          );
          expect(imagesBeforeSignIn, hasLength(1));

          await http.runWithClient(
            () => microsoftIdp.login(
              session,
              code: 'authorization-code',
              codeVerifier: 'code-verifier',
              redirectUri: 'https://serverpod.dev/auth/microsoft/callback',
              isWebPlatform: false,
            ),
            () => _microsoftClient(userIdentifier: microsoftUserIdentifier),
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

http.Client _microsoftClient({
  required final String userIdentifier,
}) {
  return MockClient((final request) async {
    if (request.method == 'POST' &&
        request.url ==
            Uri.https(
              'login.microsoftonline.com',
              '/common/oauth2/v2.0/token',
            )) {
      return http.Response(
        jsonEncode({
          'access_token': _microsoftAccessToken,
        }),
        200,
      );
    }

    if (request.method == 'GET' &&
        request.url == Uri.https('graph.microsoft.com', '/v1.0/me')) {
      return http.Response(
        jsonEncode({
          'id': userIdentifier,
          'mail': 'test@example.com',
          'displayName': 'Microsoft User',
        }),
        200,
      );
    }

    if (request.method == 'GET' &&
        request.url ==
            Uri.https('graph.microsoft.com', '/v1.0/me/photo/\$value')) {
      return http.Response.bytes(onePixelPng, 200);
    }

    fail('Unexpected Microsoft request: ${request.method} ${request.url}');
  });
}

const _microsoftAccessToken = 'microsoft-access-token';
const _microsoftClientId = 'microsoft-client-id';
const _microsoftClientSecret = 'microsoft-client-secret';
