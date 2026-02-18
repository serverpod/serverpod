import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
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
        GoogleIdpConfig(
          clientSecret: GoogleClientSecret.fromJson({
            'web': {
              'client_id': 'id',
              'client_secret': 'secret',
              'redirect_uris': ['uri'],
            },
          }),
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
          final result = await endpoints.googleAccount.hasAccount(
            sessionBuilder,
          );
          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no Google account', (
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
        final result = await endpoints.googleAccount.hasAccount(session);
        expect(result, isFalse);
      },
    );
  });

  withServerpod('Given an authenticated session with a Google account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AuthUserModel authUser;
    late TestSessionBuilder session;

    setUp(() async {
      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      await GoogleAccount.db.insertRow(
        setupSession,
        GoogleAccount(
          userIdentifier: 'google-id-${const Uuid().v4()}',
          authUserId: authUser.id,
          email: 'test-${const Uuid().v4()}@gmail.com',
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
        final result = await endpoints.googleAccount.hasAccount(session);
        expect(result, isTrue);
      },
    );
  });
}
