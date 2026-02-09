import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late GoogleIdpUtils utils;
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

  withServerpod('Given an authenticated session but no Google account', (
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

  withServerpod('Given an authenticated session with a Google account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late GoogleAccount googleAccount;
    late AuthUserModel authUser;

    setUp(() async {
      utils = _createUtils();

      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      googleAccount = await GoogleAccount.db.insertRow(
        setupSession,
        GoogleAccount(
          userIdentifier: 'google-id-${const Uuid().v4()}',
          email: 'test-${const Uuid().v4()}@gmail.com',
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
        expect(account?.id, googleAccount.id);
        expect(account?.authUserId, authUser.id);
      },
    );
  });
}

GoogleIdpUtils _createUtils() {
  return GoogleIdpUtils(
    config: GoogleIdpConfig(
      clientSecret: GoogleClientSecret.fromJson({
        'web': {
          'client_id': 'id',
          'client_secret': 'secret',
          'redirect_uris': ['uri'],
        },
      }),
    ),
    authUsers: const AuthUsers(),
  );
}
