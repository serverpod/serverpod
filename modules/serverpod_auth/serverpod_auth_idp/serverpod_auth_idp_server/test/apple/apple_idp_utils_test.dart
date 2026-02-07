import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given AppleIdpUtils',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late AppleIdpUtils utils;

      setUp(() {
        utils = AppleIdpUtils(
          tokenManager: AuthServices(
            authUsers: const AuthUsers(),
            userProfiles: const UserProfiles(),
            primaryTokenManagerBuilder: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'test-pepper',
            ),
            identityProviderBuilders: [],
          ).tokenManager,
          signInWithApple: SignInWithApple(
            config: SignInWithAppleConfiguration(
              serviceIdentifier: 'id',
              bundleIdentifier: 'bundle',
              teamId: 'team',
              keyId: 'key',
              key: 'private',
              redirectUri: 'uri',
            ),
          ),
          authUsers: const AuthUsers(),
        );
      });

      test(
        'when calling getAccount with unauthenticated session then it returns null',
        () async {
          final session = sessionBuilder.build();
          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );

      test(
        'when calling getAccount with authenticated session but no apple account then it returns null',
        () async {
          final session = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  const Uuid().v4obj().toString(),
                  {},
                ),
              )
              .build();

          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );

      test(
        'when calling getAccount with authenticated session and existing apple account then it returns the account',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await const AuthUsers().create(setupSession);
          final appleAccount = await AppleAccount.db.insertRow(
            setupSession,
            AppleAccount(
              userIdentifier: 'apple-id-${const Uuid().v4()}',
              refreshToken: 'token',
              refreshTokenRequestedWithBundleIdentifier: false,
              authUserId: authUser.id,
            ),
          );

          final session = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  authUser.id.toString(),
                  {},
                ),
              )
              .build();

          final account = await utils.getAccount(session);
          expect(account, isNotNull);
          expect(account?.id, appleAccount.id);
          expect(account?.authUserId, authUser.id);
        },
      );
    },
  );
}
