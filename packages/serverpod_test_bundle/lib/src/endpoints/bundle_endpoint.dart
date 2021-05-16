import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class BundleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }

  Future<BundleClass> modifyBundleObject(Session session, BundleClass object) async {
    object.data = 42;
    return object;
  }
}