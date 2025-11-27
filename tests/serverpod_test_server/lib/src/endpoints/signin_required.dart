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
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    if (message is SimpleData) {
      unawaited(
        Future.delayed(const Duration(seconds: 1)).then((value) async {
          // ignore: deprecated_member_use
          await sendStreamMessage(session, message);
        }),
      );
    }
  }
}

class AdminScopeRequiredEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  Future<bool> testMethod(Session session) async {
    return true;
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    if (message is SimpleData) {
      unawaited(
        Future.delayed(const Duration(seconds: 1)).then((value) async {
          // ignore: deprecated_member_use
          await sendStreamMessage(session, message);
        }),
      );
    }
  }
}
