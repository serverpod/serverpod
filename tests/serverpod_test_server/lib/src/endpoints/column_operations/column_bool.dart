import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnBoolEndpoint extends Endpoint {
  Future<void> insert(Session session, List<Types> types) async {
    for (var type in types) {
      await Types.insert(session, type);
    }
  }

  Future<int> deleteAll(Session session) async {
    return await Types.delete(session, where: (_) => Constant(true));
  }

  Future<List<Types>> findAll(Session session) async {
    return await Types.find(
      session,
      where: (_) => Constant(true),
    );
  }

  Future<List<Types>> equals(Session session, bool? value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, bool? value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<bool> value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<bool> value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, bool value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, bool value) async {
    return await Types.find(
      session,
      where: (t) => t.aBool.isNotDistinctFrom(value),
    );
  }
}
