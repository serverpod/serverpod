import 'dart:typed_data';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BasicDatabase extends Endpoint {
  Future<void> deleteAllSimpleTestData(Session session) async {
    await SimpleData.db.deleteWhere(session, where: (t) => Constant.bool(true));
  }

  Future<void> deleteSimpleTestDataLessThan(Session session, int num) async {
    await SimpleData.db.deleteWhere(session, where: (t) => t.num < num);
  }

  Future<void> findAndDeleteSimpleTestData(Session session, int num) async {
    var data = await SimpleData.db.findFirstRow(
      session,
      where: (t) => t.num.equals(num),
    );

    await SimpleData.db.deleteRow(session, data!);
  }

  Future<void> createSimpleTestData(Session session, int numRows) async {
    List<SimpleData> data = [];
    for (var i = 0; i < numRows; i++) {
      data.add(SimpleData(num: i));
    }

    await SimpleData.db.insert(session, data);
  }

  Future<List<SimpleData>> findSimpleData(
    Session session, {
    required int limit,
    required int offset,
  }) async {
    return SimpleData.db.find(
      session,
      orderBy: (t) => t.id,
      limit: limit,
      offset: offset,
    );
  }

  Future<SimpleData?> findFirstRowSimpleData(Session session, int num) async {
    return SimpleData.db.findFirstRow(
      session,
      where: (t) => t.num.equals(num),
    );
  }

  Future<SimpleData?> findByIdSimpleData(
    Session session,
    int id,
  ) async {
    return SimpleData.db.findById(
      session,
      id,
    );
  }

  Future<SimpleDataList?> findSimpleDataRowsLessThan(
    Session session,
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    var rows = await SimpleData.db.find(
      session,
      where: (t) => t.num < num,
      offset: offset,
      limit: limit,
      orderBy: (t) => t.num,
      orderDescending: descending,
    );

    return SimpleDataList(
      rows: rows,
    );
  }

  Future<SimpleData> insertRowSimpleData(
      Session session, SimpleData simpleData) {
    return SimpleData.db.insertRow(
      session,
      simpleData,
    );
  }

  Future<SimpleData> updateRowSimpleData(
      Session session, SimpleData simpleData) {
    return SimpleData.db.updateRow(
      session,
      simpleData,
    );
  }

  Future<int> deleteRowSimpleData(
    Session session,
    SimpleData simpleData,
  ) async {
    return SimpleData.db.deleteRow(
      session,
      simpleData,
    );
  }

  Future<List<int>> deleteWhereSimpleData(
    Session session,
  ) async {
    return SimpleData.db.deleteWhere(
      where: (t) => Constant.bool(true),
      session,
    );
  }

  Future<int> countSimpleData(Session session) async {
    return SimpleData.db.count(
      session,
      where: (t) => Constant.bool(true),
    );
  }

  Future<Types> insertTypes(
    Session session,
    Types value,
  ) async {
    return Types.db.insertRow(session, value);
  }

  Future<Types> updateTypes(
    Session session,
    Types value,
  ) async {
    return Types.db.updateRow(session, value);
  }

  Future<int?> countTypesRows(Session session) async {
    return await Types.db.count(session);
  }

  Future<List<int>> deleteAllInTypes(Session session) async {
    return await Types.db
        .deleteWhere(session, where: (t) => Constant.bool(true));
  }

  Future<Types?> getTypes(Session session, int id) async {
    return await Types.db.findById(session, id);
  }

  Future<int?> getTypesRawQuery(Session session, int id) async {
    var query = 'SELECT * FROM types WHERE id = $id';
    var result = await session.db.unsafeQuery(query);
    if (result.length != 1) {
      return null;
    }
    var row = result[0];
    if (row.length != Types.t.columns.length) {
      return null;
    }
    return row[0] as int;
  }

  Future<ObjectWithEnum> storeObjectWithEnum(
    Session session,
    ObjectWithEnum object,
  ) async {
    return await ObjectWithEnum.db.insertRow(session, object);
  }

  Future<ObjectWithEnum?> getObjectWithEnum(Session session, int id) async {
    return await ObjectWithEnum.db.findById(session, id);
  }

  Future<ObjectWithObject> storeObjectWithObject(
      Session session, ObjectWithObject object) async {
    return await ObjectWithObject.db.insertRow(session, object);
  }

  Future<ObjectWithObject?> getObjectWithObject(Session session, int id) async {
    return await ObjectWithObject.db.findById(session, id);
  }

  Future<int> deleteAll(Session session) async {
    var simpleDataIds = await SimpleData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    var typesIds = await Types.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    var objectsWithEnumIds = await ObjectWithEnum.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    var objectsWithObjectIds = await ObjectWithObject.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    return simpleDataIds.length +
        typesIds.length +
        objectsWithEnumIds.length +
        objectsWithObjectIds.length;
  }

  Future<bool> testByteDataStore(
    Session session,
  ) async {
    // Clear database.
    await ObjectWithByteData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    // Create byte data.
    var byteData = ByteData(256);
    for (var i = 0; i < 256; i += 1) {
      byteData.setUint8(i, i);
    }

    // Insert a row.
    var row = ObjectWithByteData(byteData: byteData);
    await ObjectWithByteData.db.insertRow(session, row);

    // Fetch the row.
    row = (await ObjectWithByteData.db.findFirstRow(session))!;

    // Verify the data.
    for (var i = 0; i < 256; i += 1) {
      if (row.byteData.getUint8(i) != i) {
        return false;
      }
    }

    return true;
  }
}
