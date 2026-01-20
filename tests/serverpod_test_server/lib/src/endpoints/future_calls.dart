import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestFutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData? data) async {
    // ignore: deprecated_member_use
    await session.serverpod.futureCallWithDelay(
      'testCall',
      data,
      const Duration(seconds: 1),
    );
  }

  Future<void> makeFutureCallThatThrows(
    Session session,
    SimpleData? data,
  ) async {
    // ignore: deprecated_member_use
    await session.serverpod.futureCallWithDelay(
      'testExceptionCall',
      data,
      const Duration(seconds: 1),
    );
  }
}
