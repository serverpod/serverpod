import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ModuleEndpoint extends Endpoint {
  /// The modules hooked up to the endpoints of the server when this endpoint
  /// was initialized, such as those a project hooks up before this module.
  List<String> modulesHookedUpWhenInitialized = [];

  @override
  void initialize(Server server, String name, String? moduleName) {
    super.initialize(server, name, moduleName);
    modulesHookedUpWhenInitialized = server.endpoints.modules.keys.toList();
  }

  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }

  Future<ModuleClass> modifyModuleObject(
    Session session,
    ModuleClass object,
  ) async {
    object.data = 42;
    return object;
  }
}
