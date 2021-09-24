import 'dart:async';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  @override
  Future<void> setupStream(Session session) async {
    print('Setup stream');
  }

  @override
  Future<void> handleStreamMessage(StreamingSession session, SerializableEntity message) async {
    if (message is ModuleClass) {
      unawaited(Future.delayed(Duration(seconds: 1)).then((value) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}