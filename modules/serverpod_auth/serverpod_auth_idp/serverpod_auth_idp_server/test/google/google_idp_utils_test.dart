import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given GoogleIdpUtils',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late GoogleIdpUtils utils;

      setUp(() {
        utils = GoogleIdpUtils(
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
        'when calling getAccount with authenticated session but no google account then it returns null',
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
        'when calling getAccount with authenticated session and existing google account then it returns the account',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await const AuthUsers().create(setupSession);
          final googleAccount = await GoogleAccount.db.insertRow(
            setupSession,
            GoogleAccount(
              userIdentifier: 'google-id-${const Uuid().v4()}',
              email: 'test-${const Uuid().v4()}@gmail.com',
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
          expect(account?.id, googleAccount.id);
          expect(account?.authUserId, authUser.id);
        },
      );
    },
  );
}
