import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  group(
    'Given two authenticated clients with separate session managers of different auth strategies',
    () {
      late Client jwtClient;
      late Client sasClient;

      late EndpointStatus jwtStatusEndpoint;
      late EndpointStatus sasStatusEndpoint;

      setUp(() async {
        jwtClient = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(
            storage: TestStorage(),
          );
        sasClient = Client('http://localhost:8080/')
          ..authSessionManager = ClientAuthSessionManager(
            storage: TestStorage(),
          );

        await jwtClient.auth.initialize();
        await sasClient.auth.initialize();

        // Can be called from either clients, since both connect to the same server.
        final testUserId = await jwtClient.authTest.createTestUser();

        await jwtClient.auth.updateSignedInUser(
          await jwtClient.authTest.createJwtToken(testUserId),
        );

        await sasClient.auth.updateSignedInUser(
          await sasClient.authTest.createSasToken(testUserId),
        );

        jwtStatusEndpoint = jwtClient.modules.serverpod_auth_core.status;
        sasStatusEndpoint = sasClient.modules.serverpod_auth_core.status;

        expect(await jwtStatusEndpoint.isSignedIn(), isTrue);
        expect(await sasStatusEndpoint.isSignedIn(), isTrue);
      });

      group('when calling the signOutDevice method on the JWT client', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await jwtClient.auth.signOutDevice();
        });

        test('then signOutDevice returns true.', () {
          expect(signOutResult, isTrue);
        });

        test(
          'then the user is signed out in the JWT client and on the server.',
          () async {
            expect(await jwtStatusEndpoint.isSignedIn(), isFalse);
          },
        );

        test(
          'then refresh tokens in the JWT client as skipped due to null auth info.',
          () async {
            expect(
              await jwtClient.auth.refreshAuthKey(force: true),
              RefreshAuthKeyResult.skipped,
            );
          },
        );

        test(
          'then the user is still signed in in the SAS client and on the server.',
          () async {
            expect(await sasStatusEndpoint.isSignedIn(), isTrue);
          },
        );
      });

      group('when calling the signOutDevice method on the SAS client', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await sasClient.auth.signOutDevice();
        });

        test('then signOutDevice returns true.', () {
          expect(signOutResult, isTrue);
        });

        test(
          'then the user is signed out in the SAS client and on the server.',
          () async {
            expect(await sasStatusEndpoint.isSignedIn(), isFalse);
          },
        );

        test(
          'then the user is still signed in in the JWT client and on the server.',
          () async {
            expect(await jwtStatusEndpoint.isSignedIn(), isTrue);
          },
        );

        test(
          'then the user can still refresh tokens in the JWT client.',
          () async {
            expect(
              await jwtClient.auth.refreshAuthKey(force: true),
              RefreshAuthKeyResult.success,
            );
          },
        );
      });

      group('when calling the signOutAllDevices method on the JWT client', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await jwtClient.auth.signOutAllDevices();
        });

        test('then signOutAllDevices returns true.', () {
          expect(signOutResult, isTrue);
        });

        test(
          'then the user is signed out in the JWT client and on the server.',
          () async {
            expect(await jwtStatusEndpoint.isSignedIn(), isFalse);
          },
        );

        test(
          'then refresh tokens in the JWT client as skipped due to null auth info.',
          () async {
            expect(
              await jwtClient.auth.refreshAuthKey(force: true),
              RefreshAuthKeyResult.skipped,
            );
          },
        );

        test(
          'then the user is signed out in the SAS client and on the server.',
          () async {
            expect(await sasStatusEndpoint.isSignedIn(), isFalse);
          },
        );

        test(
          'then validateAuthentication signs out the user in the SAS client.',
          () async {
            expect(await sasClient.auth.validateAuthentication(), isTrue);
            expect(await sasStatusEndpoint.isSignedIn(), isFalse);
          },
        );
      });

      group('when calling the signOutAllDevices method on the SAS client', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await sasClient.auth.signOutAllDevices();
        });

        test('then signOutAllDevices returns true.', () {
          expect(signOutResult, isTrue);
        });

        test(
          'then the user is signed out in the SAS client and on the server.',
          () async {
            expect(await sasStatusEndpoint.isSignedIn(), isFalse);
          },
        );

        // If calling `signOutAllDevices` from another client, we can't test that
        // the user gets signed out from JWT clients, since the access token will
        // still be valid. The user will be signed out when the access token
        // expires and the client attempts to refresh it.

        test(
          'then the user can no longer refresh tokens in the JWT client.',
          () async {
            expect(
              await jwtClient.auth.refreshAuthKey(force: true),
              RefreshAuthKeyResult.failedUnauthorized,
            );
          },
        );

        test(
          'then validateAuthentication signs out the user in the JWT client.',
          () async {
            expect(await jwtClient.auth.validateAuthentication(), isTrue);
            expect(await jwtStatusEndpoint.isSignedIn(), isFalse);
          },
        );
      });
    },
  );

  group(
    'Given an authenticated client with an unreachable server when signing out',
    () {
      late Client client;
      late TestStorage storage;

      setUp(() async {
        final tempClient = Client('http://localhost:8080/');
        final testUserId = await tempClient.authTest.createTestUser();
        final authSuccess = await tempClient.authTest.createJwtToken(
          testUserId,
        );

        storage = TestStorage();
        await storage.set(authSuccess);

        client = Client(
          'http://unreachable-server/',
          connectionTimeout: const Duration(milliseconds: 100),
        )..authSessionManager = ClientAuthSessionManager(storage: storage);

        await client.auth.restore();

        expect(client.auth.isAuthenticated, isTrue);
      });

      group('when calling signOutDevice', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await client.auth.signOutDevice();
        });

        test('then signOutDevice returns false.', () {
          expect(signOutResult, isFalse);
        });

        test('then the user is signed out locally.', () {
          expect(client.auth.isAuthenticated, isFalse);
        });

        test('then the auth info value is null.', () {
          expect(client.auth.authInfo.value, isNull);
        });

        test('then the storage is cleared.', () async {
          expect(await storage.get(), isNull);
        });
      });

      group('when calling signOutAllDevices', () {
        late bool signOutResult;

        setUp(() async {
          signOutResult = await client.auth.signOutAllDevices();
        });

        test('then signOutAllDevices returns false.', () {
          expect(signOutResult, isFalse);
        });

        test('then the user is signed out locally.', () {
          expect(client.auth.isAuthenticated, isFalse);
        });

        test('then the auth info value is null.', () {
          expect(client.auth.authInfo.value, isNull);
        });

        test('then the storage is cleared.', () async {
          expect(await storage.get(), isNull);
        });
      });
    },
  );
}
