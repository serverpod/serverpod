import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class CompleterTestCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    completer.complete(object);
  }
}

class CountingTestCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  int invocations = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    invocations++;
  }
}

class GatedTestCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  final Completer<void> release = Completer<void>();
  final Completer<void> started = Completer<void>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    started.complete();
    await release.future;
  }
}

void main() async {
  withServerpod(
    'Given FutureCallManager with registered recurring cron FutureCall that is due',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      late Session session;
      final testCallName = 'test-recurring-cron-execution-call';
      final identifier = 'recurring-cron-execution-id';
      final cronExpression = '*/5 * * * *';
      final data = SimpleData(num: 4);

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                )
                .build();

        testCall = CompleterTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          data,
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
          scheduling: CronFutureCallScheduling(cron: cronExpression),
        );
      });

      tearDown(() async {
        if (!testCall.completer.isCompleted) {
          testCall.completer.complete();
        }
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
      });

      group(
        'when the same recurring cron call is scheduled again with the same identifier',
        () {
          setUp(() async {
            await futureCallManager.scheduleFutureCall(
              testCallName,
              data,
              DateTime.now().subtract(const Duration(seconds: 1)),
              '1',
              identifier,
              scheduling: CronFutureCallScheduling(cron: cronExpression),
            );
          });

          test(
            'then the pending chain is replaced instead of duplicated',
            () async {
              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(futureCallEntries, hasLength(1));
            },
          );
        },
      );

      group('when running scheduled FutureCalls', () {
        late List<FutureCallEntry> oldFutureCallEntries;
        late List<FutureCallEntry> futureCallEntries;

        setUp(() async {
          oldFutureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          await futureCallManager.runScheduledFutureCalls();

          futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
        });

        test('then the FutureCall is executed', () async {
          await expectLater(testCall.completer.future, completes);
        });

        test('then a new FutureCallEntry is scheduled for next run', () {
          expect(futureCallEntries, hasLength(1));
        });

        test('then the new entry has a different id', () {
          expect(
            futureCallEntries.first.id,
            isNot(oldFutureCallEntries.first.id),
          );
        });

        test('then the new entry has the same name', () {
          expect(futureCallEntries.first.name, equals(testCallName));
        });

        test('then the new entry has the same serializedObject', () {
          expect(
            futureCallEntries.first.serializedObject,
            equals(data.toString()),
          );
        });

        test('then the new entry has the same serverId', () {
          expect(futureCallEntries.first.serverId, equals('1'));
        });

        test('then the new entry has the same identifier', () {
          expect(futureCallEntries.first.identifier, equals(identifier));
        });

        test('then the new entry has the same cron scheduling', () {
          final scheduling =
              futureCallEntries.first.scheduling as CronFutureCallScheduling;
          expect(scheduling.cron, equals(cronExpression));
        });

        test('then the new entry has time in the future', () {
          expect(
            futureCallEntries.first.time.isAfter(DateTime.now()),
            isTrue,
          );
        });
      });

      group(
        'when start is called',
        () {
          setUp(() async {
            await futureCallManager.start();
          });

          tearDown(() async {
            await futureCallManager.stop();
          });

          test('then the FutureCall is executed', () async {
            await expectLater(testCall.completer.future, completes);
          });

          test(
            'then a new FutureCallEntry is scheduled for next run',
            () async {
              // Wait for future call execution to complete
              await testCall.completer.future;
              await Future.delayed(Duration(milliseconds: 100));

              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(futureCallEntries, hasLength(1));
              expect(
                (futureCallEntries.first.scheduling as CronFutureCallScheduling)
                    .cron,
                equals(cronExpression),
              );
              expect(
                futureCallEntries.first.time.isAfter(DateTime.now()),
                isTrue,
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given FutureCallManager with registered recurring interval FutureCall that is due',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      late Session session;
      final testCallName = 'test-recurring-interval-execution-call';
      final identifier = 'recurring-interval-execution-id';
      final interval = Duration(minutes: 5);
      final data = SimpleData(num: 6);

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                )
                .build();

        testCall = CompleterTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          data,
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
          scheduling: IntervalFutureCallScheduling(interval: interval),
        );
      });

      tearDown(() async {
        if (!testCall.completer.isCompleted) {
          testCall.completer.complete();
        }
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
      });

      group('when running scheduled FutureCalls', () {
        late List<FutureCallEntry> oldFutureCallEntries;
        late List<FutureCallEntry> futureCallEntries;

        setUp(() async {
          oldFutureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );

          await futureCallManager.runScheduledFutureCalls();

          futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
        });

        test('then the FutureCall is executed', () async {
          await expectLater(testCall.completer.future, completes);
        });

        test('then the new entry has a different id', () {
          expect(
            futureCallEntries.first.id,
            isNot(oldFutureCallEntries.first.id),
          );
        });

        test('then a new FutureCallEntry is scheduled for next run', () {
          expect(futureCallEntries, hasLength(1));
        });

        test('then the new entry has the same name', () {
          expect(futureCallEntries.first.name, equals(testCallName));
        });

        test('then the new entry has the same serializedObject', () {
          expect(
            futureCallEntries.first.serializedObject,
            equals(data.toString()),
          );
        });

        test('then the new entry has the same serverId', () {
          expect(futureCallEntries.first.serverId, equals('1'));
        });

        test('then the new entry has the same identifier', () {
          expect(futureCallEntries.first.identifier, equals(identifier));
        });

        test('then the new entry has the same interval scheduling', () {
          final scheduling =
              futureCallEntries.first.scheduling
                  as IntervalFutureCallScheduling;
          expect(scheduling.interval, equals(interval));
        });

        test('then the new entry has time in the future', () {
          expect(
            futureCallEntries.first.time.isAfter(DateTime.now()),
            isTrue,
          );
        });
      });

      group(
        'when start is called',
        () {
          setUp(() async {
            await futureCallManager.start();
          });

          tearDown(() async {
            await futureCallManager.stop();
          });

          test('then the FutureCall is executed', () async {
            await expectLater(testCall.completer.future, completes);
          });

          test(
            'then a new FutureCallEntry is scheduled for next run',
            () async {
              // Wait for future call execution to complete
              await testCall.completer.future;
              await Future.delayed(Duration(milliseconds: 100));

              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(futureCallEntries, hasLength(1));
              expect(
                (futureCallEntries.first.scheduling
                        as IntervalFutureCallScheduling)
                    .interval
                    .inMinutes,
                equals(5),
              );
              expect(
                futureCallEntries.first.time.isAfter(DateTime.now()),
                isTrue,
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given FutureCallManager with non-recurring FutureCall',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      late Session session;
      final testCallName = 'test-non-recurring-call';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                )
                .build();

        testCall = CompleterTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 6),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          '',
        );
      });

      tearDown(() async {
        if (!testCall.completer.isCompleted) {
          testCall.completer.complete();
        }

        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
      });

      group('when running scheduled FutureCalls', () {
        late List<FutureCallEntry> futureCallEntries;

        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();

          futureCallEntries = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
        });

        test(
          'then no new FutureCallEntry is scheduled after the FutureCall is executed',
          () async {
            await testCall.completer.future;
            expect(futureCallEntries, isEmpty);
          },
        );
      });

      group(
        'when start is called',
        () {
          setUp(() async {
            await futureCallManager.start();
          });

          tearDown(() async {
            await futureCallManager.stop();
          });

          test(
            'then no new FutureCallEntry is scheduled after the FutureCall is executed',
            () async {
              // Wait for future call execution to complete
              await testCall.completer.future;
              await Future.delayed(Duration(milliseconds: 100));

              final futureCallEntries = await FutureCallEntry.db.find(
                session,
                where: (entry) => entry.name.equals(testCallName),
              );

              expect(futureCallEntries, isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a recurring FutureCall whose entry survived a crash during a run',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CountingTestCall testCall;
      late Session session;
      final testCallName = 'test-recurring-crash-recovery-call';
      final identifier = 'recurring-crash-recovery-id';
      final interval = Duration(minutes: 5);

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                )
                .build();

        testCall = CountingTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 1),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
          scheduling: IntervalFutureCallScheduling(interval: interval),
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
      });

      test(
        'when the crashed entry is re-claimed and executed '
        'then no second parallel chain is created',
        () async {
          // First run: executes the call and schedules the next occurrence.
          await futureCallManager.runScheduledFutureCalls();
          expect(testCall.invocations, 1);

          final entriesAfterFirstRun = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
          expect(entriesAfterFirstRun, hasLength(1));

          // Simulate a crash during a run: the process died while executing an
          // occurrence, so its entry stayed behind and no successor was ever
          // inserted. Remove the successor and insert a copy of the consumed
          // entry that is due now.
          await FutureCallEntry.db.deleteRow(
            session,
            entriesAfterFirstRun.first,
          );
          final crashedEntry = entriesAfterFirstRun.first.copyWith(
            id: null,
            time: DateTime.now().subtract(const Duration(seconds: 1)),
          );
          await FutureCallEntry.db.insertRow(session, crashedEntry);

          // The recovered instance (a fresh manager, as after a server restart)
          // re-claims the stale entry and executes it.
          final restartedManager =
              FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                  .withConfig(
                    FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                  )
                  .build();
          restartedManager.registerFutureCall(testCall, testCallName);
          await restartedManager.runScheduledFutureCalls();
          expect(testCall.invocations, 2);

          // The chain still has exactly one pending occurrence instead of the
          // two parallel chains the old scheduling created.
          final entriesAfterRecovery = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
          expect(entriesAfterRecovery, hasLength(1));
        },
      );
    },
  );

  withServerpod(
    'Given a recurring FutureCall that is cancelled while a run is in flight',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late GatedTestCall testCall;
      late Session session;
      final testCallName = 'test-recurring-cancel-mid-run-call';
      final identifier = 'recurring-cancel-mid-run-id';
      final interval = Duration(minutes: 5);

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(scanInterval: Duration(milliseconds: 10)),
                )
                .build();

        testCall = GatedTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 1),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
          scheduling: IntervalFutureCallScheduling(interval: interval),
        );
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
      });

      test(
        'when the call is cancelled mid-run then the chain does not resurrect',
        () async {
          final running = futureCallManager.runScheduledFutureCalls();
          await testCall.started.future;

          // The cancel deletes the only pending entry while the run is still
          // executing.
          await futureCallManager.cancelFutureCall(identifier);

          testCall.release.complete();
          await running;

          final entriesAfterCancel = await FutureCallEntry.db.find(
            session,
            where: (entry) => entry.name.equals(testCallName),
          );
          expect(entriesAfterCancel, isEmpty);
        },
      );
    },
  );
}
