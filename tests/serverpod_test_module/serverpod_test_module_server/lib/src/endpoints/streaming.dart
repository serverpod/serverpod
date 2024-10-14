import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  bool streamOpenedWasCalled = false;
  bool streamClosedWasCalled = false;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    streamClosedWasCalled = false;
    streamOpenedWasCalled = true;
  }

  Future<bool> wasStreamOpenCalled(Session session) async {
    return streamOpenedWasCalled;
  }

  @override
  Future<void> streamClosed(StreamingSession session) async {
    streamOpenedWasCalled = false;
    streamClosedWasCalled = true;
  }

  Future<bool> wasStreamClosedCalled(Session session) async {
    return streamClosedWasCalled;
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    if (message is! ModuleClass) {
      return;
    }

    unawaited(Future.delayed(const Duration(seconds: 1)).then((value) async {
      await sendStreamMessage(session, message);
    }));
  }
}
