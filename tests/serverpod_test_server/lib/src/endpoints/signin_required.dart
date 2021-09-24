import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class SignInRequiredEndpoint extends Endpoint {
  Future<bool> testMethod(Session session) async {
    return true;
  }

  @override
  bool get requireLogin => true;

  @override
  Future<void> handleStreamMessage(StreamingSession session, SerializableEntity message) async {
    if (message is SimpleData) {
      unawaited(Future.delayed(Duration(seconds: 1)).then((value) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}