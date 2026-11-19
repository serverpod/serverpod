import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

/// Runs a query that the database rejects. A named function, so the test can
/// look for it in the stack trace of the error.
Future<void> runFailingQueryForStackTraceTest(Session session) async {
  await session.db.unsafeQuery('SELECT * FROM t_does_not_exist_for_trace');
}

void main() async {
  var session = await IntegrationTestServer().session();

  test(
    'Given a query that fails in the database when awaiting it then the stack trace of the error includes the code that ran the query',
    () async {
      StackTrace? trace;
      try {
        await runFailingQueryForStackTraceTest(session);
      } on DatabaseQueryException catch (_, stackTrace) {
        trace = stackTrace;
      }

      expect(trace, isNotNull);
      expect(
        trace.toString(),
        contains('runFailingQueryForStackTraceTest'),
      );
    },
  );
}
