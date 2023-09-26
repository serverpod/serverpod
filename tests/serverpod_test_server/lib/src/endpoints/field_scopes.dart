// ignore_for_file: deprecated_member_use_from_same_package

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class FieldScopesEndpoint extends Endpoint {
  Future<void> storeObject(Session session, ObjectFieldScopes object) async {
    // Delete all old objects
    await ObjectFieldScopes.delete(session, where: (t) => Constant.bool(true));

    // Insert object
    await ObjectFieldScopes.insert(session, object);
  }

  Future<ObjectFieldScopes?> retrieveObject(Session session) async {
    return await ObjectFieldScopes.findSingleRow(session);
  }
}
