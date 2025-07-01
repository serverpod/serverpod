import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_server_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a session, when setting it on the `SessionManager`, then the server recognizes the user correctly.',
    () async {
      final sessionManager = SessionManager(
        storage: TestStorage(),
      );

      final client = Client(
        'http://localhost:8080/',
        authenticationKeyManager: sessionManager,
      );

      final testUser = await client.sessionTest.createTestUser();

      final authentication = await client.sessionTest.createSession(testUser);

      expect(
        await client.sessionTest.checkSession(testUser),
        isFalse,
      );

      await sessionManager.setLoggedIn(authentication);

      expect(
        await client.sessionTest.checkSession(testUser),
        isTrue,
      );
    },
  );
}
