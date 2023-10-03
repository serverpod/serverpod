// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ColumnDateTimeLegacyEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, DateTime? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, DateTime? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<DateTime> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<DateTime> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> isDistinctFrom(Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.isDistinctFrom(value),
    );
  }

  Future<List<Types>> isNotDistinctFrom(Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime.isNotDistinctFrom(value),
    );
  }

  Future<List<Types>> greaterThan(Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime > value,
    );
  }

  Future<List<Types>> greaterOrEqualThan(
      Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime >= value,
    );
  }

  Future<List<Types>> lessThan(Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime < value,
    );
  }

  Future<List<Types>> lessOrEqualThan(Session session, DateTime value) async {
    return await Types.find(
      session,
      where: (t) => t.aDateTime <= value,
    );
  }

  Future<List<Types>> between(
      Session session, DateTime min, DateTime max) async {
    return await Types.find(session,
        where: (t) => t.aDateTime.between(min, max));
  }

  Future<List<Types>> notBetween(
      Session session, DateTime min, DateTime max) async {
    return await Types.find(session,
        where: (t) => t.aDateTime.notBetween(min, max));
  }
}
