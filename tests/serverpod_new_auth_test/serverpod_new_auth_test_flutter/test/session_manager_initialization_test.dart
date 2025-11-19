import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  late TestStorage storage;
  late Client client;
  late AuthSuccess authSuccess;

  group('Given a `ClientAuthSessionManager` created with an empty storage', () {
    setUpAll(() async {
      storage = TestStorage();
      client = Client('http://localhost:8080/')
        ..authSessionManager = ClientAuthSessionManager(storage: storage);

      final testUser = await client.authTest.createTestUser();
      authSuccess = await client.authTest.createJwtToken(testUser);
    });

    test('when calling initialize, then it completes.', () async {
      await expectLater(client.auth.initialize(), completes);
    });

    test(
      'when getting the authentication key, then it returns `null`.',
      () async {
        expect(await client.auth.authHeaderValue, isNull);
      },
    );

    group('when logging in', () {
      setUpAll(() async {
        await client.auth.updateSignedInUser(authSuccess);
      });

      test('then `isAuthenticated` returns `true`.', () {
        expect(client.auth.isAuthenticated, isTrue);
      });

      test(
        'then `authHeaderValue` returns the session key as a Bearer token.',
        () async {
          final token = authSuccess.token;
          expect(await client.auth.authHeaderValue, 'Bearer $token');
        },
      );

      test('then the auth info value matches the one used to log in.', () {
        final authInfo = client.auth.authInfo.value;

        expect(authInfo, isNotNull);
        expect(client.auth.authInfo.value.toString(), authSuccess.toString());
      });

      test('then the storage contains the auth info.', () async {
        expect((await storage.get()).toString(), authSuccess.toString());
      });
    });

    group('when logging out on the current device', () {
      setUpAll(() async {
        await client.auth.updateSignedInUser(authSuccess);
        expect(client.auth.isAuthenticated, isTrue);
        await client.auth.signOutDevice();
      });

      test('then `isAuthenticated` returns `false`.', () {
        expect(client.auth.isAuthenticated, isFalse);
      });

      test('then `authHeaderValue` returns `null`.', () async {
        expect(await client.auth.authHeaderValue, isNull);
      });

      test('then the auth info value is `null`.', () {
        expect(client.auth.authInfo.value, isNull);
      });

      test('then the storage is empty.', () async {
        expect((await storage.get()), isNull);
      });
    });

    group('when logging out from all devices', () {
      setUpAll(() async {
        await client.auth.updateSignedInUser(authSuccess);
        expect(client.auth.isAuthenticated, isTrue);
        await client.auth.signOutAllDevices();
      });

      test('then `isAuthenticated` returns `false`.', () {
        expect(client.auth.isAuthenticated, isFalse);
      });

      test('then `authHeaderValue` returns `null`.', () async {
        expect(await client.auth.authHeaderValue, isNull);
      });

      test('then the auth info value is `null`.', () {
        expect(client.auth.authInfo.value, isNull);
      });

      test('then the storage is empty.', () async {
        expect((await storage.get()), isNull);
      });
    });
  });

  group(
    'Given a `ClientAuthSessionManager` which has been initialized with a previous SAS token from storage',
    () {
      setUp(() async {
        storage = TestStorage();
        client = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(storage: storage);

        final testUser = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createSasToken(testUser);

        await storage.set(authSuccess);
      });

      test('when calling restore, then auth info is available.', () async {
        await client.auth.restore();
        final token = authSuccess.token;

        expect(client.auth.authInfo.value, isNotNull);
        expect(client.auth.isAuthenticated, isTrue);
        expect(client.auth.authInfo.value.toString(), authSuccess.toString());
        expect(await client.auth.authHeaderValue, 'Bearer $token');
      });

      test('when initialized again, then auth info is available.', () async {
        await client.auth.initialize();

        expect(client.auth.authInfo.value, isNotNull);
        expect(client.auth.isAuthenticated, isTrue);
        expect(client.auth.authInfo.value.toString(), authSuccess.toString());
      });
    },
  );

  group(
    'Given a `ClientAuthSessionManager` which has been initialized with a previous JWT token from storage',
    () {
      setUp(() async {
        storage = TestStorage();
        client = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(storage: storage);

        final testUser = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createJwtToken(testUser);

        await storage.set(authSuccess);
      });

      test('when calling restore, then auth info is available.', () async {
        await client.auth.restore();
        final token = authSuccess.token;

        expect(client.auth.authInfo.value, isNotNull);
        expect(client.auth.isAuthenticated, isTrue);
        expect(client.auth.authInfo.value.toString(), authSuccess.toString());
        expect(await client.auth.authHeaderValue, 'Bearer $token');
      });

      group('when initialized again', () {
        setUp(() async {
          await client.auth.initialize();
        });

        test('then auth info is available.', () async {
          expect(client.auth.authInfo.value, isNotNull);
          expect(client.auth.isAuthenticated, isTrue);
        });

        test('then auth info is refreshed.', () async {
          expect(
            client.auth.authInfo.value.toString(),
            isNot(authSuccess.toString()),
          );
        });
      });
    },
  );

  group(
    'Given a `ClientAuthSessionManager` which has been initialized with a previous SAS token from storage that was revoked on the server',
    () {
      setUp(() async {
        storage = TestStorage();
        client = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(storage: storage);

        final testUser = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createSasToken(testUser);
        await client.authTest.deleteSasTokens(testUser);

        await storage.set(authSuccess);
      });

      test(
        'when calling validateAuthentication, then user is signed out.',
        () async {
          await client.auth.restore();
          expect(client.auth.authInfo.value, isNotNull);
          await client.auth.validateAuthentication();

          expect(client.auth.authInfo.value, isNull);
          expect(client.auth.isAuthenticated, isFalse);
          expect(await client.auth.authHeaderValue, isNull);
        },
      );

      test('when calling initialize, then user is signed out.', () async {
        await client.auth.initialize();

        expect(client.auth.authInfo.value, isNull);
        expect(client.auth.isAuthenticated, isFalse);
        expect(await client.auth.authHeaderValue, isNull);
      });
    },
  );

  group(
    'Given a `ClientAuthSessionManager` which has been initialized with a previous JWT token from storage that was revoked on the server',
    () {
      setUp(() async {
        storage = TestStorage();
        client = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(storage: storage);

        final testUser = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createJwtToken(testUser);
        await client.authTest.deleteJwtRefreshTokens(testUser);

        await storage.set(authSuccess);
      });

      test(
        'when calling validateAuthentication, then user is signed out.',
        () async {
          await client.auth.restore();
          expect(client.auth.authInfo.value, isNotNull);
          await client.auth.validateAuthentication();

          expect(client.auth.authInfo.value, isNull);
          expect(client.auth.isAuthenticated, isFalse);
          expect(await client.auth.authHeaderValue, isNull);
        },
      );

      test('when calling initialize, then user is signed out.', () async {
        await client.auth.initialize();

        expect(client.auth.authInfo.value, isNull);
        expect(client.auth.isAuthenticated, isFalse);
        expect(await client.auth.authHeaderValue, isNull);
      });
    },
  );

  group(
    'Given a `ClientAuthSessionManager` with an initialized cached storage containing a valid token that later changes on the underlying storage layer',
    () {
      late AuthSuccess newAuthSuccess;

      setUp(() async {
        storage = TestStorage();
        client = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(storage: storage);

        final testUser = await client.authTest.createTestUser();
        authSuccess = await client.authTest.createSasToken(testUser);

        await storage.set(authSuccess);
        await client.auth.initialize();
        expect(client.auth.authInfo.value, isNotNull);

        newAuthSuccess = await client.authTest.createSasToken(testUser);
        await storage.set(newAuthSuccess);
      });

      test(
        'when getting auth info, then the old value is still returned due to caching.',
        () async {
          expect(client.auth.authInfo.value.toString(), authSuccess.toString());
          expect(
            await client.auth.authHeaderValue,
            'Bearer ${authSuccess.token}',
          );
        },
      );

      test(
        'when getting auth info after restore, then cache is cleared and new value is returned from storage.',
        () async {
          await client.auth.restore();
          expect(
            client.auth.authInfo.value.toString(),
            newAuthSuccess.toString(),
          );
          expect(
            await client.auth.authHeaderValue,
            'Bearer ${newAuthSuccess.token}',
          );
        },
      );
    },
  );

  group(
    'Given a `ClientAuthSessionManager` with a valid token in storage and an unreachable server',
    () {
      setUp(() async {
        final tempClient = Client('http://localhost:8080/');
        final testUser = await tempClient.authTest.createTestUser();
        authSuccess = await tempClient.authTest.createSasToken(testUser);

        storage = TestStorage();
        await storage.set(authSuccess);

        client = Client(
          'http://unreachable-server/',
          connectionTimeout: const Duration(seconds: 20),
        )..authSessionManager = ClientAuthSessionManager(storage: storage);
      });

      test(
        'when calling `validateAuthentication` '
        'then network error is propagated and user is not signed out.',
        () async {
          await client.auth.restore();
          expect(client.auth.isAuthenticated, isTrue);

          await expectLater(
            client.auth.validateAuthentication(
              timeout: const Duration(seconds: 1),
            ),
            throwsA(isA<ServerpodClientException>()),
          );

          expect(client.auth.isAuthenticated, isTrue);
        },
      );

      test('when calling `validateAuthentication` with a timeout '
          'then the timeout interval overrides the default timeout.', () async {
        await client.auth.restore();
        expect(client.auth.isAuthenticated, isTrue);

        final future = client.auth.validateAuthentication(
          timeout: const Duration(seconds: 1),
        );

        final (_, elapsed) = await Stopwatch().timeElapsed(
          expectLater(future, throwsA(isA<ServerpodClientException>())),
        );

        // On web, returns immediately due to client identifying unreachable host.
        expect(elapsed.inSeconds, lessThanOrEqualTo(1));
      });

      test(
        'when calling `initialize` '
        'then network error is caught and user is not signed out and returns false.',
        () async {
          final (result, elapsed) = await Stopwatch().timeElapsed(
            client.auth.initialize(),
          );

          expect(result, isFalse);
          expect(client.auth.isAuthenticated, isTrue);
          // On web, returns immediately due to client identifying unreachable host.
          expect(elapsed.inSeconds, lessThanOrEqualTo(2));
        },
      );
    },
  );

  group('Given two separate client instances with separate session managers', () {
    late Client client1;
    late Client client2;

    setUpAll(() async {
      storage = TestStorage();
      client1 = Client('http://localhost:8080/')
        ..authSessionManager = ClientAuthSessionManager(storage: storage);
      client2 = Client('http://localhost:8080/')
        ..authSessionManager = ClientAuthSessionManager(storage: storage);

      await client1.auth.initialize();
      await client2.auth.initialize();
    });

    test('when comparing the session managers, then they are not equal.', () {
      expect(identical(client1.auth, client2.auth), isFalse);
    });

    test(
      'when logging in on one client, then the other client is not authenticated.',
      () async {
        await client1.auth.updateSignedInUser(authSuccess);
        expect(client1.auth.isAuthenticated, isTrue);
        expect(client2.auth.isAuthenticated, isFalse);
      },
    );
  });
}

extension on Stopwatch {
  Future<(T, Duration)> timeElapsed<T>(Future<T> future) async {
    start();
    final result = await future;
    stop();
    return (result, elapsed);
  }
}
