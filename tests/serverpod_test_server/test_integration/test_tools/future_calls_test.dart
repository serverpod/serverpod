import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint with generated futureCalls',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      test('when a future call is invoked then it is executed', () async {
        await endpoints.futureCalls.testCall.invoke(sessionBuilder, null);

        final logEntries = await LogEntry.db.find(
          session,
        );

        expect(logEntries, hasLength(1));
        expect(logEntries.first.message, 'null');
      });
    },
    enableSessionLogging: true,
  );
}
