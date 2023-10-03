import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnStringEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, String? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, String? value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<String> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<String> value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, String value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, String value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.isNotDistinctFrom(value),
    );
  }

  Future<List<Types>> like(Session session, String value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.like(value),
    );
  }

  Future<List<Types>> ilike(Session session, String value) async {
    return await Types.db.find(
      session,
      where: (t) => t.aString.ilike(value),
    );
  }
}
