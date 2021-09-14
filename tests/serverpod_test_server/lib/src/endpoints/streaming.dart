import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  @override
  Future<void> setupStream(Session session) async {
    print('Setup stream');
  }

  @override
  Future<void> handleStreamMessage(Session session, SerializableEntity message) async {
    if (message is SimpleData) {
      print('Got SimpleData: ${message.num}');

      unawaited(Future.delayed(Duration(seconds: 1)).then((value) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}