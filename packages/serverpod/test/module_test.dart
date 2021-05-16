import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/module.dart' as module;

void main() {
  Client client = Client('http://localhost:8080/');
  client.registerModuleProtocol(module.Protocol());

  setUp(() {
  });

  group('Modules', () {
    test('Serialization', () async {
      var success = await client.moduleSerialization.serializeModuleObject();
      expect(success, equals(true));
    });

    test('Module call', () async {
      String result = await client.modules.module.module.hello('World');
      expect(result, equals('Hello World'));
    });

    test('Passing module object', () async {
      var moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      var result = await client.moduleSerialization.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });

    test('Passing module object to module', () async {
      var moduleClass = module.ModuleClass(
          name: 'foo',
          data: 0,
      );
      var result = await client.modules.module.module.modifyModuleObject(moduleClass);
      expect(result.data, equals(42));
    });
  });
}