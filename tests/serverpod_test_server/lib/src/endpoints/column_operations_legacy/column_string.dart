// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ColumnStringLegacyEndpoint extends Endpoint {
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

  Future<List<Types>> equals(Session session, String? value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.equals(value),
    );
  }

  Future<List<Types>> notEquals(Session session, String? value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.notEquals(value),
    );
  }

  Future<List<Types>> inSet(Session session, List<String> value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.inSet(value.toSet()),
    );
  }

  Future<List<Types>> notInSet(Session session, List<String> value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.notInSet(value.toSet()),
    );
  }

  Future<List<Types>> like(Session session, String value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.like(value),
    );
  }

  Future<List<Types>> ilike(Session session, String value) async {
    return await Types.find(
      session,
      where: (t) => t.aString.ilike(value),
    );
  }
}
