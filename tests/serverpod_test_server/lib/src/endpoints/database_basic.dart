import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class BasicDatabase extends Endpoint {
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
    return session.dbNext.insertRow<Types>(value);
  }

  Future<Types> updateTypes(
    Session session,
    Types value,
  ) async {
    return session.dbNext.updateRow<Types>(value);
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

    return simpleDataIds.length + typesIds.length;
  }
}
