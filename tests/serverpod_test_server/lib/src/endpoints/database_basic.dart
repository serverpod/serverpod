import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class BasicDatabase extends Endpoint {
  Future<int?> storeTypes(Session session, Types types) async {
    await session.db.insert(types);
    return types.id;
  }

  Future<Types?> getTypes(Session session, int id) async {
    var types = await session.db.findById(tTypes, id) as Types?;
    return types;
  }

  Future<int?> getTypesRawQuery(Session session, int id) async {
    var query = 'SELECT * FROM types WHERE id = $id';
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
    for (var i = 0; i < numRows; i++) {
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

  Future<bool?> findAndDeleteSimpleTestData(Session session, int num) async {
    var data = await session.db.findSingleRow(
      tSimpleData,
      where: tSimpleData.num.equals(num),
    ) as SimpleData?;

    return await session.db.deleteRow(data!);
  }

  Future<SimpleDataList?> findSimpleDataRowsLessThan(Session session, int num, int offset, int limit, bool descending) async {
    var rows = await session.db.find(
      tSimpleData,
      where: (tSimpleData.num < num),
      offset: offset,
      limit: limit,
      orderBy: tSimpleData.num,
      orderDescending: descending,
    );

    return SimpleDataList(
      rows: rows.cast<SimpleData>(),
    );
  }

  Future<bool?> updateSimpleDataRow(Session session, int num, int newNum) async {
    var data = await session.db.findSingleRow(
      tSimpleData,
      where: tSimpleData.num.equals(num),
    ) as SimpleData?;

    if (data == null)
      return false;

    data.num = newNum;
    return await session.db.update(data);
  }

  Future<int?> storeObjectWithObject(Session session, ObjectWithObject object) async {
    await session.db.insert(object);
    return object.id;
  }

  Future<ObjectWithObject?> getObjectWithObject(Session session, int id) async {
    var object = await session.db.findById(tObjectWithObject, id) as ObjectWithObject?;
    return object;
  }
}