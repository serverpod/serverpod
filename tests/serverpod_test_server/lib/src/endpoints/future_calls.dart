import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/future_call_scheduling.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestFutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData data) async {
    await scheduleTestCall(session, data);
  }
}
