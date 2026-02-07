import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given FirebaseIdpUtils',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late FirebaseIdpUtils utils;

      setUp(() {
        utils = FirebaseIdpUtils(
          config: const FirebaseIdpConfig(
            credentials: FirebaseServiceAccountCredentials(
              projectId: 'id',
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
        'when calling getAccount with authenticated session but no firebase account then it returns null',
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
        'when calling getAccount with authenticated session and existing firebase account then it returns the account',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await const AuthUsers().create(setupSession);
          final firebaseAccount = await FirebaseAccount.db.insertRow(
            setupSession,
            FirebaseAccount(
              userIdentifier: 'firebase-id-${const Uuid().v4()}',
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
          expect(account?.id, firebaseAccount.id);
          expect(account?.authUserId, authUser.id);
        },
      );
    },
  );
}
