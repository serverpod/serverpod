import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ModuleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }

  Future<ModuleClass> modifyModuleObject(
      Session session, ModuleClass object) async {
    object.data = 42;
    return object;
  }
}
