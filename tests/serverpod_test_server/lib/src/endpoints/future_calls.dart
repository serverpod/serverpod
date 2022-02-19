import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class FutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData? data) async {
    await session.serverpod.futureCallWithDelay(
      'testCall',
      data,
      const Duration(seconds: 1),
    );
  }
}
