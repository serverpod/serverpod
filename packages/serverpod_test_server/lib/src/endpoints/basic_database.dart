import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class BasicDatabase extends Endpoint {
  Future<int?> storeTypes(Session session, Types types) async {
    await session.db.insert(types);
    return types.id;
  }

  Future<Types?> getTypes(Session session, int id) async {
    Types? types = await session.db.findById(tTypes, id) as Types?;
    return types;
  }

  Future<int?> getTypesRawQuery(Session session, int id) async {
    String query = 'SELECT * FROM types WHERE id = $id';
    var result = await session.db.query(query);
    if (result.length != 1) {
      print('getTypesRawQuery expected 1 row');
      return null;
    }
    var row = result[0];
    if (row.length != tTypes.columns.length) {
      print('getTypesRawQuery expected row with ${tTypes.columns.length} entries');
      return null;
    }
    return row[0] as int;
  }

  Future<int?> countRows(Session session) async {
    int numRows = await session.db.count(tTypes);
    return numRows;
  }
}