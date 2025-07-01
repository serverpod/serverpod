import 'package:serverpod_test_module_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given ModuleEndpoint', (sessionBuilder, endpoints) {
    test('when calling hello with name then returns greeting', () async {
      final result = await endpoints.module.hello(sessionBuilder, 'name');
      expect(result, 'Hello name');
    });

    test('when calling modifyModuleObject with object then modifies object',
        () async {
      final object = ModuleClass(name: 'name', data: 1);
      final result =
          await endpoints.module.modifyModuleObject(sessionBuilder, object);
      expect(result.data, 42);
    });
  });
}
