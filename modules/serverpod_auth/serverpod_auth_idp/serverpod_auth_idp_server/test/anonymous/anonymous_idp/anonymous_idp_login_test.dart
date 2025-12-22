import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/anonymous_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given no account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture();
      });

      test('can create a new account', () async {
        final result = await fixture.anonymousIdp.login(session);
        await expectLater(result, completion(isA<AuthSuccess>()));
      });
    },
  );
}
