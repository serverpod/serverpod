import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  late TestStorage storage;
  late Client client;

  group('Given a `ClientAuthSessionManager` created with an empty storage', () {
    setUpAll(() {
      client = Client('http://localhost:8080/');
      storage = TestStorage();

      client.authKeyProvider = ClientAuthSessionManager(
        caller: client.modules.serverpod_auth_core,
        storage: storage,
      );
    });

    test('when calling initialize, then it completes.', () async {
      await expectLater(client.auth.initialize(), completes);
    });

    test('when getting the authentication key, then it returns `null`.',
        () async {
      expect(await client.auth.authHeaderValue, isNull);
    });

    group('when logging in', () {
      setUpAll(() async {
        await client.auth.updateSignedInUser(_authSuccess);
      });

      test('then `isAuthenticated` returns `true`.', () {
        expect(client.auth.isAuthenticated, isTrue);
      });

      test('then `authHeaderValue` returns the session key as a Bearer token.',
          () async {
        expect(await client.auth.authHeaderValue, 'Bearer session-key');
      });

      test('then the auth info value matches the one used to log in.', () {
        final authInfo = client.auth.authInfo.value;

        expect(authInfo, isNotNull);
        expect(client.auth.authInfo.value.toString(), _authSuccess.toString());
      });

      test('then the storage contains the auth info.', () async {
        expect((await storage.get()).toString(), _authSuccess.toString());
      });
    });

    group('when logging out', () {
      setUpAll(() async {
        await client.auth.updateSignedInUser(_authSuccess);
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
  });

  group(
      'Given a `ClientAuthSessionManager` which has been initialized with a previous session from storage',
      () {
    setUpAll(() async {
      client = Client('http://localhost:8080/');
      storage = TestStorage();

      await storage.set(_authSuccess);

      client.authKeyProvider = ClientAuthSessionManager(
        caller: client.modules.serverpod_auth_core,
        storage: storage,
      );

      await client.auth.initialize();
    });

    test('when initialized again, then auth info is available.', () async {
      expect(client.auth.authInfo.value, isNotNull);
      expect(client.auth.isAuthenticated, isTrue);
      expect(client.auth.authInfo.value.toString(), _authSuccess.toString());
      expect(client.auth.authHeaderValue, 'Bearer session-key');
    });
  });
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
