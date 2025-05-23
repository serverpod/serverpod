import 'package:serverpod_test_module_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given IgnoredModuleEndpoint (marked with `@doNotGenerate`)',
      (sessionBuilder, endpoints) {
    test('when calling `echoString`, then it returns the input.', () async {
      final result = await endpoints.ignoredModule.echoString(
        sessionBuilder,
        'hello!',
      );

      expect(result, 'hello!');
    });

    // TODO: BigInt does not flow properly through the test tools right now
    // test('when calling `echoRecord`, then it returns the input.', () async {
    //   final result = await endpoints.ignoredModule.echoRecord(
    //     sessionBuilder,
    //     (1, BigInt.from(2)),
    //   );

    //   expect(
    //     result.$1,
    //     1,
    //   );
    //   expect(result.$2.toInt(), 2);
    // });

    test('when calling `echoModel`, then it returns the input.', () async {
      final result = await endpoints.ignoredModule.echoModel(
        sessionBuilder,
        IgnoreEndpointModel(name: 'test'),
      );

      expect(result.name, 'test');
    });

    test(
        'when calling `ignoredMethod`, it will throw as that ignored method is not exposed',
        () async {
      await expectLater(
        () => (endpoints.module as dynamic).ignoredMethod(sessionBuilder),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}
