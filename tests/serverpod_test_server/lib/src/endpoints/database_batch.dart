import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class DatabaseBatch extends Endpoint {
  Future<List<UniqueData>> batchInsert(
    Session session,
    List<UniqueData> value,
  ) async {
    return session.db.insert<UniqueData>(value);
  }

  Future<List<Types>> batchInsertTypes(
    Session session,
    List<Types> value,
  ) async {
    return session.db.insert<Types>(value);
  }

  Future<List<UniqueData>> batchUpdate(
    Session session,
    List<UniqueData> value,
  ) async {
    return session.db.update<UniqueData>(value);
  }

  Future<List<Types>> batchUpdateTypes(
    Session session,
    List<Types> value,
  ) async {
    return session.db.update<Types>(value);
  }

  Future<List<int>> batchDelete(
    Session session,
    List<UniqueData> value,
  ) async {
    return session.db.delete<UniqueData>(value);
  }

  Future<RelatedUniqueData> insertRelatedUniqueData(
    Session session,
    RelatedUniqueData value,
  ) async {
    return RelatedUniqueData.db.insertRow(session, value);
  }

  Future<UniqueData?> findByEmail(Session session, String email) async {
    return UniqueData.db
        .findFirstRow(session, where: (t) => t.email.equals(email));
  }

  Future<UniqueData?> findById(Session session, int id) async {
    return UniqueData.db.findById(session, id);
  }

  Future<List<UniqueData>> findAll(Session session) async {
    return UniqueData.db.find(session);
  }

  Future<void> deleteAll(Session session) async {
    await RelatedUniqueData.db
        .deleteWhere(session, where: (t) => Constant.bool(true));
    await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await UniqueData.db.deleteWhere(session, where: (t) => Constant.bool(true));
  }
}
