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
      late Serverpod pod;
      // generated name for the future call
      var testCallName = 'TestGeneratedCallHelloFutureCall';

      setUp(() async {
        session = sessionBuilder.build();
        pod = session.serverpod;

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        pod.futureCalls.initialize(futureCallManager, 'default');
      });

      test(
        'when scheduling a future call at specified time'
        'then a FutureCallEntry is added to the database with expected time',
        () async {
          final time = DateTime.now().toUtc();
          await pod.futureCalls
              .callAtTime(time)
              .testGeneratedCall
              .hello('Lucky');

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));
          expect(futureCallEntries.firstOrNull?.time, time);
        },
      );

      test(
        'when scheduling a future call with a delay'
        'then a FutureCallEntry is added to the database with expected time',
        () async {
          final delay = Duration(milliseconds: 10);
          final expectedTime = DateTime.now().add(delay).toUtc();

          await pod.futureCalls
              .callWithDelay(delay)
              .testGeneratedCall
              .hello('Lucky');

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));

          // the difference between the entry time and expected time should be a few milliseconds
          expect(
            futureCallEntries.first.time.difference(expectedTime),
            lessThan(Duration(milliseconds: 200)),
          );
        },
      );

      test(
        'when scheduling a future call with an identifier at speficied time'
        'then a FutureCallEntry with same identifier is added to the database',
        () async {
          final identifier = 'lucky-id';

          await pod.futureCalls
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

      test(
        'when scheduling a future call with an identifier after a delay'
        'then a FutureCallEntry with same identifier is added to the database',
        () async {
          final identifier = 'lucky-id';

          await pod.futureCalls
              .callWithDelay(Duration(milliseconds: 10), identifier: identifier)
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
      late Serverpod pod;

      setUp(() async {
        session = sessionBuilder.build();
        pod = session.serverpod;

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        pod.futureCalls.initialize(futureCallManager, 'default');

        await pod.futureCalls
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
