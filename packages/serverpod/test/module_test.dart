import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/module.dart' as module;
import 'package:test/test.dart';

void main() {
  Client client = Client('http://serverpod_test_server:8080/');

  setUp(() {});

  group('Modules', () {
    test('Serialization', () async {
      bool success = await client.moduleSerialization.serializeModuleObject();
      expect(success, equals(true));
    });

    test('Module call', () async {
      String result = await client.modules.module.module.hello('World');
      expect(result, equals('Hello World'));
    });

    test('Passing module object', () async {
      module.ModuleClass moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      module.ModuleClass result =
          await client.moduleSerialization.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });

    test('Passing module object to module', () async {
      module.ModuleClass moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      module.ModuleClass result =
          await client.modules.module.module.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });
  });
}
