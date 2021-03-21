import 'package:serverpod/serverpod.dart';

int globalInt = 0;

class BasicTypesEndpoint extends Endpoint {

  Future<int> testInt(Session session, int value) async {
    return value;
  }

  Future<double> testDouble(Session session, double value) async {
    return value;
  }

  Future<String> testString(Session session, String value) async {
    return value;
  }

  Future<List<int>> testIntList(Session session, List<int> value) async {
    return value;
  }
}