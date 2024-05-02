import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class JsonProtocolEndpoint extends Endpoint {
  Future<ScopeServerOnlyField> getJsonForProtocol(
    Session session,
  ) async {
    return ScopeServerOnlyField(
      nested: ScopeServerOnlyField(
        allScope: Types(anInt: 1),
        serverOnlyScope: Types(anInt: 2),
      ),
    );
  }
}
