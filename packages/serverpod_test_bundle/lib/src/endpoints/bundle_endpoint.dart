import 'package:serverpod/serverpod.dart';

class BundleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
}