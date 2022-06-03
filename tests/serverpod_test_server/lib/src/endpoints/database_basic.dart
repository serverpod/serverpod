import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

int globalInt = 0;

class BasicDatabase extends Endpoint {
  Future<int?> storeTypes(Session session, Types types) async {
    await Types.insert(session, types);
    return types.id;
  }

  Future<String> getDistinctTypesValue(Session session) async {
    var responce = await Types.findDistinctValue(session,
        isDistinct: true,
        returnAsList: false,
        columns: [Types.t.anInt, Types.t.aString]);
    return jsonEncode(responce);
  }

  Future<String> getDistinctTypesValueOnly(Session session) async {
    var responce = await Types.findDistinctValue(session,
        isDistinct: true,
        returnAsList: true,
        columns: [Types.t.anInt, Types.t.aString]);
    return jsonEncode(responce);
  }

  Future<Types?> optionalWhereQuery(
      Session session, int? id, String? aString) async {
    return await Types.findSingleRow(session,
        where: (t) =>
            t.id.equals(id, id != null) &
            t.aString.equals(aString, aString != null));
  }

  Future<int?> getRegExTypes(
      Session session, String regEx, bool caseSensitive, bool notMatch) async {
    var types = await Types.count(
      session,
      where: (t) => t.aString
          .regex(regEx, caseSensitive: caseSensitive, notMatch: notMatch),
    );
    return types;
  }

  Future<Types?> getTypes(Session session, int id) async {
    var types = await Types.findById(session, id);
    return types;
  }

  Future<int?> getTypesWithWhereQuery(Session session, String idQuery) async {
    var count =
        await Types.count(session, where: (t) => t.id.whereQuery(idQuery));
    return count;
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

  Future<bool> storeListOfTypes(Session session) async {
    List<Types> newTypesWithId = [
      Types(id: 1111, aString: 'Test'),
      Types(id: 2222, aString: 'Test')
    ];
    await Types.insertOrupdateBulk(session, newTypesWithId);
    List<Types> typesWithNewValue = [
      Types(aString: 'New_Test_1'),
      Types(aString: 'New_Test_2')
    ];
    await Types.insertOrupdateBulk(session, typesWithNewValue);
    List<Types> updateTypes = [
      Types(id: 1111, aString: 'Test_Update'),
      Types(id: 2222, aString: 'Test_Update')
    ];
    await Types.insertOrupdateBulk(session, updateTypes);
    return true;
  }
}
