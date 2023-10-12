import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnEnumEndpoint extends Endpoint {
  Future<void> insert(Session session, List<Types> types) async {
    for (var type in types) {
      await Types.db.insertRow(session, type);
    }
  }

  Future<int> deleteAll(Session session) async {
    var result =
        await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
    return result.length;
  }

  Future<List<Types>> findAll(Session session) async {
    return await Types.db.find(
      session,
      where: (_) => Constant.bool(true),
    );
  }

  Future<List<Types>> equals(Session session, TestEnum? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, TestEnum? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<TestEnum> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<TestEnum> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, TestEnum value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, TestEnum value) async {
    return await Types.db.find(
      session,
      where: (t) => t.anEnum.isNotDistinctFrom(value),
    );
  }
}
