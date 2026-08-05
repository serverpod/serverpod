import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';

import '../test/utils/test_storage.dart';

const _apiUrl = 'http://localhost:8080/';
const _corsRejectionCase = bool.fromEnvironment(
  'SERVERPOD_COOKIE_CORS_REJECTION',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  if (_corsRejectionCase) {
    testWidgets('rejects a non-allow-listed browser origin', (_) async {
      final client = _newClient(TestStorage());
      addTearDown(client.close);

      await expectLater(
        client.authTest.createTestUser(),
        throwsA(isA<ServerpodClientException>()),
      );
    });
    return;
  }

  testWidgets(
    'SAS cookie auth keeps unauthenticated calls and streams anonymous',
    (_) async {
      final client = _newClient(TestStorage());
      addTearDown(client.close);

      final userId = await client.authTest.createTestUser();
      final authSuccess = await client.authTest.createSasToken(userId);

      expect(authSuccess.token, isEmpty);
      expect(authSuccess.refreshToken, isNull);

      await client.auth.updateSignedInUser(authSuccess);

      expect(await client.authTest.checkSession(userId), isTrue);
      expect(await client.authTest.checkSessionUnauthenticated(), isFalse);
      expect(
        await client.authTest.checkSessionUnauthenticatedStream().first,
        isFalse,
      );
      await expectLater(
        client.unauthenticatedRequireLoginAuthTest.call(),
        throwsA(isA<ServerpodClientUnauthorized>()),
      );
    },
  );

  testWidgets(
    'cookie authentication reconnects modern streams on sign-in, switch, and sign-out',
    (_) async {
      final client = _newClient(TestStorage());
      addTearDown(client.close);

      final anonymousDone = Completer<void>();
      final anonymousSubscription = client.authTest
          .openPublicUserStream()
          .listen(
            (_) {},
            onDone: anonymousDone.complete,
          );

      final userA = await client.authTest.createTestUser();
      await client.auth.updateSignedInUser(
        await client.authTest.createSasToken(userA),
      );
      await anonymousDone.future.timeout(const Duration(seconds: 2));
      await anonymousSubscription.cancel();

      final userAValue = Completer<String>();
      final userADone = Completer<void>();
      final userASubscription = client.authenticatedStreamingTest
          .watchAuthenticatedUserId()
          .listen(
            (value) {
              if (!userAValue.isCompleted) userAValue.complete(value);
            },
            onDone: userADone.complete,
          );
      expect(await userAValue.future, userA.toString());

      final userB = await client.authTest.createTestUser();
      final userBAuth = await client.authTest.createSasToken(userB);
      await client.auth.updateSignedInUser(userBAuth);
      await userADone.future.timeout(const Duration(seconds: 2));
      await userASubscription.cancel();

      expect(
        await client.authenticatedStreamingTest
            .watchAuthenticatedUserId()
            .first,
        userB.toString(),
      );

      final userBDone = Completer<void>();
      final userBSubscription = client.authenticatedStreamingTest
          .watchAuthenticatedUserId()
          .listen((_) {}, onDone: userBDone.complete);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await client.auth.signOutDevice();
      await userBDone.future.timeout(const Duration(seconds: 2));
      await userBSubscription.cancel();

      expect(await client.authTest.checkSession(userB), isFalse);
      await expectLater(
        client.authenticatedStreamingTest.watchAuthenticatedUserId().first,
        throwsA(isA<ServerpodClientUnauthorized>()),
      );
    },
  );

  testWidgets(
    'JWT cookie refresh restores access and serializes independent clients',
    (_) async {
      final firstStorage = TestStorage();
      final firstClient = _newClient(firstStorage);
      final secondStorage = TestStorage();
      final secondClient = _newClient(secondStorage);
      addTearDown(firstClient.close);
      addTearDown(secondClient.close);

      final userId = await firstClient.authTest.createTestUser();
      final initialAuth = await firstClient.authTest.createJwtToken(userId);
      expect(initialAuth.token, isNotEmpty);
      expect(initialAuth.refreshToken, isNull);
      await firstClient.auth.updateSignedInUser(initialAuth);

      final persistedAuth = await firstStorage.get();
      expect(persistedAuth?.token, isEmpty);
      expect(persistedAuth?.refreshToken, isNull);
      await secondStorage.set(persistedAuth);
      await secondClient.auth.initialize();

      expect(secondClient.auth.authInfo?.token, isNotEmpty);
      expect(await secondClient.authTest.checkSession(userId), isTrue);

      await firstClient.authTest.resetJwtRefreshConcurrency();
      final refreshResults = await Future.wait([
        firstClient.auth.refreshAuthKey(force: true),
        secondClient.auth.refreshAuthKey(force: true),
      ]);

      expect(refreshResults, everyElement(RefreshAuthKeyResult.success));
      expect(
        await firstClient.authTest.getMaxConcurrentJwtRefreshes(),
        1,
      );
      expect(await firstClient.authTest.checkSession(userId), isTrue);
    },
  );
}

Client _newClient(TestStorage storage) {
  return Client(_apiUrl)
    ..cookieAuth = true
    ..authSessionManager = FlutterAuthSessionManager(storage: storage);
}
