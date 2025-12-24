import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

void main() {
  withServerpod(
    'Given the generated futureCalls is initialized',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      // generated name for the future call
      var testCallName = 'TestGeneratedCallHelloFutureCall';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        futureCalls.initialize(futureCallManager, 'default');
      });

      test(
        'when scheduling a future call at specified time'
        'then a FutureCallEntry is added to the database',
        () async {
          await futureCalls
              .callAtTime(DateTime.now())
              .testGeneratedCall
              .hello('Lucky');

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));
        },
      );

      test(
        'when scheduling a future call with a delay'
        'then a FutureCallEntry is added to the database',
        () async {
          await futureCalls
              .callWithDelay(Duration(milliseconds: 10))
              .testGeneratedCall
              .hello('Lucky');

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));
        },
      );

      test(
        'when scheduling a future call with an identifier'
        'then a FutureCallEntry with same identifier is added to the database',
        () async {
          final identifier = 'lucky-id';

          await futureCalls
              .callAtTime(DateTime.now(), identifier: identifier)
              .testGeneratedCall
              .hello('Lucky');

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));
          expect(futureCallEntries.first.identifier, identifier);
        },
      );
    },
  );

  withServerpod(
    'Given generated futureCalls is initialized and has scheduled FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        futureCalls.initialize(futureCallManager, 'default');

        await futureCalls
            .callAtTime(DateTime.now().subtract(const Duration(seconds: 1)))
            .testGeneratedCall
            .bye('Lucky', code: 20);
      });

      group('when running scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is executed', () async {
          final logEntries = await LogEntry.db.find(
            session,
          );

          expect(logEntries, hasLength(1));
          expect(logEntries.first.message, 'Bye Lucky. Code: 20');
        });

        test('then the FutureCallEntry gets deleted from database', () async {
          final futureCallEntries = await FutureCallEntry.db.find(
            session,
          );

          expect(futureCallEntries, isEmpty);
        });
      });
    },
    enableSessionLogging: true,
  );
}
