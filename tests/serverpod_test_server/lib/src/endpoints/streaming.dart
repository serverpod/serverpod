import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  @override
  Future<void> streamOpened(Session session) async {}

  @override
  Future<void> handleStreamMessage(
      StreamingSession session, SerializableModel message) async {
    if (message is SimpleData) {
      unawaited(Future.delayed(const Duration(seconds: 1)).then((value) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}
