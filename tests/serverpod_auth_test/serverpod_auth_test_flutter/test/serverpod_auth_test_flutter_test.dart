import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a session, when setting it on the `SessionManager`, then the server recognizes the user correctly.',
    () async {
      final client = Client(
        'http://localhost:8080/',
      )..authSessionManager = FlutterAuthSessionManager(storage: TestStorage());

      final testUser = await client.authTest.createTestUser();
      final authentication = await client.authTest.createSasToken(testUser);

      expect(await client.authTest.checkSession(testUser), isFalse);

      await client.auth.updateSignedInUser(authentication);

      expect(await client.authTest.checkSession(testUser), isTrue);
    },
  );
}
