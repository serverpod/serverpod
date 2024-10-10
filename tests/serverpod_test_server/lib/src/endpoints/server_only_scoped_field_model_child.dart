import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ServerOnlyScopedFieldChildModelEndpoint extends Endpoint {
  Future<ScopeServerOnlyFieldChild> getProtocolField(
    Session session,
  ) async {
    return ScopeServerOnlyFieldChild(
      serverOnlyScope: Types(anInt: 2),
      nested: ScopeServerOnlyField(
        allScope: Types(anInt: 1),
        serverOnlyScope: Types(anInt: 2),
      ),
      childFoo: 'childFoo',
    );
  }
}
