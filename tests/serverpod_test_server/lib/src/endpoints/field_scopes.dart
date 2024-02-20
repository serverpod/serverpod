import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class FieldScopesEndpoint extends Endpoint {
  Future<void> storeObject(Session session, ObjectFieldScopes object) async {
    // Delete all old objects
    await ObjectFieldScopes.db
        .deleteWhere(session, where: (t) => Constant.bool(true));

    // Insert object
    await ObjectFieldScopes.db.insertRow(session, object);
  }

  Future<ObjectFieldScopes?> retrieveObject(Session session) async {
    return await ObjectFieldScopes.db.findFirstRow(session);
  }
}
