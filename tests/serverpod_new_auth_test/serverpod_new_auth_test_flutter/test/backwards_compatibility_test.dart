import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_server_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a legacy user, when importing the user with password, then it can complete the migration of the old password at login.',
    () async {
      final sessionManager = SessionManager(
        storage: TestStorage(),
      );

      final client = Client(
        'http://localhost:8080/',
        authenticationKeyManager: sessionManager,
      );

      final email =
          'test_${DateTime.now().microsecondsSinceEpoch}@serverpod.dev';
      final password = 'Asdf123!!!!!';

      final userId =
          await client.emailAccountBackwardsCompatibilityTest.createLegacyUser(
        email: email,
        password: password,
      );

      final authKey = await client.emailAccountBackwardsCompatibilityTest
          .createLegacySession(
        userId: userId,
        scopes: {'test'},
      );

      await client.emailAccountBackwardsCompatibilityTest.migrateUserByEmail(
        email: email,
        password: password,
      );

      final newAuthUserId =
          await client.emailAccountBackwardsCompatibilityTest.getNewAuthUserId(
        userId: userId,
      );

      await client.emailAccountBackwardsCompatibilityTest.deleteLegacyAuthData(
        userId: userId,
      );

      expect(
        await client.emailAccountBackwardsCompatibilityTest
            .backwardsCompatibleAuthSessionCheck(
          sessionKey: '${authKey.id!}:${authKey.key!}',
        ),
        newAuthUserId,
      );

      expect(
        await client.emailAccountBackwardsCompatibilityTest.checkLegacyPassword(
          email: email,
          password: password,
        ),
        isFalse, // legacy password does not work anymore, since account has been migrated
      );

      expect(
        await client.emailAccount.login(email: email, password: password),
        isNotNull,
      );
    },
  );

  test(
    'Given a legacy user, when importing the user without password, then it can complete the migration of the old password at login.',
    () async {
      final sessionManager = SessionManager(
        storage: TestStorage(),
      );

      final client = Client(
        'http://localhost:8080/',
        authenticationKeyManager: sessionManager,
      );

      final email =
          'test_${DateTime.now().microsecondsSinceEpoch}@serverpod.dev';
      final password = 'Asdf123!!!!!';

      final userId =
          await client.emailAccountBackwardsCompatibilityTest.createLegacyUser(
        email: email,
        password: password,
      );

      final authKey = await client.emailAccountBackwardsCompatibilityTest
          .createLegacySession(
        userId: userId,
        scopes: {'test'},
      );

      await client.emailAccountBackwardsCompatibilityTest.migrateUserByEmail(
        email: email,
        password: null,
      );

      final newAuthUserId =
          await client.emailAccountBackwardsCompatibilityTest.getNewAuthUserId(
        userId: userId,
      );

      await client.emailAccountBackwardsCompatibilityTest.deleteLegacyAuthData(
        userId: userId,
      );

      expect(
        await client.emailAccountBackwardsCompatibilityTest
            .backwardsCompatibleAuthSessionCheck(
          sessionKey: '${authKey.id!}:${authKey.key!}',
        ),
        newAuthUserId,
      );

      expect(
        await client.emailAccountBackwardsCompatibilityTest.checkLegacyPassword(
          email: email,
          password: password,
        ),
        isTrue, // legacy password is still kept
      );
    },
  );
}
