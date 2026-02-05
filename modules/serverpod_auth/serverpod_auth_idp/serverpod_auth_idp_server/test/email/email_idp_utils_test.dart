import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given EmailIdpUtils',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late EmailIdpTestFixture fixture;
      late EmailIdpUtils utils;

      setUp(() {
        fixture = EmailIdpTestFixture();
        utils = fixture.emailIdp.utils;
      });

      tearDown(() async {
        await fixture.tearDown(sessionBuilder.build());
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
        'when calling getAccount with authenticated session but no email account then it returns null',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await fixture.authUsers.create(setupSession);

          final session = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  authUser.id.toString(),
                  {},
                ),
              )
              .build();

          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );

      test(
        'when calling getAccount with authenticated session and existing email account then it returns the account',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await fixture.authUsers.create(setupSession);
          final emailAccount = await fixture.createEmailAccount(
            setupSession,
            authUserId: authUser.id,
            email: 'test-${const Uuid().v4()}@serverpod.dev',
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
          expect(account?.id, emailAccount.id);
          expect(account?.authUserId, authUser.id);
        },
      );
    },
  );
}
