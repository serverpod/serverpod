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
      orderBy: SimpleData.t.id,
      limit: limit,
      offset: offset,
    );
  }

  Future<SimpleData?> findRowSimpleData(Session session, int num) async {
    return SimpleData.db.findRow(
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

  Future<List<int>> deleteAll(Session session) async {
    return SimpleData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  }

  Future<int> countSimpleData(
    Session session, {
    Expression? where,
    Transaction? transaction,
  }) async {
    return SimpleData.db.count(
      session,
      where: (t) => Constant.bool(true),
      transaction: transaction,
    );
  }
}
