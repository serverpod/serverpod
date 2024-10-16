import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class MockStorage implements Storage {
  final Map<String, dynamic> _values = {};
  @override
  Future<int?> getInt(String key) async {
    return _values[key];
  }

  @override
  Future<String?> getString(String key) async {
    return _values[key];
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }
}

void main() {
  const serverUrl = 'http://serverpod_test_server:8080/';

  group('Given an authenticated user', () {
    late Client client;
    late Client secondClient;
    late SessionManager clientSessionManager;
    late SessionManager secondClientSessionManager;

    setUpAll(() async {
      // Create two clients to simulate two different devices
      client = Client(
        serverUrl,
        authenticationKeyManager: FlutterAuthenticationKeyManager(
          storage: MockStorage(),
        ),
      );
      clientSessionManager = SessionManager(
        caller: client.modules.auth,
        storage: MockStorage(),
      );
      await clientSessionManager.initialize();

      secondClient = Client(
        serverUrl,
        authenticationKeyManager: FlutterAuthenticationKeyManager(
          storage: MockStorage(),
        ),
      );
      secondClientSessionManager = SessionManager(
        caller: secondClient.modules.auth,
        storage: MockStorage(),
      );
      await secondClientSessionManager.initialize();
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
      await clientSessionManager.registerSignedInUser(
        response.userInfo!,
        response.keyId!,
        response.key!,
      );

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClientSessionManager.registerSignedInUser(
        secondResponse.userInfo!,
        secondResponse.keyId!,
        secondResponse.key!,
      );

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out from all sessions using the deprecated signOutUser method
      // ignore: deprecated_member_use
      await clientSessionManager.signOut();

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
      await clientSessionManager.registerSignedInUser(
        response.userInfo!,
        response.keyId!,
        response.key!,
      );

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClientSessionManager.registerSignedInUser(
        secondResponse.userInfo!,
        secondResponse.keyId!,
        secondResponse.key!,
      );

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out only from the current device (client)
      await clientSessionManager.signOutCurrentDevice();

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
      await clientSessionManager.registerSignedInUser(
        response.userInfo!,
        response.keyId!,
        response.key!,
      );

      // Authenticate the second client and store the auth key
      var secondResponse = await secondClient.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      expect(secondResponse.success, isTrue,
          reason: 'Re-authentication failed for the second client');
      await secondClientSessionManager.registerSignedInUser(
        secondResponse.userInfo!,
        secondResponse.keyId!,
        secondResponse.key!,
      );

      // Check both sessions are signed in
      var firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      var secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isTrue);
      expect(secondSessionSignedIn, isTrue);

      // Sign out from all devices
      await clientSessionManager.signOutAllDevices();

      // Verify both clients are signed out
      firstSessionSignedIn = await client.modules.auth.status.isSignedIn();
      secondSessionSignedIn =
          await secondClient.modules.auth.status.isSignedIn();
      expect(firstSessionSignedIn, isFalse);
      expect(secondSessionSignedIn, isFalse);
    });
  });
}
