import 'package:serverpod/serverpod.dart';

class MyFeatureEndpoint extends Endpoint {
  Future<String> myFeatureMethod(Session session) async {
    return 'Hello, world!';
  }
}
