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

  Future<int?> countTypesRows(Session session) async {
    return await session.db.count(tTypes);
  }

  Future<int?> deleteAllInTypes(Session session) async {
    return await session.db.delete(
      tTypes,
      where: Constant(true),
    );
  }

  Future<void> createSimpleTestData(Session session, int numRows) async {
    for (int i = 0; i < numRows; i++) {
      var data = SimpleData(num: i,);
      await session.db.insert(data);
    }
  }

  Future<int?> countSimpleData(Session session) async {
    return await session.db.count(tSimpleData);
  }

  Future<void> deleteAllSimpleTestData(Session session) async {
    await session.db.delete(tSimpleData, where: Constant(true));
  }

  Future<void> deleteSimpleTestDataLessThan(Session session, int num) async {
    await session.db.delete(tSimpleData, where: (tSimpleData.num < num));
  }
}