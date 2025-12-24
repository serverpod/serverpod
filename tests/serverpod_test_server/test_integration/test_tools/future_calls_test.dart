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
        await endpoints.futureCalls.testGeneratedCall.hello(
          sessionBuilder,
          'Lucky',
        );

        final logEntries = await LogEntry.db.find(
          session,
        );

        expect(logEntries, isNotEmpty);
        expect(logEntries.last.message, 'Hello Lucky');
      });
    },
    enableSessionLogging: true,
  );
}
