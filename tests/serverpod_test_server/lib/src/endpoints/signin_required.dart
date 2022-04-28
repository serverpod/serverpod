import 'dart:async';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SignInRequiredEndpoint extends Endpoint {
  Future<bool> testMethod(Session session) async {
    return true;
  }

  @override
  bool get requireLogin => true;

  @override
  Future<void> handleStreamMessage(
      StreamingSession session, SerializableEntity message) async {
    if (message is SimpleData) {
      unawaited(
          Future<void>.delayed(const Duration(seconds: 1)).then((_) async {
        await sendStreamMessage(session, message);
      }));
    }
  }
}
