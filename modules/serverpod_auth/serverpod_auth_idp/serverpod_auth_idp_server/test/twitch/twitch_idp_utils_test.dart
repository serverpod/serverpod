import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/twitch.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late TwitchIdpUtils utils;
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

  withServerpod('Given an authenticated session but no Twitch account', (
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

  withServerpod('Given an authenticated session with a Twitch account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late TwitchAccount twitchAccount;
    late AuthUserModel authUser;

    setUp(() async {
      utils = _createUtils();

      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      twitchAccount = await TwitchAccount.db.insertRow(
        setupSession,
        TwitchAccount(
          userIdentifier: 'twitch-id-${const Uuid().v4()}',
          login: 'testuser',
          displayName: 'Test User',
          email: 'test-${const Uuid().v4()}@example.com',
          accessToken: 'test-access-token',
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
        expect(account?.id, twitchAccount.id);
        expect(account?.authUserId, authUser.id);
      },
    );
  });
}

TwitchIdpUtils _createUtils() {
  return TwitchIdpUtils(
    config: TwitchIdpConfig(
      oauthCredentials: TwitchOAuthCredentials.fromJson({
        'clientId': 'test-client-id',
        'clientSecret': 'test-client-secret',
      }),
    ),
    authUsers: const AuthUsers(),
  );
}
