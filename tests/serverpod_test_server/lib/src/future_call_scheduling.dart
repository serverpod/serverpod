import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

// This helper lives outside the endpoint file because endpoints cannot import
// the generated future_calls.dart: it is generated after endpoint analysis,
// so the import would fail when generating from scratch.

Future<void> scheduleTestCall(Session session, SimpleData data) async {
  await session.serverpod.futureCalls
      .callWithDelay(const Duration(seconds: 1))
      .testCall
      .run(data);
}
