import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/module.dart' as module;

class ModuleSerializationEndpoint extends Endpoint {
  Future<bool> serializeModuleObject(Session session) async {
    var moduleClass = module.ModuleClass(
      data: 42,
      name: 'foo',
    );

    try {
      var s = SerializationManager.serializeToJson(moduleClass);
      var unpacked =
          pod.serializationManager.deserializeJson<module.ModuleClass>(s);
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
}
