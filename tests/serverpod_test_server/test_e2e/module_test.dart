import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/module.dart' as module;
import 'package:test/test.dart';

import 'config.dart';

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
  });

  group('Nested modules classes.', () {
    test(
      'Given a generated protocol class with a custom class, then serialze the internal data.',
      () async {
        var result =
            await client.moduleSerialization.serializeNestedModuleObject();
        expect(result.entity.data, equals(42));
        expect(result.list[0].data, equals(42));
        expect(result.map['foo']?.data, equals(42));
      },
    );
  });
}
