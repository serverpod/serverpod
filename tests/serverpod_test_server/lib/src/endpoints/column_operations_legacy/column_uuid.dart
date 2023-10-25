// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnUuidLegacyEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, UuidValue? value) async {
    return await Types.find(
      session,
      where: (t) => t.aUuid.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, UuidValue? value) async {
    return await Types.find(
      session,
      where: (t) => t.aUuid.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<UuidValue> value) async {
    return await Types.find(
      session,
      where: (t) => t.aUuid.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<UuidValue> value) async {
    return await Types.find(
      session,
      where: (t) => t.aUuid.notInSet(value.toSet()),
    );
  }
}
