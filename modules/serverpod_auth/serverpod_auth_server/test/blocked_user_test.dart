import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a blocked user', (sessionBuilder, _) {
    const email = 'test@serverpod.dev';
    const password = 'password123';
    late int userId;
    setUp(() async {
      var session = sessionBuilder.build();
      var user = await Emails.createUser(
        session,
        'blockedUser',
        email,
        password,
      );

      assert(user != null, 'User should be created successfully');
      var maybeUserId = user!.id;
      assert(maybeUserId != null, 'User ID should not be null');

      userId = maybeUserId!;
      await Users.blockUser(session, userId);
    });

    test(
        'when user attempts to authenticate, then authentication fails with reason "blocked"',
        () async {
      var session = sessionBuilder.build();
      var result = await Emails.authenticate(session, email, password);

      expect(result.success, isFalse);
      expect(result.failReason, AuthenticationFailReason.blocked);
    });
  });

  withServerpod('Given a previously blocked user', (sessionBuilder, _) {
    const email = 'test@serverpod.dev';
    const password = 'password123';
    setUp(() async {
      var session = sessionBuilder.build();
      var user = await Emails.createUser(
        session,
        'blockedUser',
        email,
        password,
      );

      assert(user != null, 'User should be created successfully');
      var maybeUserId = user!.id;
      assert(maybeUserId != null, 'User ID should not be null');

      var userId = maybeUserId!;
      await Users.blockUser(session, userId);
      await Users.unblockUser(session, userId);
    });

    test('when user attempts to authenticate, then authentication succeeds',
        () async {
      var session = sessionBuilder.build();
      var result = await Emails.authenticate(session, email, password);

      expect(result.success, isTrue);
    });
  });
}
