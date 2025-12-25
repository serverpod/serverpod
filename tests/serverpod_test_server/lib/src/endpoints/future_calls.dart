import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestFutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData? data) async {
    await futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .testCall
        .invoke(data);
  }

  Future<void> makeFutureCallThatThrows(
    Session session,
    SimpleData? data,
  ) async {
    await futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .testExceptionCall
        .invoke(data);
  }
}
