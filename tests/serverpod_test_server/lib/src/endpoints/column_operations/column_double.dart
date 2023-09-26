// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnDoubleEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, double? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, double? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<double> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<double> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble.isNotDistinctFrom(value),
    );
  }

  Future<List<Types>> greaterThan(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble > value,
    );
  }

  Future<List<Types>> greaterOrEqualThan(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble >= value,
    );
  }

  Future<List<Types>> lessThan(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble < value,
    );
  }

  Future<List<Types>> lessOrEqualThan(Session session, double value) async {
    return await Types.find(
      session,
      where: (t) => t.aDouble <= value,
    );
  }

  Future<List<Types>> between(Session session, double min, double max) async {
    return await Types.find(session, where: (t) => t.aDouble.between(min, max));
  }

  Future<List<Types>> notBetween(
      Session session, double min, double max) async {
    return await Types.find(session,
        where: (t) => t.aDouble.notBetween(min, max));
  }
}
