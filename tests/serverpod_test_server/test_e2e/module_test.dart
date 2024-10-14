import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as module;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Modules', () {
    test('Serialization', () async {
      var success = await client.moduleSerialization.serializeModuleObject();
      expect(success, equals(true));
    });

    test('Module call', () async {
      var result = await client.modules.module.module.hello('World');
      expect(result, equals('Hello World'));
    });

    test('Passing module object', () async {
      var moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      var result =
          await client.moduleSerialization.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });

    test('Passing module object to module', () async {
      var moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      var result =
          await client.modules.module.module.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });

    group('when calling endpoint streams on module', () {
      late Stream streamingStream;
      setUpAll(() async {
        streamingStream =
            client.modules.module.streaming.stream.asBroadcastStream();
      });
      setUp(() async {
        await client.openStreamingConnection(
          disconnectOnLostInternetConnection: false,
        );
      });

      tearDown(() async {
        await client.closeStreamingConnection();
      });

      test('then should be possible to send to and read from endpoint stream',
          () async {
        var nums = [42, 1337, 69];

        for (var num in nums) {
          await client.modules.module.streaming
              .sendStreamMessage(module.ModuleClass(name: 'name', data: num));
        }

        var resultNums =
            (await streamingStream.take(3).toList()).map((o) => o.data);
        expect(resultNums, equals(nums));
      });

      test('then stream opened should have been called', () async {
        await expectLater(client.modules.module.streaming.wasStreamOpenCalled(),
            completion(isTrue));
      });

      test('then stream closed should have been called', () async {
        await client.closeStreamingConnection();

        await expectLater(
            client.modules.module.streaming.wasStreamClosedCalled(),
            completion(isTrue));
      });
    });
  });

  group('Nested modules classes.', () {
    test(
      'Given a generated protocol class with a custom class, then serialize the internal data.',
      () async {
        var result =
            await client.moduleSerialization.serializeNestedModuleObject();
        expect(result.model.data, equals(42));
        expect(result.list[0].data, equals(42));
        expect(result.map['foo']?.data, equals(42));
      },
    );
  });
}
