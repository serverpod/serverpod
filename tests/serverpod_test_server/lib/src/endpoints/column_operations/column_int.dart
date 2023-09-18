import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnIntEndpoint extends Endpoint {
  Future<void> insert(Session session, List<Types> types) async {
    for (var type in types) {
      await Types.insert(session, type);
    }
  }

  Future<int> deleteAll(Session session) async {
    return await Types.delete(session, where: (_) => Constant.bool(true));
  }

  Future<List<Types>> findAll(Session session) async {
    return await Types.find(
      session,
      where: (_) => Constant.bool(true),
    );
  }

  Future<List<Types>> equals(Session session, int? value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, int? value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<int> value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<int> value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt.isNotDistinctFrom(value),
    );
  }

  Future<List<Types>> greaterThan(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt > value,
    );
  }

  Future<List<Types>> greaterOrEqualThan(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt >= value,
    );
  }

  Future<List<Types>> lessThan(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt < value,
    );
  }

  Future<List<Types>> lessOrEqualThan(Session session, int value) async {
    return await Types.find(
      session,
      where: (t) => t.anInt <= value,
    );
  }

  Future<List<Types>> between(Session session, int min, int max) async {
    return await Types.find(session, where: (t) => t.anInt.between(min, max));
  }

  Future<List<Types>> notBetween(Session session, int min, int max) async {
    return await Types.find(session,
        where: (t) => t.anInt.notBetween(min, max));
  }
}
