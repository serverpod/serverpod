import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_shared/src/protocol_custom_classes.dart';

class CustomClassProtocolEndpoint extends Endpoint {
  Future<ProtocolCustomClass> getProtocolField(
    Session session,
  ) async {
    return ProtocolCustomClass(
      value: "Value",
      serverOnlyValue: "ServerOnlyValue",
    );
  }

  @override
  Future<void> streamOpened(StreamingSession session) async {
    unawaited(
      Future.delayed(const Duration(seconds: 1)).then(
        (value) async {
          await sendStreamMessage(
            session,
            ProtocolCustomClass(
              value: "Value",
              serverOnlyValue: "ServerOnlyValue",
            ),
          );
        },
      ),
    );
  }
}
