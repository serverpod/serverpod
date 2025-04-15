import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/futureCalls/test_call.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  late Serverpod server;
  late Session session;

  late TestCall testCall;

  group('FutureCallManager -', () {
    setUp(() async {
      server = IntegrationTestServer.create();

      testCall = TestCall();
      server.registerFutureCall(testCall, 'testCall');

      await server.start();

      session = await server.createSession(enableLogging: false);
      await LoggingUtil.clearAllLogs(session);
    });

    tearDown(() async {
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when scheduling a future call in the past and starting the manager, then the call is executed and removed from database',
        () async {
      await server.futureCallAtTime(
        'testCall',
        SimpleData(num: 42),
        DateTime.now().subtract(const Duration(seconds: 1)),
      );

      await testCall.completer.future;

      final futureCallEntries = await FutureCallEntry.db.find(session);

      expect(futureCallEntries, hasLength(0));
    });
  });
}
