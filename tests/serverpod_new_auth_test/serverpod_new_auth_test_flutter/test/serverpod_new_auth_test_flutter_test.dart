import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a session, when setting it on the `SessionManager`, then the server recognizes the user correctly.',
    () async {
      final client = Client('http://localhost:8080/')
        ..authSessionManager = ClientAuthSessionManager(storage: TestStorage());

      final testUser = await client.sessionTest.createTestUser();
      final authentication = await client.sessionTest.createSession(testUser);

      expect(await client.sessionTest.checkSession(testUser), isFalse);

      await client.auth.updateSignedInUser(authentication);

      expect(await client.sessionTest.checkSession(testUser), isTrue);
    },
  );
}
