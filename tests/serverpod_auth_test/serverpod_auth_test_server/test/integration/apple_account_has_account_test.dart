import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper-long-enough',
  );

  setUp(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [
        const AppleIdpConfig(
          serviceIdentifier: 'id',
          bundleIdentifier: 'bundle',
          teamId: 'team',
          keyId: 'key',
          key: 'private',
          redirectUri: 'uri',
        ),
      ],
    );
  });

  tearDown(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given an unauthenticated session',
    (final sessionBuilder, final endpoints) {
      test(
        'when calling hasAccount then it returns false',
        () async {
          final result = await endpoints.appleAccount.hasAccount(
            sessionBuilder,
          );
          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no Apple account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late TestSessionBuilder session;

    setUp(() async {
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          const Uuid().v4obj().uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns false',
      () async {
        final result = await endpoints.appleAccount.hasAccount(session);
        expect(result, isFalse);
      },
    );
  });

  withServerpod('Given an authenticated session with an Apple account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AuthUserModel authUser;
    late TestSessionBuilder session;

    setUp(() async {
      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      await AppleAccount.db.insertRow(
        setupSession,
        AppleAccount(
          userIdentifier: 'apple-id-${const Uuid().v4()}',
          authUserId: authUser.id,
          refreshToken: 'token',
          refreshTokenRequestedWithBundleIdentifier: false,
        ),
      );
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUser.id.uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns true',
      () async {
        final result = await endpoints.appleAccount.hasAccount(session);
        expect(result, isTrue);
      },
    );
  });
}
