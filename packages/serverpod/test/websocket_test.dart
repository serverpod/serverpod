import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/module.dart';
import 'package:test/test.dart';

import 'authentication_test.dart';

void main() {
  var client = Client(
    'http://serverpod_test_server:8080/',
    authenticationKeyManager: TestAuthKeyManager(),
  );

  var streamingStream = client.streaming.stream.asBroadcastStream();

  setUp(() {});

  group('Basic websocket', () {
    test('Connect and send SimpleData', () async {
      await client.connectWebSocket();

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
      var response =
          await client.authentication.authenticate('test@foo.bar', 'password');
      if (response.success) {
        await client.authenticationKeyManager!
            .put('${response.keyId}:${response.key}');
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);

      // Restart streams
      client.close();
      await Future.delayed(const Duration(milliseconds: 100));
      await client.connectWebSocket();
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
  });

  group('Timeout', () {
    test('5 second default timeout', () async {
      // Only perform the check for web.
      // TODO: Make sure this always works correctly on all platforms.
      if (identical(0, 0.0)) {
        client.close();
        await client.connectWebSocket();
        await Future.delayed(const Duration(seconds: 1));
        expect(client.isWebSocketConnected, true);

        // We should still be connected after 3 seconds.
        await Future.delayed(const Duration(seconds: 2));
        expect(client.isWebSocketConnected, true);

        // We should time out after 6 seconds if no messages are passed.
        await Future.delayed(const Duration(seconds: 3));
        expect(client.isWebSocketConnected, false);
      }
    });
  });
}
