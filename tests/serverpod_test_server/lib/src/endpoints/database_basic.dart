import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

int globalInt = 0;

class BasicDatabase extends Endpoint {
  Future<int?> storeTypes(Session session, Types types) async {
    await Types.insert(session, types);
    return types.id;
  }

  Future<Types?> getTypes(Session session, int id) async {
    var types = await Types.findById(session, id);
    return types;
  }

  Future<int?> storeObjectWithEnum(
    Session session,
    ObjectWithEnum object,
  ) async {
    await ObjectWithEnum.insert(session, object);
    return object.id;
  }

  Future<ObjectWithEnum?> getObjectWithEnum(Session session, int id) async {
    var object = await ObjectWithEnum.findById(session, id);
    return object;
  }

  Future<int?> getTypesRawQuery(Session session, int id) async {
    var query = 'SELECT * FROM types WHERE id = $id';
    var result = await session.db.query(query);
    if (result.length != 1) {
      return null;
    }
    var row = result[0];
    if (row.length != Types.t.columns.length) {
      return null;
    }
    return row[0] as int;
  }

  Future<int?> countTypesRows(Session session) async {
    return await Types.count(session);
  }

  Future<int?> deleteAllInTypes(Session session) async {
    return await Types.delete(session, where: (t) => Constant(true));
  }

  Future<void> createSimpleTestData(Session session, int numRows) async {
    for (var i = 0; i < numRows; i++) {
      var data = SimpleData(
        num: i,
      );
      await SimpleData.insert(session, data);
    }
  }

  Future<int?> countSimpleData(Session session) async {
    return await SimpleData.count(session);
  }

  Future<void> deleteAllSimpleTestData(Session session) async {
    await SimpleData.delete(session, where: (t) => Constant(true));
  }

  Future<void> deleteSimpleTestDataLessThan(Session session, int num) async {
    await SimpleData.delete(session, where: (t) => t.num < num);
    await session.db.delete<SimpleData>(where: (SimpleData.t.num < num));
  }

  Future<bool?> findAndDeleteSimpleTestData(Session session, int num) async {
    var data = await SimpleData.findSingleRow(
      session,
      where: (t) => t.num.equals(num),
    );

    return await session.db.deleteRow(data!);
  }

  Future<SimpleDataList?> findSimpleDataRowsLessThan(
    Session session,
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    var rows = await SimpleData.find(
      session,
      where: (t) => t.num < num,
      offset: offset,
      limit: limit,
      orderBy: SimpleData.t.num,
      orderDescending: descending,
    );

    return SimpleDataList(
      rows: rows,
    );
  }

  Future<bool?> updateSimpleDataRow(
    Session session,
    int num,
    int newNum,
  ) async {
    var data = await SimpleData.findSingleRow(
      session,
      where: (t) => t.num.equals(num),
    );

    if (data == null) return false;

    data.num = newNum;
    return await SimpleData.update(session, data);
  }

  Future<int?> storeObjectWithObject(
      Session session, ObjectWithObject object) async {
    await ObjectWithObject.insert(session, object);
    return object.id;
  }

  Future<ObjectWithObject?> getObjectWithObject(Session session, int id) async {
    return await ObjectWithObject.findById(session, id);
  }

  Future<bool> testByteDataStore(
    Session session,
  ) async {
    // Clear database.
    await ObjectWithByteData.delete(
      session,
      where: (t) => Constant(true),
    );

    // Create byte data.
    var byteData = ByteData(256);
    for (var i = 0; i < 256; i += 1) {
      byteData.setUint8(i, i);
    }

    // Insert a row.
    var row = ObjectWithByteData(byteData: byteData);
    await ObjectWithByteData.insert(session, row);

    // Fetch the row.
    row = (await ObjectWithByteData.findSingleRow(session))!;

    // Verify the data.
    for (var i = 0; i < 256; i += 1) {
      if (row.byteData.getUint8(i) != i) {
        return false;
      }
    }

    return true;
  }
}
