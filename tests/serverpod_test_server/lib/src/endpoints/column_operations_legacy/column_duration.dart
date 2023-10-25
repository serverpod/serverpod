// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnDurationLegacyEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, Duration? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, Duration? value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<Duration> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<Duration> value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> greaterThan(Session session, Duration value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration > value,
    );
  }

  Future<List<Types>> greaterOrEqualThan(
      Session session, Duration value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration >= value,
    );
  }

  Future<List<Types>> lessThan(Session session, Duration value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration < value,
    );
  }

  Future<List<Types>> lessOrEqualThan(Session session, Duration value) async {
    return await Types.find(
      session,
      where: (t) => t.aDuration <= value,
    );
  }

  Future<List<Types>> between(
      Session session, Duration min, Duration max) async {
    return await Types.find(session,
        where: (t) => t.aDuration.between(min, max));
  }

  Future<List<Types>> notBetween(
      Session session, Duration min, Duration max) async {
    return await Types.find(session,
        where: (t) => t.aDuration.notBetween(min, max));
  }
}
