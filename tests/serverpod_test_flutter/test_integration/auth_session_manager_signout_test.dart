import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class MockStorage implements Storage {
  final Map<String, dynamic> _values = {};
  @override
  Future<int?> getInt(String key) async => _values[key];
  @override
  Future<String?> getString(String key) async => _values[key];
  @override
  Future<void> remove(String key) async => _values.remove(key);
  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;
  @override
  Future<void> setString(String key, String value) async =>
      _values[key] = value;
}

void main() {
  const serverUrl = 'http://serverpod_test_server:8080/';

  group('Given two authenticated clients with SessionManagers', () {
    late Client primaryClient;
    late Client secondaryClient;
    late SessionManager primarySessionManager;
    late SessionManager secondarySessionManager;

    setUp(() async {
      primaryClient = Client(
        serverUrl,
        authenticationKeyManager: FlutterAuthenticationKeyManager(
          storage: MockStorage(),
        ),
      );
      primarySessionManager = SessionManager(
        caller: primaryClient.modules.auth,
        storage: MockStorage(),
      );
      await primarySessionManager.initialize();

      secondaryClient = Client(
        serverUrl,
        authenticationKeyManager: FlutterAuthenticationKeyManager(
          storage: MockStorage(),
        ),
      );
      secondarySessionManager = SessionManager(
        caller: secondaryClient.modules.auth,
        storage: MockStorage(),
      );
      await secondarySessionManager.initialize();

      await _authenticateClientAndSessionManager(
        primaryClient,
        primarySessionManager,
      );
      await _authenticateClientAndSessionManager(
        secondaryClient,
        secondarySessionManager,
      );

      assert(
        primarySessionManager.isSignedIn,
        'Primary client failed to authenticate.',
      );
      assert(
        secondarySessionManager.isSignedIn,
        'Secondary client failed to authenticate.',
      );
      assert(
        await primaryClient.modules.auth.status.isSignedIn(),
        'Primary client is not signed in on the server.',
      );
      assert(
        await secondaryClient.modules.auth.status.isSignedIn(),
        'Secondary client is not signed in on the server.',
      );
    });

    tearDown(() async {
      await primaryClient.modules.auth.status.signOutAllDevices();
      primaryClient.close();
      secondaryClient.close();
    });

    group('when calling signOutDevice on the first SessionManager', () {
      setUp(() async {
        bool result = await primarySessionManager.signOutDevice();
        assert(
          result,
          'Primary SessionManager failed to sign out from current device.',
        );
      });

      test(
        'then the first client is signed out in SessionManager and on the server',
        () async {
          expect(
            await primaryClient.modules.auth.status.isSignedIn(),
            isFalse,
            reason:
                'Primary client should be signed out but is still signed in on the server.',
          );
        },
      );

      test(
        'then the second client remains signed in in SessionManager and on the server',
        () async {
          expect(
            await secondaryClient.modules.auth.status.isSignedIn(),
            isTrue,
            reason: 'Secondary client should remain signed in on the server.',
          );
        },
      );
    });

    group('when calling signOutAllDevices on the first SessionManager', () {
      setUp(() async {
        bool result = await primarySessionManager.signOutAllDevices();
        assert(
          result,
          'Primary SessionManager failed to sign out from all devices.',
        );
      });

      test(
        'then the first client is signed out in SessionManager and on the server',
        () async {
          expect(
            await primaryClient.modules.auth.status.isSignedIn(),
            isFalse,
            reason:
                'Primary client should be signed out but is still signed in on the server.',
          );
        },
      );

      test(
        'then the second client is signed out in SessionManager and on the server',
        () async {
          expect(
            await secondaryClient.modules.auth.status.isSignedIn(),
            isFalse,
            reason:
                'Secondary client should be signed out but is still signed in on the server.',
          );
        },
      );
    });
  });
}

Future<void> _authenticateClientAndSessionManager(
  Client client,
  SessionManager sessionManager,
) async {
  var response = await client.authentication.authenticate(
    'test@foo.bar',
    'password',
  );
  expect(response.success, isTrue, reason: 'Authentication failed for client.');
  await sessionManager.registerSignedInUser(
    response.userInfo!,
    response.keyId!,
    response.key!,
  );
}
