import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class DatabaseBatchGenerated extends Endpoint {
  Future<List<UniqueData>> batchInsert(
    Session session,
    List<UniqueData> value,
  ) async {
    return UniqueData.db.insert(session, value);
  }

  Future<List<Types>> batchInsertTypes(
    Session session,
    List<Types> value,
  ) async {
    return Types.db.insert(session, value);
  }

  Future<List<UniqueData>> batchUpdate(
    Session session,
    List<UniqueData> value,
  ) async {
    return UniqueData.db.update(session, value);
  }

  Future<List<Types>> batchUpdateTypes(
    Session session,
    List<Types> value,
  ) async {
    return Types.db.update(session, value);
  }

  Future<List<int>> batchDelete(
    Session session,
    List<UniqueData> value,
  ) async {
    return UniqueData.db.delete(session, value);
  }

  Future<RelatedUniqueData> insertRelatedUniqueData(
    Session session,
    RelatedUniqueData value,
  ) async {
    return RelatedUniqueData.db.insertRow(session, value);
  }

  Future<UniqueData?> findByEmail(Session session, String email) async {
    return UniqueData.db.findFirstRow(session, where: (t) => t.email.equals(email));
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
