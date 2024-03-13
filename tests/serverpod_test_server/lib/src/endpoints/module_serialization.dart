import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;

import '../generated/module_datatype.dart';

class ModuleSerializationEndpoint extends Endpoint {
  Future<bool> serializeModuleObject(Session session) async {
    var moduleClass = module.ModuleClass(
      data: 42,
      name: 'foo',
    );

    try {
      var s = SerializationManager.encode(moduleClass);
      var unpacked = pod.serializationManager.decode<module.ModuleClass>(s);
      return (unpacked.data == 42 && unpacked.name == 'foo');
    } catch (e, stackTrace) {
      stdout.writeln(
          'ModuleSerializationEndpoint.serializeModuleObject failed: $e');
      stdout.writeln('$stackTrace');

      return false;
    }
  }

  Future<module.ModuleClass> modifyModuleObject(
      Session session, module.ModuleClass object) async {
    object.data = 42;
    return object;
  }

  Future<ModuleDatatype> serializeNestedModuleObject(Session session) async {
    var internalModuleClass = module.ModuleClass(
      data: 42,
      name: 'foo',
    );

    return ModuleDatatype(
      model: internalModuleClass,
      list: [internalModuleClass],
      map: {'foo': internalModuleClass},
    );
  }
}
