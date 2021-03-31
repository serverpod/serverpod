import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class BasicDatabase extends Endpoint {
  Future<int?> storeTypes(Session session, Types types) async {
    await session.insert(types);
    return types.id;
  }

  Future<Types?> getTypes(Session session, int id) async {
    Types? types = await session.findById(tTypes, id) as Types?;
    return types;
  }

  Future<int?> countRows(Session session) async {
    int numRows = await session.count(tTypes);
    return numRows;
  }
}