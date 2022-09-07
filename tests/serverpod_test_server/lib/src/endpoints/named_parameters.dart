import 'package:serverpod/serverpod.dart';

class NamedParametersEndpoint extends Endpoint {
  Future<bool> namedParametersMethod(
    Session session, {
    required int namedInt,
    int intWithDefaultValue = 42,
    int? nullableInt,
    int? nullableIntWithDefaultValue = 42,
  }) async {
    return true;
  }

  Future<bool> namedParametersMethodEqualInts(
    Session session, {
    required int namedInt,
    int? nullableInt,
  }) async {
    return namedInt == nullableInt;
  }
}
