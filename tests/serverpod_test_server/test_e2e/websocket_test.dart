import 'dart:async';

import 'package:serverpod/src/authentication/scope.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_shared/serverpod_test_shared.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    // ignore: deprecated_member_use
    authenticationKeyManager: TestAuthKeyManager(),
  );

  var streamingStream = client.streaming.stream.asBroadcastStream();

  setUp(() {});

  group('Basic websocket', () {
    test('Connect and send SimpleData', () async {
      // ignore: deprecated_member_use
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      var nums = [42, 1337, 69];

      for (var num in nums) {
        await client.streaming.sendStreamMessage(SimpleData(num: num));
      }

      var i = 0;
      await for (var message in streamingStream) {
        var simpleData = message as SimpleData;
        expect(simpleData.num, nums[i]);

        i += 1;
        if (i == nums.length) break;
      }
    });

    test('Test extraClassNames', () async {
      expect(
        client.serializationManager.getClassNameForObject(CustomClass('test')),
        'CustomClass',
      );

      // ignore: deprecated_member_use
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      var resultFuture = client.customTypes.stream
          .timeout(const Duration(seconds: 4))
          .first;

      await client.customTypes.sendStreamMessage(CustomClass('test'));

      var result = await resultFuture;

      expect(result, isNotNull);
      expect(result, isA<CustomClass>());
      expect((result as CustomClass).value, 'testtest');
    });
  });

  group('Modules', () {
    test('Send ModuleClass to module', () async {
      var nums = [42, 1337, 69];
      var names = ['Foo', 'Bar', 'Baz'];

      for (var i = 0; i < nums.length; i += 1) {
        await client.modules.module.streaming.sendStreamMessage(
          ModuleClass(name: names[i], data: nums[i]),
        );
      }

      var i = 0;
      await for (var message in client.modules.module.streaming.stream) {
        var object = message as ModuleClass;
        expect(object.data, nums[i]);
        expect(object.name, names[i]);

        i += 1;
        if (i == nums.length) break;
      }
    });
  });

  group('Authentication', () {
    test('Access restricted endpoint without authentication', () async {
      // This should be ignored by the server as user isn't authenticated.
      await client.signInRequired.sendStreamMessage(SimpleData(num: 666));
      await Future.delayed(const Duration(seconds: 1));
    });

    test('Authenticate with correct credentials', () async {
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      if (response.success) {
        // ignore: deprecated_member_use
        await client.authenticationKeyManager!.put(
          '${response.keyId}:${response.key}',
        );
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);
      expect(response.key, isNotNull);
      expect(response.keyId, isNotNull);

      // Restart streams
      // ignore: deprecated_member_use
      await client.closeStreamingConnection();
      // ignore: deprecated_member_use
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );
    });

    test('Connect and send SimpleData while authenticated', () async {
      var nums = [11, 22, 33];

      for (var num in nums) {
        await client.signInRequired.sendStreamMessage(SimpleData(num: num));
      }

      var i = 0;
      await for (var message in client.signInRequired.stream) {
        var simpleData = message as SimpleData;
        expect(simpleData.num, nums[i]);

        i += 1;
        if (i == nums.length) break;
      }
    });

    test('Upgrade streaming connection', () async {
      // Make sure we are signed out.
      await client.authentication.signOut();
      // ignore: deprecated_member_use
      await client.authenticationKeyManager!.remove();
      // ignore: deprecated_member_use
      await client.closeStreamingConnection();
      client.signInRequired.resetStream();
      // ignore: deprecated_member_use
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      // This should be ignored by the server as user isn't authenticated.
      await client.signInRequired.sendStreamMessage(SimpleData(num: 666));
      await Future.delayed(const Duration(seconds: 1));

      // Authenticate and upgrade stream.
      var response = await client.authentication.authenticate(
        'test@foo.bar',
        'password',
      );
      if (response.success) {
        // ignore: deprecated_member_use
        await client.authenticationKeyManager!.put(
          '${response.keyId}:${response.key}',
        );
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);
      expect(response.key, isNotNull);
      expect(response.keyId, isNotNull);

      // ignore: deprecated_member_use
      await client.updateStreamingConnectionAuthenticationKey();

      var nums = [11, 22, 33];

      for (var num in nums) {
        await client.signInRequired.sendStreamMessage(SimpleData(num: num));
      }

      var i = 0;
      await for (var message in client.signInRequired.stream) {
        var simpleData = message as SimpleData;
        expect(simpleData.num, nums[i]);

        i += 1;
        if (i == nums.length) break;
      }
      // ignore: deprecated_member_use
      client.closeStreamingConnection();
      client.signInRequired.resetStream();
    });

    group('Given signed in user without "admin" scope', () {
      setUp(() async {
        var response = await client.authentication.authenticate(
          'test@foo.bar',
          'password',
        );
        assert(response.success, 'Failed to authenticate user');
        // ignore: deprecated_member_use
        await client.authenticationKeyManager?.put(
          '${response.keyId}:${response.key}',
        );
        assert(
          await client.modules.auth.status.isSignedIn(),
          'Failed to sign in',
        );
        // ignore: deprecated_member_use
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );
      });

      tearDown(() async {
        // ignore: deprecated_member_use
        await client.authenticationKeyManager?.remove();
        await client.authentication.removeAllUsers();
        await client.authentication.signOut();
        assert(
          await client.modules.auth.status.isSignedIn() == false,
          'Still signed in after teardown',
        );
        // ignore: deprecated_member_use
        client.closeStreamingConnection();
        client.adminScopeRequired.resetStream();
      });

      test(
        'when sending message to stream endpoint that requires "admin" scope then message is ignored.',
        () async {
          await client.adminScopeRequired.sendStreamMessage(
            SimpleData(num: 666),
          );

          expectLater(
            client.adminScopeRequired.stream.first.timeout(
              Duration(seconds: 2),
            ),
            throwsA(isA<TimeoutException>()),
          );
        },
      );
    });

    group('Given signed in user with "admin" scope', () {
      setUp(() async {
        var response = await client.authentication.authenticate(
          'test@foo.bar',
          'password',
          [Scope.admin.name!],
        );
        assert(response.success, 'Failed to authenticate user');
        // ignore: deprecated_member_use
        await client.authenticationKeyManager?.put(
          '${response.keyId}:${response.key}',
        );
        assert(
          await client.modules.auth.status.isSignedIn(),
          'Failed to sign in',
        );
        // ignore: deprecated_member_use
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );
      });

      tearDown(() async {
        // ignore: deprecated_member_use
        await client.authenticationKeyManager?.remove();
        await client.authentication.removeAllUsers();
        await client.authentication.signOut();
        assert(
          await client.modules.auth.status.isSignedIn() == false,
          'Still signed in after teardown',
        );
        // ignore: deprecated_member_use
        client.closeStreamingConnection();
        client.adminScopeRequired.resetStream();
      });

      test(
        'when sending message to stream endpoint that requires "admin" scope then message is processed.',
        () async {
          const streamedNumber = 666;
          await client.adminScopeRequired.sendStreamMessage(
            SimpleData(num: streamedNumber),
          );

          expectLater(
            client.adminScopeRequired.stream.first.timeout(
              Duration(seconds: 2),
            ),
            completion(
              isA<SerializableModel>().having(
                (e) => (e as SimpleData).num,
                'num',
                streamedNumber,
              ),
            ),
          );
        },
      );
    });
  });

  group('Closing and reconnecting', () {
    test('Close and reconnect', () async {
      // Close and immediately reconnect.
      // ignore: deprecated_member_use
      await client.closeStreamingConnection();
      // ignore: deprecated_member_use
      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      // Immediately after the connection call, we should be in a connecting
      // state.
      expect(
        // ignore: deprecated_member_use
        client.streamingConnectionStatus,
        equals(StreamingConnectionStatus.connecting),
      );

      // We should be connected shortly after opening the stream.
      await Future.delayed(const Duration(seconds: 1));
      expect(
        // ignore: deprecated_member_use
        client.streamingConnectionStatus,
        StreamingConnectionStatus.connected,
      );

      // We should still be connected after 5 seconds.
      await Future.delayed(const Duration(seconds: 5));
      expect(
        // ignore: deprecated_member_use
        client.streamingConnectionStatus,
        StreamingConnectionStatus.connected,
      );
    });

    test('Disconnect', () async {
      // ignore: deprecated_member_use
      await client.closeStreamingConnection();

      expect(
        // ignore: deprecated_member_use
        client.streamingConnectionStatus,
        StreamingConnectionStatus.disconnected,
      );
    });
  });
}
