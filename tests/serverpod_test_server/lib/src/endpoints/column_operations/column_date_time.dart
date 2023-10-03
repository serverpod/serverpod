import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ColumnDateTimeEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, DateTime? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, DateTime? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<DateTime> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<DateTime> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime.isNotDistinctFrom(value),
    );
  }

  Future<List<Types>> greaterThan(Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime > value,
    );
  }

  Future<List<Types>> greaterOrEqualThan(
      Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime >= value,
    );
  }

  Future<List<Types>> lessThan(Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime < value,
    );
  }

  Future<List<Types>> lessOrEqualThan(Session session, DateTime value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aDateTime <= value,
    );
  }

  Future<List<Types>> between(
      Session session, DateTime min, DateTime max) async {
    return await Types.db
        .find(session, where: (t) => t.aDateTime.between(min, max));
  }

  Future<List<Types>> notBetween(
      Session session, DateTime min, DateTime max) async {
    return await Types.db
        .find(session, where: (t) => t.aDateTime.notBetween(min, max));
  }
}
