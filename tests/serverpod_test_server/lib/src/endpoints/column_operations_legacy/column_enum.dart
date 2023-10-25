// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnEnumLegacyEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, TestEnum? value) async {
    return await Types.find(
      session,
      where: (t) => t.anEnum.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, TestEnum? value) async {
    return await Types.find(
      session,
      where: (t) => t.anEnum.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<TestEnum> value) async {
    return await Types.find(
      session,
      where: (t) => t.anEnum.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<TestEnum> value) async {
    return await Types.find(
      session,
      where: (t) => t.anEnum.notInSet(value.toSet()),
    );
  }
}
