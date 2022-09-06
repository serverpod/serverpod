import 'package:serverpod/serverpod.dart';

class OptionalParametersEndpoint extends Endpoint {
  Future<int?> returnOptionalInt(Session session, [int? optionalInt]) async {
    return optionalInt;
  }
}
