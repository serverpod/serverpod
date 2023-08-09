import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TownEndpoint extends Endpoint {
  Future<int> insert(Session session, Town town) async {
    await Town.insert(session, town);
    return town.id!;
  }

  Future<int> deleteAll(Session session) async {
    return await Town.delete(session, where: (_) => Constant(true));
  }
}
