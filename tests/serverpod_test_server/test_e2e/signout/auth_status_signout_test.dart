import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  group('Given two authenticated clients', () {
    late Client primaryClient;
    late Client secondaryClient;

    setUp(() async {
      primaryClient = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
      );
      secondaryClient = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
      );

      await _authenticateClient(primaryClient);
      await _authenticateClient(secondaryClient);

      assert(
        await primaryClient.modules.auth.status.isSignedIn(),
        'Primary client failed to authenticate',
      );
      assert(
        await secondaryClient.modules.auth.status.isSignedIn(),
        'Secondary client failed to authenticate',
      );
    });

    tearDown(() async {
      await primaryClient.modules.auth.status.signOutAllDevices();
      primaryClient.close();
      secondaryClient.close();
    });

    group('when calling signOutCurrentDevice with first client', () {
      setUp(() async {
        await primaryClient.modules.auth.status.signOutDevice();
      });

      test('then first client is signed out', () async {
        expect(
          await primaryClient.modules.auth.status.isSignedIn(),
          isFalse,
          reason:
              'Primary client was not signed out after signOutCurrentDevice()',
        );
      });

      test('then second client remains signed in', () async {
        expect(
          await secondaryClient.modules.auth.status.isSignedIn(),
          isTrue,
          reason:
              'Secondary client should remain signed in after primary client signOutCurrentDevice()',
        );
      });
    });

    group('when calling signOutAllDevices with first client', () {
      setUp(() async {
        await primaryClient.modules.auth.status.signOutAllDevices();
      });

      test('then first client is signed out', () async {
        expect(
          await primaryClient.modules.auth.status.isSignedIn(),
          isFalse,
          reason: 'Primary client was not signed out after signOutAllDevices()',
        );
      });

      test('then second client is signed out', () async {
        expect(
          await secondaryClient.modules.auth.status.isSignedIn(),
          isFalse,
          reason:
              'Secondary client was not signed out after signOutAllDevices()',
        );
      });
    });
  });
}

Future<void> _authenticateClient(Client client) async {
  var response = await client.authentication.authenticate(
    'test@foo.bar',
    'password',
  );
  expect(response.success, isTrue, reason: 'Authentication failed for client');
  // ignore: deprecated_member_use
  await client.authenticationKeyManager?.put(
    '${response.keyId}:${response.key}',
  );
}
