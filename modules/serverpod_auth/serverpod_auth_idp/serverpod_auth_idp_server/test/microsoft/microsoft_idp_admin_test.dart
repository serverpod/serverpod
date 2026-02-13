import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/microsoft.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late MicrosoftIdpAdmin admin;
  late MicrosoftIdpUtils utils;
  late Session session;

  withServerpod(
    'Given MicrosoftIdpAdmin',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      setUp(() {
        utils = _createUtils();
        admin = MicrosoftIdpAdmin(utils: utils);
        session = sessionBuilder.build();
      });

      test(
        'when linking Microsoft authentication then it creates a new account.',
        () async {
          final authUser = await const AuthUsers().create(session);
          final accountDetails = (
            userIdentifier: 'microsoft-user-${const Uuid().v4()}',
            email: 'test-${const Uuid().v4()}@outlook.com',
            name: 'Test User',
            imageBytes: null,
          );

          final account = await admin.linkMicrosoftAuthentication(
            session,
            authUserId: authUser.id,
            accountDetails: accountDetails,
          );

          expect(account.id, isNotNull);
          expect(account.authUserId, authUser.id);
          expect(account.userIdentifier, accountDetails.userIdentifier);
          expect(account.email, accountDetails.email);
        },
      );

      test(
        'when finding user by Microsoft user id then it returns the auth user id.',
        () async {
          final authUser = await const AuthUsers().create(session);
          final userIdentifier = 'microsoft-user-${const Uuid().v4()}';
          await MicrosoftAccount.db.insertRow(
            session,
            MicrosoftAccount(
              userIdentifier: userIdentifier,
              email: 'test-${const Uuid().v4()}@outlook.com',
              authUserId: authUser.id,
            ),
          );

          final foundUserId = await MicrosoftIdpAdmin.findUserByMicrosoftUserId(
            session,
            userIdentifier: userIdentifier,
          );

          expect(foundUserId, authUser.id);
        },
      );

      test(
        'when finding user by non-existent Microsoft user id then it returns null.',
        () async {
          final foundUserId = await MicrosoftIdpAdmin.findUserByMicrosoftUserId(
            session,
            userIdentifier: 'non-existent-user-id',
          );

          expect(foundUserId, isNull);
        },
      );
    },
  );
}

MicrosoftIdpUtils _createUtils() {
  return MicrosoftIdpUtils(
    config: MicrosoftIdpConfig(
      clientId: 'test-client-id',
      clientSecret: 'test-client-secret',
      tenant: 'common',
    ),
    authUsers: const AuthUsers(),
  );
}
