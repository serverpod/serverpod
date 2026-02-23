import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late FirebaseIdpUtils utils;
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

  withServerpod('Given an authenticated session but no Firebase account', (
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

  withServerpod('Given an authenticated session with a Firebase account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late FirebaseAccount firebaseAccount;
    late AuthUserModel authUser;

    setUp(() async {
      utils = _createUtils();

      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      firebaseAccount = await FirebaseAccount.db.insertRow(
        setupSession,
        FirebaseAccount(
          userIdentifier: 'firebase-id-${const Uuid().v4()}',
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
        expect(account?.id, firebaseAccount.id);
        expect(account?.authUserId, authUser.id);
      },
    );
  });
}

FirebaseIdpUtils _createUtils() {
  return FirebaseIdpUtils(
    config: const FirebaseIdpConfig(
      credentials: FirebaseServiceAccountCredentials(
        projectId: 'id',
      ),
    ),
    authUsers: const AuthUsers(),
  );
}
