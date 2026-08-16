import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
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

      test(
        'when invoking a future call then it is executed immediately',
        () async {
          await endpoints.futureCalls.testGeneratedCall.logData(
            sessionBuilder,
            SimpleData(num: 90),
          );

          final logEntries = await LogEntry.db.find(
            session,
          );

          expect(logEntries, isNotEmpty);
          expect(logEntries.last.message, 'Data: 90');
        },
      );
    },
    enableSessionLogging: true,
  );
}
