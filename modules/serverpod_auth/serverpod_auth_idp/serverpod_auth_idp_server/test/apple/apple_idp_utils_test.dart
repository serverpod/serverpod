import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late AppleIdpUtils utils;
  late Session session;

  withServerpod(
    'Given an unauthenticated session',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      setUp(() {
        utils = _createUtils();
        session = sessionBuilder.build();
      });

      test(
        'when calling getAccount then it returns null',
        () async {
          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no Apple account', (
    final sessionBuilder,
    final endpoints,
  ) {
    setUp(() {
      utils = _createUtils();
      session = sessionBuilder
          .copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              const Uuid().v4obj().toString(),
              {},
            ),
          )
          .build();
    });

    test(
      'when calling getAccount then it returns null',
      () async {
        final account = await utils.getAccount(session);
        expect(account, isNull);
      },
    );
  });

  withServerpod('Given an authenticated session with an Apple account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AppleAccount appleAccount;
    late AuthUserModel authUser;

    setUp(() async {
      utils = _createUtils();

      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      appleAccount = await AppleAccount.db.insertRow(
        setupSession,
        AppleAccount(
          userIdentifier: 'apple-id-${const Uuid().v4()}',
          refreshToken: 'token',
          refreshTokenRequestedWithBundleIdentifier: false,
          authUserId: authUser.id,
        ),
      );
      session = sessionBuilder
          .copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUser.id.toString(),
              {},
            ),
          )
          .build();
    });

    test(
      'when calling getAccount then it returns the account',
      () async {
        final account = await utils.getAccount(session);
        expect(account, isNotNull);
        expect(account?.id, appleAccount.id);
        expect(account?.authUserId, authUser.id);
      },
    );
  });
}

AppleIdpUtils _createUtils() {
  return AppleIdpUtils(
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
}
