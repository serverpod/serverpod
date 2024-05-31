import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ServerOnlyScopedFieldModelEndpoint extends Endpoint {
  Future<ScopeServerOnlyField> getScopeServerOnlyField(
    Session session,
  ) async {
    return ScopeServerOnlyField(
      serverOnlyScope: Types(anInt: 2),
      nested: ScopeServerOnlyField(
        allScope: Types(anInt: 1),
        serverOnlyScope: Types(anInt: 2),
      ),
    );
  }

  @override
  Future<void> streamOpened(StreamingSession session) async {
    unawaited(
      Future.delayed(const Duration(seconds: 1)).then(
        (value) async {
          await sendStreamMessage(
            session,
            ScopeServerOnlyField(
              serverOnlyScope: Types(anInt: 2),
              nested: ScopeServerOnlyField(
                allScope: Types(anInt: 1),
                serverOnlyScope: Types(anInt: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
