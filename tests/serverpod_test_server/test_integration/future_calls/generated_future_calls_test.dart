import 'package:clock/clock.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/date_time_matcher.dart';
import '../utils/future_call_manager_builder.dart';

void main() {
  withServerpod(
    'Given the generated futureCalls is initialized',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late Serverpod pod;
      // generated name for the future call
      final testCallName = 'TestGeneratedCallHelloFutureCall';
      final doTaskFutureCallName = 'TestGeneratedCallDoTaskFutureCall';

      setUp(() async {
        session = sessionBuilder.build();
        pod = session.serverpod;

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        pod.futureCalls.initialize(futureCallManager, 'default');
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) =>
              entry.name.equals(testCallName) |
              entry.name.equals(doTaskFutureCallName),
        );
        await session.close();
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
          final delay = Duration(milliseconds: 100);
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
          expect(futureCallEntries.first.time.isAfter(expectedTime), isTrue);
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

      test(
        'when a scheduled future call with an identifier is cancelled'
        'then the FutureCallEntry for that identifier is removed from the database',
        () async {
          final identifier = 'lucky-id';

          await pod.futureCalls
              .callWithDelay(Duration(milliseconds: 10), identifier: identifier)
              .testGeneratedCall
              .hello('Lucky');

          var futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, hasLength(1));

          await pod.futureCalls.cancel(identifier);

          futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, isEmpty);
        },
      );

      test(
        'when scheduling a future call that does not require any parameter'
        'then a FutureCallEntry is added to the database',
        () async {
          final time = DateTime.now().toUtc();
          await pod.futureCalls.callAtTime(time).testGeneratedCall.doTask();

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(doTaskFutureCallName),
          );

          expect(futureCallEntries, hasLength(1));
          expect(futureCallEntries.firstOrNull?.time, time);
        },
      );

      group(
        'when scheduling a recurring future call with a valid cron expression',
        () {
          final cronExpression = '0 0 1 1 *';

          setUp(() async {
            await pod.futureCalls
                .callRecurring()
                .cron(cronExpression)
                .testGeneratedCall
                .hello('Lucky');
          });

          test(
            'then a FutureCallEntry is added to the database with CronFutureCallScheduling',
            () async {
              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(futureCallEntries, hasLength(1));
              expect(
                futureCallEntries.first.scheduling,
                isA<CronFutureCallScheduling>().having(
                  (s) => s.cron,
                  'cron',
                  cronExpression,
                ),
              );
            },
          );

          test(
            'then FutureCallEntry in the database has the correct time',
            () async {
              final now = DateTime.now().toUtc();
              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(
                futureCallEntries.first.time,
                matchesDate(now.year + 1, 1, 1, 0, 0),
              );
            },
          );
        },
      );

      test(
        'when scheduling a recurring future call with an invalid cron expression, '
        'then an exception is thrown and no FutureCallEntry is added to the database',
        () async {
          final invalidCronExpression = '* * * *';

          expect(
            () async {
              await pod.futureCalls
                  .callRecurring()
                  .cron(invalidCronExpression)
                  .testGeneratedCall
                  .hello('Lucky');
            },
            throwsA(
              isA<CronFormatException>().having(
                (e) => e.message,
                'message',
                contains('Invalid cron expression: $invalidCronExpression'),
              ),
            ),
          );

          final futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          expect(futureCallEntries, isEmpty);
        },
      );

      group(
        'when scheduling a recurring future call with interval',
        () {
          final now = DateTime.now().toUtc();
          final interval = Duration(minutes: 5);
          late List<FutureCallEntry> futureCallEntries;

          setUp(() async {
            await withClock(Clock.fixed(now), () async {
              await pod.futureCalls
                  .callRecurring()
                  .every(interval)
                  .testGeneratedCall
                  .hello('Lucky');

              futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );
            });
          });

          test(
            'then a FutureCallEntry is added to the database with IntervalFutureCallScheduling',
            () async {
              expect(futureCallEntries, hasLength(1));
              expect(
                futureCallEntries.first.scheduling,
                isA<IntervalFutureCallScheduling>().having(
                  (s) => (s.interval, s.start),
                  'interval',
                  (interval, null),
                ),
              );
            },
          );

          test(
            'then the FutureCallEntry time is set to current time plus the interval',
            () async {
              expect(
                futureCallEntries.first.time,
                now.add(interval),
              );
            },
          );
        },
      );

      test(
        'when scheduling a recurring future call with interval and start DateTime, '
        'then a FutureCallEntry is added to the database with the time set to the start time',
        () async {
          final now = DateTime.now().toUtc();
          await withClock(Clock.fixed(now), () async {
            final interval = Duration(minutes: 5);
            final start = now.add(Duration(hours: 1));

            await pod.futureCalls
                .callRecurring()
                .every(interval, start: start)
                .testGeneratedCall
                .hello('Lucky');

            final futureCallEntries = await FutureCallEntry.db.find(
              session,
              where: (entry) => entry.name.equals(testCallName),
            );

            expect(futureCallEntries, hasLength(1));
            expect(futureCallEntries.first.time, start);
          });
        },
      );
    },
  );
}
