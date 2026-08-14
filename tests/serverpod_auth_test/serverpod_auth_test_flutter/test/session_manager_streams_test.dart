import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';

import 'package:serverpod_auth_test_flutter/src/test_utils/test_storage.dart';

void main() {
  test(
    'Given a header-mode session manager with an open method stream '
    'when the signed-in user changes '
    'then the stream stays open.',
    () async {
      final client = Client(
        'http://localhost:8080/',
      )..authSessionManager = FlutterAuthSessionManager(storage: TestStorage());
      addTearDown(client.close);

      final userA = await client.authTest.createTestUser();
      // Minted before signing in as A: an authenticated caller may not
      // create a session for another user.
      final userB = await client.authTest.createTestUser();
      final userBAuth = await client.authTest.createSasToken(userB);
      await client.auth.updateSignedInUser(
        await client.authTest.createSasToken(userA),
      );

      final firstValue = Completer<String>();
      final done = Completer<void>();
      final subscription = client.authenticatedStreamingTest
          .watchAuthenticatedUserId()
          .listen(
            (value) {
              if (!firstValue.isCompleted) firstValue.complete(value);
            },
            onDone: done.complete,
          );
      expect(await firstValue.future, userA.toString());

      await client.auth.updateSignedInUser(userBAuth);

      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(done.isCompleted, isFalse);
      await subscription.cancel();
    },
  );
}
