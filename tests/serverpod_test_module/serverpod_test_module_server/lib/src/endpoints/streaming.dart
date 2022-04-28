import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  @override
  Future<void> streamOpened(StreamingSession session) async {}

  @override
  Future<void> handleStreamMessage(
      StreamingSession session, SerializableEntity message) async {
    if (message is ModuleClass) {
      unawaited(
          Future<void>.delayed(const Duration(seconds: 1)).then((_) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}
