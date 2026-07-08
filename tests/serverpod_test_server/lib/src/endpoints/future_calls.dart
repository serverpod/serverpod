import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestFutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData data) async {
    await session.serverpod.futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .testCall
        .run(data);
  }

  Future<void> makeFutureCallThatThrows(
    Session session,
    SimpleData data,
  ) async {
    await session.serverpod.futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .testExceptionCall
        .run(data);
  }
}
