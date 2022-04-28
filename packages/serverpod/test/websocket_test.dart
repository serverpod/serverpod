import 'package:serverpod_auth_client/src/protocol/authentication_response.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/module.dart';
import 'package:test/test.dart';

import 'authentication_test.dart';

void main() {
  Client client = Client(
    'http://serverpod_test_server:8080/',
    authenticationKeyManager: TestAuthKeyManager(),
  );

  Stream<SerializableEntity> streamingStream =
      client.streaming.stream.asBroadcastStream();

  setUp(() {});

  group('Basic websocket', () {
    test('Connect and send SimpleData', () async {
      await client.connectWebSocket();

      List<int> nums = <int>[42, 1337, 69];

      for (int num in nums) {
        await client.streaming.sendStreamMessage(SimpleData(num: num));
      }

      int i = 0;
      await for (SerializableEntity message in streamingStream) {
        SimpleData simpleData = message as SimpleData;
        expect(simpleData.num, nums[i]);

        i += 1;
        if (i == nums.length) break;
      }
    });
  });

  group('Modules', () {
    test('Send ModuleClass to module', () async {
      List<int> nums = <int>[42, 1337, 69];
      List<String> names = <String>['Foo', 'Bar', 'Baz'];

      for (int i = 0; i < nums.length; i += 1) {
        await client.modules.module.streaming.sendStreamMessage(
          ModuleClass(name: names[i], data: nums[i]),
        );
      }

      int i = 0;
      await for (SerializableEntity message
          in client.modules.module.streaming.stream) {
        ModuleClass object = message as ModuleClass;
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
      await Future<void>.delayed(const Duration(seconds: 1));
    });

    test('Authenticate with correct credentials', () async {
      AuthenticationResponse response =
          await client.authentication.authenticate('test@foo.bar', 'password');
      if (response.success) {
        await client.authenticationKeyManager!
            .put('${response.keyId}:${response.key}');
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);

      // Restart streams
      client.close();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await client.connectWebSocket();
    });

    test('Connect and send SimpleData while authenticated', () async {
      List<int> nums = <int>[11, 22, 33];

      for (int num in nums) {
        await client.signInRequired.sendStreamMessage(SimpleData(num: num));
      }

      int i = 0;
      await for (SerializableEntity message in client.signInRequired.stream) {
        SimpleData simpleData = message as SimpleData;
        expect(simpleData.num, nums[i]);

        i += 1;
        if (i == nums.length) break;
      }
    });
  });

  group('Timeout', () {
    test('5 second default timeout', () async {
      client.close();
      await client.connectWebSocket();
      expect(client.isWebSocketConnected, true);

      // We should still be connected after 3 seconds.
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(client.isWebSocketConnected, true);

      // We should time out after 6 seconds if no messages are passed.
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(client.isWebSocketConnected, false);
    });
  });
}
