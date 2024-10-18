// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
// import '../generated/protocol.dart';

class ModuleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return ModuleUtil.buildGreeting(name);
  }
}

abstract final class ModuleUtil {
  static String buildGreeting(String name) {
    return 'Hello $name';
  }
}
