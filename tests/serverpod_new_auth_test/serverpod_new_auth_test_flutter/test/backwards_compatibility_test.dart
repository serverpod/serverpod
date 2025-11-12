import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a legacy user, when importing the user, then their legacy password can be migrated later on and used for the login.',
    () async {
      final client = Client('http://localhost:8080/')
        ..authSessionManager = ClientAuthSessionManager(storage: TestStorage());

      final email =
          'test_${DateTime.now().microsecondsSinceEpoch}@serverpod.dev';
      const password = 'Asdf123!!!!!';

      final userId = await client.emailAccountBackwardsCompatibilityTest
          .createLegacyUser(
            email: email,
            password: password,
          );

      await client.emailAccountBackwardsCompatibilityTest.migrateUser(
        legacyUserId: userId,
        password: password,
      );

      final newAuthUserId = await client.emailAccountBackwardsCompatibilityTest
          .getNewAuthUserId(
            userId: userId,
          );

      expect(
        await client.emailAccountBackwardsCompatibilityTest.checkLegacyPassword(
          email: email,
          password: password,
        ),
        isTrue, // legacy password still works, as it has not been import
      );

      // calling into the normal email endpoint fails
      await expectLater(
        client.emailAccount.login(email: email, password: password),
        throwsA(
          isA<EmailAccountLoginException>(),
        ),
      );

      // calling into the password-migrating email endpoint succeeds
      expect(
        await client.passwordImportingEmailAccount.login(
          email: email,
          password: password,
        ),
        isA<AuthSuccess>().having(
          (final s) => s.authUserId,
          'authUserId',
          newAuthUserId,
        ),
      );

      // calling into the normal email endpoint succeeds now as well, as the password has been imported
      expect(
        await client.emailAccount.login(email: email, password: password),
        isA<AuthSuccess>().having(
          (final s) => s.authUserId,
          'authUserId',
          newAuthUserId,
        ),
      );

      expect(
        await client.emailAccountBackwardsCompatibilityTest.checkLegacyPassword(
          email: email,
          password: password,
        ),
        isFalse, // legacy password has been deleted, thus the check does not work anymore
      );
    },
  );
}
