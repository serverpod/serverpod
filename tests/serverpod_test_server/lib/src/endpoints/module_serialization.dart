import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/module.dart' as module;
import '../generated/protocol.dart';

class ModuleSerializationEndpoint extends Endpoint {
  Future<bool> serializeModuleObject(Session session) async {
    var moduleClass = module.ModuleClass(
      data: 42,
      name: 'foo',
    );

    try {
      var s = pod.serializationManager.serializeEntity(moduleClass)!;
      var unpacked = pod.serializationManager.createEntityFromSerialization(jsonDecode(s)) as module.ModuleClass;
      return (unpacked.data == 42 && unpacked.name == 'foo');
    }
    catch(e, stackTrace) {
      print('ModuleSerializationEndpoint.serializeModuleObject failed: $e');
      print('$stackTrace');

      return false;
    }
  }

  Future<module.ModuleClass> modifyModuleObject(Session session, module.ModuleClass object) async {
    object.data = 42;
    return object;
  }
}
