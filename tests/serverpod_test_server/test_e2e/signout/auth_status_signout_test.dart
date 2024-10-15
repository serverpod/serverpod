import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Given an authenticated user', () {
    late Client client;
    late Client secondClient;

    setUpAll(() async {
      // Create two clients to simulate two different devices
      client = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
      );
      secondClient = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
      );
    });

    tearDownAll(() async {
      // Clean up after tests
      await client.modules.auth.status.signOutAllDevices();
      secondClient.close();
      client.close();
    });

    test(
        'when calling the deprecated signOutUser method from the status endpoint then the user is signed out from all sessions on all devices',
        () async {
      // Authenticate the first client and store the auth key
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(response.success, isTrue,
          reason: 'Re-authentication failed for the first client');
      await client.authenticationKeyManager
          ?.put('${response.keyId}:${response.key}');

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClient.authenticationKeyManager
          ?.put('${secondResponse.keyId}:${secondResponse.key}');

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out from all sessions using the deprecated signOutUser method
      // ignore: deprecated_member_use
      await client.modules.auth.status.signOutUser();

      // Verify both sessions are signed out
      firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isFalse);
      expect(secondSessionSignedIn, isFalse);
    });

    test(
        'when calling signOutCurrentDevice from the status endpoint then only the current device session is signed out and other devices remain signed in',
        () async {
      // Authenticate the first client and store the auth key
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(response.success, isTrue,
          reason: 'Re-authentication failed for the first client');
      await client.authenticationKeyManager
          ?.put('${response.keyId}:${response.key}');

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClient.authenticationKeyManager
          ?.put('${secondResponse.keyId}:${secondResponse.key}');

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out only from the current device (client)
      await client.modules.auth.status.signOutCurrentDevice();

      // Verify the first client is signed out but the second remains signed in
      firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isFalse);
      expect(secondSessionSignedIn, isTrue);
    });

    test(
        'when calling signOutAllDevices from the status endpoint then all sessions on all devices are signed out',
        () async {
      // Authenticate the first client and store the auth key
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(response.success, isTrue,
          reason: 'Re-authentication failed for the first client');
      await client.authenticationKeyManager
          ?.put('${response.keyId}:${response.key}');

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClient.authenticationKeyManager
          ?.put('${secondResponse.keyId}:${secondResponse.key}');

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out from all devices
      await client.modules.auth.status.signOutAllDevices();

      // Verify both clients are signed out
      firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isFalse);
      expect(secondSessionSignedIn, isFalse);
    });
  });
}
