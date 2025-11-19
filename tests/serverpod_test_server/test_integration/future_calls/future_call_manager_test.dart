import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class CompleterTestCall extends FutureCall<SimpleData> {
  final Completer<SimpleData?> completer = Completer<SimpleData?>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    completer.complete(object);
  }
}

class CounterTestCall extends FutureCall<SimpleData> {
  int counter = 0;

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    counter++;
  }
}

class ListTestCall extends FutureCall<SimpleData> {
  List<SimpleData?> list = [];

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    list.add(object);
  }
}

class DelayedListTestCall extends FutureCall<SimpleData> {
  List<SimpleData?> completed = [];

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    await Future.delayed(Duration(milliseconds: object?.num ?? 0));
    completed.add(object);
  }
}

void main() async {
  withServerpod('Given FutureCallManager', (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-db-entry-call';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
        sessionBuilder,
      ).build();

      futureCallManager.registerFutureCall(
        CompleterTestCall(),
        testCallName,
      );
    });

    group('when scheduling a FutureCall', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now(),
          '1',
          'unique-identifier-42',
        );
      });

      test('then a FutureCallEntry is added to the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        expect(futureCallEntries, hasLength(1));
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall', (
    sessionBuilder,
    _,
  ) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-cancel-future-call';
    var identifier = 'unique-identifier-1337';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
        sessionBuilder,
      ).build();

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        identifier,
      );
    });

    group('when cancelling the scheduled FutureCall', () {
      setUp(() async {
        await futureCallManager.cancelFutureCall(identifier);
      });

      test('then the FutureCallEntry is removed from the database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        expect(futureCallEntries, isEmpty);
      });
    });
  });

  withServerpod('Given FutureCallManager with a scheduled FutureCall', (
    sessionBuilder,
    _,
  ) {
    late FutureCallManager futureCallManager;
    late Session session;
    var testCallName = 'test-cancel-future-call-existing';
    var identifier = 'unique-identifier-1337';

    setUp(() async {
      session = sessionBuilder.build();

      futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
        sessionBuilder,
      ).build();

      await futureCallManager.scheduleFutureCall(
        testCallName,
        SimpleData(num: 4),
        DateTime.now().add(Duration(days: 42)),
        '1',
        identifier,
      );
    });

    test('when cancelling a non-scheduled FutureCall'
        'then scheduled FutureCall is not removed', () async {
      await futureCallManager.cancelFutureCall('non-existing-identifier');

      final futureCallEntries = await FutureCallEntry.db.find(
        session,
        where: (entry) => entry.name.equals(testCallName),
      );

      expect(futureCallEntries, hasLength(1));
    });
  });

  withServerpod(
    'Given FutureCallManager with a scheduled not-registered FutureCall',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      var testCallName = 'non-registered-future-call';
      var identifier = 'very-unique-identifier';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(Duration(days: 42)),
          '1',
          identifier,
        );
      });

      test('when executing all scheduled FutureCalls '
          'then FutureCall entry is removed from the database', () async {
        await futureCallManager.runScheduledFutureCalls();

        final futureCallEntries = await FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );

        expect(futureCallEntries, isEmpty);
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with scheduled FutureCall that is due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      late Session session;
      var testCallName = 'testCall';
      var identifier = 'alex';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = CompleterTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );
      });

      group('when running scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is executed', () async {
          await expectLater(testCall.completer.future, completes);
        });

        test('then the FutureCallEntry gets deleted from database', () async {
          final futureCallEntries = await FutureCallEntry.db.find(
            session,
          );

          expect(futureCallEntries, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with registered future call that is not due',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      var testCallName = 'no-due-call';
      var identifier = 'not-due-id';

      setUp(() async {
        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    // Set a short scan interval for testing
                    scanInterval: Duration(milliseconds: 1),
                  ),
                )
                .build();

        testCall = CompleterTestCall();
        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 1),
          DateTime.now().add(Duration(days: 1)),
          '1',
          identifier,
        );
      });

      group('when start is called', () {
        setUp(() async {
          futureCallManager.start();
          // Wait briefly to allow processing to occur (or not occur)
          await Future.delayed(Duration(milliseconds: 10));
        });

        tearDown(() async {
          await futureCallManager.stop();
        });

        test('then FutureCall is not processed', () async {
          expect(testCall.completer.isCompleted, isFalse);
        });
      });
    },
  );

  withServerpod('Given FutureCallManager in continuous mode', (
    sessionBuilder,
    _,
  ) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;
    var testCallName = 'continuous-mode-call';
    var identifier = 'due-now-id';

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .withConfig(
                FutureCallConfig(
                  // Set a short scan interval for testing
                  scanInterval: Duration(milliseconds: 1),
                ),
              )
              .build();

      testCall = CompleterTestCall();
      futureCallManager.registerFutureCall(testCall, testCallName);

      futureCallManager.start();
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when a new future call becomes due', () {
      setUp(() async {
        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 2),
          DateTime.now().subtract(Duration(seconds: 1)), // Already due
          '1',
          identifier,
        );
      });

      test('then the call is processed automatically', () async {
        await expectLater(testCall.completer.future, completes);
      });
    });
  });

  withServerpod(
    'Given FutureCallManager that has been stopped from continuous mode',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CompleterTestCall testCall;
      var testCallName = 'after-stop-call';
      var canaryCallName = 'canary-call';
      var identifier = 'stop-test-id';

      setUp(() async {
        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    // Set a short scan interval for testing
                    scanInterval: Duration(milliseconds: 1),
                  ),
                )
                .build();

        var canaryCall = CompleterTestCall();
        futureCallManager.registerFutureCall(
          canaryCall,
          canaryCallName,
        );

        testCall = CompleterTestCall();
        futureCallManager.registerFutureCall(
          testCall,
          testCallName,
        );

        await futureCallManager.scheduleFutureCall(
          canaryCallName,
          SimpleData(num: 1),
          DateTime.now(),
          '1',
          identifier,
        );

        futureCallManager.start();

        // Wait for the canary call to be processed
        await canaryCall.completer.future;

        await futureCallManager.stop();
      });

      test(
        'when scheduling a new future call then future call is not processed',
        () async {
          await futureCallManager.scheduleFutureCall(
            testCallName,
            SimpleData(num: 3),
            DateTime.now(),
            '1',
            identifier,
          );

          // Since scan interval is set to 1, we need to wait a bit to ensure
          // that the scheduler has had a chance to process any new calls if it
          // were to do so.
          await Future.delayed(Duration(milliseconds: 100));

          expect(testCall.completer.isCompleted, isFalse);
        },
      );
    },
  );

  withServerpod(
    'Given FutureCallManager with due FutureCall scheduled multiple times',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late CounterTestCall testCall;
      late Session session;
      var testCallName = 'testCall';
      var identifier = 'alex';

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();

        testCall = CounterTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );

        await futureCallManager.scheduleFutureCall(
          testCallName,
          SimpleData(num: 4),
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );
      });

      group('when running all scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then the FutureCall is executed multiple times', () {
          expect(testCall.counter, equals(2));
        });

        test(
          'then the FutureCallEntries are deleted from the database',
          () async {
            final futureCallEntries = await FutureCallEntry.db.find(
              session,
            );

            expect(futureCallEntries, isEmpty);
          },
        );
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with due FutureCall scheduled multiple times with different passed due dates',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late ListTestCall testCall;
      var oldestSimpleData = SimpleData(num: 1);
      var newestSimpleData = SimpleData(num: 2);
      var testCallName = 'testCall';
      var identifier = 'alex';

      setUp(() async {
        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    // Set a short scan interval for testing
                    scanInterval: Duration(milliseconds: 1),
                    concurrencyLimit: 1,
                  ),
                )
                .build();

        testCall = ListTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          oldestSimpleData,
          DateTime.now().subtract(const Duration(seconds: 5)),
          '1',
          identifier,
        );

        await futureCallManager.scheduleFutureCall(
          testCallName,
          newestSimpleData,
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );
      });

      group('when running all scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then oldest FutureCall is executed first', () async {
          () {
            expect(testCall.list.first?.num, oldestSimpleData.num);
          };
        });

        test('then newest FutureCall is executed last', () async {
          () {
            expect(testCall.list.last?.num, newestSimpleData.num);
          };
        });
      });
    },
  );

  withServerpod(
    'Given FutureCallManager with concurrency limit 2 and 2 FutureCalls are scheduled',
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late ListTestCall testCall;
      var firstButSlowest = SimpleData(num: 1000);
      var lastButFastest = SimpleData(num: 20);
      var testCallName = 'testCall';
      var identifier = 'alex';

      setUp(() async {
        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    // Set a short scan interval for testing
                    scanInterval: Duration(milliseconds: 1),
                    concurrencyLimit: 2,
                  ),
                )
                .build();

        testCall = ListTestCall();

        futureCallManager.registerFutureCall(testCall, testCallName);

        await futureCallManager.scheduleFutureCall(
          testCallName,
          firstButSlowest,
          DateTime.now().subtract(const Duration(seconds: 5)),
          '1',
          identifier,
        );

        await futureCallManager.scheduleFutureCall(
          testCallName,
          lastButFastest,
          DateTime.now().subtract(const Duration(seconds: 1)),
          '1',
          identifier,
        );
      });

      group('when running all scheduled FutureCalls', () {
        setUp(() async {
          await futureCallManager.runScheduledFutureCalls();
        });

        test('then future calls are processed concurrently', () async {
          () {
            // The call that is scheduled last is faster to process. When the calls
            // are processed concurrently, the last call is added to the
            // completed list first.
            expect(testCall.list.first?.num, lastButFastest.num);
            // The call that is scheduled first is slower to process, so it is
            // added to the completed list last.
            expect(testCall.list.last?.num, firstButSlowest.num);
          };
        });
      });
    },
  );
}
